---
title: 7. 경제성
nav_order: 8
has_children: true
---

# 경제성 (Economics)

> **공간 임대업 관점**: 평당 비용 ↓ × 평당 수익 ↑ × utilization ↑.
>
> 모든 economics 결정의 핵심 프레임. 매출·원가·BEP 계산이 이 3축을 따릅니다.

## 핵심 등식

```
지점당 월 매출 = Σ (클래스 가격 × 해당 클래스 출석 인원)   ← no-show 포함 예약 차감 기준
지점당 월 원가 = 평수 × 평당 임대료 + 인건비 + 강사 정산(조합형) + 시스템·보험
지점당 월 이익 = 매출 - 원가
지점당 BEP    = CapEx ÷ 월이익
```

→ **GX 전환 후 핵심 레버**: 클래스당 가격 × 정원 가동률 × 클래스 편성 수.
단위 경제는 1:1 PT 슬롯(1명) → **그룹 클래스 정원 수용** 구조로 재산출 대상. ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html))

> **⚠️ 주의**: 아래 섹션의 구체 수치(BEP·LTV·capacity 등)는 1:1 PT 레일 기준 추정치입니다.
> GX 정원·드롭인 모델로의 재산출이 필요합니다. 각 페이지의 표기를 따르세요.

## 결정 노드

- [📊 단위 경제 시뮬레이션 (라이브 작업장)](./simulation.html) ★
- [7A. 단위 경제 (지점당 P&L)](./unit-economics.html)
- [7B. 매출·원가 모델](./revenue-cost.html)
- [7C. 100호점 추정 — BEP / CapEx](./projection.html)
