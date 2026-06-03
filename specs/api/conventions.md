---
title: 컨벤션
parent: 🔌 API
grand_parent: 스펙 (PRD)
nav_order: 2
---

# 컨벤션

**Status**: Draft · **Updated**: 2026-06-03

## URL 형식
- snake_case 경로 ❌ → camelCase (예: `/api/mentors/me/proApplication`)
- 리소스: 복수형 (`reservations`)
- 단일: ID (`reservations/:id`)

## 요청
- 페이로드: camelCase JSON
- 헤더 `Authorization: Bearer <token>`
- 시간: ISO 8601

## 응답
- 일관 형식: `{ data, meta }`
- 리스트: `{ data, pagination, meta }`
- 에러: `{ error: { code, message, details } }`

## 페이지네이션
- `?page=1&size=20` 또는 `?cursor=xxx`
- 응답 `pagination: { page, size, total }`

## 멱등성
- POST `Idempotency-Key` 헤더 지원 (결제·생성 액션)
- **GX 지갑 충전**: `WalletTransaction.idempotencyKey @unique` — DB 레벨 이중 적립 방어. 동일 키 재시도 시 기존 결과 replay.

## GX 전용 에러 코드

| 코드 | HTTP | 의미 |
|---|---|---|
| `INSUFFICIENT_BALANCE` | 422 | 지갑 잔액 부족 (충전 CTA 분기) |
| `REFUND_CUTOFF_PASSED` | 422 | 환불 마감 후 취소 (환불 0원, 좌석 복구) |
| `CLASS_CANCELLED` | 409 | 이미 폐강된 클래스 |
| `CLASS_FULL` | 409 | 정원 초과 |
| `GX_NOT_ENABLED` | 403 | 강사 GX 개설 권한 없음 (`gxOpenEnabled=false`) |
| `SETTLEMENT_DONE` | 409 | 정산 완료 후 출석 변경 불가 |

---

| 2026-05-13 | 초안 |
| 2026-06-03 | GX 멱등성·에러 코드 추가 (ADR 0011) |
