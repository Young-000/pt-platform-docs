---
title: v2 — 예약 API
parent: 🔌 API
grand_parent: 스펙 (PRD)
nav_order: 7
---

# 🔌 v2 — 예약 API (`/api/reservations`)

**Status**: v2 Accepted · **Updated**: 2026-05-16
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html)
**🗄️ Data**: [3. Schedule](../data/03-schedule.html) · [4. Reservation](../data/04-reservation.html)
**의존**: [5A 예약](../../operations/reservation.html) · [2D 정책](../../members/policies.html)

> v2 예약 흐름은 **회원 직접 선택**(자동 매칭 ❌). 카테고리 → 시간 → 강사 → (Pro 옵션 확인) → 결제(회차 차감 + Pro 옵션 포인트 차감) → 확정. 모든 점유는 **30분 unit MentorBlock** 기준 (60분 = 2 unit 연속).

## 1. 가용 슬롯 조회

### GET `/api/slots/available`
**권한**: member
**Query**:
- `date` (YYYY-MM-DD, KST) — 필수
- `categoryId` — 필수
- `programId` — 옵션 (강사 필터 정확도 ↑)
- `duration` ∈ {30, 60} — 기본 30

**Response 200**:
```json
{
  "data": [
    {
      "startAt": "2026-05-20T19:00:00+09:00",
      "mentors": [
        { "mentorId": "m_001", "name": "지훈", "isPro": false, "rating": 4.6 },
        { "mentorId": "m_002", "name": "수진", "isPro": true,  "rating": 4.8, "proSurcharge": 5000 }
      ]
    }
  ]
}
```

**Logic**:
- 카테고리·시간·duration 충족하는 **MentorBlock 가용**
- duration=60 → `[startAt, startAt+30]` 두 block 모두 open
- 룸 필요 카테고리면 가용 룸 ≥ 1 인 시간만 노출

### GET `/api/slots/mentor/:mentorId`
**권한**: member
**Query**: `from`, `to`, `categoryId?`
**Use**: 회원이 특정 강사 프로필에서 일정을 보고 싶을 때.

## 2. 예약 생성

### POST `/api/reservations`
**권한**: member
**Body**:
```json
{
  "mentorId": "m_002",
  "programId": "prog_stretch_full",
  "startAt": "2026-05-20T19:00:00+09:00",
  "duration": 30,
  "ticketId": "tk_..." 
}
```

**검증·트랜잭션 (전부 또는 무):**
```
BEGIN;
  -- 1) Ticket lock + 잔여 회차 ≥ 1
  SELECT creditsRemaining FROM MembershipTicket
    WHERE id=? AND memberId=? AND status='active' FOR UPDATE;
  IF creditsRemaining < 1 → INSUFFICIENT_CREDITS

  -- 2) MentorBlock(s) lock + open
  SELECT id FROM MentorBlock
    WHERE mentorId=? AND startAt IN (?, ?+30m) AND status='open' FOR UPDATE;
  IF count != duration/30 → BLOCK_TAKEN

  -- 3) 카테고리 룸 필요 시 가용 Room 1개 lock
  IF category.requiresPrivateRoom:
    SELECT id FROM Room WHERE storeId=? AND id NOT IN (
      SELECT assignedRoomId FROM Reservation
        WHERE startAt < ?+30m*units AND startAt+duration > ? AND status='confirmed'
    ) LIMIT 1 FOR UPDATE;
    IF none → INSUFFICIENT_ROOM

  -- 4) Pro 옵션 포인트 차감
  IF mentor.isPro:
    UPDATE PointBalance SET balance = balance - admin.pro_mentor_surcharge_per_session
      WHERE memberId=? AND balance >= ?;
    IF affected=0 → INSUFFICIENT_POINTS

  -- 5) MentorBlock status=assigned
  -- 6) MembershipTicket.creditsRemaining -= 1
  -- 7) Reservation insert (mentorBlockIds[], assignedRoomId, pointsCharged, isPro)
  -- 8) Session insert (status=booked)
COMMIT;
```

**Response 201**:
```json
{
  "data": {
    "id": "rsv_...",
    "mentorId": "m_002",
    "programId": "prog_stretch_full",
    "categoryId": "cat_stretch",
    "startAt": "2026-05-20T19:00:00+09:00",
    "duration": 30,
    "assignedRoomId": "room_3",
    "isPro": true,
    "pointsCharged": 5000,
    "creditsRemaining": 11,
    "status": "confirmed"
  }
}
```

## 3. 변경·취소 룰

### PATCH `/api/reservations/:id` (시간·강사 변경)
**권한**: member
**룰** ([2D](../../members/policies.html)):
- 48h+ 전: 무료
- 48h~6h: 회차 차감 + DayPass 1매 발급
- 6h 이내: 변경 ❌ (취소 = no-show)

내부적으로 기존 점유 해제 + 신규 점유 트랜잭션.

### DELETE `/api/reservations/:id`
**권한**: member
**룰**: 시점별 동일 — 48h+ 전엔 회차 복원·MentorBlock open으로 복귀, 48h~6h엔 회차 차감 + DayPass 발급, 6h 이내는 no-show 처리(회차 차감, MentorBlock은 정산 카운트).

## 4. 체크인

### POST `/api/reservations/:id/check-in`
**권한**: member
**Validation**: 현재 시각이 `startAt - 15m ~ startAt + 15m` 범위
**Effect**: `Session.checkedInAt = NOW()`, `status=checked-in`
**Edge**: T+15까지 미체크인 → cron이 `status=no-show`로 전환 + 회차 차감 확정.

## 5. 당일 예약권 (DayPass)

### POST `/api/day-passes/:id/use`
**권한**: member
**Behavior**: 회차 대신 DayPass로 1예약 진행. `DayPass.used=true`, `usedReservationId` 기록.

## 6. 고정 슬롯 (FixedSlot — 자유 선택)

| Method | Path | 비고 |
|---|---|---|
| POST | `/api/fixed-slots` | weekday·hour·minute·duration·preferredMentorId·preferredCategoryId |
| GET | `/api/fixed-slots` | 본인 활성 슬롯 |
| PATCH | `/api/fixed-slots/:id` | 월 1회 변경 제한 |
| DELETE | `/api/fixed-slots/:id` | 해제 |

> cron `fixed-slot-auto-book`이 매주 자동 예약 시도 (실패 시 알림).

## 7. 에러

| 코드 | HTTP | 의미 |
|---|---|---|
| `BLOCK_TAKEN` | 409 | 선택 시각 강사 이미 점유 |
| `INSUFFICIENT_ROOM` | 409 | 룸 필요 프로그램인데 가용 룸 없음 |
| `INSUFFICIENT_CREDITS` | 422 | 회차 부족 |
| `INSUFFICIENT_POINTS` | 422 | Pro 옵션 포인트 부족 |
| `TICKET_EXPIRED` | 422 | 회차권 만료 |
| `POLICY_VIOLATION` | 422 | 6h 이내 변경 시도 등 |
| `RESERVATION_NOT_OWNED` | 403 | 본인 예약 ❌ |

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-16 | 신규 — v2 예약 흐름 (강사+프로그램·자동 매칭 ❌·30분 unit·트랜잭션 룰) |
