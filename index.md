---
title: 홈
layout: home
nav_order: 1
---

# PT Platform — 결정 대시보드

> **예약제 private PT shop** — 강사 풀 + 공간 + AI 코치를 하나의 앱에 묶은 새로운 형태의 피트니스 서비스.
> 목표: **100호점 이상 체인화**

{: .note }
> 본 사이트는 단순 위키가 아니라 **사업 OS**입니다. 모든 핵심 결정이 여기에 정의되고, 결정 전엔 🔴TBD로 남아 있습니다. 결정 후엔 ADR로 봉인됩니다.

---

## 결정 영역 (한눈에)

각 영역의 상세 결정 항목은 해당 카테고리 페이지로 이동.

### 제품 정체성
| 항목 | 상태 |
|---|---|
| [정체성 — 예약제 private PT shop](./product/identity.html) | 🟡 Drafted |
| [비전 — 100호점 확장](./product/vision.html) | 🟢 Locked |
| [문제의식 — 5가지 고질병](./product/problems.html) | 🟢 Drafted |
| [페르소나 — Middle Ground Mover](./product/personas.html) | 🟢 Drafted |

### 강사 (Partners) ★ 최우선
| 항목 | 상태 |
|---|---|
| [강사 모델 (Pro vs Peer, gig vs hybrid)](./partners/model.html) | 🔴 TBD |
| [강사 모집 전략 (콜드스타트 vs 스케일)](./partners/recruitment.html) | 🔴 TBD |
| [강사 정산](./partners/payout.html) | 🔴 TBD |
| [강사 품질 관리·등급](./partners/quality.html) | 🔴 TBD |

### 회원 (Members)
| 항목 | 상태 |
|---|---|
| [회원 여정 (가입 → 재예약)](./members/journey.html) | 🔴 TBD |
| [멤버십 구조](./members/membership.html) | 🔴 TBD |
| [가격 체계](./members/pricing.html) | 🔴 TBD |
| [환불·노쇼·취소](./members/policies.html) | 🔴 TBD |

### 운영 (Operations)
| 항목 | 상태 |
|---|---|
| [세션 구조 (30분 카디오 + 60분 PT)](./operations/session.html) | 🟡 Partial |
| [예약 시스템](./operations/reservation.html) | 🔴 TBD |
| [지점 운영 (무인/유인·운영시간 등)](./operations/store.html) | 🔴 TBD |

### 경제성 (Economics)
| 항목 | 상태 |
|---|---|
| [단위 경제 (지점당)](./economics/unit-economics.html) | 🔴 TBD |
| [매출 모델](./economics/revenue.html) | 🔴 TBD |
| [원가 구조](./economics/cost.html) | 🔴 TBD |
| [100호점 추정](./economics/projection.html) | 🔴 TBD |

### 법무·약관
| 항목 | 상태 |
|---|---|
| [개인정보 / 이용약관](./legal/) | ⚪ 변호사 검토 필요 |

**범례**: 🟢 결정 · 🟡 부분 정의 · 🔴 미결정 · ⚪ 외부 의존

---

## 우선순위 (먼저 풀어야 할 결정)

| 순위 | 영역 | 왜 먼저 |
|---|---|---|
| 1 | **강사 모델** | 정산·품질·예약·회원 매칭 모두 여기서 파생 |
| 2 | **세션 구조 확정** | "Pro PT" vs "Peer 운동" 두 종류 정의 |
| 3 | **멤버십 구조** | 가격·회원 여정·예약 단위 모두 여기서 파생 |
| 4 | **단위 경제** | 가격 결정의 검증 도구 |
| 5 | **가격 체계** | 강사 정산 단가 + 시뮬레이터 입력값 |
| 6 | **예약 시스템** | 위 결정되면 자연스럽게 도출 |
| 7 | **회원 정책** | 운영 시작 직전 |
| 8 | **약관·개인정보** | 사업자 등록 / 결제 연동 시 |

---

## 라이브 앱

| 앱 | URL |
|---|---|
| 유저 앱 | [pt-platform-mvp.vercel.app](https://pt-platform-mvp.vercel.app) |
| 강사 앱 | [pt-platform-partner.vercel.app](https://pt-platform-partner.vercel.app) |
| 어드민 | [pt-platform-admin.vercel.app](https://pt-platform-admin.vercel.app) |
| 수익 시뮬레이터 | [pt-platform-simulator.vercel.app](https://pt-platform-simulator.vercel.app) |

---

협업자라면 [온보딩 가이드](./onboarding.html)를 먼저 읽어주세요.

{: .warning }
> 본 문서는 PT Platform 내부 문서입니다. 외부 공유 시 사전 협의가 필요합니다.
