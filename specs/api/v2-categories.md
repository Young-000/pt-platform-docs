---
title: v2 — 카테고리 API
parent: 🔌 API
grand_parent: 스펙 (PRD)
nav_order: 5
---

# 🔌 v2 — 카테고리 API (`/api/categories`)

**Status**: v2 Accepted · **Updated**: 2026-05-16
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html)
**🗄️ Data**: `CourseCategory` (`specs/data/02-space.md` 또는 별도 모델 — admin master)

> 카테고리 = "스트레칭", "필라테스", "1:1 PT", "자유 헬스" 등 **확장 가능 마스터**. v2 핵심: `requiresPrivateRoom`·`requiresMentor`·`defaultDurationMinutes`로 예약·룸 배정·정산 로직이 분기.

## 1. CourseCategory 필드

| Field | Type | Required | Description |
|---|---|---|---|
| id | String | ✓ | PK |
| name | String | ✓ | "스트레칭" 등 (UI 표기) |
| slug | String | ✓ | "stretching" (URL·로깅) |
| description | String? | - | 회원 안내 |
| requiresPrivateRoom | Boolean | ✓ | true → 룸 자동 배정 + 룸 점유 검사 |
| requiresMentor | Boolean | ✓ | false면 자유 헬스 (별도 흐름) |
| defaultDurationMinutes | Int | ✓ | 30 또는 60 (회원 UI 기본 선택) |
| allowedDurations | Int[] | ✓ | 예: [30, 60] |
| iconUrl | String? | - | |
| sortOrder | Int | ✓ | 회원 앱 표시 순서 |
| isActive | Boolean | ✓ | 소프트 비활성 |
| createdAt | DateTime | ✓ | |

## 2. 엔드포인트

### GET `/api/categories`
**권한**: public
**Query**: `?activeOnly=true` (기본 true)
**Response 200**:
```json
{
  "data": [
    {
      "id": "cat_stretch",
      "name": "스트레칭",
      "slug": "stretching",
      "requiresPrivateRoom": true,
      "requiresMentor": true,
      "defaultDurationMinutes": 30,
      "allowedDurations": [30, 60],
      "sortOrder": 1,
      "isActive": true
    }
  ],
  "meta": { "timestamp": "..." }
}
```

### POST `/api/categories`
**권한**: admin
**Body**:
```json
{
  "name": "필라테스",
  "slug": "pilates",
  "requiresPrivateRoom": true,
  "requiresMentor": true,
  "defaultDurationMinutes": 60,
  "allowedDurations": [30, 60],
  "sortOrder": 2
}
```
**Validation**: `slug` unique · `defaultDurationMinutes ∈ allowedDurations` · `allowedDurations` 모든 값 30의 배수
**Response 201**: 생성된 카테고리

### PATCH `/api/categories/:id`
**권한**: admin
**Body**: partial CourseCategory 필드
**Edge**: `requiresPrivateRoom` 변경은 진행 중 예약에 영향 ❌ (생성 시점 denorm). `isActive=false`는 신규 예약만 차단.

### DELETE `/api/categories/:id`
**권한**: admin
**Behavior**: 소프트 삭제 = `isActive=false` (회원·예약 무결성 유지). 실제 row 삭제 ❌.
**Response 204**

## 3. 에러

| 코드 | 의미 |
|---|---|
| `VALIDATION_ERROR` | slug 중복 / duration 검증 실패 |
| `CATEGORY_IN_USE` | (DELETE 시) 미래 예약 존재 → 비활성화만 허용 |

## 4. 사용 흐름

```
회원 앱 예약 화면 → GET /api/categories → 선택
  → POST /api/reservations { categoryId, programId, ... }
  → 백엔드: category.requiresPrivateRoom로 룸 배정 트랜잭션 분기
```

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-16 | 신규 — v2 카테고리 마스터 API (ADR 0001) |
