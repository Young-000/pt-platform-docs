---
title: 🟡 7A. 단위 경제 (지점당)
parent: 7. 경제성
nav_order: 1
---

# 7A. 단위 경제 (지점당 P&L)

**🟡 Drafted** (v2 시나리오 재계산 진행 중) · 의존: [ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0004](../decisions/0004-one-time-ticket-pricing.html), [ADR 0006](../decisions/0006-beta-location-strategy.html), [4D 공간](../service/space.html), [2B 멤버십](../members/membership.html), [2C 가격](../members/pricing.html), [3G 멘토 정산](../partners/payout.html) → [7C 100호점 추정](./projection.html)

→ **상세 시나리오 매트릭스: [📊 단위 경제 시뮬레이션](./simulation.html)**

> **📌 2026-05-18 — 베타 default 갱신** ([ADR 0006](../decisions/0006-beta-location-strategy.html))
>
> 베타 1호점 = **평당 10만 외곽 입지·capex 1억** (단위 경제 검증 우선). 강남 (평당 35만·capex 3억) 가정은 Phase 2 이월. 본 페이지의 v2 가정도 베타 기준으로 갱신.

## 락된 가정 (v2 · 베타 기준)

- 표준 지점: **60평** (8 private room × 4평 = 32평 + 오픈 28평)
- 임대료: 평당 **10만** (베타·외곽 입지, [ADR 0006](../decisions/0006-beta-location-strategy.html)) → 총 임대 약 **600만/월**
- 초기 capex: **약 1억** (인테리어 5천 + 기구 3천 + 보증금/기타 2천)
- 멘토 정산: **30분 unit당 12,000원 (S1) ~ 20,000원 상한 (S2)**
- 회원 결제: 회차권 5단 (회당 25,000 ~ 40,000원, [ADR 0004](../decisions/0004-one-time-ticket-pricing.html))
- Pro 인증 옵션: +5,000원/회 (회원 → 강사 추가, 본사 부담 ❌)
- 가동률 시나리오: 공격 / 표준 / 보수 — 30분 unit 기준 재계산
- 비교 참고: 강남 입지 (평당 35만·임대 2,100만·capex 3억) 는 Phase 2 (2~3호점) 진입 시 추가

## 보류 (v2 재산출)

- BEP 시점 (몇 호점·몇 회원) — 60평·회차권 5단 기준
- 12개월·24개월 누적 P&L
- 오픈 공간 1:1 PT vs 자유 헬스 분배 가정

---

| 2026-05-11 | 90평 가설 + 100명 BEP / 12개월 — v1, 폐기 |
| 2026-05-12 | 시뮬레이션 페이지로 분리. 멘토 30분 모델 + 9 시나리오 매트릭스 |
| 2026-05-16 | v2 본문 정합 갱신 — 60평·평당 35만·회차권 5단·S1/S2 정산 ([ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0004](../decisions/0004-one-time-ticket-pricing.html)) |
| 2026-05-18 | 베타 default 갱신 — 평당 10만·임대 600만·capex 1억 ([ADR 0006](../decisions/0006-beta-location-strategy.html)). 강남 가정은 Phase 2 이월 |
