---
title: 2026-05-13 예약 (회원)
parent: 👤 유저
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 👤 예약 (회원 흐름, v2)

**Status**: v2 Accepted · **Layer**: 👤 유저 · **Updated**: 2026-05-16
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0003](../../decisions/0003-free-gym-add-on.html) · [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html)
**📡 API**: [catalog](../api/catalog.html) · [v2-reservations](../api/v2-reservations.html) · [v2-free-gym](../api/v2-free-gym.html)
**🗄️ Data**: [3. Schedule](../data/03-schedule.html) · [4. Reservation](../data/04-reservation.html)
**의존**: [5A 예약](../../operations/reservation.html) · [2D 정책](../../members/policies.html)

## 1. 배경 (v2)

v2 예약 = **회원이 카테고리 → 시간 → 강사를 직접 선택**하는 단일 흐름. v1의 자동 매칭(AI 추천 → 24h 거절), 카디오+룸 stagger 모델 폐기. 룸은 프로그램 속성에 따라 자동 배정.

## 2. 락된 규칙 (v2)

- 예약 대상 = **강사 + 프로그램** (룸 ❌ 회원 선택 불가, 자동 배정)
- 단위 = **30분 unit** (60분 = 2 unit 연속)
- 자유 헬스는 별도 입구 (예약 ❌, QR 입장)
- 14일 전부터 가능, 모든 회원 동일 시점
- 변경/취소 룰 ([2D](../../members/policies.html)):
  - 48h+ 전: 무료 (회차 미차감)
  - 48h~6h: 회차 차감 + 당일 예약권 1매
  - 6h 이내: 회차 100% 차감 (= 노쇼)

## 3. 예약 흐름

```
1. 카테고리 선택 (GET /api/categories — 스트레칭/필라테스/1:1 PT/...)
2. 날짜·duration(30/60) 선택
3. 가용 슬롯 조회 (GET /api/slots/available?date=&categoryId=&duration=)
   → 시간별 + 그 시간에 가능한 강사 리스트 (일반 / Pro 배지)
4. 시간 + 강사 + 프로그램 선택
5. Pro 강사면 +5,000원 포인트 차감 안내
6. 결제(회차 차감 + Pro 옵션 포인트 차감) (POST /api/reservations)
7. 룸 자동 배정 (요구되면) → 확정 카드 표시
```

> **자유 헬스 입구**는 별도: 회차권 보유자는 홈에서 "지금 자유 헬스 입장" → QR → `POST /api/free-gym/enter` (회차 차감 ❌). [ADR 0003](../../decisions/0003-free-gym-add-on.html).

## 4. 화면 / 컴포넌트

| 화면 | 핵심 |
|---|---|
| 카테고리 선택 | 활성 카테고리 카드(이름·아이콘·기본 duration) |
| 시간/duration 선택 | 캘린더 + 30/60 토글 |
| 강사 선택 | 시간별 가용 강사 + 배지(Pro=+5k) + 평점·리뷰 수 |
| 예약 확정 | 강사·프로그램·시작·duration·룸 배정 결과·회차/포인트 차감 |
| 내 예약 | 미래 예약 리스트, 변경/취소 (룰 시각화) |

## 5. 변경·취소

- 변경 = 동일 트랜잭션으로 기존 점유 해제 + 신규 점유 (실패 시 롤백, 원 예약 유지)
- 6h 이내 변경 ❌ (취소 = 노쇼)
- 노쇼 보상 (강사 측 사유): `BonusCredit` 1매 + 회차 복원

## 6. 고정 슬롯 (옵션 — 자유 선택)

- 매주 같은 요일·시간 자동 예약. **v2에선 피크 강제 ❌**, 회원이 자유 선택.
- preferredMentorId·preferredCategoryId 등록 가능, 매칭 실패 시 알림.
- 월 1회 변경 제한.

## 7. Edge Cases

- 강사가 30분 후 슬롯도 안 열려 있어 60분 선택 ❌ → UI에서 30분만 활성
- 룸 필요 카테고리, 가용 룸 없음 → 해당 시간 강사 자체 비활성 표시
- 두 회원 동시 같은 강사 30분 시도 → 트랜잭션 lock → 한 명 `BLOCK_TAKEN`
- Pro 옵션 포인트 부족 → 일반 강사 fallback 또는 충전 안내

## 8. 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-13 | v1 초안 — 카디오+룸 묶음, 자동/수동 매칭, 24h 거절, 고정 슬롯 피크 강제 |
| 2026-05-16 | **v2 재작성** — 강사+프로그램 직접 선택, 자동 매칭 폐기, 30분 unit, 자유 헬스 분리. v1은 `_archive/v1-user-reservation.md`. (ADR 0001·0003) |
