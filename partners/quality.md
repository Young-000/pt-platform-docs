---
title: 🔴 3H. 강사 품질·등급 (P1~P5)
parent: 3. 강사
nav_order: 8
---

# 3H. 강사 품질·등급 (P1~P5, recoverGX)

**🔴 TBD** (원칙만 락, 세부 보류) · 의존: [ADR 0011](../decisions/0011-recovergx-gx-pivot.html), [ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0002](../decisions/0002-license-policy.html), [ADR 0007](../decisions/0007-trainer-model.html) 승계, [3E 운영 모델](./model.html), [3F 개설 권한](./peer-leader.html), [3G 정산](./payout.html) → 회원 클래스 검색·정렬 가중치, `gxOpenEnabled` 자동 부여 기준

> 회원은 매 클래스마다 강사+프로그램을 직접 선택 ([ADR 0001](../decisions/0001-consumer-pivot.html)). 평점·재수강률은 **회원 측 클래스 검색·정렬·필터링** 가중치로 노출 (자동 매칭·강제 우선순위 ❌).

## 원칙

- 회원 평점·재수강률·클래스 출석률·기록 입력률 등 다축 평가
- 등급 P1~P5 ([ADR 0007](../decisions/0007-trainer-model.html) 승계)는 **조합형 정산 기본금 기준선** + **`gxOpenEnabled` 자동 부여 기준 (Phase 3+)** + 회원 측 클래스 목록 **정렬 가중치**에 활용
- 등급이 정산에 직접 영향 (기본금 기준선) → 조합형 정책 세부는 [3G](./payout.html)

## 세부 보류

- 평가 지표·가중치 (클래스 완주율·출석률·NPS 조합 상세)
- 회원 클래스 검색 화면의 정렬 가중치 계산식
- 회원 컴플레인 처리 SOP (단계·기준)
- Phase 3+ `gxOpenEnabled` 자동 부여 등급 기준 (P3 또는 P2+)

→ 1호점 운영 데이터 축적 후 구체화.

---

| 2026-05-12 | 4단계 등급 + 가중치 가설 |
| 2026-05-12 | 원칙만 락, 세부는 1호점 운영 데이터 보면서 TBD |
| 2026-05-16 | Critical 리뷰 High 8건 fix — "매칭 우선순위·자동 매칭" v1 표현 제거. 평점·재예약률 = 회원 측 검색·정렬 가중치로만 사용 |
| 2026-06-04 | **recoverGX 피벗** — 세션 → 클래스 관점 전환. 등급 P1~P5 ADR 0007 승계 명시. gxOpenEnabled 자동 부여 기준 세부 보류 항목 추가 |
