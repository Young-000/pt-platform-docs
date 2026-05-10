---
title: 결정 트리
parent: 1. 제품
nav_order: 1
---

# 결정 트리 (Decision Tree)

> **사업 OS의 골격.** 모든 결정이 이 트리의 어딘가에 위치합니다.
> 위에서부터 아래로 내려가며 한 노드씩 정의합니다. 상위 결정이 하위 결정의 제약/입력이 됩니다.

{: .note }
> 결정 진행 상태는 [홈 대시보드](./)에서 한눈에 확인 가능합니다.

---

## Level 0 — 정체성 🟢 LOCKED

> **"예약제 private PT shop with AI"** — 100호점 체인화 야망.

→ [상세](./product/identity.html)

---

## Level 1 — 포지셔닝 (Who & Why) ★ 진행 중

| 노드 | 내용 | 페이지 |
|---|---|---|
| 1A | 타겟 고객 — 누가 쓰는가 | [personas](./product/personas.html) |
| 1B | 문제의식 / JTBD — 왜 쓰는가 | [problems](./product/problems.html) |
| 1C | 경쟁 대안 비교 — 뭐가 다른가 | [competition](./product/competition.html) |
| 1D | Value Proposition — 한 줄 약속 | [value-prop](./product/value-prop.html) |

---

## Level 2 — 서비스 (What)

| 노드 | 내용 | 페이지 |
|---|---|---|
| 2A | 세션 종류 — Pro PT vs Peer 운동 | [session-types](./service/session-types.html) |
| 2B | 세션 포맷 — 30분 카디오 + 60분 방 PT | [session](./service/session.html) |
| 2C | AI 역할 범위 | [ai-role](./service/ai-role.html) |
| 2D | 공간 구조 — 방 단위·테마·평수 | [space](./service/space.html) |

---

## Level 3 — 강사 (Partners)

| 노드 | 내용 | 페이지 |
|---|---|---|
| 3A | Pro 강사 모델 (gig vs 전속 vs hybrid) | [model](./partners/model.html) |
| 3B | Peer 운동 리더 (자격·보상·검증) | [peer-leader](./partners/peer-leader.html) |
| 3C | 모집 전략 (콜드스타트 vs 스케일) | [recruitment](./partners/recruitment.html) |
| 3D | 정산 구조 | [payout](./partners/payout.html) |
| 3E | 품질 관리·등급 | [quality](./partners/quality.html) |

---

## Level 4 — 회원 (Members)

| 노드 | 내용 | 페이지 |
|---|---|---|
| 4A | 멤버십 구조 | [membership](./members/membership.html) |
| 4B | 가격 체계 | [pricing](./members/pricing.html) |
| 4C | 회원 여정 (가입~이탈방지) | [journey](./members/journey.html) |
| 4D | 환불·노쇼·취소·일시정지·양도 | [policies](./members/policies.html) |

---

## Level 5 — 비즈니스 모델 (How we make money)

| 노드 | 내용 | 페이지 |
|---|---|---|
| 5A | 확장 모델 — 직영 vs 가맹 vs 하이브리드 | [expansion-model](./expansion/model.html) |
| 5B | 본사 ↔ 가맹점주 책임 분담 | [responsibility](./expansion/responsibility.html) |
| 5C | 본사 수익 모델 (가맹비·로열티·분배) | [revenue-share](./expansion/revenue-share.html) |

---

## Level 6 — 운영 (Operations)

| 노드 | 내용 | 페이지 |
|---|---|---|
| 6A | 예약 시스템 (피크 6-10pm 고정 슬롯 등) | [reservation](./operations/reservation.html) |
| 6B | 지점 운영 (무인/유인, 시간, SOP) | [store](./operations/store.html) |
| 6C | 안전·보험·사고 | [safety](./operations/safety.html) |

---

## Level 7 — 경제성 (Economics)

| 노드 | 내용 | 페이지 |
|---|---|---|
| 7A | 단위 경제 (지점당 P&L) | [unit-economics](./economics/unit-economics.html) |
| 7B | 매출·원가 모델 | [revenue-cost](./economics/revenue-cost.html) |
| 7C | 100호점 추정 / BEP / CapEx | [projection](./economics/projection.html) |

---

## Level 8 — 법무

| 노드 | 내용 | 페이지 |
|---|---|---|
| 8A | 가맹사업법 / 정보공개서 | [franchise-law](./legal/franchise-law.html) |
| 8B | PT 자격증 법규 | [pt-license](./legal/pt-license.html) |
| 8C | 개인정보·이용약관 | [privacy-tos](./legal/privacy-tos.html) |

---

## 진행 원칙

1. **위에서 아래로** — 상위 노드가 결정되어야 하위 옵션이 좁혀짐
2. **한 노드씩** — 동시에 여러 결정 시도하지 않음
3. **결정 후 ADR** — 결정되면 `decisions/`에 ADR 봉인
4. **하위 노드는 상위 변경 시 재검토** — 트리는 살아있는 문서
