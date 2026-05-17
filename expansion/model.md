---
title: 🟢 6A. 확장 모델
parent: 6. 비즈니스 모델
nav_order: 1
---

# 6A. 확장 모델 (직영 vs 가맹 vs 하이브리드)

**🟢 Decided** (구조 락, 자본 소요 숫자는 TBD) · 의존: [0 비전](../product/vision.html) → [6B R&R](./responsibility.html), [6C 본사 수익](./revenue-share.html), [3D 모집](../partners/recruitment.html), [7C 100호점 추정](../economics/projection.html)

## 하이브리드 단계별

| Phase | 모델 |
|---|---|
| **Phase 1 (1-3호점)** | **100% 직영** — PMF 검증, 운영 매뉴얼 정립 |
| **Phase 2 (4-10호점)** | 직영 + 가맹 1-2개 병행 — 가맹 시스템 다듬기 |
| **Phase 3 (10-30호점)** | 가맹 70% + 직영 30% — 본격 확장 |
| **Phase 4 (30-100호점)** | 가맹 90% + 직영 10% — 직영은 플래그십·R&D |

## 추가 가속 옵션

- **기존 헬스장 4개 → 가맹 변환 검토** (Phase 1 가속·강사 모집 인프라 활용)

## 폐기

- 100% 직영 ❌ (CapEx 부담 큼)
- 100% 가맹 ❌ (검증 안 된 모델로 모집 어려움)

## 자본 소요 — 베타 default ([ADR 0006](../decisions/0006-beta-location-strategy.html))

| Phase | 호점당 capex | 임대 가정 | 비고 |
|---|---|---|---|
| **Phase 0 (베타 1호점)** | **1억** | 평당 10만 외곽 (월 600만) | 단위 경제 검증 우선 |
| Phase 1 (1~3호) | 1~3억 | 베타 + 강남 2호점 추가 (Phase 2 진입 시) | 베타 KPI 4/5 통과 시 강남 진입 |
| Phase 2 (4~10호) | 호점별 1~3억 | 입지 다양화 | 가맹 capex = 점주 부담 (R&R 참조) |
| Phase 3+ | 가맹점 부담 1억 (외곽) ~ 3억 (강남) | 가맹점 자율 | 점주 BEP = 베타 모델 기준 2.7개월 |

→ **가맹 확장 매력**: 점주당 capex 1억 (외곽 모델) → BEP 2.7개월. 강남 capex 3억 시 BEP 14개월.
→ 자기자본·시드 투자 비율은 [2C 가격](../members/pricing.html) + [7A 단위 경제](../economics/unit-economics.html) + 베타 실측 후 확정.

---

| 2026-05-12 | 직영·가맹·하이브리드 비교 |
| 2026-05-12 | 하이브리드 4-Phase 구조 락. 기존 헬스장 가맹 변환 옵션 추가. 자본 숫자 TBD. |
| 2026-05-18 | 자본 소요 표 갱신 — 베타 capex 1억·외곽 입지 ([ADR 0006](../decisions/0006-beta-location-strategy.html)). 가맹점주 BEP 2.7개월 |
