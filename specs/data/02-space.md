---
title: 2. Space (Store·Room·CardioSeat)
parent: 🗄️ 데이터
grand_parent: 스펙 (PRD)
nav_order: 12
---

# 2. Space — Store·Room·CardioSeat

지점·방·카디오 자리. [4D 공간](../../service/space.html) 정책 반영.

{: .warning }
> **v2 변경 ([ADR 0001](../../decisions/0001-consumer-pivot.html))**: 표준 지점 = **60평** (8 private room × 4평 + 오픈 28평). 카디오존(CardioSeat) 모델은 v1 폐기 — v2에선 오픈 공간(OpenSpace) 단일 자원. 본문 스키마는 v1이며 데이터 재설계 시 CardioSeat → OpenSpace 마이그레이션 + Room 평수 4평 반영 필요.

## Store

**Purpose**: 1지점 정보. 표준 90평 (8방 + 카디오 6 + 공용 22평) — v1 (v2: 60평).
**Related PRDs**: [🏢 세션 시스템](../platform/2026-05-13-session-system.html) · [🏢 예약 시스템](../platform/2026-05-13-reservation-system.html)
**Lifecycle**: 인테리어 → 개점 → 운영 → 폐점

### Fields

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| id | String | ✓ | cuid() | PK |
| name | String | ✓ | - | "강남 1호점" |
| address | String | ✓ | - | 주소 전체 |
| totalArea | Decimal(5,2) | ✓ | - | 평 (90.00 표준) |
| roomCount | Int | ✓ | 8 | 방 개수 |
| cardioSeatCount | Int | ✓ | 6 | 카디오 자리 수 |
| openingTime | String | ✓ | "06:00" | 평일 오픈 |
| closingTime | String | ✓ | "23:00" | 평일 클로즈 |
| weekendOpen | String | - | "08:00" | 주말 |
| weekendClose | String | - | "21:00" | 주말 |
| status | String | ✓ | active | active/closed/maintenance |
| openedAt | DateTime | ✓ | - | 개점일 |
| createdAt | DateTime | ✓ | now() | 생성일 |

### Validation
- totalArea: 50-200평 (소형~대형 범위)
- roomCount: 4-12 (Phase 1 표준 8)
- cardioSeatCount: 방 수의 절반~동일 (효율적 매칭)
- closingTime > openingTime

### Indexes
- `status` — 활성 지점만 조회

### Common Queries
- 운영 중 지점: `WHERE status = 'active'`
- 지점별 회원 분포: `Member JOIN Reservation JOIN Session JOIN ... GROUP BY storeId`

### Edge Cases
- 임시 폐쇄 (인테리어): status='maintenance' → 신규 예약 ❌, 기존 예약 다른 지점 안내
- 영구 폐점: 90일 전 회원 알림, 다른 지점 이전 옵션 제공

---

## Room

**Purpose**: private room (1:1 멘토링 60분 슬롯).
**Related PRDs**: [🏢 세션 시스템](../platform/2026-05-13-session-system.html)
**Lifecycle**: 인테리어 → active → (보수 시) maintenance → (폐쇄) inactive

### Fields

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| id | String | ✓ | cuid() | PK |
| storeId | String | ✓ | - | FK → Store |
| number | Int | ✓ | - | 1-8 (지점 내 unique) |
| area | Decimal(4,2) | ✓ | - | 평 (7.00 표준) |
| staggerGroup | String | ✓ | A | A (정각 시작) / B (30분 시작) |
| status | String | ✓ | active | active/maintenance/inactive |
| createdAt | DateTime | ✓ | now() | |

### Validation
- (storeId, number) unique
- area: 5-10평 범위
- staggerGroup: 정각 4방 + 30분 4방 = stagger 패턴 enforcement

### Indexes
- `[storeId, number]` (unique)
- `[storeId, status]` — 매칭 시 활성 방 필터

### Common Queries
- 지점 활성 방: `WHERE storeId = ? AND status = 'active'`
- stagger 정각 방: `WHERE staggerGroup = 'A'`

### Edge Cases
- 방 유지보수 중 매칭됨: 자동 다른 방으로 swap (회원 알림)
- stagger 그룹 미설정: 시드 데이터 시점에 강제 (A 4개 + B 4개)

---

## CardioSeat

**Purpose**: 카디오존 자리 (런닝/바이크 30분 슬롯). 회원이 자리 단위로 예약.
**Related PRDs**: [🏢 세션 시스템](../platform/2026-05-13-session-system.html)
**Lifecycle**: 활성 → (기계 고장) maintenance → (수리 후) active

### Fields

| Field | Type | Required | Default | Description |
|---|---|---|---|---|
| id | String | ✓ | cuid() | PK |
| storeId | String | ✓ | - | FK |
| number | Int | ✓ | - | 1-6 (지점 내 unique) |
| equipment | String | - | null | "런닝머신" / "바이크" / "로잉머신" |
| status | String | ✓ | active | active/maintenance/inactive |
| createdAt | DateTime | ✓ | now() | |

### Validation
- (storeId, number) unique
- equipment enum
- 카디오 자리 6 = 방 8 매칭 (4 이론치 + 2 여유)

### Indexes
- `[storeId, number]` (unique)
- `[storeId, status]` — 매칭 시 활성 카디오 필터

### Common Queries
- 지점 활성 카디오: `WHERE storeId = ? AND status = 'active'`
- 카디오 자리당 일일 사용: `CardioSlot WHERE seatId = ? AND DATE(startAt) = ?`

### Edge Cases
- 기계 고장 시 (status=maintenance): 그 자리 슬롯 자동 닫힘, 회원 다른 자리로 swap
- 모든 자리 점유 시 (이론치 6 = 동시 6명): 추가 예약 차단

## 📘 사용 PRD

[🏢 세션 시스템](../platform/2026-05-13-session-system.html) · [🏢 예약 시스템](../platform/2026-05-13-reservation-system.html)

---

| 2026-05-13 | 초안 — Store/Room/CardioSeat 상세 명세 |
