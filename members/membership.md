---
title: 🔴 4B. 멤버십 구조
parent: 2. 회원
nav_order: 2
---

# Level 4B — 멤버십 구조

| | |
|---|---|
| **상태** | 🔴 TBD |
| **Owner** | @young |
| **Last updated** | 2026-05-11 |
| **상위 의존** | [2A 세션 종류](../service/session-types.html) · [1A 페르소나](../product/personas.html) |
| **하위 영향** | [4C 가격](./pricing.html) · [4A 여정](./journey.html) · [4D 정책](./policies.html) · [6A 예약](../operations/reservation.html) · [7B 매출 모델](../economics/revenue-cost.html) |

---

## 결정해야 할 것

> **회원이 무엇을 사는가? 한 달에 몇 회? 어떤 종류 세션?**

세부 질문:
1. **회차 기반** vs **무제한**?
2. 티어 몇 단계? (입문 ~ 프리미엄)
3. Pro PT vs Peer 운동 비율을 어떻게 구성?
4. 추가 PT (멤버십 외) 별도 결제 가능?
5. **기간**: 월 단위? 3·6·12개월 약정?

---

## 옵션

### A. **회차 기반 단순 티어** ⭐
- 한 달 X회 PT 패키지. Pro/Peer 비율로 티어 구분.
- 예시:
  - Light: Peer 8회 / 월
  - Standard: Peer 6회 + Pro 2회 / 월
  - Premium: Peer 4회 + Pro 6회 / 월
- ✅ 단순. 회원 이해 쉬움
- ✅ 단위 경제 예측 쉬움 (utilization 가설 직접 연결)
- ❌ "남은 회차 안 쓰면 손해" 압박

### B. **무제한 + 프리미엄 옵션**
- 모든 티어가 Peer 무제한, Pro PT는 추가
- 예시: Standard(Peer 무제한) / Pro(Peer 무제한 + Pro 4회)
- ✅ 회원 자유도 ↑
- ❌ utilization 폭주 → 공급 부족 위험
- ❌ 단위 경제 예측 어려움

### C. **포인트제** — 월 X포인트 충전, 세션마다 차감
- Pro 1회 = 200pt, Peer 1회 = 100pt 등
- ✅ 유연성 최대
- ❌ 회원 이해 복잡

---

## 추천

**A (회차 기반 단순 티어)**.

이유:
- 공간 임대업 관점에서 utilization 예측 가능 = 단위 경제 안정
- 회원·가맹점주·본사 모두 이해 쉬움
- 100호점 표준화 적합

→ 무제한·포인트제는 향후 옵션으로 검토 가능 (Phase 2).

---

## 티어 구성 가설 (가격 결정 전 형식만)

| 티어 | Peer 회차 | Pro 회차 | 타겟 |
|---|---|---|---|
| Light | 4 | 0 | 입문, 가격 민감 |
| Standard | 6 | 2 | 일반 (1A 1순위 페르소나) |
| Premium | 4 | 6 | 본격 관리 |

→ Pro 회차 비율 = AI 의존도([2C](../service/ai-role.html))와 trade-off.

---

## 약정 기간

| 옵션 | 장단점 |
|---|---|
| 1개월 자동결제 | 진입 마찰 ↓, 이탈 ↑ |
| 3·6·12개월 약정 (할인) ⭐ | 락인 ↑, 캐시플로 ↑, 이탈 ↓ |
| 연간 선결제 (큰 할인) | 캐시플로 폭발, but 환불 리스크 |

→ **3·6·12 단계 할인** 추천.

---

## 결정 기준

- [ ] 페르소나(1A) 1순위가 어느 티어에 가장 매력 느끼는가
- [ ] 강사 모델(3E) 공급량과 일치하는가 (무제한은 공급 어려움)
- [ ] 단위 경제 ([7A](../economics/unit-economics.html)) BEP 빠른가

---

## 의존성

**입력**: [2A 세션 종류](../service/session-types.html), [1A 페르소나](../product/personas.html), [2C AI 역할](../service/ai-role.html)
**영향 주는 것**:
- [4C 가격](./pricing.html) — 티어별 가격
- [4A 회원 여정](./journey.html) — 가입·갱신
- [4D 정책](./policies.html) — 회차 환불·이월
- [6A 예약 시스템](../operations/reservation.html) — 회차 차감 로직
- [7B 매출](../economics/revenue-cost.html) — ARPU

---

## 변경 이력

| 날짜 | 변경자 | 변경 내용 |
|---|---|---|
| 2026-05-11 | Young + Claude | 회차/무제한/포인트 옵션 + A(회차) 추천 |
