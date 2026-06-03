---
title: 비용 관리
parent: 🚀 인프라·모니터링
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 비용 관리

**Status**: Draft · **Updated**: 2026-06-04

> recoverGX 피벗 반영 — GX 모델 6종 테이블 추가에 따른 RDS 용량 소폭 증가 예상. 인프라 단가 구조는 동일. [ADR 0011](../decisions/0011-recovergx-gx-pivot.html) 참조.

## 주요 비용

- AWS RDS·ECS (us-east-1): 월 ~100만
- Vercel Pro (4앱 — mvp/partner/admin/landing): 월 50만
- AI API (Claude·OpenAI): 회원당 월 ~10,000원
- Solapi 알림톡: ~30,000원/지점/월
- Sentry·DataDog: ~50,000원/월

→ 회원 200명 + 1지점 기준 인프라 = 월 약 350만 (회원당 ~17,500원)

---

| 2026-05-13 | 초안 |
| 2026-06-04 | recoverGX 피벗 — GX 테이블 추가 영향 메모, 랜딩 앱 Vercel 포함 |
