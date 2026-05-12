---
title: 결제 흐름
parent: 💳 결제 PG
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 결제 흐름 (시나리오별)

**Status**: Draft · **Updated**: 2026-05-13

## 1. 신규 가입·첫 결제

```
회원 → 멤버십 선택 (주 1·2회권 + 약정) → 카드 등록
→ PG 호출 (인증·승인) → success
→ Membership 활성화 (creditsRemaining 충전)
→ PaymentLedger 'escrow' 등록 (7일 후 releasable)
→ 회원 확인 화면 + 영수증 이메일
```

## 2. 자동 갱신 (정기결제)

```
cron 갱신 D-7일 → 알림 (푸시·인앱·이메일)
cron D-1일 → 자동결제 시도 (PG)
  success → Membership 다음 기간 시작
  fail → retry 3회 (24h 간격) → 7일 grace → 자동 해지
```

## 3. 포인트 충전

```
회원 → 충전 단위 선택 (5만/10만/20만)
→ PG 호출 → success → PointBalance 증가
→ 영수증
```

## 4. 환불 (중도 해지)

```
회원 → 해지 신청 → 사유 입력
→ 환불 산출 (미사용 회차 × 정상가)
→ 약관 동의 + 확인
→ PG 환불 API (부분 환불 가능)
→ Refund 생성 + Payment.status='refunded'
→ Membership status='cancelled'
→ 이미 정산된 멘토 분배 → 다음 격주에 회수
```

## 5. 청약철회 (7일 이내)

```
회원 → 7일 이내 + 사용 회차 0
→ PG 전액 환불
→ Membership 즉시 종료
→ 회원 데이터 보관 (5년 — 분쟁 대비)
```

## 6. 6h 이내 취소 (= 노쇼)

```
회원이 6h 이내 취소 → 회차 1 차감
→ 환불 ❌
→ 멘토 정산 정상 진행 (멘토 보호)
```

## 7. Pro 인증 멘토 swap 보상

```
시스템이 Pro 예약을 일반 멘토로 변경
→ 회원 BonusCredit 발급 (1회권)
→ Pro 차감된 포인트 환불
```

## 8. 데이터 모델

```typescript
interface Payment {
  id: string
  memberId: string
  type: 'membership' | 'point' | 'trial'
  amount: number
  status: 'pending' | 'paid' | 'failed' | 'refunded'
  pgProvider: 'toss' | 'portone'
  pgTransactionId: string
  paidAt?: string
  refundedAt?: string
}

interface PaymentLedger {
  id: string
  paymentId: string
  status: 'escrow' | 'releasable' | 'refunded' | 'distributed'
  releasedAt?: string  // 7일 후
}

interface Refund {
  id: string
  paymentId: string
  usedCredits: number
  refundAmount: number  // 부분 환불
  fee: number
  reason: string
  processedAt?: string
}
```

## 9. PG API 매핑

| 동작 | 토스페이먼츠 | 포트원 |
|---|---|---|
| 인증·결제 | `/v1/payments/confirm` | `/payments/:imp_uid/cancel` |
| 정기결제 (빌링키) | `/v1/billing/authorizations` | `/subscribe/payments/onetime` |
| 환불 | `/v1/payments/:paymentKey/cancel` | `/payments/:imp_uid/cancel` |
| Webhook | tossPayments → 본사 | portone → 본사 |

## 10. 엣지 케이스

| 케이스 | 처리 |
|---|---|
| PG 결제 후 webhook 누락 | 5분 간격 cron 동기화 |
| 환불 시 PG는 성공·본사 DB 실패 | 트랜잭션 + Sentry 알림 |
| 카드 한도 초과 | retry 3회 후 알림 |
| 카드 정지 | 회원 알림 → 다른 카드 등록 권유 |
| 회원이 환불 후 재가입 | 새 Membership (이전 데이터 보존) |
| 부분 환불 (사용 회차 + 미사용) | Refund.refundAmount = 미사용분 |

---

| 2026-05-13 | 초안 — 8 시나리오 + 데이터 모델 + PG API 매핑 |
