---
title: 2026-05-13 정산·분배 (시스템)
parent: 🏢 플랫폼
grand_parent: 스펙 (PRD)
nav_order: 6
---

# 🏢 정산·자동 분배 시스템

{: .warning }
> **PT 레일 (보류)** — 이 스펙은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

### GX 대응

GX 전환으로 정산 구조가 **조합형(기본금 + 수강 인당 보너스 + 매출 비율%)**으로 확장된다. PT 레일의 "30분 unit 1세션 = 1 정산 단위" 단순 모델 대신, GX 클래스 1회당 기본금 + (실제 출석 인원 × 인당 보너스) + 월 총매출 비율%를 합산하는 복합 산식이 적용된다. 격주 정산 주기·Escrow 7일·환불 회수·TaxReport 자동 생성 등의 운영 골격은 계승.

**Status**: Draft
**관련 결정**: [3G 정산](../../partners/payout.html) · [6C 본사 수익](../../expansion/revenue-share.html) · [6B R&R](../../expansion/responsibility.html)
**📡 API**: [정산](../api/catalog.html#정산-payout) · [시스템·Cron](../api/catalog.html#시스템--cron)
**🗄️ Data**: [9. Payout](../data/09-payout.html) · [7. Membership](../data/07-membership.html) · [10. Audit](../data/10-audit.html)

## 1. 핵심 컴포넌트

```
회원 결제 (본사 앱 직접 수령)
       │
       ▼
   결제 분배 엔진
   ┌────┬──────┬───────┐
   │멘토│ 본사  │가맹점주│
   └────┴──────┴───────┘
       │
       ▼
   격주 입금 처리
```

## 2. 분배 로직 (Phase 1 직영 기준)

```
회원 1세션 결제 X원
  → 멘토 정산: 회당 단가 (일반 고정 / Pro 자율)
  → 본사 보유: X - 멘토 회당 (운영비 + 마진)
  → 가맹점주 분배: 0 (Phase 1 직영)

Phase 2+ 가맹 시작:
  → 멘토 정산: 회당 단가
  → 가맹점주 분배: 매출 비율 (TBD, [6C](../../expansion/revenue-share.html))
  → 본사 보유: 나머지
```

## 3. 결제 흐름

```
회원 결제 (PG) → 본사 결제 계좌 (Escrow 형태)
                      │
                      ├─ 즉시: 환불 가능 status 유지 (7일)
                      └─ 7일 후: 정산 가능 status 전환

격주 마감일:
  for each mentor:
    sum 정산 가능 세션 → 명세서 → 입금
  for each franchisee (Phase 2+):
    sum 매출 분배 → 명세서 → 입금
  본사 = 나머지 (운영비·R&D)
```

## 4. 데이터 모델

```
PayoutPeriod
  ├─ id, start_date (격주 시작), end_date

PaymentLedger (결제 원장)
  ├─ id, payment_id, member_id, amount, paid_at
  ├─ status ENUM(escrow, releasable, refunded, distributed)
  ├─ released_at (7일 후)

DistributionEntry (분배 단위)
  ├─ id, payment_ledger_id, recipient_type ENUM(mentor, hq, franchisee)
  ├─ recipient_id, amount, applied_rate
  ├─ status ENUM(pending, paid)

MentorPayout (격주 정산)
  ├─ id, mentor_id, period_id, gross, deductions, net
  ├─ paid_at, transaction_id

FranchiseePayout (Phase 2+)
  ├─ id, franchisee_id, store_id, period_id
  ├─ gross, royalty_deducted, system_fee_deducted, net

TaxReport (세무 자료)
  ├─ id, recipient_type, recipient_id
  ├─ period (월), gross_income, deductions
  ├─ report_url (PDF)
```

## 5. 자동 분배 트리거

- 결제 완료 직후: `escrow` 상태로 적재
- 7일 후 (cron): `releasable`로 전환
- 격주 마감일: 멘토·가맹점주 정산 산출 → 입금
- 환불 발생 시: 해당 결제의 분배 entry 회수

## 6. API 엔드포인트

- `POST /payments/internal/release` (cron) — 7일 경과 결제 풀기
- `POST /payouts/calculate` (cron, 격주) — 정산 산출
- `POST /payouts/:id/pay` — 입금 실행 (가상계좌 / 이체 API)
- `GET /mentors/:id/payouts` — 멘토 본인 명세서 조회
- `GET /franchisees/:id/payouts` — 가맹점주 명세서 (Phase 2+)
- `GET /tax-reports/:recipient_type/:id` — 세무 자료 PDF

## 7. 본사 수익 흐름 (분배 후 남는 것)

```
본사 보유 = 회원 결제 - 멘토 정산 (Phase 1)
            = 위 - 가맹점주 분배 (Phase 2+)

본사 보유 → 본사 운영비
  - AI API 비용
  - CS 인력
  - 마케팅
  - 시스템 인프라
  - R&D
  - 마진 (목표 월 500만/지점, 향후 ↑)
```

## 8. 다른 레이어 영향

- **👤 유저**: 결제 자체 → [멤버십 PRD](./2026-05-13-membership-system.html)
- **💪 멘토**: 정산 화면 → [멘토 정산 PRD](../mentor/2026-05-13-payout.html)
- **가맹점주 (Phase 2+)**: 별도 가맹점주 화면 PRD 추후 작성

## 9. 엣지 케이스

- 환불 처리 시 이미 정산된 멘토 회수: 다음 격주 정산에서 차감
- 입금 실패 (계좌 오류): 재시도 + 멘토 알림
- 정산 중 시스템 다운: 트랜잭션 보장 (Idempotency key)
- 세무 신고 누락: 월말 cron으로 자동 생성

## 10. 측정 지표

- 정산 정확도 100% (오류 사고 0건)
- 분배 처리 SLA: 격주 마감일 자정 ~ 다음날 정오 내 완료
- 환불 → 정산 회수 정확도 100%
- 본사 운영비 충당 비율 ≥ 100% (Phase 2 진입 시)

---

| 2026-05-13 | 초안 |
