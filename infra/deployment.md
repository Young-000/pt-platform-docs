---
title: 배포 (Vercel·ECS·RDS)
parent: 🚀 인프라·모니터링
grand_parent: 스펙 (PRD)
nav_order: 2
---

# 배포 (Vercel·ECS·RDS)

**Status**: Draft · **Updated**: 2026-06-04

> recoverGX 피벗 반영 — 랜딩(`@pt/landing`) Vercel 추가, API에 gx / wallet / gx-admin 라우트군 포함. [ADR 0011](../decisions/0011-recovergx-gx-pivot.html) 참조.

## Vercel
- 프론트 4개 (mvp / partner / admin / landing — `@pt/landing`) 자동 배포
- 환경변수 관리

## AWS ECS Fargate
- `apps/api` 컨테이너 (us-east-1)
- 주요 API 라우트군: auth / members / sessions / gx / wallet / gx-admin
- RDS PostgreSQL (`recover` DB → `pt_platform` 스키마)

## 배포 흐름
- PR → 미리보기 (Vercel)
- main merge → 프로덕션

→ Phase 1 직전 상세 작성

---

| 2026-05-13 | 초안 |
| 2026-06-04 | recoverGX 피벗 — 랜딩 앱 추가, GX/wallet/gx-admin 라우트 명시 |
