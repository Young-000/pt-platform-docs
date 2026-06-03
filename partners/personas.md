---
title: 🟢 3A. 강사 페르소나
parent: 3. 강사
nav_order: 1
---

# Level 3A — 강사 페르소나 (recoverGX)

| | |
|---|---|
| **상태** | 🟢 Decided (비전) |
| **Owner** | @young |
| **Last updated** | 2026-06-04 |
| **상위 의존** | [ADR 0011](../decisions/0011-recovergx-gx-pivot.html) · [ADR 0001](../decisions/0001-consumer-pivot.html) · [ADR 0002](../decisions/0002-license-policy.html) · [1A 회원 페르소나](../product/personas.html) · [0. 비전](../product/vision.html) |
| **하위 영향** | [3B 강사 문제](./problems.html) · [3C 강사 VP](./value-prop.html) · [3D 모집](./recruitment.html) · [3E 모델](./model.html) · [3G 정산](./payout.html) |

---

## 비전 — **GX 강사를 "자율 클래스 오너"로**

```
검증된 강사가,
본인이 원하는 클래스를 직접 개설하고,
플랫폼이 결제·정산·검증을 대행한다.
```

특정 강사군을 타겟하지 않습니다.
**자격증 + 어드민 검증(`gxOpenEnabled`)을 통과한 강사라면 누구나 자기 클래스를 개설하는 모델**을 만듭니다.

---

## 핵심 메커니즘

| 차원 | GX 자율 클래스 모델 |
|---|---|
| 가입 마찰 | 자격증 인증 + 본사 아카데미 통과 → `gxOpenEnabled` 부여 후 즉시 개설 가능 |
| 클래스 자율 | 지점·룸·카테고리·시간·정원·가격 범위 내 자유 설정 |
| 약정 | 풀타임 의무 ❌ |
| 영업·CS | 본사가 회원 모집·결제·CS 처리. 강사는 클래스 운영에만 집중 |
| 정산 | 조합형 (기본금 + 인당 출석 + 매출 비율), 격주 입금 |
| 본업 | 별도 본업 있어도 OK / 풀타임 전업도 OK |

→ "GX 강사 = 특정 시설 소속" 고정관념 해체.

---

## 누가 들어오는가 (자연 발생)

특정 페르소나를 좁히지 않으므로 다음이 모두 자연스럽게 풀에 들어옴:

- 헬스장·스튜디오 피고용 GX 강사 (퇴근 후 독립 클래스 개설)
- 전직 트레이너·필라테스·요가 강사 (재진입 발판)
- 부업 원하는 자격증 보유자 (직장인 + 자격증)
- 신입 강사 (성장 발판 — P1 등급 시작)
- 베테랑 프리랜서 (안정 회원풀 + 클래스 자율성)

→ **풀을 좁히지 않고 시스템(검증·개설 권한)으로 다양한 강사를 흡수.**

---

## Phase별 적용

| Phase | 적용 |
|---|---|
| **Phase 1 (1-3호점)** | 비전은 자율 개설이지만 실제론 본사가 직접 헤드헌팅한 **안정 코어 강사** 운영 (PMF 검증). 다종목 mix (스트레칭·필라테스·근력 GX 등). 어드민이 스케줄·카테고리 배치 + `gxOpenEnabled` 강사가 자율 개설 병행. 회원 카테고리 수요 데이터 누적 시 추가 채용 trigger (카테고리 가동률 > 70% 또는 대기열 발생) |
| **Phase 2 (4호점+)** | 아카데미 통과자 자율 가입. `gxOpenEnabled` 부여 범위 확대. 어드민 큐레이션 완화 |
| **Phase 3 (10호점+)** | 완전 자동 onboarding. P3+ 강사 `gxOpenEnabled` 자동 부여. 진정한 오픈마켓 지향 |

---

## 의존성

**입력**: [1A 회원 페르소나](../product/personas.html), [0. 비전](../product/vision.html), [ADR 0011](../decisions/0011-recovergx-gx-pivot.html)
**영향 주는 것**:
- [3B 강사 문제의식](./problems.html)
- [3C 강사 Value Prop](./value-prop.html) — "클래스 자율 개설 + 플랫폼 대행"이 메인 카피
- [3D 모집 전략](./recruitment.html)
- [3E GX 강사 운영 모델](./model.html)
- [3F gxOpenEnabled 검증](./peer-leader.html)
- [3G 정산](./payout.html) — 조합형 정산 구조

---

## 변경 이력

| 날짜 | 변경자 | 변경 내용 |
|---|---|---|
| 2026-05-11 | Young + Claude | 4종 페르소나 가설 (성장 발판·독립 검증·부업·Peer) |
| 2026-05-11 | Young | 재정의: 특정 강사군 ❌. 비전 = "PT를 파트타임 잡으로" (배달기사형) |
| 2026-06-04 | Young + Claude | **recoverGX 피벗** — 1:1 PT → GX 클래스 개설 모델. 비전 = "GX 강사를 자율 클래스 오너로". 핵심 메커니즘·자연 발생 풀·Phase별 적용 GX 관점 전환 |
