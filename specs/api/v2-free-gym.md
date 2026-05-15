---
title: v2 — 자유 헬스 API
parent: 🔌 API
grand_parent: 스펙 (PRD)
nav_order: 8
---

# 🔌 v2 — 자유 헬스 API (`/api/free-gym/*`)

**Status**: v2 Accepted · **Updated**: 2026-05-16
**관련 결정**: [ADR 0003](../../decisions/0003-free-gym-add-on.html)
**🗄️ Data**: `FreeGymVisit` ([4. Reservation](../data/04-reservation.html))
**의존**: [5D 자유 헬스 SOP](../../operations/free-gym.html)

> 자유 헬스 = 회차권 보유 회원 부가 이용 (단독 가입 ❌, 회차 차감 ❌, 정산 ❌). 입장/퇴장 기록만 남기고 운영 분석·안전(비상 호출) 트리거.

## 1. 자격

입장 가능 조건:
- 회원이 `MembershipTicket` 보유 + `status IN ('active', 'paused')`, **또는**
- 최근 만료 ticket의 `expiresAt > NOW() - admin.free_gym.grace_days_after_expiry` (기본 30일)

미충족 시 `FREE_GYM_NOT_ELIGIBLE` 반환.

## 2. 엔드포인트

### POST `/api/free-gym/enter`
**권한**: member
**Body**:
```json
{ "storeId": "store_pangyo" }
```
**Behavior**:
1. 자격 검증
2. 활성 visit 1건 제한 — 이미 `exitedAt IS NULL`이면 `ALREADY_INSIDE`
3. `FreeGymVisit { memberId, storeId, enteredAt, ticketSnapshot }` insert
4. (옵션) 게이트 시스템에 입장 신호

**Response 201**:
```json
{
  "data": {
    "id": "visit_...",
    "enteredAt": "2026-05-16T07:30:00+09:00",
    "storeId": "store_pangyo",
    "ticketSnapshot": { "ticketType": "twenty_four", "creditsRemaining": 9, "expiresAt": "2026-08-01" }
  }
}
```

### POST `/api/free-gym/exit`
**권한**: member
**Body**: `{ }` (현재 active visit 자동 식별)
**Behavior**: `exitedAt = NOW()`, `autoClosed=false`
**Edge**: 활성 visit ❌ → `NO_ACTIVE_VISIT`

### GET `/api/free-gym/today`
**권한**: member
**Response**:
```json
{
  "data": {
    "activeVisit": { "id": "visit_...", "enteredAt": "..." },
    "todayVisits": [ /* 오늘 입장/퇴장 이력 */ ]
  }
}
```

### GET `/api/admin/free-gym/visits`
**권한**: admin
**Query**: `?from=&to=&storeId=&memberId=`
**Use**: 운영 분석 (회원 빈도, 무인 시간대 입장률 등 — [5D §6](../../operations/free-gym.html)).
**Response**: 페이지네이션 visit 리스트

## 3. 자동 마감 (cron)

`/api/system/cron/free-gym-auto-exit` — 5분 간격 실행
```
UPDATE FreeGymVisit
   SET exitedAt = enteredAt + INTERVAL '180 minutes',
       autoClosed = true
 WHERE exitedAt IS NULL
   AND enteredAt < NOW() - INTERVAL '180 minutes';
```

운영 변수: `admin.free_gym.max_session_minutes` (기본 180).

## 4. 비상 호출

비상벨 트리거는 별도 SOP ([5C 안전](../../operations/safety.html) · [5D §4](../../operations/free-gym.html)) — 활성 visit이 있는 회원 식별 + 가맹점장·CS·119 알림. 본 API는 visit 식별만 제공.

## 5. 에러

| 코드 | HTTP | 의미 |
|---|---|---|
| `FREE_GYM_NOT_ELIGIBLE` | 403 | 회차권 없음 / grace 만료 |
| `ALREADY_INSIDE` | 409 | 활성 visit 존재 |
| `NO_ACTIVE_VISIT` | 404 | exit 시 활성 visit 없음 |
| `STORE_FREE_GYM_DISABLED` | 403 | `admin.free_gym.enabled=false` 지점 |

## 6. 사용 시나리오

```
회원 → 게이트 QR → POST /api/free-gym/enter
  ↓
운동 (회차 차감 ❌, 강사 ❌)
  ↓
게이트 exit 또는 180분 후 자동 마감
  ↓
AI 대시보드 (운영자): 회원별 자유 헬스 빈도 → 멤버십 갱신 예측 지표
```

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-16 | 신규 — v2 자유 헬스 enter/exit/today/admin endpoint (ADR 0003) |
