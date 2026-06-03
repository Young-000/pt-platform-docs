---
title: 🟢 2C. 가격 체계
parent: 2. 회원
nav_order: 3
---

# 2C. 가격 체계

**🟢 GX 피벗 (2026-06-04)** ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html)) · 의존: [2B 지갑](./membership.html), [3G 정산](../partners/payout.html), [7A 단위 경제](../economics/unit-economics.html), [1C 경쟁](../product/competition.html) → [1D VP](../product/value-prop.html), 마케팅·시뮬레이터

{: .note }
GX 피벗([ADR 0011](../decisions/0011-recovergx-gx-pivot.html))으로 회차권 5단 단일 단가는 **클래스별 가격 + 지갑 차감** 구조로 대체됨. 옛 ADR 0004(회차권) 기반 가격은 아래 "폐기된 가격 구조" 참고.

## 클래스 가격

강사가 클래스별로 가격을 직접 지정하며, 어드민이 상한·하한을 설정한다.

| 구분 | 기본값 | 변수 |
|---|---|---|
| 클래스 최저가 | **10,000원** | `admin.PricingConfig.minClassPrice` |
| 클래스 최고가 | **50,000원** | `admin.PricingConfig.maxClassPrice` |
| 강사 지정 | 1만~5만원 범위 내 자유 | — |

**예시 클래스 단가 (강사별 상이, 참고용)**

| 클래스 유형 | 예시 단가 |
|---|---|
| 스트레칭 | 15,000원 |
| 컨디셔닝 | 25,000원 |
| 버닝 | 30,000원 |

{: .warning }
위 예시 단가는 참고용. 실제 단가는 강사가 어드민 범위(1만~5만) 내에서 결정. 베타 운영 후 재산출 대상.

## 충전 패키지 (지갑)

| 패키지 | 결제액 | 지갑 잔액 | 보너스율 |
|---|---|---|---|
| 소형 | 50,000원 | 50,000원 | — |
| 중형 | 100,000원 | 105,000원 | +5% |
| 대형 | 300,000원 | 330,000원 | +10% |

- 결제: mock PG (실 PG 미연동, 베타 기준)
- 모든 수치는 `admin.PricingConfig` 변수 — 운영 중 즉시 변경 가능

## ARPU 가정

클래스별 단가 분산·충전 패턴이 결정된 후 재산출 대상. 현재 기준 없음.

## 핵심 제약 — 공간 비용

**60평 표준 1지점** ([4D 공간](../service/space.html), [ADR 0006](../decisions/0006-beta-location-strategy.html)):

| 항목 | 값 |
|---|---|
| 평당 임대 | 10만원 (외곽·준도심 기준) |
| 월 임대 | 600만원 |
| 운영비 (인건비·관리비·AI·CS) | 2,000만원 |
| **월 고정비** | **2,600만원** |
| Capex | 1.5~2억원 |

→ 단위 경제 ([7A](../economics/unit-economics.html)) 시뮬레이션에서 손익 추적. GX 전환 후 capacity·이용률 가정 재산출 대상.

## 폐기된 가격 구조 (GX 피벗 이전)

- **회차권 5단** (1회 35k / 4회 135k / 12회 390k / 24회 720k / 48회 1,320k) — [ADR 0011](../decisions/0011-recovergx-gx-pivot.html)로 충전금 대체
- **30분 unit 단일 단가** (정상 35,000원, 평균 ARPU 30,000원) — 클래스별 가격으로 대체
- Pro +5천 옵션 — 폐기

## 다음 단계

1. 베타 클래스 단가 결정 (강사 협의)
2. [7A 단위 경제 시뮬레이션](../economics/simulation.html) — GX 전환 후 고정비 / 클래스당 수익 재산출
3. 베타 3개월 후 클래스별 예약 비중 데이터로 ARPU 재산출

---

| 날짜 | 변경 |
|---|---|
| 2026-05-12 | 초기 가설 (Light 15만 / Std 25만 / Premium 40만) — v1 placeholder |
| 2026-05-16 | v2 정합 — 60평·회차권 5단 ([ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0004](../decisions/0004-one-time-ticket-pricing.html)) |
| 2026-05-18 | 베타 default 비용 갱신 — 평당 10만·임대 600만·capex 1억 ([ADR 0006](../decisions/0006-beta-location-strategy.html)) |
| 2026-05-20 | v2 봉인 — Pro Only·30분 unit·5단 회차권·운영비 2,000만 |
| 2026-06-04 | **GX 피벗** — 클래스별 가격(1~5만)+지갑 구조로 전면 교체. 회차권·단일 단가 폐기 ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html)) |
