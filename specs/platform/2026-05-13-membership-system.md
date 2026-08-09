---
title: 2026-05-13 멤버십·결제 (시스템)
parent: 🏢 플랫폼
grand_parent: 스펙 (PRD)
nav_order: 2
---

# 🏢 멤버십·결제·정책 (시스템)

{: .warning }
> **PT 레일 (보류)** — 이 스펙은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

### GX 대응

GX 전환으로 결제 모델이 **지갑 충전 → 드롭인 차감** 구조로 바뀐다: 회원이 지갑에 현금을 충전하고, GX 클래스 예약(드롭인)마다 회당가를 차감. 회차권 5단 라인업은 GX 패스(횟수권 또는 무제한 월정액)로 대체될 수 있으며 정책은 ADR 0011 후속 설계에서 확정. 환불·일시정지 로직의 기본 골격(청약철회 7일·자동 갱신·정책 엔진)은 GX 레일에도 계승.

**Status**: Draft
**관련 결정**: [2B 멤버십](../../members/membership.html) · [2C 가격](../../members/pricing.html) · [2D 정책](../../members/policies.html)
**📡 API**: [멤버십·결제](../api/catalog.html#멤버십결제-membership) · [시스템·Cron](../api/catalog.html#시스템--cron)
**🗄️ Data**: [7. Membership](../data/07-membership.html) · [10. Audit](../data/10-audit.html)

## 1. 시스템 구성

- 결제 PG: **토스페이먼츠 또는 포트원** (Phase 1 결정)
- 자동결제: 카드 정기결제 모듈
- 정책 엔진: 환불·취소·일시정지 룰 자동 산출
- 본사 결제 직수령 → 자동 분배 (멘토·가맹점주는 [정산 시스템](./2026-05-13-payout-system.html))

## 2. 핵심 로직

### A. 환불 산출

```
미사용 회차 수 × 정상가 환산 단가 - 위약금 = 환불액
정상가 환산: 약정 할인 받은 경우 정상가 적용 후 차액
```

### B. 일시정지 처리

- 사유 ❌, 자유 신청
- 누적 일시정지 = 약정 기간의 30% 이내
- 약정 만료일 = 원래 만료 + 일시정지 누적 일수

### C. 갱신 알림

- 만료 7일 전: 푸시 + 인앱 알림
- 만료 1일 전: 자동결제 시도 → 실패 시 7일 grace + 자동 해지

### D. 청약철회

- 결제 후 7일 이내 + 사용 회차 0 = 100% 환불
- 사용 회차 > 0 = 사용분 차감 후 환불

## 3. 데이터 모델

```
Membership
  ├─ id, member_id
  ├─ type ENUM(week1, week2)
  ├─ credits_remaining (int)
  ├─ contract_months (int), discount_rate
  ├─ started_at, expires_at, paused_at, resumed_at
  ├─ auto_renew (bool), price_at_purchase

PointBalance
  ├─ id, member_id
  ├─ balance (int)
  ├─ last_charged_at

Payment
  ├─ id, member_id
  ├─ type ENUM(membership, point, trial)
  ├─ amount, currency, status
  ├─ pg_transaction_id
  ├─ paid_at, refunded_at

Refund
  ├─ id, payment_id
  ├─ used_credits, refund_amount, fee, reason
  ├─ processed_at

PolicyEvent (회원 정책 트리거 로그)
  ├─ id, member_id, type ENUM(refund, pause, cancel, no-show, compensation)
  ├─ payload (jsonb), created_at
```

## 4. API 엔드포인트

- `POST /memberships` — 멤버십 가입 (결제 포함)
- `POST /memberships/:id/pause` — 일시정지
- `POST /memberships/:id/resume` — 재개
- `POST /memberships/:id/refund` — 환불 신청 (산출 → 처리)
- `POST /points/charge` — 포인트 충전
- `POST /points/consume` — Pro 인증 멘토 예약 시 차감
- `POST /payments/webhook` — PG 결과 수신

## 5. PG 연동 (선택 미정)

- 토스페이먼츠: 단순·국내 점유율 ↑
- 포트원 (구 아임포트): 다중 PG 통합 가능, 약간 복잡

→ 1호점 가맹업자 결제 정책 확인 후 최종 결정.

## 6. 다른 레이어 영향

- **👤 유저**: 화면·UX는 [회원 PRD](../user/2026-05-13-membership-payment.html)
- **💪 멘토**: 본인 정산은 [정산 시스템](./2026-05-13-payout-system.html)
- **🏢 어드민**: 환불·정지 수동 처리 가능 (정책 위반 시)

## 7. 엣지 케이스

- 카드 결제 실패: retry 3회 후 회원 알림 + 7일 grace
- PG webhook 누락: cron 동기화 (5분 간격)
- 환불 후 멘토 정산 회수 필요 시: 환불 사유 분류로 처리

## 8. 측정 지표

- 결제 성공률 ≥ 99%
- 자동 갱신 성공률 ≥ 95%
- 환불 처리 SLA: 신청 후 영업일 3일 이내

---

| 2026-05-13 | 초안 |
