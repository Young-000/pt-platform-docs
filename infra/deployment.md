---
title: 배포 (Vercel·ECS·RDS)
parent: 🚀 인프라·모니터링
grand_parent: 스펙 (PRD)
nav_order: 2
---

# 배포 (Vercel·ECS·RDS)

**Status**: Draft · **Updated**: 2026-05-13

## Vercel
- 프론트 3개 (mvp/partner/admin) 자동 배포
- 환경변수 관리

## AWS ECS Fargate
- `apps/api` 컨테이너
- RDS PostgreSQL

## 배포 흐름
- PR → 미리보기 (Vercel)
- main merge → 프로덕션

→ Phase 1 직전 상세 작성

---

| 2026-05-13 | 초안 |
