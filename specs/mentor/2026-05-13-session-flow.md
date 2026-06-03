---
title: 2026-05-13 세션 진행 (멘토)
parent: 💪 멘토
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 💪 세션 진행 (멘토 흐름, v2)

{: .warning }
> **PT 레일 (보류)** — 이 스펙은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

### GX 대응

GX 전환 후 강사 세션 흐름이 **GX 클래스 진행**으로 바뀐다: 오늘 GX 클래스 목록 조회 → 수강 회원 명단 확인 → 그룹 클래스 진행 → 출석 체크 → 클래스 메모 입력(개인 처방 대신 그룹 퀄리티 메모). 1:1 운동 처방·AI 가이드 노출·강사 인계 메모는 GX 레일에서 보류. 노쇼 체크·세션 기록 입력 SLA의 기본 흐름은 계승.

**Status**: v2 Accepted · **Layer**: 💪 멘토 · **Updated**: 2026-05-16
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0002](../../decisions/0002-license-policy.html)
**📡 API**: [catalog](../api/catalog.html) · [v2-reservations](../api/v2-reservations.html) · [v2-programs](../api/v2-programs.html)
**🗄️ Data**: [3. Schedule](../data/03-schedule.html) · [4. Reservation](../data/04-reservation.html)

## 1. 배경 (v2)

멘토 = 30분 unit 슬롯을 자유 오픈하는 **파트타임 잡 모델**(배달기사형, [ADR 0001](../../decisions/0001-consumer-pivot.html)). 일반 멘토(자격증 ❌, 본사 검증 코스만)와 Pro 멘토(자격증 ✅ + 본사 심사, [ADR 0002](../../decisions/0002-license-policy.html))로 구분. v1의 "4+4 룸 stagger, 멘토 1시간에 2 회원 cover" 모델은 폐기.

## 2. 락된 규칙 (v2)

- 슬롯 단위 = **30분 unit** (MentorBlock)
- 회원 예약 1건 = 30분 1 unit (또는 60분 = 같은 멘토 2 unit 연속)
- 카테고리별 진행 (스트레칭·필라테스·1:1 PT·…). 멘토는 본인이 매핑한 프로그램만 노출 (MentorProgram, [v2-programs](../api/v2-programs.html))
- 호칭: **"멘토"** (트레이너·코치 ❌ — [ADR 0002](../../decisions/0002-license-policy.html) §4)
- 운동 설계 = **AI**, 멘토는 가이드+코칭 (강사 직접 처방 ❌)

## 3. 세션 흐름 (멘토 시점)

```
오늘 일정 조회 (GET /api/mentors/me/today)
  ↓
세션 시작 전 회원 정보 (GET /api/sessions/:id/pre-info)
  - 페르소나·목표·이전 세션 기록·AI 추천 운동
  ↓
회원 체크인 알림 → 룸/오픈 공간 이동
  ↓
30분(또는 60분) 1:1 진행
  - 룸 코스: 자동 배정 룸에서
  - 1:1 PT: 오픈 공간
  ↓
세션 종료 → 5분 내 기록 입력 (POST /api/sessions/:id/record)
  ↓
다음 슬롯 (없으면 일정 종료)
```

## 4. 슬롯 운영

| 액션 | API |
|---|---|
| 슬롯 조회 | GET `/api/mentors/me/blocks?from&to` |
| 단건 오픈 | POST `/api/mentors/me/blocks` |
| 반복 오픈 | POST `/api/mentors/me/blocks/bulk` |
| 닫기 (48h+) | DELETE `/api/mentors/me/blocks/:id` |
| 프로그램 매핑 | PUT `/api/mentors/me/programs` |

**Edge**: 6h 이내 슬롯 닫기 = `penaltyApplied=true` → 정산 차감 + 회원 보상 ([3G 정산](../../partners/payout.html)).

## 5. 30분 unit 운영

- 1시간 = 같은 회원 60분 1예약 또는 다른 회원 30분 × 2.
- v2에서는 stagger 룸 이동 ❌ — 회원이 직접 강사·시간 선택하므로 멘토는 자기 슬롯 단위로만 점유.
- 룸 코스는 트랜잭션이 룸 자동 배정. 멘토는 배정된 룸으로 이동.

## 6. 카테고리별 R&R

| 카테고리 | 멘토 R&R |
|---|---|
| 스트레칭 | 자세 교정, 가동범위 유도 (30/60분 모두 1:1) |
| 필라테스 | 도구 사용 안내, 자세 교정 |
| 1:1 PT | AI 운동 가이드 기반 코칭 (수행 보조·중량 조절) |
| 자유 헬스 | 멘토 R&R ❌ (회원 자유 이용, 가맹점장이 안전 책임) |

## 7. Pro 인증

- 자격증 ✅ + 본사 심사 통과 시 Pro
- Pro 슬롯은 회원에게 배지 노출 + 회원 결제 시 회당 +5,000원 (멘토 100% 인센티브, [3G](../../partners/payout.html))

## 8. Edge Cases

- 멘토 노쇼 (T+15 미체크인): `status=completed + penaltyApplied=true`, 회원 보상 + 정산 차감
- 회원 노쇼: 멘토 정상 정산 (회원 회차만 차감)
- 6h 이내 슬롯 취소: 패널티 적용
- 진행 중 부상·이상: 강제 종료 + 사유 기록

## 9. 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-13 | v1 초안 — 90분 세트, 방 A→B stagger, 1시간 2 회원 cover |
| 2026-05-16 | **v2 재작성** — 30분 unit 단일 점유, 카테고리별 R&R, stagger 폐기. v1은 `_archive/v1-mentor-session-flow.md`. (ADR 0001·0002) |
