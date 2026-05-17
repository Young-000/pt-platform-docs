---
title: 결정 기록 (ADR)
nav_order: 11
has_children: true
---

# 의사결정 기록 (ADR)

> Architecture Decision Records — **사업·제품 차원의 결정**을 봉인하는 곳.

구두로만 합의된 결정은 시간 지나면 사라집니다. 여기에 기록해야 진짜 결정.

## 작성 규칙

- 파일명: `NNNN-title.md` (4자리 일련번호)
- [`_template.md`](./_template.html) 복사해서 사용
- 결정 트리의 노드가 닫힐 때마다 ADR 추가

## 목록

- [0001. 소비자향 PT 시장 피벗](./0001-consumer-pivot.html) — 2026-05-15. 단일 PT → 다종목·강사+프로그램 예약·30분 unit·60평·강사 풀 2시나리오
- [0002. 멘토 자격증 정책](./0002-license-policy.html) — 2026-05-15. 일반 멘토 ❌ / Pro ✅ / 가맹점장 ✅ / 법안 통과 시 admin 토글
- [0003. 자유 헬스 = 부가](./0003-free-gym-add-on.html) — 2026-05-15. 강사 코스 회원에게만 개방, 단독 가입 ❌
- [0004. 회차권 라인업 (1·4·12·24·48회) 가격 책정](./0004-one-time-ticket-pricing.html) — 2026-05-16. 회차권 단일 모델, 5단 라인업(1회 4만 ~ 48회 120만), Pro 강사 옵션 +5천/회
- [0005. Phase별 가격 책정 전략](./0005-pricing-phase-strategy.html) — 2026-05-16. Phase 0~4+ 가격 매트릭스, 2D sensitivity, LTV 추정, Pro 옵션 인상 트리거 (util ≥ 70% AND Pro ≥ 30%)
- [0006. 베타 1호점 입지 전략](./0006-beta-location-strategy.html) — 2026-05-18. 단위 경제 검증 우선. 평당 10만 외곽 입지·capex 1억. Bear 도 흑자 27%·BEP 2.7개월. 강남은 Phase 2 이월
