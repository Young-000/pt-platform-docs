---
title: 2026-05-13 예약 시스템 (백엔드)
parent: 🏢 플랫폼
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 🏢 예약 시스템 (백엔드)

**Status**: 🟡 Updated (2026-05-16) · v2 본문 적용
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0002](../../decisions/0002-license-policy.html) · [ADR 0003](../../decisions/0003-free-gym-add-on.html) · [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html)
**의존**: [5A 예약](../../operations/reservation.html) · [5D 자유 헬스](../../operations/free-gym.html) · [2D 정책](../../members/policies.html) · [4D 공간](../../service/space.html)
**📡 API**: [v2 예약](../api/v2-reservations.html) · [v2 카테고리](../api/v2-categories.html) · [v2 프로그램](../api/v2-programs.html)
**🗄️ Data**: [3. Schedule](../data/03-schedule.html) · [4. Reservation](../data/04-reservation.html) · [10. Audit](../data/10-audit.html)

{: .note }
> **v2 (2026-05-16)**: 자동 매칭 알고리즘·24h 거절·CardioSlot+RoomSlot 90분 세트 모델은 **폐기** ([ADR 0001](../../decisions/0001-consumer-pivot.html)). 회원이 카테고리 → 시간 → 강사를 **직접 선택**하는 단일 흐름. 단위 = **30분 unit** (60분 = 2 unit 연속).

## 1. 핵심 컴포넌트

- **카테고리·프로그램 마스터** (admin 운영, 확장 가능)
- **MentorBlock 30분 unit** 점유 모델
- **룸 자동 배정** (카테고리 `requiresPrivateRoom`에 따라)
- **회차권(MembershipTicket) 차감 + Pro 옵션 포인트 차감** 동시 트랜잭션
- **PolicyConfig 동적 조회** (변경/취소 윈도우·노쇼 룰 등)
- **FixedSlot 자유 선택** (자동 매칭 ❌, 본인 선호 강사·카테고리만 저장 → cron이 자동 예약 시도)

## 2. 예약 흐름 (v2)

```
1. 회원이 카테고리 선택 (스트레칭 / 필라테스 / 1:1 PT / 자유 헬스 …)
2. (옵션) 프로그램 선택 — 강사 필터 정확도 ↑
3. GET /api/slots/available → 가용 시간·강사 리스트 노출
4. 회원이 시작 시각 + duration(30/60) + 강사 선택
5. Pro 강사 선택 시 포인트 차감 안내 (admin.pro_mentor_surcharge_per_session)
6. POST /api/reservations
   → MembershipTicket lock + MentorBlock lock + (룸 필요 시) Room lock
   → 회차 1 차감 + (Pro면) 포인트 차감 + Reservation/Session insert
7. 확정 알림
```

> 자유 헬스(`requiresMentor=false`) 카테고리는 예약 흐름 ❌ — 별도 [v2 자유 헬스 API](../api/v2-free-gym.html)의 enter/exit 흐름. ([ADR 0003](../../decisions/0003-free-gym-add-on.html))

## 3. 데이터 모델

```
CourseCategory (admin master)
  ├─ id, name, slug
  ├─ requiresPrivateRoom (bool)   // true → 룸 자동 배정
  ├─ requiresMentor (bool)        // false → 자유 헬스
  ├─ defaultDurationMinutes (Int) // 30 or 60
  ├─ allowedDurations (Int[])     // [30, 60]
  └─ isActive, sortOrder

Program (admin master)
  ├─ id, categoryId (FK), name, level, defaultDurationMinutes
  └─ isActive, sortOrder

MentorProgram (mentor 자기 매핑)
  ├─ mentorId, programId (composite PK)
  └─ isPrimary

MentorBlock (멘토 30분 unit 가용 시간)
  ├─ id, mentorId, startAt, status (open / assigned / closed)
  └─ (60분 예약 = 연속 2 block 동시 점유)

Room (지점 private 룸, 8개/지점)
  ├─ id, storeId, name, capacity=1

Reservation
  ├─ id, memberId, mentorId, programId, categoryId
  ├─ startAt, duration (30/60), unitCount (1/2)
  ├─ mentorBlockIds (Int[])
  ├─ assignedRoomId (nullable — 룸 필요 카테고리만)
  ├─ ticketId (FK MembershipTicket — 회차 차감 출처)
  ├─ isPro (bool, snapshot), pointsCharged (Int, snapshot)
  ├─ status (confirmed / checked-in / completed / no-show / cancelled)
  └─ createdAt, cancelledAt?, cancelReason?

MembershipTicket (회차권 — ADR 0004 5단)
  ├─ id, memberId, ticketType (one / four / twelve / twenty_four / forty_eight)
  ├─ creditsTotal, creditsRemaining
  ├─ purchasedAt, expiresAt, status (active / paused / expired / refunded)

PointBalance (Pro 옵션 차감 통화)
  ├─ memberId, balance

DayPass (당일 예약권 — 48h~6h 변경/취소 시 발급)
  ├─ id, memberId, issuedAt, expiresAt (당일 23:59)
  ├─ used (bool), usedReservationId?

FixedSlot (자유 선호 슬롯 — 자동 예약 시도)
  ├─ id, memberId, weekday, hour, minute, duration
  ├─ preferredMentorId?, preferredCategoryId?
  └─ active

PolicyConfig (admin 동적 변수)
  ├─ change_window_hours (default 48)
  ├─ partial_window_hours (default 6)
  ├─ partial_credit_back ("day_pass")
  ├─ no_show_credit_charge (default 1.0)
  ├─ compensation_credit_on_provider_noshow (default 1)
  ├─ pro_mentor_surcharge_per_session (default 5000)
  └─ free_gym.* (5D)
```

## 4. 트랜잭션 룰 (POST /api/reservations)

격리 수준 **Serializable** (또는 SELECT … FOR UPDATE + retry):

```
BEGIN;
  -- 1) Ticket lock + 잔여 회차 ≥ 1
  SELECT creditsRemaining FROM MembershipTicket
    WHERE id=? AND memberId=? AND status='active' FOR UPDATE;
  IF creditsRemaining < 1            → INSUFFICIENT_CREDITS
  IF expiresAt < NOW()               → TICKET_EXPIRED

  -- 2) MentorBlock(s) lock (duration/30 개)
  SELECT id FROM MentorBlock
    WHERE mentorId=? AND startAt IN (?, ?+30m) AND status='open' FOR UPDATE;
  IF count != units                  → BLOCK_TAKEN

  -- 3) 카테고리 룸 필요 시 가용 Room 1개 lock
  IF category.requiresPrivateRoom:
    SELECT id FROM Room WHERE storeId=? AND id NOT IN (
      SELECT assignedRoomId FROM Reservation
        WHERE startAt < ?+30m*units AND startAt+duration > ?
          AND status IN ('confirmed','checked-in')
    ) LIMIT 1 FOR UPDATE;
    IF none                          → INSUFFICIENT_ROOM

  -- 4) Pro 옵션 포인트 차감
  IF mentor.isPro:
    UPDATE PointBalance SET balance = balance - policy.pro_mentor_surcharge_per_session
      WHERE memberId=? AND balance >= ?;
    IF affected=0                    → INSUFFICIENT_POINTS

  -- 5) MentorBlock status='assigned'
  -- 6) MembershipTicket.creditsRemaining -= 1
  -- 7) Reservation insert (mentorBlockIds[], assignedRoomId, isPro, pointsCharged)
  -- 8) Session insert (status='booked')
COMMIT;
```

상세 API 계약은 [v2 예약 API](../api/v2-reservations.html) §2 참조.

## 5. 변경·취소 룰 (PolicyConfig 동적)

| 시점 (startAt 기준) | 처리 |
|---|---|
| `change_window_hours`(48h) 이전 | 무료 — 회차 복원, MentorBlock=open 복귀, 룸 해제 |
| `change_window_hours` ~ `partial_window_hours`(48h~6h) | 회차 차감 유지 + DayPass 1매 발급 |
| `partial_window_hours`(6h) 이내 | 변경 ❌, 취소 = no-show 처리 (회차 차감 확정) |

모든 시점 비교는 `PolicyConfig` 현재 값 조회 (admin 변경 즉시 반영, 진행 중 예약은 생성 시점 snapshot 미사용 = 운영 결정).

## 6. 체크인 & no-show

- 체크인 윈도우: `startAt - 15m` ~ `startAt + 15m` (POST /api/reservations/:id/check-in)
- cron `reservation-noshow-check` (1분 간격): `startAt + 15m` 경과 + `status='confirmed'` → `no-show` 전환
- 멘토 노쇼 (체크인 미입력·세션 기록 미생성 + T+30m): `compensation_credit_on_provider_noshow` 만큼 회원 회차 +1 보상

## 7. FixedSlot (자유 선호 슬롯)

> v1의 "고정 슬롯 우선권/가로채기 차단"은 **폐기**. v2 FixedSlot은 회원 본인 자동 예약 시도용 메타데이터일 뿐.

```
cron 매주 일요일 00:30:
  for each FixedSlot WHERE active:
    for next 14 days, weekday/hour matches:
      if no existing reservation at that slot:
        try POST /api/reservations { mentorId=preferredMentorId, ... }
      log result (success / BLOCK_TAKEN / INSUFFICIENT_CREDITS …)
      notify member
```

선호 강사가 그 시각에 슬롯을 열지 않았으면 자동 예약 실패 → 알림으로 회원이 직접 다른 강사 선택. 가로채기 차단 ❌ (선착순).

## 8. 자유 헬스 (별도 흐름)

`requiresMentor=false` 카테고리는 본 예약 시스템을 거치지 않는다. enter/exit + visit 로깅만. 자격은 회차권 보유 + grace_days_after_expiry. 회차 차감 ❌. 상세는 [v2 자유 헬스 API](../api/v2-free-gym.html) · [5D 운영 SOP](../../operations/free-gym.html).

## 9. 엣지 케이스

- 동시성 (두 회원이 같은 MentorBlock): Serializable + FOR UPDATE → 두 번째 트랜잭션 `BLOCK_TAKEN`
- 룸 부족 (룸 필요 카테고리, 8 룸 모두 점유): `INSUFFICIENT_ROOM` (회원 다른 시간 안내)
- Pro 포인트 부족: `INSUFFICIENT_POINTS` (포인트 충전 또는 일반 강사 선택 안내)
- 회차권 만료(`expiresAt < NOW`): `TICKET_EXPIRED` (재구매 안내)
- 변경 시 신규 시간에서 BLOCK_TAKEN: 기존 예약 유지, 원자성 보장
- 멘토 슬롯 취소(6h 이내): 영향 받은 모든 회원 회차 +1 보상 (cron)
- 카테고리 비활성화(`isActive=false`): 기존 예약 무영향, 신규만 차단

## 10. 측정 지표

- 예약 생성 p95 < 500ms (트랜잭션 전체)
- 트랜잭션 충돌(retry) 비율 < 1%
- 룸 부족(`INSUFFICIENT_ROOM`) 비율 < 5% (피크)
- 노쇼 cron 정확도 100% (T+15 ±30s)
- FixedSlot 자동 예약 성공률 ≥ 70% (선호 강사 슬롯 오픈율 의존)

## 11. API 매트릭스

전체 contract는 [v2 예약 API](../api/v2-reservations.html) · [v2 카테고리 API](../api/v2-categories.html) · [v2 프로그램 API](../api/v2-programs.html).

| Method | Path | 비고 |
|---|---|---|
| GET | `/api/categories` | 카테고리 마스터 |
| GET | `/api/programs?categoryId=` | 카테고리 → 프로그램 |
| GET | `/api/mentors/:id/programs` | 강사 프로필 매핑 |
| GET | `/api/slots/available` | 가용 슬롯·강사 |
| POST | `/api/reservations` | 예약 생성 (트랜잭션) |
| PATCH | `/api/reservations/:id` | 시간·강사 변경 |
| DELETE | `/api/reservations/:id` | 취소 |
| POST | `/api/reservations/:id/check-in` | 체크인 |
| POST | `/api/day-passes/:id/use` | 당일 예약권 사용 |
| POST | `/api/fixed-slots` | 자유 선호 슬롯 등록 |

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-13 | 초안 (v1) — 매칭 알고리즘·90분 세트·CardioSlot+RoomSlot·우선권 |
| 2026-05-16 | v2 본문 재작성 — 자동 매칭 폐기, 회원 직접 선택 단일 흐름, 30분 unit MentorBlock, 룸 자동 배정, 트랜잭션 룰, FixedSlot 자동 예약 ([ADR 0001](../../decisions/0001-consumer-pivot.html)) |
