---
title: 🟢 3E. GX 강사 운영 모델
parent: 3. 강사
nav_order: 5
---

# 3E. GX 강사 운영 모델 (recoverGX)

**🟢 Decided** · 의존: [ADR 0011](../decisions/0011-recovergx-gx-pivot.html), [ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0002](../decisions/0002-license-policy.html), [0 비전](../product/vision.html), [3A 페르소나](./personas.html), [3F 개설 권한](./peer-leader.html) → [3D 모집](./recruitment.html), [3G 정산](./payout.html), [3H 등급](./quality.html), [5A 예약](../operations/reservation.html)

> **recoverGX 피벗** ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html)): 강사 슬롯 오픈(1:1 PT) → **검증된 강사가 그룹 클래스를 직접 개설**하는 모델. 어드민이 `gxOpenEnabled` 권한·카테고리·가격 범위를 통제하며 초기는 어드민 큐레이션, 장기적으로 오픈마켓 지향.

## 공통 원칙 (모든 Phase)

- **프리랜서 계약** (직고용 ❌)
- **본사가 마케팅·예약·결제·CS·세금 전부 대행** — 강사는 클래스 운영에만 집중
- **조합형 정산** ([3G](./payout.html)) — 기본금 + 인당 출석 + 매출 비율 조합
- **클래스 개설 자율** (지점·룸·카테고리·시간·정원·가격 범위 내) — `gxOpenEnabled` 부여된 강사만

## Phase별 진화

| Phase | 모델 | 강사 수/지점 | 클래스 개설 |
|---|---|---|---|
| **Phase 1 (1-3호점, PMF 검증)** | 본사 헤드헌팅 코어 강사 + 어드민 큐레이션 | 12~15명 | 어드민이 직접 스케줄·카테고리 배치 + `gxOpenEnabled` 부여 강사가 자율 개설 병행 |
| **Phase 2 (4호점+)** | 아카데미 통과자 자율 가입 + 어드민 큐레이션 완화 | 호점당 12~15명 | `gxOpenEnabled` 자동 부여 범위 확대. 가격·카테고리 룰 어드민 설정 |
| **Phase 3 (10호점+)** | 완전 자동 onboarding, 등급별 차등 개설 권한 | 가맹점 자율 | 등급 P3+ → `gxOpenEnabled` 자동 부여 (오픈마켓 지향) |

## 클래스 개설 자율 범위 (어드민 설정)

| 항목 | 강사 자율 | 어드민 통제 |
|---|---|---|
| 지점·룸 | 가용 룸 선택 | 룸 가용 시간 배정 |
| 카테고리 | 등록된 카테고리 내 선택 | 카테고리 목록·추가 |
| 시간·정원 | 자유 설정 | 최대 정원 상한 |
| 가격 | 범위 내 자유 설정 | 가격 하한·상한 룰 |

## 폐기 옵션

- 완전 어드민 스케줄 배정 — 강사 자율성 ↓, 확장 불가
- 완전 오픈마켓 (초기) — Phase 1엔 품질 통제 어려움

→ 어드민 큐레이션 + 검증 강사 자율 개설 Hybrid가 100호점 비전과 양립.

---

| 2026-05-12 | gig/전속/Hybrid 비교 |
| 2026-05-12 | Hybrid Phase별 진화 (1: 코어 12 → 2: 자율 → 3: 자동) 락 |
| 2026-06-04 | recoverGX 피벗 — 1:1 PT 슬롯 → GX 클래스 개설 모델로 전환. 어드민 큐레이션 + gxOpenEnabled 검증 강사 자율 개설 Hybrid |
