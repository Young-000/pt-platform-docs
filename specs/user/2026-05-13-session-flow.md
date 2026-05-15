---
title: 2026-05-13 세션 진행 (회원 흐름)
parent: 👤 유저
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 👤 세션 진행 (회원 흐름, v2)

**Status**: v2 Accepted · **Layer**: 👤 유저 · **Updated**: 2026-05-16
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0002](../../decisions/0002-license-policy.html) · [ADR 0003](../../decisions/0003-free-gym-add-on.html)
**📡 API**: [catalog](../api/catalog.html) · [v2-reservations](../api/v2-reservations.html) · [v2-free-gym](../api/v2-free-gym.html)
**🗄️ Data**: [3. Schedule](../data/03-schedule.html) · [4. Reservation](../data/04-reservation.html)

## 1. 배경 (v2)

회원 1세션 단위 = **30분 unit**(60분 = 2 unit 연속). 카테고리별로 룸/오픈 공간이 다르고, 강사 1:1 진행 시간도 카테고리에 따라 다르다. v1의 "카디오 30 + 룸 60 = 90분 세트"·"4+4 stagger" 모델은 폐기.

## 2. 락된 규칙 (v2)

- 회원 예약 단위 = **강사 + 프로그램 + 30분 unit**
- 룸 코스(스트레칭·필라테스): 룸 1개 **자동 배정** (회원이 룸 직접 선택 ❌)
- 오픈 공간 코스(1:1 PT): 오픈 공간에서 진행
- 자유 헬스: 별도 흐름 (`/api/free-gym/enter`), 회차 차감 ❌ ([ADR 0003](../../decisions/0003-free-gym-add-on.html))
- 모든 공간 예약제 (워크인 ❌)
- 노쇼 룰 ([2D](../../members/policies.html)) — 6h 이내 취소 = 노쇼, 회차 1 차감

## 3. 세션 흐름

```
홈 → [예약 카드] → 30분 전 알림
  ↓
지점 도착 → QR 체크인 (POST /api/reservations/:id/check-in)
  ↓
세션 시작 (30분 또는 60분)
  - 룸 코스: 자동 배정 룸 입장, 강사와 1:1
  - 오픈 코스(1:1 PT): 오픈 공간에서 강사와 1:1
  ↓
강사가 세션 기록 입력 (5분 내)
  ↓
세션 요약 + 평가 (POST /api/sessions/:id/rating)
```

## 4. 화면 / 컴포넌트

| 화면 | 핵심 정보 |
|---|---|
| 홈 | 다음 예약(강사·프로그램·시각·duration·룸 배정), 잔여 회차, 자유 헬스 자격 |
| 세션 상세 | 강사 프로필, 프로그램, 시작/종료, 체크인 버튼, 변경/취소 (룰 안내) |
| 체크인 결과 | 룸 코스 → "룸 N 입장" / 오픈 코스 → "오픈 공간 데스크" |
| 세션 후 | 강사 기록 요약, 5점 척도 평가, AI 다음 운동 추천 |

## 5. AI 역할

- 다음 세션 카테고리·강사 **추천**(보조). v2에서는 자동 예약 ❌, 회원이 추천을 보고 직접 선택.
- 세션 후 요약 / 월간 분석.

## 6. 카테고리별 분기

| 카테고리 | 룸 | 강사 | 단위 | 비고 |
|---|---|---|---|---|
| 스트레칭 | ✅ 자동 배정 | ✅ | 30 / 60 | private 1:1 |
| 필라테스 | ✅ | ✅ | 30 / 60 | private 1:1, 도구 |
| 1:1 PT | ❌ (오픈) | ✅ | 30 / 60 | 오픈 공간 |
| 자유 헬스 | ❌ | ❌ | 입장~퇴장 자유 | 회차 ❌ |

> 카테고리는 admin master ([v2-categories](../api/v2-categories.html)) — `requiresPrivateRoom`·`requiresMentor` 플래그로 분기.

## 7. Edge Cases

- **체크인 늦음 (T+15 초과)**: cron이 `status=no-show`, 회차 차감 확정. 알림 + 재예약 안내.
- **강사 노쇼**: 회원 알림 + `BonusCredit` 1매 + 회차 복원. 그 자리에서 재선택.
- **룸 배정 실패**: 예약 시점에 차단 (`INSUFFICIENT_ROOM`). 진행 중 발생 ❌.
- **60분 예약 중 조퇴**: 강사가 종료 처리, 회차 정상 차감.

## 8. 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-13 | v1 초안 — 90분 세트 (카디오 30 + 룸 60 stagger) |
| 2026-05-16 | **v2 재작성** — 30분 unit, 카테고리별 분기, 자유 헬스 분리. v1은 `_archive/v1-user-session-flow.md`. (ADR 0001·0003) |
