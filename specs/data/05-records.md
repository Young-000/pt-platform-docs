---
title: 5. Records (SessionRecord·Rating)
parent: 🗄️ 데이터
grand_parent: 스펙 (PRD)
nav_order: 15
---

# 5. Records — SessionRecord·Rating

세션 기록 + 회원 평가. [4C AI 역할](../../service/ai-role.html), [3H 품질](../../partners/quality.html) 정책 반영.

> **GX 영향**: GX 출석 기록은 `GxBooking.attendanceStatus` 필드에서 관리. `SessionRecord`·`Rating`은 PT 레일 전용 (보존·미활성) ([ADR 0011](../../decisions/0011-recovergx-gx-pivot.html)).

## SessionRecord

**Purpose**: 멘토가 입력하는 세션 기록 (5분 내 SLA). AI 학습 + 다음 추천의 핵심 입력.
**Related PRDs**: [💪 세션 진행](../mentor/2026-05-13-session-flow.html) · [🏢 AI 엔진](../platform/2026-05-13-ai-engine.html)
**Lifecycle**: 멘토 입력 → 저장 → AI 학습 → 회원 노출

### Fields

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| id | String | ✓ | cuid() | PK |
| sessionId | String | ✓ | - | FK → Session (1:1) |
| mentorId | String | ✓ | - | FK |
| performedAt | DateTime | ✓ | - | 세션 실제 진행 시각 |
| exercises | Json | ✓ | - | ExercisePerformed[] 구조화 |
| formNotes | Text | - | "" | 1-2줄 폼 이슈 |
| handoverNotes | Text | ✓ | - | 3-5줄 다음 인계 (AI 학습용) |
| memberCondition | Text? | - | null | 회원 컨디션 메모 |
| totalVolumeKg | Decimal(7,2)? | - | null | 자동 계산 (kg × reps 총합) |
| enteredAt | DateTime | ✓ | now() | 입력 시각 (5분 SLA 측정) |
| modifiedAt | DateTime? | - | null | 수정 시 |

### exercises Json 스키마

```json
[
  {
    "name": "데드리프트",
    "category": "lower",
    "sets": [
      { "weight": 60, "reps": 5, "completed": true, "modifiedBy": "ai" },
      { "weight": 65, "reps": 5, "completed": true, "modifiedBy": "mentor" }
    ],
    "note": "5세트째 폼 흔들림"
  }
]
```

### Validation
- sessionId unique (1:1)
- handoverNotes ≥ 1자 (AI 학습용 필수)
- enteredAt - session.completedAt ≤ 24h (정책 위반 시 알림)

### Indexes
- `sessionId` (unique)
- `[mentorId, performedAt]` — 멘토 이력
- `[performedAt]` — 시간 범위 분석

### Common Queries
- 회원 최근 N세션: `JOIN Session WHERE memberId=? ORDER BY performedAt DESC LIMIT N`
- 멘토 기록 품질 (평균 길이·완성도): `AVG(LENGTH(handoverNotes)), AVG(LENGTH(formNotes))`
- AI 학습 입력: `SELECT exercises, handoverNotes WHERE session.memberId=? ORDER BY performedAt DESC LIMIT 10`

### Edge Cases
- 입력 24h 누락 → cron 알림 → 48h 누락 시 default 기록 자동 생성
- 멘토 수정 (modifiedAt 기록) — AI 학습 시 가중치 ↓
- 회원이 운동 시퀀스 못 따라간 경우 → sets.completed=false 표시

---

## Rating

**Purpose**: 회원이 세션 후 멘토에게 주는 평가 (5점 + 코멘트).
**Related PRDs**: [👤 세션 진행](../user/2026-05-13-session-flow.html) · [🏢 멘토 등급](../platform/2026-05-13-mentor-tier-system.html)
**Lifecycle**: 회원 입력 → 저장 → 멘토 averageRating 갱신

### Fields

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| id | String | ✓ | cuid() | PK |
| sessionId | String | ✓ | - | FK → Session (1:1) |
| memberId | String | ✓ | - | denorm |
| mentorId | String | ✓ | - | denorm |
| score | Int | ✓ | - | 1-5 |
| comment | Text? | - | null | 자유 텍스트 |
| createdAt | DateTime | ✓ | now() | |
| publicOnProfile | Boolean | ✓ | true | 멘토 프로필 노출 여부 |

### Validation
- sessionId unique (1:1, 1세션 = 1 평가)
- score ∈ {1, 2, 3, 4, 5}
- session.status = 'completed' 만 평가 가능
- 평가 가능 기간: session.completedAt + 7일 이내

### Indexes
- `sessionId` (unique)
- `[mentorId]` — 멘토 평점 집계
- `[memberId, createdAt]` — 회원 평가 이력

### Common Queries
- 멘토 평균 평점: `AVG(score) WHERE mentorId=?`
- 멘토 평점 분포: `GROUP BY score WHERE mentorId=?`
- 회원 평가 누락: `Session WHERE status='completed' AND id NOT IN (SELECT sessionId FROM Rating)`

### Edge Cases
- 평가 시점 24h 미응답 → 푸시 알림 (1회)
- 평가 시점 7일 미응답 → 자동 default 5점 (영향 ↓)
- 평가 후 7일 이내 수정 가능 (이후 lock)
- 부적절한 코멘트 신고 → 운영자 검토 → publicOnProfile=false

## 📘 사용 PRD

[👤 AI 가이드](../user/2026-05-13-ai-coaching.html) · [💪 세션 진행](../mentor/2026-05-13-session-flow.html) · [🏢 AI 엔진](../platform/2026-05-13-ai-engine.html)

---

| 2026-05-13 | 초안 — SessionRecord·Rating 상세 명세 |
