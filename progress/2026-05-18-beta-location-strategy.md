---
title: "2026-05-18 — 베타 1호점 입지 전략 봉인 (단위 경제 검증 우선)"
parent: 진행 로그
nav_order: 3
---

# 2026-05-18 — 베타 입지 전략 봉인 + 시뮬·PRD 가정 일괄 갱신

5/17 수익성 리뷰 → 5/18 의사결정: **베타 1호점 = 단위 경제 검증 우선 전략 봉인** ([ADR 0006](../decisions/0006-beta-location-strategy.html))

## 배경

5/17 수익성 리뷰에서 베타 1호점 v1 가정 (강남·평당 35만·capex 3억) 검토:

| 시나리오 | util | 마진 | BEP | 12개월 누적 (capex 차감) |
|---|---|---|---|---|
| Base | 50% | 20% | 14개월 | ~0 |
| Bear | 35% | 8% | 18개월+ | **−1억** |
| Bull | 65% | 28% | 8개월 | +1.5억 |

→ Bear 적자 1억. **베타 = "단위 경제가 가능한지" 자체를 검증하는 단계**인데 capex 3억·BEP 14개월은 검증 실패 시 회수 부담 ↑. 베타 목적과 가정 불일치.

## 결정 (ADR 0006)

베타 1호점 = **평당 10만 외곽 입지·capex 1억**. 강남은 Phase 2 (2~3호점)로 이월.

### 비교 (Base · S1 · 회원 495명)

| | 강남 (평당 35만·capex 3억) | **베타 (평당 10만·capex 1억)** |
|---|---|---|
| 월 임대 | 2,100만 | **600만** |
| 월 이익 (Base) | 2,187만 (20%) | **3,687만 (33%)** |
| BEP | 14개월 | **2.7개월** |
| Bear (util 35%) | 619만 (8%) | **2,119만 (27%)** |
| 12개월 누적 (capex 차감) | ~0 | **+3.3억** |

→ 모든 시나리오에서 베타 우월. 가맹점주 BEP 2.7개월 → 확산 매력 내장.

## 베타 KPI (단위 경제 검증 5종)

| # | KPI | 임계 (D+) |
|---|---|---|
| 1 | utilization (가중) ≥ 35% | D+30 (Bear 임계) |
| 2 | utilization (가중) ≥ 50% | D+90 (Base 도달) |
| 3 | CAC ≤ 20만 | D+90 |
| 4 | 회원 ≥ 200명 | D+90 |
| 5 | 마진 ≥ 25% | D+90 |

## 일괄 갱신된 파일

### ADR · index
- `decisions/0006-beta-location-strategy.md` (신규)
- `decisions/index.md` — ADR 0006 등록
- `progress/index.md` — 5/18 항목 추가

### PRD callout
- `economics/simulation.md` — 베타 vs 강남 비교 표 callout 추가
- `economics/unit-economics.md` — 락된 가정 베타 기준으로 갱신 (평당 10만·임대 600만·capex 1억)
- `economics/revenue-cost.md` — 핵심 가정 갱신
- `members/pricing.md` — 60평 1지점 비용 가정 갱신 (베타·강남 비교 표)
- `service/space.md` — 베타 입지 가정 callout + Phase 0 추가
- `expansion/model.md` — 자본 소요 표 갱신 (Phase별 capex)
- `expansion/responsibility.md` — 가맹점주 CapEx 부담액 명시 (베타 약 1억)

### 시뮬레이터
- `pt-platform-simulator/src/pages/HomeV3.tsx` — 입지 토글에 "베타 (외곽·10만/평)" 추가, default → 베타. capex default 3억 → 1억. ADR 0006 callout
- `pt-platform-simulator/src/pages/HomeV2.tsx` — `defaults.rentPerPyeong` 35 → 10
- `npm run build` 통과

## 외부 의존 (미해결)

| # | 항목 | 담당 | 데드라인 |
|---|---|---|---|
| 1 | 지방 자유업/체육시설업 분류 (지자체별) | 외부 변호사 | D-14 |
| 2 | 지방 PG 등록·세무 처리 | 본사 운영 | D-14 |
| 3 | 지방 강사 풀 검증 (입지별 5명 이상) | 운영 | D-21 |
| 4 | 후보지 3곳 현장 답사 + 임대료 견적 | CEO + 운영 | D-21 |

## 다음 단계

- D-14: 변호사 확인 결과 정리 + 지자체별 분류 표 작성
- D-21: 후보지 3곳 (경기 외곽·인천·지방 광역시 외곽 중) 답사 → 최종 1곳 봉인
- D-30: 베타 KPI 1번 (util ≥ 35%) 1차 점검
- 베타 6개월 후 KPI 4/5 통과 시 → Phase 2 진입 (강남 2호점) ADR 0007 작성
