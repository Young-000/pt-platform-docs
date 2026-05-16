---
title: 🔴 7C. 100호점 추정
parent: 7. 경제성
nav_order: 3
---

# 7C. 100호점 추정 (BEP / CapEx)

**🔴 TBD** · 의존: [7A 단위 경제](./unit-economics.html), [7B 매출·원가](./revenue-cost.html), [6A 확장 모델](../expansion/model.html)

> **🆕 2026-05-16 — Phase별 가격 매트릭스** ([ADR 0005](../decisions/0005-pricing-phase-strategy.html))
>
> Phase 0~4+ 단계별 가격·KPI·트리거 매트릭스 봉인. 본 7C 의 100호점 추정은 ADR 0005 의 Phase 4+ 가맹점 자율 + 본사 라이선스 fee 모델 가정 위에 작성된다. 12개월 P&L 시뮬은 시뮬레이터 v3 참조.

## 결정 보류 항목

- CapEx (지점당) 정확한 금액
- Phase 1~4 단계별 자본 소요·매출·이익
- 본사 BEP 시점 (호점 수 / 회원 수)
- 자기자본 vs 시드·시리즈 A 투자 비율

## 가설 (시뮬레이션 기준)

- CapEx 지점당: 인테리어 + 기구 + 보증금 + 오픈 마케팅 → 약 **3-5억 가설** (위치·규모별 차이)
- 직영 (Phase 1): 본사 자본 부담
- 가맹 (Phase 2+): 가맹점주 자본 부담 ([6A](../expansion/model.html))
- 본사 BEP: 가맹 매출 분배 + 시스템료가 본사 운영비 cover

→ 정확한 추정은 [2C 가격](../members/pricing.html) + [7A 시뮬레이션](./simulation.html) 락 후.

## Phase별 큰 흐름

| Phase | 호점 | 자본 흐름 |
|---|---|---|
| 1 (1-3호점) | 직영 | 자기자본 + 시드 |
| 2 (4-10) | 직영 + 가맹 시작 | 시리즈 A 검토 |
| 3 (10-30) | 가맹 본격 | 본사 캐시플로 자립 |
| 4 (30-100) | 가맹 90%+ | 본사 본격 흑자 |

---

| 2026-05-11 | CapEx 4억 / Phase별 추정 가설치 |
| 2026-05-12 | 옛 placeholder 숫자 제거. 가격·단위경제 락 후 재산출 |
