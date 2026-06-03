---
title: 공유 컴포넌트
parent: 🎨 디자인 시스템
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 공유 컴포넌트 (shadcn/ui 기반)

{: .warning }
> **PT 레일 (보류)** — 이 스펙은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

**Status**: Draft · **Updated**: 2026-05-13
**위치**: `packages/ui/`

## 핵심 컴포넌트

- Button (Primary·Secondary·Outline·Ghost)
- Card
- Input·Select·Textarea
- Modal·Sheet
- Toast
- Tabs
- Calendar (예약 그리드)
- MentorCard (사진·평점·배지)
- SlotGrid (30분 단위)

## 변형 (premium 톤)

- 자극적 그라데이션 ❌
- subtle border 1px + shadow-sm
- focus ring 부드러운 blue

→ [품질 기준](./quality.html) 참조.

---

| 2026-05-13 | 초안 |
