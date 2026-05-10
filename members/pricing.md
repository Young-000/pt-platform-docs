---
title: 🔴 4C. 가격 체계
parent: 2. 회원
nav_order: 3
---

# Level 4C — 가격 체계

| | |
|---|---|
| **상태** | 🔴 TBD ⚠️ **재검토 필요** |
| **Owner** | @young |
| **Last updated** | 2026-05-11 |
| **재검토 사유** | 초기 가설 가격 (Light 15만 / Standard 25만 / Premium 40만)은 placeholder. 실제 가격은 페르소나·강사 정산·단위 경제·경쟁사 검증 후 재산출 필요. |
| **상위 의존** | [4B 멤버십](./membership.html) · [3G 정산](../partners/payout.html) · [1C 경쟁비교](../product/competition.html) |
| **하위 영향** | [7A 단위 경제](../economics/unit-economics.html) · [7B 매출](../economics/revenue-cost.html) · [1D Value Prop](../product/value-prop.html) |

---

## 결정해야 할 것

> **각 티어 월 가격이 얼마인가? 추가 PT 단가는?**

세부 질문:
1. Light/Standard/Premium 각 티어 월 가격
2. Pro 회당 가격 (멤버십 내 vs 추가 결제)
3. Peer 회당 가격
4. 약정 기간별 할인율 (1·3·6·12개월)
5. 다이나믹 프라이싱 (피크/오프피크)?
6. 첫 달 프로모션·할인 정책?

---

## 시작점 — 시뮬레이터 가설

기존 시뮬레이터 ARPU 12.75만 (Basic 60% / Standard 25% / Premium 15%).
→ 새 모델(1:1 PT 중심 + AI)에서는 ARPU 더 올라갈 가능성.

---

## 옵션

### A. **시장 평균 가격**
- 부티크 PT 시장 평균 = 25-35만/월 → 동급 가격
- ✅ 시장 익숙
- ❌ "AI 차별점"이 가격 프리미엄 정당화 못 함

### B. **풀 PT의 절반** ⭐
- 풀 PT (1:1 전속) 80만 → 우리 35-40만
- "절반 가격에 AI 코치 추가" 메시지
- ✅ 명확한 가치 명제
- ❌ 강사 정산 압박

### C. **헬스장 + α**
- 헬스장 10만 → 우리 15-20만
- 진입 마찰 최소
- ✅ 대중화 빠름
- ❌ 강사 단가 시장 시세 미달
- ❌ "PT" 브랜드 약화

---

## 추천

**B (풀 PT의 절반)** — 시장 빈자리 + Value Prop 명확.

가설 가격 (월 / 90분 세션 기준):

| 티어 | Peer 회수 | Pro 회수 | 가격 (가설) | ARPU 가정 |
|---|---|---|---|---|
| Light | 4 | 0 | **15만** | 입문 진입 |
| Standard | 6 | 2 | **25만** | 메인 ⭐ |
| Premium | 4 | 6 | **40만** | 본격 |

추가 PT (멤버십 외):
- Pro 회당: 35,000~50,000 (강사 자율, 등급별)
- Peer 회당: 15,000~20,000

---

## 약정 할인

| 기간 | 할인율 |
|---|---|
| 1개월 자동결제 | 0% |
| 3개월 선결제 | -5% |
| 6개월 | -10% |
| 12개월 | -15% |

---

## 다이나믹 프라이싱 (Phase 2)

피크(6-10pm) vs 오프피크 가격 차등 → 평당 수익 ↑.
1호점 운영 데이터 쌓인 후 도입 검토.

---

## 결정 기준

- [ ] 강사 정산 단가 ([3G](../partners/payout.html))와 합산 시 본사 마진 충분
- [ ] 페르소나 1순위가 25만/월에 willing to pay인가 (인터뷰)
- [ ] 단위 경제 ([7A](../economics/unit-economics.html)) BEP 18개월 이하

---

## 의존성

**입력**: [4B 멤버십](./membership.html), [3G 정산](../partners/payout.html), [1C 경쟁](../product/competition.html)
**영향 주는 것**:
- [7A 단위 경제](../economics/unit-economics.html) — ARPU 입력
- [1D Value Prop](../product/value-prop.html) — "절반 가격" 메시지
- [4D 정책](./policies.html) — 환불 계산법

---

## 변경 이력

| 날짜 | 변경자 | 변경 내용 |
|---|---|---|
| 2026-05-11 | Young + Claude | 가격 옵션 A/B/C, B 추천 + 약정 할인 가설 |
