---
title: 네이밍·컨벤션
parent: 🗄️ 데이터
grand_parent: 스펙 (PRD)
nav_order: 4
---

# 네이밍·컨벤션

**Status**: Draft · **Updated**: 2026-05-13

## 네이밍
- 테이블: PascalCase (Prisma 모델)
- 컬럼: camelCase (Prisma) → DB snake_case 자동 변환
- enum: 소문자 + 언더스코어 (`pro_certified`)
- FK: `<table>Id` (예: `memberId`)

## 인덱스
- 유니크: `@@unique([col1, col2])`
- 일반: `@@index([col1, col2])`
- 자주 쿼리되는 컬럼 우선

## 제약
- FK 의무 (참조 무결성)
- enum 강제 (status 등)
- NOT NULL 명시

## 시간
- DateTime (UTC 저장, KST 표시)
- `createdAt` / `updatedAt` 표준

## 페이지네이션
- offset (`page, size`) 또는 cursor
- 큰 테이블 (예: Notification) = cursor 권장

---

| 2026-05-13 | 초안 |
