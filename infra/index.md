---
title: 🚀 인프라·모니터링
nav_order: 11
has_children: true
---

# 🚀 인프라·모니터링

> Phase 1 런칭 필수. 배포·관측·비용·SLO.

## 하위 문서

- [배포](./deployment.html) — Vercel·ECS·RDS
- [모니터링·관측](./observability.html) — Sentry·DataDog·로그
- [비용 관리](./cost.html) — AI API·인프라 비용
- [백업·복구](./backup.html) — RDS·S3

## 현재 인프라 (스캔 결과)

- **프론트**: Vercel × 3 (mvp / partner / admin)
- **백엔드**: AWS ECS Fargate (`apps/api`)
- **DB**: AWS RDS PostgreSQL (`recover` DB → `pt_platform` 스키마)
- **CDN**: Vercel edge
- **AI**: Anthropic Claude API (TBD 본격 연동)

## 신규 필요

- 🛡️ Sentry — 에러 추적
- 📊 DataDog 또는 GCP Cloud Logging — 로그·메트릭
- 🚨 Slack 알림 (배포·에러·SLO 위반)
- 💰 비용 대시보드 (AI API·AWS·Vercel)
