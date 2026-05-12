---
title: 엔드포인트 카탈로그
parent: 🔌 API
grand_parent: 스펙 (PRD)
nav_order: 1
---

# API 엔드포인트 카탈로그

**Status**: Draft · **Updated**: 2026-05-13
**관련 PRD**: 모든 [플랫폼 PRD](../platform/) · [👤 유저 PRD](../user/) · [💪 멘토 PRD](../mentor/)

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
| PATCH | `/api/members/me` | member | 프로필 수정 (페르소나·목표) |
| GET | `/api/members/me/dashboard` | member | 홈 대시보드 (예약·진행 등) |
| GET | `/api/members/me/phase` | member | 운동 Phase |
| GET | `/api/members/me/progress?period=week|month` | member | 운동량·중량 추이 |
| GET | `/api/members/me/handover-notes?limit=3` | member | 강사 인계 메모 요약 |
| GET | `/api/members/me/sessions` | member | 세션 히스토리 |
| GET | `/api/members/me/sessions/:id` | member | 세션 상세 |

## 멘토 (Mentor)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/mentors/me` | mentor | 본인 정보 (등급·통계) |
| PATCH | `/api/mentors/me` | mentor | 프로필 수정 |
| GET | `/api/mentors/me/today` | mentor | 오늘 일정 |
| GET | `/api/mentors/me/blocks?from&to` | mentor | 슬롯 조회 |
| POST | `/api/mentors/me/blocks` | mentor | 슬롯 오픈 |
| POST | `/api/mentors/me/blocks/bulk` | mentor | 반복 슬롯 등록 |
| DELETE | `/api/mentors/me/blocks/:id` | mentor | 슬롯 닫기 (룰 적용) |
| GET | `/api/mentors/me/obligation` | mentor | 의무 슬롯 상태 (Phase 1) |
| PATCH | `/api/mentors/me/rate` | mentor (pro) | Pro 단가 변경 |
| GET | `/api/mentors/me/rate-history` | mentor | 단가 변경 이력 |
| POST | `/api/mentors/me/pro-application` | mentor | Pro 인증 신청 |
| GET | `/api/mentors/me/pro-application` | mentor | 신청 진행 상황 |
| POST | `/api/mentors/me/pro-application/video` | mentor | 영상 업로드 |
| GET | `/api/mentors/me/complaints` | mentor | 본인 컴플레인 |
| GET | `/api/mentors/me/tier-history` | mentor | 등급 변경 이력 |
| GET | `/api/mentors/:id` (public) | public | 멘토 프로필 (회원 매칭 시) |

## 예약 (Reservation)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/slots/available?date=&isPeak=` | member | 가용 시간 슬롯 |
| POST | `/api/reservations/match-candidates` | member | 멘토 매칭 후보 3명 |
| POST | `/api/reservations` | member | 예약 생성 |
| GET | `/api/reservations` | member | 본인 예약 리스트 |
| GET | `/api/reservations/:id` | member·mentor | 예약 상세 |
| POST | `/api/reservations/:id/reject` | member | 자동 매칭 24h 거절 |
| PATCH | `/api/reservations/:id` | member | 변경 |
| DELETE | `/api/reservations/:id` | member | 취소 (룰 적용) |
| POST | `/api/check-in` | member | 세션 QR 체크인 |
| POST | `/api/fixed-slots` | member | 고정 슬롯 신청 |
| GET | `/api/fixed-slots` | member | 본인 고정 슬롯 |
| PATCH | `/api/fixed-slots/:id` | member | 변경 (월 1회) |
| POST | `/api/day-passes/:id/use` | member | 당일 예약권 사용 |

## 세션 (Session)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/sessions/today` | member·mentor | 오늘 세션 |
| GET | `/api/sessions/:id` | member·mentor | 세션 상세 |
| GET | `/api/sessions/:id/pre-info` | mentor | 세션 직전 회원 정보 |
| POST | `/api/sessions/:id/check-in` | member | 회원 QR 체크인 |
| POST | `/api/sessions/:id/record` | mentor | 세션 기록 저장 |
| GET | `/api/sessions/:id/summary` | member | 세션 종료 요약 |
| POST | `/api/sessions/:id/rating` | member | 평가 제출 |

## 멤버십·결제 (Membership)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| POST | `/api/memberships` | member | 가입 + 첫 결제 |
| GET | `/api/memberships/me` | member | 현재 멤버십 |
| POST | `/api/memberships/me/pause` | member | 일시정지 |
| POST | `/api/memberships/me/resume` | member | 재개 |
| POST | `/api/memberships/me/cancel` | member | 중도 해지 (환불) |
| GET | `/api/memberships/me/refund-preview` | member | 환불액 미리보기 |
| POST | `/api/points/charge` | member | 포인트 충전 |
| POST | `/api/points/consume` | system | Pro 매칭 시 자동 차감 |
| POST | `/api/points/refund` | member | 미사용 포인트 환불 |
| GET | `/api/payments` | member | 결제 내역 |
| POST | `/api/payments/webhook` | PG (signed) | PG 결제 webhook |

## AI

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/ai/recommendation?sessionId=` | member·mentor | 세션 추천 |
| GET | `/api/ai/recommendation/next` | member | 다음 세션 추천 |
| GET | `/api/ai/monthly-analysis?month=` | member | 월간 분석 |
| GET | `/api/ai/cardio-guide?sessionId=` | member | 카디오 가이드 |
| GET | `/api/ai/room-guide?sessionId=` | member | 방 자율 가이드 |

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
| GET | `/api/notifications/me` | auth | 내 인앱 알림 |
| PATCH | `/api/notifications/me/:id/read` | auth | 읽음 처리 |
| PATCH | `/api/notifications/me/preferences` | auth | 채널·마케팅 설정 |
| POST | `/api/notifications/internal/send` | system | 시스템 트리거 |

## 어드민 (Admin)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| GET | `/api/admin/dashboard` | admin | KPI 대시보드 |
| GET | `/api/admin/members` | admin | 회원 리스트·검색 |
| GET | `/api/admin/mentors` | admin | 멘토 리스트 |
| POST | `/api/admin/mentors/:id/verify` | admin | 검증 코스 통과 처리 |
| GET | `/api/admin/pro-applications` | admin | Pro 신청 큐 |
| POST | `/api/admin/pro-applications/:id/decide` | admin | 심사 결정 |
| GET | `/api/admin/complaints` | admin | 컴플레인 큐 |
| POST | `/api/admin/complaints/:id/resolve` | admin | 컴플레인 해결 |
| GET | `/api/admin/reservations` | admin | 예약 모니터링 |
| GET | `/api/admin/payouts/:periodId` | admin | 격주 정산 현황 |
| POST | `/api/admin/payouts/:id/retry` | admin | 입금 재시도 |
| GET | `/api/admin/stores` | admin | 지점 관리 |

## 시스템 (System / Cron)

| Method | Path | 권한 | 설명 |
|---|---|---|---|
| POST | `/api/system/cron/no-show-detection` | cron | T+15 노쇼 감지 |
| POST | `/api/system/cron/fixed-slot-auto-book` | cron | 매주 고정 슬롯 자동 예약 |
| POST | `/api/system/cron/payment-ledger-release` | cron | 7일 후 escrow → releasable |
| POST | `/api/system/cron/payout-calculate` | cron | 격주 정산 산출 |
| POST | `/api/system/cron/membership-renewal` | cron | D-1 자동 갱신 |
| POST | `/api/system/cron/tax-report-generate` | cron | 월말 세무 자료 생성 |

---

## 응답 형식 (전체 공통)

성공:
```json
{
  "data": { /* 리소스 */ },
  "meta": { "timestamp": "2026-05-13T19:00:00+09:00" }
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
    "code": "RESERVATION_CONFLICT",
    "message": "이 슬롯은 이미 예약되었습니다.",
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
| `RESERVATION_CONFLICT` | 409 | 슬롯 중복 |
| `INSUFFICIENT_CREDITS` | 422 | 회차 부족 |
| `INSUFFICIENT_POINTS` | 422 | 포인트 부족 |
| `POLICY_VIOLATION` | 422 | 정책 위반 (6h 이내 취소 등) |
| `PAYMENT_FAILED` | 402 | PG 결제 실패 |
| `RATE_LIMITED` | 429 | 요청 한도 초과 |
| `INTERNAL_ERROR` | 500 | 서버 오류 |

---

| 2026-05-13 | 초안 — 12 도메인 그룹·80+ endpoint 통합 |
