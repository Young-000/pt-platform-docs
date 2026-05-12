---
title: 💳 결제 PG
parent: 스펙 (PRD)
nav_order: 6
has_children: true
---

# 💳 결제 PG 연동

> Phase 1 런칭 필수. 멤버십 결제·포인트·자동결제·환불·세금계산서.

## 하위 문서

- [PG 선택](./pg-selection.html) — 토스페이먼츠 vs 포트원
- [결제 흐름](./flow.html) — 가입·정기결제·환불 시나리오
- [정산·세무](./settlement.html) — 본사 escrow → 분배 → 세금계산서

## 관련 결정

- [2B 멤버십](../../members/membership.html) (주 1·2회권 + 포인트)
- [2D 정책](../../members/policies.html) (환불 룰)
- [6C 본사 수익 모델](../../expansion/revenue-share.html) (분배)

## 핵심 의사결정

| 항목 | 옵션 | 추천 |
|---|---|---|
| PG | 토스페이먼츠 / 포트원 | TBD (1호점 직전 결정) |
| 정기결제 (자동결제) | PG 별 지원 | 필수 |
| 부분 환불 | PG 지원 확인 | 필수 |
| 세금계산서 발급 | 자체 vs PG | 자체 권장 |
| 카드 토큰 저장 | PG 위탁 | 본사 PCI 불필요 |
