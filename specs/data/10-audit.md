---
title: 10. Audit (Policy·Cancellation)
parent: 🗄️ 데이터
grand_parent: 스펙 (PRD)
nav_order: 20
---

# 10. Audit — PolicyEvent·CancellationLog

정책 트리거·취소 감사 로그. 환불·노쇼·보상 추적 + 분쟁 대응.

> **GX 영향 (2026-06-03)**: GX 취소·환불은 `WalletTransaction(type=refund)`으로 원장 기록. `CancellationLog`는 PT 레일 전용. GX 폐강(전원 환불)은 `GxSettlement` 미생성 상태에서 원자적 `updateMany`로 처리 ([ADR 0011](../../decisions/0011-recovergx-gx-pivot.html)).

## PolicyEvent

**Purpose**: 모든 정책 액션의 감사 로그 (환불·일시정지·노쇼·보상·등급 변경 등).
**Related PRDs**: [🏢 멤버십 시스템](../platform/2026-05-13-membership-system.html) · [🏢 멘토 등급](../platform/2026-05-13-mentor-tier-system.html) · [🏢 예약](../platform/2026-05-13-reservation-system.html)
**Lifecycle**: 시스템 또는 admin 액션 → 기록 (append-only)

### Fields

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| id | String | ✓ | cuid() | PK |
| memberId | String? | - | null | 회원 관련 |
| mentorId | String? | - | null | 멘토 관련 |
| storeId | String? | - | null | 지점 관련 |
| type | String | ✓ | - | refund/pause/cancel/no_show/compensation/tier_change |
| subType | String? | - | null | 세부 분류 ("member_no_show", "mentor_no_show" 등) |
| payload | Json | ✓ | - | 액션 컨텍스트 (금액·시간·사유 등) |
| triggeredBy | String | ✓ | - | "system" / "member_xxx" / "admin_xxx" |
| createdAt | DateTime | ✓ | now() | |

### payload Json 예시

```json
// 환불
{
  "paymentId": "pay_xxx",
  "refundAmount": 240000,
  "usedCredits": 2,
  "reason": "중도해지"
}

// 회원 노쇼
{
  "reservationId": "res_xxx",
  "sessionId": "ses_xxx",
  "creditCharged": 1
}

// 본사·멘토 노쇼
{
  "reservationId": "res_xxx",
  "compensationCredits": 1,
  "mentorTierImpact": "verified"  // 등급 영향
}

// 일시정지
{
  "membershipId": "mem_xxx",
  "pauseStartedAt": "...",
  "pauseEndAt": "...",
  "pauseDays": 31
}
```

### Validation
- type enum strict
- triggeredBy 형식: "system" | "member_{id}" | "admin_{id}"
- append-only — 수정 ❌

### Indexes
- `[memberId, createdAt]` — 회원 정책 이력
- `[mentorId, createdAt]` — 멘토 이력
- `[type, createdAt]` — 분석
- `[storeId, createdAt]` — 지점 운영 데이터

### Common Queries
- 회원 환불 이력: `WHERE memberId=? AND type='refund' ORDER BY createdAt DESC`
- 일별 노쇼 수: `WHERE type='no_show' AND DATE(createdAt) = ?`
- 멘토 noshow 누적: `WHERE mentorId=? AND type='no_show' AND subType='mentor_no_show'`

### Edge Cases
- 시스템 자동 트리거 (cron 노쇼 처리) vs admin 수동 → triggeredBy로 구분
- 분쟁 시 evidence: 이 테이블이 truth source

---

## CancellationLog

**Purpose**: 예약 취소 상세 로그 (48h/6h 룰 적용 결과 추적).
**Related PRDs**: [🏢 예약](../platform/2026-05-13-reservation-system.html) · [👤 예약](../user/2026-05-13-reservation.html)
**Lifecycle**: 취소 시 기록 (append-only)

### Fields

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| id | String | ✓ | cuid() | PK |
| reservationId | String | ✓ | - | FK |
| sessionStartAt | DateTime | ✓ | - | 세션 예정 시각 (denorm) |
| cancelledBy | String | ✓ | - | "member" / "mentor" / "system" / "admin" |
| cancelledById | String | ✓ | - | id (member id, mentor id, admin id) |
| cancelledAt | DateTime | ✓ | now() | 취소 시각 |
| hoursBeforeSession | Decimal(5,2) | ✓ | - | 세션 시작까지 남은 시간 (음수면 사후) |
| category | String | ✓ | - | before_48h / 48h_to_6h / within_6h / mentor_no_show / member_no_show |
| creditCharged | Int | ✓ | 0 | 차감 회차 (0 또는 1) |
| dayPassIssued | Boolean | ✓ | false | 48h-6h 시 true |
| dayPassId | String? | - | null | 발급된 DayPass |
| bonusCreditIssued | Int | ✓ | 0 | 보상 회차 |
| bonusCreditId | String? | - | null | 발급된 BonusCredit |
| penaltyOnMentor | Boolean | ✓ | false | 멘토 등급 패널티 적용 |
| mentorPayoutDeduction | Int | ✓ | 0 | 멘토 정산 차감 (6h 이내 멘토 취소) |
| reason | String? | - | null | 취소 사유 텍스트 |

### Validation
- category 결정 (자동): hoursBeforeSession >= 48 → before_48h / 6-48 → 48h_to_6h / 0-6 → within_6h / 음수 = no_show
- cancelledBy enum
- dayPassIssued=true → category='48h_to_6h' AND cancelledBy='member'
- bonusCreditIssued > 0 → cancelledBy='mentor' OR 'system'

### Indexes
- `reservationId` (unique)
- `[cancelledBy, cancelledAt]` — 누가 자주 취소하는지
- `[category, cancelledAt]` — 카테고리별 패턴 분석

### Common Queries
- 회원 6h 이내 취소 빈도: `WHERE cancelledBy='member' AND cancelledById=? AND category='within_6h'`
- 멘토 6h 이내 취소: `WHERE cancelledBy='mentor' AND cancelledById=? AND category='within_6h'` → 등급 평가 입력
- 일별 노쇼 vs 취소 비율: `GROUP BY category, DATE(cancelledAt)`

### Edge Cases
- 회원 노쇼는 별도 트리거 (T+15 cron) — category='member_no_show', cancelledBy='system'
- admin 강제 취소 (운영 사유): cancelledBy='admin', creditCharged=0, bonusCreditIssued=가변
- 양측 동시 취소 (race condition): 먼저 들어온 것 기준 처리

---

## 통합 Audit 흐름 예시

### 시나리오: 회원 6h 이내 취소

```
1. 회원이 6h 이내 취소 클릭
2. UI 강한 경고 → 확정
3. 시스템:
   a) CancellationLog 추가 (category=within_6h, creditCharged=1)
   b) PolicyEvent 추가 (type=cancel, subType=member_within_6h)
   c) Membership.creditsRemaining -= 1
   d) MentorPayout는 정상 (멘토 보호)
   e) Reservation.status='cancelled'
4. 회원 알림 (회차 차감 안내)
```

### 시나리오: 멘토 노쇼

```
1. T+15 cron: Reservation.status='confirmed' AND no checkedInAt AND mentor not entered
2. 시스템:
   a) CancellationLog (category=mentor_no_show, penaltyOnMentor=true)
   b) PolicyEvent (type=no_show, subType=mentor)
   c) BonusCredit 발급 → bonusCreditIssued=1
   d) MentorPayout deduction +20,000 (회당)
   e) Mentor tier 평가 입력 (averageRating 보정·등급 검토 트리거)
   f) Reservation.status='no_show'
   g) Session.status='no_show'
3. 회원 알림 (보상 회차 안내), 멘토 알림 (패널티 안내)
```

## 📘 사용 PRD

[🏢 모든 플랫폼 PRD](../platform/) · [🏢 예약 시스템](../platform/2026-05-13-reservation-system.html) · [🏢 멤버십 시스템](../platform/2026-05-13-membership-system.html) · [🏢 멘토 등급](../platform/2026-05-13-mentor-tier-system.html)

---

| 2026-05-13 | 초안 — PolicyEvent·CancellationLog 상세 + 통합 흐름 예시 |
