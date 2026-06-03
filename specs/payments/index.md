---
title: 💳 결제 PG
parent: 스펙 (PRD)
nav_order: 6
has_children: true
---

# 💳 결제 PG 연동

> Phase 1 런칭 필수. 지갑 충전 결제·환불·정산·세금계산서.

{: .highlight }
> **recoverGX (2026-06-03)**: 결제 구조 단순화. **PG 연동 1건만 필요** — 지갑 충전 시 정액 패키지 결제 1건. 클래스 예약은 지갑 내부 차감이라 PG 미관여. 현재 mock PG 사용 중. 실 PG 연동은 `wallet/charge` 엔드포인트 1개에 집중하면 됨. 정본: [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html).

## 하위 문서

- [PG 선택](./pg-selection.html) — 토스페이먼츠 vs 포트원 (충전 1건 기준으로 단순화)
- [결제 흐름](./flow.html) — 충전·드롭인 예약·취소·환불 시나리오
- [정산·세무](./settlement.html) — GxSettlement → 분배 → 세금계산서

## 관련 결정

- [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) — GX 지갑 결제 모델
- [2D 정책](../../members/policies.html) (환불 룰 — GX: refundCutoffHours 정책)
- [6C 본사 수익 모델](../../expansion/revenue-share.html) (분배)

## 핵심 의사결정

| 항목 | 현황 | 비고 |
|---|---|---|
| PG 연동 범위 | 지갑 충전 1건 (mock PG) | 클래스 예약은 지갑 내부 차감 |
| 실 PG 연동 | 미완료 — 후속 작업 | 토스페이먼츠 권장 |
| 충전 멱등성 | `WalletTransaction.idempotencyKey @unique` | DB 레벨 이중 적립 방어 |
| 환불 정책 | `GxPolicy.refundCutoffHours` (기본 6h) | 어드민 관리 |
| 정기결제 | 현재 불필요 (충전금 소진 방식) | 구독 모델 전환 시 필요 |
| 세금계산서 | 자체 권장 | 미구현 |
