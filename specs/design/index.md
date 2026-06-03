---
title: 🎨 디자인 시스템
parent: 스펙 (PRD)
nav_order: 9
has_children: true
---

# 🎨 디자인 시스템

{: .warning }
> **PT 레일 (보류)** — 이 스펙은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

> **GX 전환 영향**: 토큰·컴포넌트 기본 시스템(shadcn/ui, Pretendard+Inter, 컬러 팔레트)은 GX 레일에도 그대로 계승. GX에서는 시간표 그리드·그룹 클래스 카드·출석 현황 컴포넌트가 추가되며, 1:1 PT 전용 컴포넌트(MentorCard Pro 배지·SlotGrid 30분 unit)는 PT 레일 재개 시 재사용.

> **품질 목표**: 런칭 가능한 수준의, 최소 링글급 premium UX.

## 하위 문서

- [품질 기준](./quality.html) — 어떤 수준이어야 하는가
- [토큰](./tokens.html) — 색상·타이포·간격
- [공유 컴포넌트](./components.html) — shadcn/ui 기반

## 기술 스택

- **컴포넌트**: shadcn/ui (`packages/ui/`)
- **스타일**: Tailwind CSS
- **아이콘**: lucide-react
- **폰트**: Pretendard (한글) + Inter (영문)
- **다크모드**: Phase 2+ 검토
