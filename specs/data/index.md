---
title: 🗄️ 데이터
parent: 스펙 (PRD)
nav_order: 4
has_children: true
---

# 🗄️ 데이터 (DB Schema·ERD·Migration)

> PRD에 분산된 데이터 모델을 **통합 관리**. 코드 작성 전 락 필요.

{: .highlight }
> **recoverGX 신규 모델 (2026-06-03)**: `Wallet` · `WalletTransaction` · `ChargePackage` · `GxPolicy` · `GxPayoutPolicy` · `GxSettlement` 추가. 기존 `GxClass`·`GxBooking`·`Mentor` 컬럼 확장. 상세: [전체 스키마](./schema.html) · [데이터 7](./07-membership.html) · [데이터 9](./09-payout.html). 정본: `pt-platform/docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`.

## 위치 매핑

- Prisma 스키마: `packages/db/prisma/schema.prisma`
- 마이그레이션: `packages/db/prisma/migrations/`
- DB: RDS PostgreSQL `recover` DB → `pt_platform` 스키마

## 하위 문서

- [전체 스키마](./schema.html) — Prisma 모델 통합 (GX 신규 모델 포함)
- [ERD](./erd.html) — Mermaid 관계도
- [마이그레이션 계획](./migrations.html) — 기존 → 새 스키마 + GX 마이그레이션
- [네이밍·컨벤션](./conventions.html) — snake_case · 인덱스 · 제약
- [07 지갑·결제](./07-membership.html) — Wallet·WalletTransaction·ChargePackage
- [09 정산](./09-payout.html) — GxPayoutPolicy·GxSettlement

## 관련 결정

모든 [Level 2~7 결정](../../product/decision-tree.html)이 데이터 모델에 영향. [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) — GX 신규 모델 6개.
