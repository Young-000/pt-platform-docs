---
title: 엔드포인트 카탈로그
parent: 🔌 API
grand_parent: 스펙 (PRD)
nav_order: 1
---

# API 엔드포인트 카탈로그 (v2 + GX)

**Status**: v2 Accepted · GX Implemented · **Updated**: 2026-06-03
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0003](../../decisions/0003-free-gym-add-on.html) · [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html) · [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html)

> **GX 추가 (2026-06-03)**: recoverGX 피벗으로 `/api/gx/*` · `/api/wallet/*` · `/api/gx-admin/*` 라우트군 구현. 기존 v2 PT 라우트는 보존(프론트 미노출). 정본 설계: `pt-platform/docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`.

## GX 오픈 플랫폼 (recoverGX — 구현 완료)

### 지갑 (`/api/wallet`)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/wallet/me` | member | 잔액 + 거래 내역 |
| GET | `/api/wallet/packages` | public | 활성 충전 패키지 목록 |
| POST | `/api/wallet/charge` | member | 충전 (mock PG, `idempotencyKey` 필수 — 이중 적립 방어) |

### GX 클래스·예약·정산 (`/api/gx`)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/gx/meta` | public | 지점·룸·강사·카테고리·가격범위(`priceRange`) |
| GET | `/api/gx/classes` | public | 시간표 + 잔여석 |
| POST | `/api/gx/classes` | admin + 검증강사 | 개설 (가격 범위 검증·카테고리 존재 검증) |
| GET | `/api/gx/classes/mine` | mentor | 내 클래스 + 수강생 명단 |
| GET | `/api/gx/bookings/mine` | member | 내 예약 목록 (예정/지난) |
| POST | `/api/gx/bookings` | member | 드롭인 예약 (지갑 차감 + 정원 점유, 단일 트랜잭션, idempotency) |
| DELETE | `/api/gx/bookings/:id` | member | 취소 + 지갑 환불 (마감 전: 전액, 마감 후: 0원) |
| PATCH | `/api/gx/bookings/:id/attendance` | mentor(본인 클래스) | 출석 체크 (attended / no_show) |
| POST | `/api/gx/classes/:id/complete` | admin·mentor | 클래스 완료 → `GxSettlement` 자동 생성 |
| DELETE | `/api/gx/classes/:id` | admin·mentor(본인) | 폐강 + 예약자 전원 환불 + status=cancelled |
| GET | `/api/gx/settlements` | admin·mentor(본인) | 정산 내역 (클래스명·매출·지급액·마진) |

### GX 어드민 룰 (`/api/gx-admin`)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/gx-admin/policy` | admin | GX 정책 조회 (가격범위·환불마감시간) |
| PUT | `/api/gx-admin/policy` | admin | GX 정책 수정 (`gx_policy_singleton` upsert) |
| GET | `/api/gx-admin/packages` | admin | 충전 패키지 목록 |
| POST | `/api/gx-admin/packages` | admin | 충전 패키지 생성 |
| PATCH | `/api/gx-admin/packages/:id` | admin | 충전 패키지 수정·비활성화 (active 필드) |
| GET | `/api/gx-admin/payout-policies` | admin | 정산 정책 목록 |
| POST | `/api/gx-admin/payout-policies` | admin | 정산 정책 생성 |
| PATCH | `/api/gx-admin/payout-policies/:id` | admin | 정산 정책 수정·비활성화 (active 필드) |
| GET | `/api/gx-admin/mentors` | admin | 강사 GX 개설 현황 |
| PATCH | `/api/gx-admin/mentors/:id` | admin | 강사 GX 개설 권한 토글 (`gxOpenEnabled`) + 정산 정책 할당 |

> **강사 개설 권한**: `Mentor.gxOpenEnabled` 전용 필드 — `MentorTier` 대신 사용 (tier 변별력 없음). 어드민이 토글.
> **GxPolicy 싱글톤**: 고정 ID `gx_policy_singleton` upsert로 단일 행 보장.
> **에러 코드 추가**: `INSUFFICIENT_BALANCE` (잔액 부족, 프론트 충전 CTA 분기), `REFUND_CUTOFF_PASSED` (환불 마감 후 취소).

---

## PT 레일 (보존·프론트 미노출)

{: .warning }
> 아래 엔드포인트는 코드베이스에 보존되어 있으나, recoverGX 전환 후 3앱 네비게이션에서 숨겨진 상태. 재활성화 여부 미결정.

## 인증 (Auth)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| POST | `/api/auth/register` | public | 회원 가입 |
| POST | `/api/auth/login` | public | 로그인 (JWT 발급) |
| POST | `/api/auth/refresh` | public | 토큰 갱신 |
| POST | `/api/auth/logout` | auth | 로그아웃 |
| POST | `/api/auth/verify-phone` | auth | 휴대폰 인증 |

## 회원 (Member)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/members/me` | member | 본인 프로필 |
| PATCH | `/api/members/me` | member | 프로필 수정 |
| GET | `/api/members/me/dashboard` | member | 홈 대시보드 (예약·잔여 회차·자유 헬스 자격) |
| GET | `/api/members/me/progress?period=week\|month` | member | 운동량 추이 |
| GET | `/api/members/me/sessions` | member | 세션 히스토리 |
| GET | `/api/members/me/sessions/:id` | member | 세션 상세 |

## 멘토 (Mentor)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/mentors/me` | mentor | 본인 정보 (등급·통계) |
| PATCH | `/api/mentors/me` | mentor | 프로필 수정 |
| GET | `/api/mentors/me/today` | mentor | 오늘 일정 |
| GET | `/api/mentors/me/blocks?from&to` | mentor | 30분 unit 슬롯 조회 |
| POST | `/api/mentors/me/blocks` | mentor | 슬롯 오픈 |
| POST | `/api/mentors/me/blocks/bulk` | mentor | 반복 슬롯 등록 |
| DELETE | `/api/mentors/me/blocks/:id` | mentor | 슬롯 닫기 (룰 적용) |
| POST | `/api/mentors/me/pro-application` | mentor | Pro 인증 신청 |
| GET | `/api/mentors/me/pro-application` | mentor | 신청 진행 |
| GET | `/api/mentors/me/complaints` | mentor | 본인 컴플레인 |
| GET | `/api/mentors/me/tier-history` | mentor | 등급 변경 이력 |
| GET | `/api/mentors/:id` (public) | public | 멘토 프로필 (예약 선택 화면용) |

## 카테고리·프로그램 (v2 신규)

> 상세: [v2-categories](./v2-categories.html) · [v2-programs](./v2-programs.html)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/categories` | public | 활성 코스 카테고리 리스트 |
| POST | `/api/categories` | admin | 카테고리 생성 |
| PATCH | `/api/categories/:id` | admin | 카테고리 수정 |
| DELETE | `/api/categories/:id` | admin | 소프트 삭제 |
| GET | `/api/programs?categoryId=&mentorId=` | public | 프로그램 리스트 (카테고리·강사 필터) |
| POST | `/api/programs` | admin | 프로그램 생성 |
| PATCH | `/api/programs/:id` | admin | 프로그램 수정 |
| DELETE | `/api/programs/:id` | admin | 소프트 삭제 |
| GET | `/api/mentors/:id/programs` | public | 강사가 제공하는 프로그램 매핑 |
| PUT | `/api/mentors/me/programs` | mentor | 본인 프로그램 매핑 갱신 |

## 예약 (Reservation — v2)

> 상세: [v2-reservations](./v2-reservations.html)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/slots/available?date=&categoryId=&duration=` | member | 카테고리·시간 가용 강사 슬롯 |
| GET | `/api/slots/mentor/:mentorId?from=&to=` | member | 특정 강사 가용 슬롯 |
| POST | `/api/reservations` | member | 예약 생성 (강사 + 프로그램 + 30/60분) |
| GET | `/api/reservations` | member | 본인 예약 리스트 |
| GET | `/api/reservations/:id` | member·mentor | 예약 상세 |
| PATCH | `/api/reservations/:id` | member | 변경 (룰 적용) |
| DELETE | `/api/reservations/:id` | member | 취소 (룰 적용) |
| POST | `/api/reservations/:id/check-in` | member | QR 체크인 |
| POST | `/api/day-passes/:id/use` | member | 당일 예약권 사용 |
| POST | `/api/fixed-slots` | member | 고정 슬롯 등록 (자유 선택) |
| GET | `/api/fixed-slots` | member | 본인 고정 슬롯 |
| PATCH | `/api/fixed-slots/:id` | member | 변경 (월 1회) |

> **v1 폐기 endpoint**: `/api/reservations/match-candidates`, `/api/reservations/:id/reject` — 자동 매칭 흐름 제거.

## 자유 헬스 (Free Gym — v2 신규)

> 상세: [v2-free-gym](./v2-free-gym.html)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| POST | `/api/free-gym/enter` | member | QR 체크인 (회차권 자격 검증) |
| POST | `/api/free-gym/exit` | member | 체크아웃 |
| GET | `/api/free-gym/today` | member | 오늘 본인 visit |
| GET | `/api/admin/free-gym/visits?from=&to=&storeId=` | admin | 운영 모니터링 |

## 세션 (Session)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/sessions/today` | member·mentor | 오늘 세션 |
| GET | `/api/sessions/:id` | member·mentor | 세션 상세 |
| GET | `/api/sessions/:id/pre-info` | mentor | 직전 회원 정보 |
| POST | `/api/sessions/:id/check-in` | member | 회원 체크인 |
| POST | `/api/sessions/:id/record` | mentor | 세션 기록 |
| GET | `/api/sessions/:id/summary` | member | 종료 요약 |
| POST | `/api/sessions/:id/rating` | member | 평가 제출 |

## 회차권·결제 (Ticket — v2)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| POST | `/api/tickets` | member | 회차권 결제 (`ticketType` ∈ one/four/twelve/twenty_four/forty_eight) |
| GET | `/api/tickets/me` | member | 본인 활성 회차권 |
| GET | `/api/tickets/me/history` | member | 회차권 이력 |
| POST | `/api/tickets/me/:id/pause` | member | 일시정지 (4회+ 회차권만) |
| POST | `/api/tickets/me/:id/resume` | member | 재개 |
| POST | `/api/tickets/me/:id/cancel` | member | 중도 해지 (환불 산출 + 처리) |
| GET | `/api/tickets/me/:id/refund-preview` | member | 환불액 미리보기 |
| POST | `/api/points/charge` | member | 포인트 충전 |
| POST | `/api/points/consume` | system | Pro 매칭 시 자동 차감 |
| POST | `/api/points/refund` | member | 미사용 포인트 환불 |
| GET | `/api/payments` | member | 결제 내역 |
| POST | `/api/payments/webhook` | PG (signed) | PG webhook |

> **v1 폐기 endpoint**: `/api/memberships*` — `MembershipTicket` 단일 모델로 통합 ([data/07](../data/07-membership.html)).

## AI

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/ai/recommendation?sessionId=` | member·mentor | 세션 추천 |
| GET | `/api/ai/recommendation/next` | member | 다음 세션 추천 (카테고리·강사 후보) |
| GET | `/api/ai/monthly-analysis?month=` | member | 월간 분석 |

## 정산 (Payout)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/mentors/me/payouts/current` | mentor | 이번 격주 |
| GET | `/api/mentors/me/payouts?from&to` | mentor | 정산 이력 |
| GET | `/api/mentors/me/payouts/:id` | mentor | 정산 상세 |
| GET | `/api/mentors/me/payouts/:id/statement` | mentor | PDF 명세 |
| GET | `/api/mentors/me/tax-reports/:month` | mentor | 세무 자료 |
| PATCH | `/api/mentors/me/bank-account` | mentor | 계좌 변경 |

## 알림 (Notifications)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/notifications/me` | auth | 인앱 알림 |
| PATCH | `/api/notifications/me/:id/read` | auth | 읽음 처리 |
| PATCH | `/api/notifications/me/preferences` | auth | 채널·마케팅 설정 |
| POST | `/api/notifications/internal/send` | system | 시스템 트리거 |

## 어드민 (Admin)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/admin/dashboard` | admin | KPI 대시보드 |
| GET | `/api/admin/members` | admin | 회원 리스트 |
| GET | `/api/admin/mentors` | admin | 멘토 리스트 |
| POST | `/api/admin/mentors/:id/verify` | admin | 검증 코스 통과 처리 |
| GET | `/api/admin/pro-applications` | admin | Pro 신청 큐 |
| POST | `/api/admin/pro-applications/:id/decide` | admin | 심사 결정 |
| GET | `/api/admin/complaints` | admin | 컴플레인 큐 |
| POST | `/api/admin/complaints/:id/resolve` | admin | 해결 |
| GET | `/api/admin/reservations` | admin | 예약 모니터링 |
| GET | `/api/admin/free-gym/visits` | admin | 자유 헬스 운영 |
| GET | `/api/admin/payouts/:periodId` | admin | 격주 정산 |
| POST | `/api/admin/payouts/:id/retry` | admin | 입금 재시도 |
| GET | `/api/admin/stores` | admin | 지점 관리 |
| GET | `/api/admin/pricing-config` | admin | 회차권 가격·Pro 옵션 변수 |
| PATCH | `/api/admin/pricing-config` | admin | 정책 변수 갱신 |

## 시스템 (System / Cron)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| POST | `/api/system/cron/no-show-detection` | cron | T+15 노쇼 감지 |
| POST | `/api/system/cron/fixed-slot-auto-book` | cron | 매주 고정 슬롯 자동 예약 |
| POST | `/api/system/cron/free-gym-auto-exit` | cron | 180분 무활동 자동 exit |
| POST | `/api/system/cron/ticket-auto-activate` | cron | 결제 후 30일 미사용 자동 활성화 |
| POST | `/api/system/cron/ticket-expiry` | cron | 만료 처리 + grace period 알림 |
| POST | `/api/system/cron/payout-calculate` | cron | 격주 정산 산출 |
| POST | `/api/system/cron/tax-report-generate` | cron | 월말 세무 자료 |

---

## 응답 형식 (공통)

성공:
```json
{
  "data": { /* 리소스 */ },
  "meta": { "timestamp": "2026-05-16T19:00:00+09:00" }
}
```

리스트:
```json
{
  "data": [...],
  "pagination": { "page": 1, "size": 20, "total": 100 },
  "meta": {...}
}
```

에러:
```json
{
  "error": {
    "code": "BLOCK_TAKEN",
    "message": "선택한 강사 슬롯이 이미 예약되었습니다.",
    "details": {...}
  }
}
```

## 에러 코드 (주요)

| 코드 | HTTP | 의미 |
|---|---|---|
| `UNAUTHORIZED` | 401 | 인증 실패 |
| `FORBIDDEN` | 403 | 권한 없음 |
| `NOT_FOUND` | 404 | 리소스 없음 |
| `VALIDATION_ERROR` | 400 | 입력 오류 |
| `BLOCK_TAKEN` | 409 | 강사 30분 unit 이미 점유 |
| `INSUFFICIENT_ROOM` | 409 | 룸 필요 프로그램인데 가용 룸 없음 |
| `INSUFFICIENT_CREDITS` | 422 | 회차 부족 |
| `INSUFFICIENT_POINTS` | 422 | Pro 옵션 포인트 부족 |
| `TICKET_EXPIRED` | 422 | 회차권 만료 |
| `FREE_GYM_NOT_ELIGIBLE` | 403 | 자유 헬스 자격 ❌ (회차권 ❌ 또는 grace 만료) |
| `POLICY_VIOLATION` | 422 | 정책 위반 (6h 이내 취소 등) |
| `PAYMENT_FAILED` | 402 | PG 결제 실패 |
| `RATE_LIMITED` | 429 | 요청 한도 초과 |
| `INTERNAL_ERROR` | 500 | 서버 오류 |

---

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-13 | v1 초안 — 12 도메인 그룹·80+ endpoint |
| 2026-05-16 | **v2 재작성** — 매칭(`match-candidates`/`reject`) 폐기, 카테고리·프로그램·자유 헬스 endpoint 신설, 회차권(`/api/tickets`) 단일 모델, 에러코드 v2 갱신. v1 본문은 `_archive/v1-api-catalog.md` 참조. (ADR 0001 · 0003 · 0004) |
| 2026-06-03 | **GX 추가** — `/api/gx/*` (클래스·예약·정산) · `/api/wallet/*` (지갑·충전) · `/api/gx-admin/*` (정책·패키지·강사) 신설. PT 라우트 보존·미노출 배너 추가. (ADR 0011) |
