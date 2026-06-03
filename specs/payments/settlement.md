---
title: 정산·세무
parent: 💳 결제 PG
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 정산·세무

**Status**: GX Implemented · **Updated**: 2026-06-03

## GX 정산 (recoverGX — 구현 완료)

### 흐름

```
클래스 완료 → POST /api/gx/classes/:id/complete
→ [자동] GxSettlement 생성:
    attendedCount = 출석 인원
    revenue = 취소 환불 제외 차감 합계 (no_show 포함)
    policySnapshot = 강사 할당 GxPayoutPolicy 스냅샷
    payoutAmount = baseAmount + (perHeadAmount × attendedCount) + (revenue × revenueSharePercent / 100)
    platformMargin = revenue - payoutAmount
```

### 특이사항

- **정책 스냅샷**: `policySnapshot Json` 박제 → config 변경 후에도 해당 클래스 정산 불변
- **실제 이체 미구현**: 계산·조회까지만. 은행 지급은 후속 작업
- **정산 확정 후 출석 불변**: `GxSettlement` 생성 후 `PATCH /attendance` 차단

### 정산 조회

- 어드민: `GET /api/gx/settlements` — 전체 클래스별 매출·지급액·마진
- 강사: `GET /api/gx/settlements` — 본인 클래스만 필터링

---

{: .warning }
> 아래 PT 레일 정산은 **보존·미활성** 상태.

## PT 레일 정산 (보류)

### 본사 escrow (PT)
- 결제 → 7일 escrow (`PaymentLedger`) → releasable
- 환불 가능 기간 보호

### 분배 (PT)
- 멘토 격주 정산 (`MentorPayout`)
- 가맹점주 분배 (Phase 2 예정)

## 세무

- 본사: GX 매출 = `GxSettlement.revenue` 합계
- 멘토: 사업소득 원천세 3.3% (`GxSettlement.payoutAmount` 기준)
- 월 1회 사업소득 명세서 (`TaxReport`) — 현재 미구현

---

| 2026-05-13 | 초안 — PT 레일 기준 |
| 2026-06-03 | GX 정산 흐름 추가 (GxSettlement, 조합형 공식). PT 레일 보류 배너. (ADR 0011) |
