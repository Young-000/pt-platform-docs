---
title: 마이그레이션 계획
parent: 🗄️ 데이터
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 마이그레이션 계획 — 기존 → 새 스키마

**Status**: Draft · **Updated**: 2026-05-13

## 현재 스키마 (12 테이블)

```
profiles · memberships · coaches · branches · rooms · bookings ·
session_records · time_slots · coach_branches · reviews · inbody_records ·
goals · settlements
```

## 새 스키마 (40+ 모델)

위 [스키마 페이지](./schema.html) 참고.

## 매핑 (현재 → 새)

| 현재 | 새 | 변경 |
|---|---|---|
| `profiles` (role: member/coach/admin) | `Member` / `Mentor` / `Admin` 3 테이블 분리 | role별 컬럼 분리, FK 정리 |
| `memberships.tier (basic/standard/premium)` | `Membership.type (week1/week2)` | tier 폐기, 회차 단순화 |
| `memberships.space_credits + pt_credits` | `Membership.creditsRemaining` 단일 | 분리 폐기 |
| `coaches.status (pending/approved)` | `Mentor.tier + status` | 등급 + 상태 분리 |
| `coaches.premium_rate` | `Mentor.proCurrentRate` (Pro만) | 일반은 본사 고정 |
| `bookings (room_id + start/end time)` | `Reservation + Session + CardioSlot + RoomSlot` | 90분 세트 분해 |
| `bookings.mode (self/smart_session)` | 단일 — 모두 세션 | mode 폐기 |
| `time_slots (60분, 자유)` | `MentorBlock (30분)` | 60→30분, 매칭 자동화 |
| `session_records` | `SessionRecord` | 거의 동일, jsonb 강화 |
| `settlements (월)` | `MentorPayout (격주) + PayoutPeriod` | 월 → 격주, 분배 분리 |
| `inbody_records`, `goals` | 동일 유지 | (선택) Member에 직접 연결 |
| `reviews` | `Rating` | 단순화 |
| `branches` | `Store` | rename |
| `rooms` | `Room` | 거의 동일 |

## 마이그레이션 단계

### Phase A — 신규 테이블 추가 (down-time ❌)
1. 새 모델 추가 (`Mentor`, `MentorBlock`, `FixedSlot`, `CardioSeat`, `CardioSlot`, `RoomSlot`, `PointBalance`, `BonusCredit`, `DayPass`, `AIRecommendation`, `Phase`, `ExerciseLibrary`, ...)
2. 기존 테이블 그대로 유지
3. 새 컬럼 추가 (`Membership.contractMonths`, `Membership.autoRenew` 등)

### Phase B — 데이터 변환 (사용량 적은 시간)
1. `profiles.role=coach` → `Mentor` 행 생성 + 기존 ID 매핑
2. `profiles.role=member` → `Member` 행 생성
3. `memberships` 변환:
   - tier=basic + space_credits=8 + pt=0 → week1? 또는 week2 (회수로 판단)
   - tier=standard → week2 + pt 회차 → 회원에게 안내 후 변환
   - tier=premium → 동일
4. `bookings` → `Reservation + Session + slots`:
   - 기존 60분 = 새 RoomSlot 60분 매핑 (자율 30분 + 멘토 30분으로 가정)
   - 카디오 슬롯 = 별도 생성 (선택)
5. `time_slots` (60분) → `MentorBlock` (30분 × 2 분해)
6. `settlements` (월) → `MentorPayout` (격주 분할)

### Phase C — 코드 전환
1. API 새 모델 기준으로 수정 (별도 PRD)
2. 프론트 (`mvp`, `partner`, `admin`) 새 entities 사용
3. 기존 엔드포인트 deprecated marker

### Phase D — 기존 테이블 폐기
1. 검증 후 (1-2주) 옛 테이블 drop
2. `profiles`, `bookings`, `time_slots`, `settlements`, `coaches` 폐기

## 다운타임 전략

- Phase A·B: down-time ❌ (병행 운영)
- Phase C: 가능하면 새벽 (회원 사용 적은 시간)
- Phase D: 완전 검증 후

## 롤백 계획

- 각 Phase별 백업
- Prisma migration `migrate reset` + restore 절차
- 1주일 유예 기간 (Phase D 전) — 문제 시 코드만 옛 모델로 되돌림

---

| 2026-05-13 | 초안 — Phase A~D 단계별 + 매핑 표 + 롤백 |
