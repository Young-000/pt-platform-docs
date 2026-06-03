---
title: 결제 흐름
parent: 💳 결제 PG
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 결제 흐름 (시나리오별)

**Status**: GX Implemented · **Updated**: 2026-06-03

{: .highlight }
> **recoverGX 흐름**: 지갑 충전(정액 패키지, mock PG) → 클래스 예약 시 차감 → 취소 시 환불. PG는 충전 1회만 관여. 아래 시나리오 1~3은 GX 활성 구현, 4~7은 PT 레일(보류).

## 1. 지갑 충전 (GX — 구현 완료)

```
회원 → 충전 패키지 선택 (어드민이 설정한 정액: 예 5만/10만/30만)
→ POST /api/wallet/charge (idempotencyKey 필수)
→ mock PG 호출 → success
→ WalletTransaction(type=charge) 생성, Wallet.balance 증가
→ 충전 확인 화면
```

> 이중 충전 방어: `WalletTransaction.idempotencyKey @unique`. 동일 키 재시도 → 기존 결과 replay.

## 2. 클래스 예약·차감 (GX — 구현 완료)

```
회원 → 시간표에서 클래스 선택 → 가격 확인 (잔액에서 N원 차감 안내)
→ POST /api/gx/bookings (idempotency)
  [단일 트랜잭션]:
    잔액 확인 (부족 → INSUFFICIENT_BALANCE → 충전 CTA)
    WalletTransaction(type=deduct, refType='gx_booking') 생성
    GxBooking 생성 + bookedCount 원자 증가
→ 예약 확정 화면 (잔액 표시)
```

## 3. 취소·환불 (GX — 구현 완료)

```
회원 → 예약 취소
→ DELETE /api/gx/bookings/:id
  refundCutoffHours 전 취소:
    WalletTransaction(type=refund) 생성 → 지갑 전액 복구
    GxBooking.status = cancelled, bookedCount 감소
  refundCutoffHours 이내 취소:
    환불 0원 (좌석은 복구)
    GxBooking.status = cancelled, bookedCount 감소
```

## 4. 폐강 (GX — 구현 완료)

```
강사/어드민 → DELETE /api/gx/classes/:id
→ [원자적 updateMany]: 모든 예약자 전액 환불 (시점·출석 무관)
→ GxClass.status = cancelled
→ 전원 WalletTransaction(type=refund) 생성
```

---

{: .warning }
> 아래 시나리오(5~8)는 **PT 레일 (보류)** 기준. 코드·모델 보존 상태.

## 5. PT 신규 가입·첫 결제 (보류)

```
회원 → 멤버십 선택 (주 1·2회권 + 약정) → 카드 등록
→ PG 호출 (인증·승인) → success
→ Membership 활성화 (creditsRemaining 충전)
→ PaymentLedger 'escrow' 등록 (7일 후 releasable)
→ 회원 확인 화면 + 영수증 이메일
```

## 6. PT 자동 갱신 (정기결제, 보류)

```
cron 갱신 D-7일 → 알림
cron D-1일 → 자동결제 시도 (PG)
  success → Membership 다음 기간 시작
  fail → retry 3회 → 7일 grace → 자동 해지
```

## 7. PT 중도 해지·환불 (보류)

```
회원 → 해지 신청 → 환불 산출 (미사용 회차 × 정상가)
→ PG 환불 API → Refund 생성 → Membership cancelled
→ 이미 정산된 멘토 분배 다음 격주에 회수
```

## 8. PT 청약철회 (보류)

```
7일 이내 + 미사용 → PG 전액 환불 → Membership 즉시 종료
```

---

## 데이터 모델 (GX)

```typescript
interface Wallet {
  id: string
  memberId: string      // unique
  balance: number       // KRW 잔액
}

interface WalletTransaction {
  id: string
  walletId: string
  type: 'charge' | 'deduct' | 'refund'
  amount: number        // 항상 양수
  balanceAfter: number  // 거래 후 잔액 스냅샷
  refType?: 'gx_booking' | 'charge_package'
  refId?: string
  idempotencyKey?: string  // unique — 이중 충전 방어
}

interface ChargePackage {
  id: string
  name: string
  amount: number
  bonus: number
  active: boolean
  sortOrder: number
}
```

## PG API 매핑 (충전 1건 기준)

| 동작 | 토스페이먼츠 | 포트원 |
|---|---|---|
| 인증·결제 (충전) | `/v1/payments/confirm` | `/payments/onetime` |
| 환불 (충전 취소) | `/v1/payments/:paymentKey/cancel` | `/payments/:imp_uid/cancel` |
| Webhook | tossPayments → 본사 | portone → 본사 |

> 정기결제(빌링키) 불필요 — 충전금 소진 방식.

## 엣지 케이스

| 케이스 | 처리 |
|---|---|
| 충전 PG 성공·DB 실패 | 트랜잭션 + 알림. idempotencyKey로 재시도 안전 |
| 잔액 부족 예약 | `INSUFFICIENT_BALANCE` → 클라이언트 충전 CTA |
| 취소 마감 후 환불 요청 | `REFUND_CUTOFF_PASSED` → 환불 0원 안내 |
| 폐강 동시 예약 경합 | `updateMany` 원자 처리로 이중 환불 차단 |
| 정산 후 출석 변경 | `SETTLEMENT_DONE` 에러 |

---

| 2026-05-13 | 초안 — PT 레일 시나리오 |
| 2026-06-03 | GX 지갑 흐름(충전·차감·취소·폐강) 추가. PT 레일 보류 배너. (ADR 0011) |
