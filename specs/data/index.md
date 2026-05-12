---
title: 🗄️ 데이터
parent: 스펙 (PRD)
nav_order: 4
has_children: true
---

# 🗄️ 데이터 (DB Schema·ERD·Migration)

> PRD에 분산된 데이터 모델을 **통합 관리**. 코드 작성 전 락 필요.

## 위치 매핑

- Prisma 스키마: `packages/db/prisma/schema.prisma`
- 마이그레이션: `packages/db/prisma/migrations/`
- DB: RDS PostgreSQL `recover` DB → `pt_platform` 스키마

## 하위 문서

- [전체 스키마](./schema.html) — Prisma 모델 통합
- [ERD](./erd.html) — Mermaid 관계도
- [마이그레이션 계획](./migrations.html) — 기존 → 새 스키마
- [네이밍·컨벤션](./conventions.html) — snake_case · 인덱스 · 제약

## 관련 결정

모든 [Level 2~7 결정](../../decision-tree.html)이 데이터 모델에 영향.
