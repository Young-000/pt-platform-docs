---
title: 2026-05-13 멤버십·결제 (회원)
parent: 👤 유저
grand_parent: 스펙 (PRD)
nav_order: 2
---

# 👤 회차권·결제·정책 (회원 흐름, v2)

{: .warning }
> **PT 레일 (보류)** — 이 스펙은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

### GX 대응

GX 전환 후 회원 결제 흐름이 **지갑 충전 → 드롭인 차감**으로 바뀐다: 회원이 지갑에 현금을 충전(PG 결제)하고, GX 클래스 드롭인 예약마다 회당가를 차감. 회차권 5단 라인업은 GX 패스(횟수권 또는 무제한 월정액)로 전환 검토 중(ADR 0011 후속 확정). 청약철회·환불 산출 기본 정책 골격은 계승.

**Status**: v2 Accepted · **Layer**: 👤 유저 · **Updated**: 2026-05-16
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html)
**📡 API**: [catalog](../api/catalog.html) `/api/tickets/*` · `/api/points/*`
**🗄️ Data**: [7. Membership](../data/07-membership.html) · [10. Audit](../data/10-audit.html)
**의존**: [2B 멤버십](../../members/membership.html) · [2C 가격](../../members/pricing.html) · [2D 정책](../../members/policies.html)

## 1. 배경 (v2)

v2에서 멤버십은 **회차권 단일 모델** ([ADR 0004](../../decisions/0004-one-time-ticket-pricing.html))로 통일. "주 1회/주 2회 + 약정 1·3·6·12개월" 다차원 구조 폐기. 회원이 보는 가격표는 **회차 수 × 회당가** 한 차원 + Pro 옵션.

## 2. 회차권 라인업 (5단, 봉인 — ADR 0004)

| 상품 | 회차 | 가격 | 회당가 |
|---|---|---|---|
| 1회차권 | 1 | 40,000원 | 40,000 |
| 4회차권 | 4 | 140,000원 | 35,000 |
| 12회차권 | 12 | 360,000원 | 30,000 |
| 24회차권 | 24 | 650,000원 | 27,000 |
| 48회차권 | 48 | 1,200,000원 | 25,000 |

모든 값 = `admin.PricingConfig` 변수 (정책 운영).

## 3. Pro 옵션 (포인트)

- Pro 강사 ([ADR 0002](../../decisions/0002-license-policy.html)) 매칭 시 회당 **+5,000원 포인트 차감**.
- 포인트는 별도 충전 (현금). 잔액 부족 시 → 일반 강사로 fallback 또는 충전 안내.
- 미사용 포인트 100% 환불 (현금 결제분), 보너스분 ❌.

## 4. 결제 흐름

```
회차권 선택 (1/4/12/24/48) → 결제(PG) → MembershipTicket created
  ↓ (첫 사용 또는 30일)
status=active, activatedAt 기록, expiresAt 산출
  ↓
예약 = 회차 1 차감 (Pro면 포인트 5k 추가 차감)
  ↓
회차 0 또는 만료일 도과 → expired
```

## 5. 화면 / 컴포넌트

| 화면 | 핵심 정보 |
|---|---|
| 회차권 구매 | 5단 카드(회차/가격/회당가), 결제 버튼 |
| 내 회차권 | ticketType, 잔여/총 회차, 만료일, 일시정지/해지 메뉴 |
| 포인트 | 잔액, 충전, 사용 내역 |
| 환불 미리보기 | `GET /api/tickets/me/:id/refund-preview` 결과 — 산출식 노출 |

## 6. 정책 (회원 알림 포인트)

- **청약철회**: 결제 후 7일 + 미사용 = 100% 환불
- **1회차권 환불**: 24h + 미사용만 100%, 그 외 ❌
- **4·12·24·48회차권 환불**: `priceCharged − pricePerCredit × usedCredits` (음수 시 0)
- **일시정지**: 4회+ 회차권만, 잔여 회차 30% 한도
- **양도**: ❌
- **자동 갱신**: 옵션 (회원 동의 시)

## 7. 자유 헬스 자격

회차권 보유 회원은 자유 헬스 부가 이용 ([ADR 0003](../../decisions/0003-free-gym-add-on.html))
- 회차권 active/paused, 또는 만료 후 30일 이내 (grace)
- 입장 시 회차 소비 ❌

## 8. Edge Cases

- 결제 직후 청약철회 (created 상태): 100% 환불, ticket cancelled
- 활성 회차권 있는 상태에서 추가 결제: created 상태 추가 row (한 회원 = 최대 1 active + 1 created)
- 가격 인상 적용 시점: 자동 갱신 회원에게 D-7 알림 + 동의 후 갱신
- Pro 옵션 포인트 부족: 예약 트랜잭션 실패 (`INSUFFICIENT_POINTS`) → 일반 강사 재선택 안내

## 9. 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-13 | v1 초안 — 주 1회/주 2회권, 약정 할인 1·3·6·12개월 |
| 2026-05-16 | **v2 재작성** — 회차권 5단 단일 모델, Pro 옵션 포인트, 환불 공식 통일. v1은 `_archive/v1-user-membership-payment.md`. (ADR 0004) |
