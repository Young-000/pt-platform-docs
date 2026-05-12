---
title: 컨벤션
parent: 🔌 API
grand_parent: 스펙 (PRD)
nav_order: 2
---

# 컨벤션

**Status**: Draft · **Updated**: 2026-05-13

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

---

| 2026-05-13 | 초안 |
