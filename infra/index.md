---
title: 🚀 인프라·모니터링
nav_order: 11
has_children: true
---

# 🚀 인프라·모니터링

> Phase 1 런칭 필수. 배포·관측·비용·SLO.

> recoverGX 피벗 후 모노레포·ECS·RDS·Vercel 구조 승계. GX 모델 추가 테이블(6종) 포함. [ADR 0011](../decisions/0011-recovergx-gx-pivot.html) 참조.

## 하위 문서

- [배포](./deployment.html) — Vercel·ECS·RDS (랜딩·GX 라우트 포함)
- [모니터링·관측](./observability.html) — Sentry·DataDog·로그
- [비용 관리](./cost.html) — AI API·인프라 비용
- [백업·복구](./backup.html) — RDS·S3

## 현재 인프라 (스캔 결과)

- **프론트**: Vercel × 4 (mvp / partner / admin / landing — `@pt/landing`)
- **백엔드**: AWS ECS Fargate (`apps/api`, us-east-1) — gx / wallet / gx-admin 라우트군 포함
- **DB**: AWS RDS PostgreSQL (`recover` DB → `pt_platform` 스키마, GX 모델 6종 추가)
- **CDN**: Vercel edge
- **AI**: Anthropic Claude API (TBD 본격 연동)

## 신규 필요

- 🛡️ Sentry — 에러 추적
- 📊 DataDog 또는 GCP Cloud Logging — 로그·메트릭
- 🚨 Slack 알림 (배포·에러·SLO 위반)
- 💰 비용 대시보드 (AI API·AWS·Vercel)
