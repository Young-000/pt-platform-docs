---
title: 🔌 API
parent: 스펙 (PRD)
nav_order: 8
has_children: true
---

# 🔌 API 카탈로그

> 모든 endpoint 통합. PRD에 분산된 API를 한곳에서 검색·일관성 관리.

## 하위 문서

- [엔드포인트 카탈로그](./catalog.html) — 리소스별 endpoint 전체 목록
- [컨벤션](./conventions.html) — 네이밍·요청/응답·에러·페이지네이션
- [인증·권한](./auth.html) — JWT·role·permission

## 도메인 그룹

| 그룹 | 베이스 | 주요 리소스 |
|---|---|---|
| Auth | `/api/auth` | login·register·refresh |
| Members | `/api/members` | profile·preferences |
| Mentors | `/api/mentors` | tier·blocks·rate |
| Stores | `/api/stores` | rooms·cardio-seats |
| Reservations | `/api/reservations` | matching·cancel·day-pass |
| Sessions | `/api/sessions` | check-in·record·rating |
| Memberships | `/api/memberships` | pause·refund·points |
| Payments | `/api/payments` | charge·webhook |
| AI | `/api/ai` | recommendation·analysis |
| Payouts | `/api/payouts` | mentor·tax |
| Notifications | `/api/notifications` | send·preferences |
| Admin | `/api/admin` | complaints·applications·tier-change |

## 기술 스택

- Express + TypeScript (`apps/api/`)
- 인증: JWT (HS256, 7일 만료)
- 페이로드: camelCase (자동 snake_case 변환)
- 인코딩: UTF-8 JSON
- 시간: ISO 8601 (서버 KST, +09:00)
- 응답 시간: p95 < 200ms 목표
