---
title: 🟡 7A. 단위 경제 (지점당)
parent: 7. 경제성
nav_order: 1
---

# 7A. 단위 경제 (지점당 P&L)

**🟡 Drafted** (v2 시나리오 재계산 진행 중) · 의존: [ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0004](../decisions/0004-one-time-ticket-pricing.html), [4D 공간](../service/space.html), [2B 멤버십](../members/membership.html), [2C 가격](../members/pricing.html), [3G 멘토 정산](../partners/payout.html) → [7C 100호점 추정](./projection.html)

→ **상세 시나리오 매트릭스: [📊 단위 경제 시뮬레이션](./simulation.html)**

## 락된 가정 (v2)

- 표준 지점: **60평** (8 private room × 4평 = 32평 + 오픈 28평)
- 임대료: 평당 **35만** (강남 기준) → 총 임대 약 **2,100만/월**
- 멘토 정산: **30분 unit당 12,000원 (S1) ~ 20,000원 상한 (S2)**
- 회원 결제: 회차권 5단 (회당 25,000 ~ 40,000원, [ADR 0004](../decisions/0004-one-time-ticket-pricing.html))
- Pro 인증 옵션: +5,000원/회 (회원 → 강사 추가, 본사 부담 ❌)
- 가동률 시나리오: 공격 / 표준 / 보수 — 30분 unit 기준 재계산

## 보류 (v2 재산출)

- BEP 시점 (몇 호점·몇 회원) — 60평·회차권 5단 기준
- 12개월·24개월 누적 P&L
- 오픈 공간 1:1 PT vs 자유 헬스 분배 가정

---

| 2026-05-11 | 90평 가설 + 100명 BEP / 12개월 — v1, 폐기 |
| 2026-05-12 | 시뮬레이션 페이지로 분리. 멘토 30분 모델 + 9 시나리오 매트릭스 |
| 2026-05-16 | v2 본문 정합 갱신 — 60평·평당 35만·회차권 5단·S1/S2 정산 ([ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0004](../decisions/0004-one-time-ticket-pricing.html)) |
