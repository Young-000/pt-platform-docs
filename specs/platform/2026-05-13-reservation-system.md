---
title: 2026-05-13 예약 시스템 (백엔드)
parent: 🏢 플랫폼
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 🏢 예약 시스템 (백엔드)

**Status**: Draft
**관련 결정**: [5A 예약](../../operations/reservation.html) · [2D 정책](../../members/policies.html) · [4D 공간](../../service/space.html)

## 1. 핵심 컴포넌트

- **고정 슬롯 자동 갱신** (피크 6-10pm)
- **AI 매칭 엔진** (회원 페르소나·이력·이전 멘토 기반)
- **연속성 보장 로직** (이전 멘토 우선)
- **24h 거절권 처리**
- **변경/취소 룰 (48h/6h) 자동 적용**
- **카디오 슬롯 + 방 슬롯 + 멘토 블록 3중 매칭**

## 2. 매칭 알고리즘 (의사 코드)

```
function matchSession(member, requestedTimeSlot):
  // 1. 방 슬롯 가용 확인
  roomSlot = findAvailableRoom(requestedTimeSlot)
  if not roomSlot: return BLOCKED("방 풀")

  // 2. 카디오 슬롯 (시작 -30분) 가용 확인
  cardioSlot = findAvailableCardio(requestedTimeSlot - 30min)
  if not cardioSlot: return BLOCKED("카디오 풀")

  // 3. 멘토 매칭 (T+60~T+90 30분 블록)
  mentorBlock = roomSlot.startAt + 30min
  candidates = mentors with open block at mentorBlock

  // 4. 이전 멘토 우선 (고정 슬롯 + 연속성 보장)
  prevMentor = member.lastSessionMentorAt(requestedTimeSlot.weekday, requestedTimeSlot.hour)
  if prevMentor in candidates:
    return autoAssign(member, roomSlot, cardioSlot, prevMentor)

  // 5. AI 추천 (페르소나·이력 기반 점수)
  scored = candidates.map(m => scoreMentor(m, member))
  topN = scored.topN(3)
  return PROPOSE(topN)
```

## 3. 고정 슬롯 자동 갱신

```
cron: 매주 일요일 자정
  for each member with fixed slot:
    for next 14 days, weekday/hour matches fixed slot:
      if no existing reservation:
        try matchSession(member, slot)
      if matched:
        notify member ("매주 자동 예약 확정")
```

## 4. 데이터 모델

```
ReservationPolicy (정적, 변경 시 ADR)
  ├─ change_window_hours: 48
  ├─ partial_window_hours: 6
  ├─ partial_credit_back: "day_pass"  // 당일 예약권
  ├─ no_show_credit_charge: 1.0       // 100%
  ├─ compensation_credit: 1            // 본사 노쇼 시 +1

FixedSlot
  ├─ id, member_id
  ├─ weekday (0-6), hour, minute
  ├─ active (bool), created_at

DayPass (당일 예약권)
  ├─ id, member_id, issued_at, expires_at (당일 23:59)
  ├─ used (bool), used_at

PriorityBooking (고정권 회원 가로채기 차단)
  ├─ id, fixed_slot_id, mentor_id
  ├─ valid_until (다음 슬롯 시작 전까지)
```

## 5. API 엔드포인트

- `POST /reservations` — 신규 예약 (매칭 포함)
- `POST /reservations/:id/reject` — 회원 24h 거절
- `PATCH /reservations/:id` — 변경 (시간·멘토)
- `DELETE /reservations/:id` — 취소 (룰 적용)
- `POST /fixed-slots` — 고정 슬롯 등록
- `POST /mentor-blocks` — 멘토 슬롯 오픈 (멘토 측)

## 6. 우선권 (고정 슬롯의 이전 멘토 가로채기 차단)

```
when 회원 X예약 시도:
  if 슬롯 = 다른 회원 Y의 고정 슬롯 시간
     and Y의 이전 멘토가 이 슬롯에 슬롯 오픈
     and Y의 매칭이 아직 미확정:
    → 가로채기 차단 ("우선권 회원 매칭 진행 중")
```

## 7. 다른 레이어 영향

- **👤 유저** / **💪 멘토**: 각각의 PRD 참고

## 8. 엣지 케이스

- 매칭 시 멘토 풀 0명: 회원 알림 + 운영 매니저 대응
- 동시성 (두 회원이 같은 슬롯 동시 시도): DB row lock
- 멘토 슬롯 취소 (6h 이내): 모든 매칭된 회원에게 회차 +1 자동 보상
- 회원 자동 매칭 모드에서 적합 멘토 없음: 매칭 보류 + 수동 모드 전환 안내

## 9. 측정 지표

- 매칭 p95 응답 < 500ms
- 매칭 성공률 ≥ 95%
- 우선권 가로채기 사고 0건

---

| 2026-05-13 | 초안 |
