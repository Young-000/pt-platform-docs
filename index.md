---
title: 홈
nav_order: 1
---

# PT Platform — 결정 대시보드

> **예약제 private PT shop with AI** — AI 기반 운동 세션을 핵심으로 하는 회원제 부티크 PT 서비스.
> 목표: **100호점 이상 체인화** (가맹 모델 활용 가능).

{: .note }
> 본 사이트는 단순 위키가 아니라 **사업 OS**입니다. 모든 핵심 결정이 여기에 정의되고, 결정 전엔 🔴 TBD로 남아 있습니다. 결정 후엔 ADR로 봉인됩니다.

전체 구조는 **[결정 트리](./decision-tree.html)**에서 한눈에. 각 노드는 통일된 [결정 카드](./_decision-card-template.html) 양식을 따릅니다.

---

## 결정 영역 한눈에

각 항목 옆 상태가 색깔로 표시됩니다.
**범례** — 🟢 결정 / 🟡 부분 정의 / 🔴 미결정 / ⚪ 외부 의존

### 제품 정체성

- 🟡 [정체성 — 예약제 private PT shop with AI](./product/identity.html)
- 🟢 [비전 — 100호점 확장](./product/vision.html)
- 🔴 [문제의식 — 5가지 고질병 정제](./product/problems.html)
- 🔴 [페르소나 — 1순위/2순위 단계화](./product/personas.html)
- 🔴 [경쟁 대안 비교](./product/competition.html)
- 🔴 [Value Proposition](./product/value-prop.html)

### 강사 (Partners) ★ 최우선

- 🔴 [강사 모델 — Pro vs Peer, gig vs hybrid](./partners/model.html)
- 🔴 [Peer 운동 리더 모델](./partners/peer-leader.html)
- 🔴 [강사 모집 전략 — 콜드스타트 vs 스케일](./partners/recruitment.html)
- 🔴 [강사 정산 구조](./partners/payout.html)
- 🔴 [강사 품질 관리·등급](./partners/quality.html)

### 회원 (Members)

- 🔴 [회원 여정 — 가입 → 재예약](./members/journey.html)
- 🔴 [멤버십 구조](./members/membership.html)
- 🔴 [가격 체계](./members/pricing.html)
- 🔴 [환불·노쇼·취소·일시정지·양도](./members/policies.html)

### 서비스 (What)

- 🔴 [세션 종류 — Pro PT vs Peer 운동](./operations/session-types.html)
- 🟡 [세션 포맷 — 30분 카디오 + 60분 PT](./operations/session.html)
- 🔴 [AI 역할 범위](./operations/ai-role.html)
- 🔴 [공간 구조 — 방·테마·평수](./operations/space.html)

### 운영 (Operations)

- 🔴 [예약 시스템 — 피크 6-10pm 고정 슬롯 등](./operations/reservation.html)
- 🔴 [지점 운영 — 무인/유인·시간·SOP](./operations/store.html)
- 🔴 [안전·보험·사고처리](./operations/safety.html)

### 비즈니스 모델 (How we make money)

- 🔴 [확장 모델 — 직영 vs 가맹 vs 하이브리드](./expansion/model.html)
- 🔴 [본사 ↔ 가맹점주 책임 분담](./expansion/responsibility.html)
- 🔴 [본사 수익 모델 — 가맹비·로열티·분배](./expansion/revenue-share.html)

### 경제성 (Economics)

- 🔴 [단위 경제 — 지점당 P&L](./economics/unit-economics.html)
- 🔴 [매출·원가 모델](./economics/revenue-cost.html)
- 🔴 [100호점 추정 — BEP / CapEx](./economics/projection.html)

### 법무·약관

- ⚪ [가맹사업법 / 정보공개서](./legal/franchise-law.html)
- ⚪ [PT 자격증 법규](./legal/pt-license.html)
- ⚪ [개인정보 / 이용약관](./legal/privacy-tos.html)

---

## 우선 결정 순서

1. **강사 모델** — 정산·품질·예약 모두 여기서 파생
2. **세션 종류 (Pro PT vs Peer)** — 강사 모델과 동시 결정
3. **멤버십 구조** — 가격·여정·예약 단위 입력
4. **단위 경제** — 가격 결정의 검증 도구
5. **가격 체계**
6. **예약 시스템**
7. **회원 정책 (환불·노쇼)**
8. **약관·개인정보** — 사업자 등록 / 결제 연동 시

---

## 라이브 앱

- [유저 앱](https://pt-platform-mvp.vercel.app)
- [강사 앱](https://pt-platform-partner.vercel.app)
- [어드민](https://pt-platform-admin.vercel.app)
- [수익 시뮬레이터](https://pt-platform-simulator.vercel.app)

---

협업자라면 [온보딩 가이드](./onboarding.html)를 먼저 읽어주세요.

{: .warning }
> 본 문서는 PT Platform 내부 문서입니다. 외부 공유 시 사전 협의가 필요합니다.
