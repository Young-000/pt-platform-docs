---
title: 🔴 2C. 가격 체계
parent: 2. 회원
nav_order: 3
---

# 2C. 가격 체계

**🟢 부분 확정** ([ADR 0001](../decisions/0001-consumer-pivot.html) · [ADR 0004](../decisions/0004-one-time-ticket-pricing.html)) · 의존: [2B 멤버십](./membership.html), [3G 정산](../partners/payout.html), [7A 단위 경제](../economics/unit-economics.html), [1C 경쟁](../product/competition.html) → [1D VP](../product/value-prop.html), 마케팅·시뮬레이터

> **📌 회차권 라인업 — [ADR 0004](../decisions/0004-one-time-ticket-pricing.html) (2026-05-16)**
>
> 멤버십 vs 단발권 이분법 ❌ → **회차권 단일 모델**, 회차 수만 가변.
>
> | 상품 | 회차 | 가격 | 회당가 | 권장 패턴 |
> |---|---|---|---|---|
> | **1회차권** | 1 | **40,000원** | 40,000원 | 체험·단발 |
> | **4회차권** | 4 | 140,000원 | 35,000원 | 주 1회 × 1개월 |
> | **12회차권** | 12 | 360,000원 | 30,000원 | 주 1회 × 3개월 / 주 3회 × 1개월 |
> | **24회차권** | 24 | 650,000원 | 27,000원 | 주 2회 × 3개월 / 주 1회 × 6개월 |
> | **48회차권** | 48 | 1,200,000원 | 25,000원 | 주 2회 × 6개월 |
>
> **프로그램 옵션**: 카테고리 무관 회당가 동일. **Pro 강사** ([ADR 0002](../decisions/0002-license-policy.html)) 선택 시 **+5,000원/회** 포인트 차감.  자유 헬스는 회차 소비 ❌ (멤버십 부가, [ADR 0003](../decisions/0003-free-gym-add-on.html)).
>
> 모든 값 = `admin.PricingConfig` 변수.  베타 6개월 후 (2026-11) 재검토.

## 남은 결정

- 포인트 충전 단위 (Pro +5,000원/회 = 별도 충전 vs 회당 즉시 결제)
- 약정 할인율 (다회차권 = 회차 수가 곧 약정 강도. 추가 % 할인 검토 중)
- 단발 1회권 vs 신규 회원 첫 4회권 프로모션 가격

## 핵심 제약 — 평당 비용 약 35만/월

**60평 표준 1지점** ([4D 공간](../service/space.html), [ADR 0001](../decisions/0001-consumer-pivot.html)):
- 평당 임대료 **35만** (강남 기준) → 총 임대 약 **2,100만/월**
- 추가 관리비·공과금·인건비·강사 정산·보험 등
- 회원 수 × 회차 소비 × 회당가 = 전체 비용 + 마진 충당해야 함

→ 단위 경제 ([7A](../economics/unit-economics.html)) 시뮬레이션에서 손익 추적.

## 결정 보류 사유 (잔여)

- 페르소나 1A 인터뷰 데이터 (지불 의지 추가 검증)
- 강사 정산 단가 (12k~20k 범위 내 등급별 분포 미정)
- 단위 경제 재산출 (60평·회차권 5단 기준)
- 경쟁 1C 빈자리 가격대 검증

## 다음 단계

1. [📊 단위 경제 시뮬레이션](../economics/simulation.html)에서 회차권 5단·60평 시나리오 픽
2. 페르소나 1A 인터뷰 (지불 의지 검증)
3. 포인트·약정 할인 정책 확정

→ **현재 락**: 회차권 5단 라인업 + 회당 25k~40k + Pro +5k 옵션 ([ADR 0004](../decisions/0004-one-time-ticket-pricing.html)).

---

| 2026-05-12 | 초기 가설 가격 (Light 15만 / Std 25만 / Premium 40만) — placeholder, v1 |
| 2026-05-12 | 평당 비용 8-10만 제약 반영, 가격은 TBD 유지 — v1 |
| 2026-05-16 | v2 본문 정합 갱신 — 60평·평당 35만·회차권 5단 ([ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0004](../decisions/0004-one-time-ticket-pricing.html)) |
