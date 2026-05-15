---
title: 🔴 7B. 매출·원가 모델
parent: 7. 경제성
nav_order: 2
---

# 7B. 매출·원가 모델

**🔴 TBD** · 의존: [ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0004](../decisions/0004-one-time-ticket-pricing.html), [2B 멤버십](../members/membership.html), [2C 가격](../members/pricing.html), [3G 정산](../partners/payout.html), [6C 본사 분배](../expansion/revenue-share.html), [7A 단위 경제](./unit-economics.html)

→ **시뮬레이션에서 변수 조정으로 확인**: [📊 단위 경제 시뮬레이션](./simulation.html)

## 결정 보류 항목

- 매출 항목 분류 (회차권 5단·Pro 포인트·체험·자유 헬스 부가)
- 고정비·변동비 정확한 분류
- 본사 vs 가맹점주 비용 분담 (Phase 2+ 가맹 시작 시)
- 회원당 본사 변동비 (AI API, CS 인력 분담)

## 핵심 가정 v2 (시뮬레이션 기준 — [7A](./unit-economics.html) 참고)

- 표준 **60평** / 평당 임대료 **35만** (강남 기준) → 지점 총 임대 약 **2,100만/월**
- 멘토 정산: **30분 unit당 12,000원 (S1) ~ 20,000원 상한 (S2)**
- 회원 결제: 회차권 5단 — 회당 25,000~40,000원 ([ADR 0004](../decisions/0004-one-time-ticket-pricing.html))
- Pro 인증 옵션: +5,000원/회 (회원 → 강사 추가, 본사 부담 ❌)

→ 정확한 매출·원가 산출은 가격(2C) 락 후.

---

| 2026-05-11 | 매출·원가 항목 분류 + 변동비 50% 가설 |
| 2026-05-12 | 시뮬레이션 페이지로 위임. 옛 placeholder 숫자 (540만·25만) 제거 |
| 2026-05-16 | v2 본문 정합 갱신 — 60평·평당 35만·회차권 5단·S1/S2 정산 ([ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0004](../decisions/0004-one-time-ticket-pricing.html)) |
