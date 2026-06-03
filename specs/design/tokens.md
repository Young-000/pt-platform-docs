---
title: 토큰
parent: 🎨 디자인 시스템
grand_parent: 스펙 (PRD)
nav_order: 2
---

# 디자인 토큰

{: .warning }
> **PT 레일 (보류)** — 이 스펙은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

**Status**: Draft · **Updated**: 2026-05-13

## 색상 (Tailwind 토큰)

```
primary:    #1a73e8 (Tailwind blue-600 변형)
neutral-50: #fafafa
neutral-100: #f5f5f5
neutral-700: #374151
neutral-900: #111827
accent:     #b45309 (강조 — 노란/주황 톤)
success:    #16a34a
warning:    #f59e0b
error:      #dc2626
```

## 타이포그래피

- 한글: **Pretendard** (Variable)
- 영문: **Inter** (Variable)
- 숫자: `font-variant-numeric: tabular-nums`

| 등급 | 크기 | 굵기 |
|---|---|---|
| h1 | 28px | 700 |
| h2 | 22px | 600 |
| h3 | 18px | 600 |
| body | 14-16px | 400 |
| small | 12-13px | 400 |

## 간격

- 4·8·12·16·24·32·40·48·64

## 라운드

- card: 10-12px
- button: 8px
- input: 6-8px

## 그림자

- shadow-sm (subtle, default)
- shadow-md (모달·드롭다운)

→ 디자이너 영입 후 구체화. shadcn/ui 기본 + variant.

---

| 2026-05-13 | 초안 |
