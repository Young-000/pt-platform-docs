---
title: v2 — 프로그램 API
parent: 🔌 API
grand_parent: 스펙 (PRD)
nav_order: 6
---

# 🔌 v2 — 프로그램 API (`/api/programs`, `/api/mentors/:id/programs`)

**Status**: v2 Accepted · **Updated**: 2026-05-16
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html)
**🗄️ Data**: `Program`, `MentorProgram` (강사·프로그램 매핑)

> 프로그램 = 카테고리 안의 세부 코스 (예: "전신 스트레칭", "필라테스 입문", "근력 1:1 PT"). 강사는 본인이 제공할 수 있는 프로그램을 매핑한다.

## 1. Program 모델

| Field | Type | Required | Description |
|---|---|---|---|
| id | String | ✓ | PK |
| categoryId | String | ✓ | FK → CourseCategory |
| name | String | ✓ | "전신 스트레칭" |
| description | String? | - | |
| defaultDurationMinutes | Int | ✓ | 카테고리 기본값에서 상속 가능 |
| level | String? | - | "beginner" / "intermediate" / "advanced" |
| isActive | Boolean | ✓ | |
| sortOrder | Int | ✓ | |
| createdAt | DateTime | ✓ | |

## 2. MentorProgram (매핑)

| Field | Type | Required | Description |
|---|---|---|---|
| mentorId | String | ✓ | composite PK |
| programId | String | ✓ | composite PK |
| isPrimary | Boolean | ✓ | 강사 주력 종목 표기 |
| addedAt | DateTime | ✓ | |

## 3. 엔드포인트

### GET `/api/programs`
**권한**: public
**Query**: `?categoryId=&mentorId=&activeOnly=true`
**Response 200**:
```json
{
  "data": [
    {
      "id": "prog_stretch_full",
      "categoryId": "cat_stretch",
      "categoryName": "스트레칭",
      "name": "전신 스트레칭",
      "defaultDurationMinutes": 30,
      "level": "beginner",
      "isActive": true,
      "mentorCount": 4
    }
  ],
  "pagination": {...}
}
```

### POST `/api/programs`
**권한**: admin
**Body**:
```json
{
  "categoryId": "cat_pilates",
  "name": "필라테스 입문",
  "defaultDurationMinutes": 60,
  "level": "beginner"
}
```
**Validation**: `defaultDurationMinutes ∈ category.allowedDurations`

### PATCH `/api/programs/:id`
**권한**: admin
**Body**: partial

### DELETE `/api/programs/:id`
**권한**: admin
**Behavior**: 소프트 삭제 (`isActive=false`)

### GET `/api/mentors/:id/programs`
**권한**: public
**Response**: 강사가 매핑한 활성 프로그램 리스트 (회원 앱 강사 프로필 화면용)
```json
{
  "data": [
    { "programId": "prog_stretch_full", "categoryId": "cat_stretch", "name": "전신 스트레칭", "isPrimary": true }
  ]
}
```

### PUT `/api/mentors/me/programs`
**권한**: mentor
**Body**:
```json
{
  "programs": [
    { "programId": "prog_stretch_full", "isPrimary": true },
    { "programId": "prog_pt_strength", "isPrimary": false }
  ]
}
```
**Behavior**: 전체 매핑 replace (PATCH 아닌 PUT 시맨틱).
**Edge**: 이미 잡힌 예약과 매핑 해제 충돌 시 → 미래 예약 있는 매핑은 해제 차단 + `PROGRAM_HAS_RESERVATIONS` 에러.

## 4. 필터링 시나리오

회원 앱:
1. 카테고리 선택 → `GET /api/programs?categoryId=cat_stretch&activeOnly=true`
2. 프로그램 선택 → `GET /api/slots/available?categoryId=cat_stretch&programId=...&date=...&duration=30`

강사 앱:
1. 본인 매핑 보기 → `GET /api/mentors/:id/programs` (id = me)
2. 갱신 → `PUT /api/mentors/me/programs`

## 5. 에러

| 코드 | 의미 |
|---|---|
| `VALIDATION_ERROR` | duration 검증 / category 비활성 |
| `PROGRAM_HAS_RESERVATIONS` | 매핑 해제 시 미래 예약 잔존 |
| `NOT_FOUND` | 프로그램·카테고리 없음 |

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-16 | 신규 — v2 프로그램 CRUD + Mentor-Program 매핑 (ADR 0001) |
