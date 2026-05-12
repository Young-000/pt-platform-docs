---
title: 2026-05-13 멤버십·결제 (회원)
parent: 👤 유저
grand_parent: 스펙 (PRD)
nav_order: 2
---

# 👤 멤버십·결제·정책 (회원 흐름)

**Status**: Draft · **Layer**: 👤 유저 · **Updated**: 2026-05-13
**관련 결정**: [2B 멤버십](../../members/membership.html) · [2C 가격](../../members/pricing.html) · [2D 정책](../../members/policies.html) · [2A 회원 여정](../../members/journey.html) · [1A 페르소나](../../product/personas.html) · [4A 세션 종류](../../service/session-types.html)
**현재 코드**: `apps/mvp/src/pages/MembershipPage.tsx`, `LoginPage.tsx`, `RegisterPage.tsx`

## 1. 배경

기존 MVP는 Basic / Standard / Premium 3티어 + space_credits + pt_credits 분리 구조. 새 모델은 **주 1회권 / 주 2회권 단일 회차** + **포인트 옵션** (Pro 인증 멘토). 전면 개편 필요.

## 2. 정책서 락된 사항

### 멤버십 구조 (2B)
- **주 1회권** (월 4회) / **주 2회권** (월 8회) — 단일 회차 (Pro/일반 구분 ❌, default 일반)
- **포인트** 별도 충전 — Pro 인증 멘토 예약 시 회당 차감
- **약정**: 1개월 0% / 3개월 -5% / 6개월 -10% / 12개월 -15%
- 무제한·티어 분리·토큰 ❌

### 보상 (2B)
- Pro 인증 예약 → 본사 사정으로 일반 멘토 변경 → **1회권 발급**

### 정책 (2D)
- 환불: 미사용 회차 정상가 환산 100% 환불 (약정 차액 차감)
- 회원 노쇼: 회차 1회 차감
- 본사·멘토 노쇼: 회차 +1 보상
- 변경/취소: 48h 전 무료 / 48h-6h 당일 예약권 / 6h 이내 차감
- 일시정지: 사유 ❌ 자유, 약정 30% 이내, 자동 연장
- 양도 ❌
- 청약철회: 결제 후 7일 이내 미사용 = 100% 환불

### 페르소나 (1A) — 메인 멤버십 매칭
- 메인 페르소나 = 주 2회 운동러 → **주 2회권 = 메인 SKU**

## 3. 현재 코드 vs 새 시스템

| 영역 | 현재 (MVP) | 새 시스템 |
|---|---|---|
| 티어 | basic / standard / premium | 주 1회권 / 주 2회권 |
| 회차 종류 | space_credits + pt_credits (분리) | 단일 credits (월 4 or 8) + points (Pro용) |
| Premium 차별 | pt_credits 많음 | ❌ 폐기 (Pro는 포인트 옵션) |
| 약정 | 모델 없음 | 1/3/6/12개월 단계 할인 |
| 일시정지 | 모델 없음 | 자유 신청, 약정 30% 한도, 자동 연장 |
| 환불 | 모델 없음 | 미사용 회차 정상가 환산 100% |
| 자동결제 | 모델 없음 | default ON |
| 보상권 | 모델 없음 | 1회권 (Pro→일반 변경 시) + 당일 예약권 (48h-6h 취소) |

## 4. 회원 시나리오

### 4.1 가입 (`/register`)

**단계**:
1. 이메일·휴대폰·비밀번호
2. 기본 페르소나 (운동 경험·주 운동 횟수·목표) — 매칭 정확도 ↑
3. (선택) 첫 체험 1만원 결제 → 1세션 체험

**현재 코드**: `RegisterPage.tsx` 단순 양식. 페르소나 입력 단계 추가 필요.

### 4.2 멤버십 가입 (`/membership/new`)

| 단계 | 화면 |
|---|---|
| 1. 멤버십 선택 | 주 1회권 vs 주 2회권 카드 (가격·회수 표시) |
| 2. 약정 선택 | 슬라이더 1·3·6·12개월 + 할인율 동적 표시 |
| 3. 결제 정보 | 카드 등록 (자동결제 default ON) + 약관 동의 |
| 4. 첫 결제 | PG 호출 → 성공 시 멤버십 활성화 |

### 4.3 일상 사용 (`/membership`)

- 회차 잔량 + 만료일 + 자동결제 상태
- 약정 진행률 (예: "12개월 약정 중 3개월차")
- 일시정지 버튼 (조건 충족 시)
- 결제 내역

### 4.4 갱신 흐름

- D-7일: 푸시 + 인앱 알림
- D-3일: 두번째 알림 + 업그레이드 인센티브 ("주 1 → 주 2 + 첫 달 10% 할인")
- D-1일: 자동결제 시도
- D+0: 성공 → 다음 약정 기간 시작
- D+0 실패: 7일 grace + 재시도 → 14일 후 자동 해지

### 4.5 일시정지

- 마이페이지 → "일시정지 신청" → 사유 입력 (옵션) → 시작·종료일 선택
- 한도: 약정 기간의 30% (예: 12개월 약정 = 최대 3.6개월 = 108일)
- 정지 중 = 회차 사용 ❌, 자동결제 stop, 만료일 자동 연장
- 재개: 회원이 직접 또는 자동 (지정 종료일)

### 4.6 환불 (중도 해지)

| 단계 | 액션 |
|---|---|
| 신청 | 마이페이지 → "해지 신청" + 사유 서베이 |
| 산출 | 사용 회차 = 정상가 적용 / 미사용 회차 = 약정 할인가 환산 환불 |
| 미리보기 | "현재 환불 가능액: ₩XX,XXX" 표시 |
| 확정 | 약관 동의 + 계좌 입력 (또는 카드 환불) |
| 처리 | 본사 영업일 3일 이내 |

### 4.7 포인트 충전 (`/points`)

- 충전 단위: 5만 / 10만 / 20만 (3 옵션, 보너스 다를 수 있음)
- 결제 PG 호출
- 잔액 표시
- Pro 인증 멘토 예약 시 자동 차감
- 환불: 미사용 = 100%, 약정 할인 보너스 분 ❌

### 4.8 포인트 잔액 부족 흐름 (Pro 매칭 시)

회원이 Pro 인증 멘토 선택 → 포인트 잔액 < 차감액 발생:

```
[부족 알림 모달]
  현재 잔액: 5,000원
  필요: 10,000원
  부족: 5,000원

  [충전하기]  [일반 멘토로 변경]

[충전하기 클릭]
  → 포인트 충전 모듈 즉시 표시 (inline modal 또는 풀화면)
  → 5/10/20만 선택 → PG 결제
  → 결제 완료 시 자동으로 예약 흐름 복귀
  → Pro 매칭 진행 + 포인트 차감 + 예약 확정

[일반 멘토 변경 클릭]
  → fallback (일반 멘토 풀에서 재매칭)
```

### 4.9 자동결제 (자동 갱신) toggle

- 마이페이지 멤버십 카드에 명시적 toggle (`autoRenew` Boolean)
- ON (default): 만료일 자동 결제
- OFF: 만료 시 자동 해지 안내
- 변경 시 즉시 적용 (다음 결제부터)
- 7일 전 알림 시 변경 가능

## 5. 화면별 요구사항

### 5.1 멤버십 가입 화면

**컴포넌트**: `MembershipSelectPage` (신규)

```
┌─────────────────────────────────────┐
│  주 1회권          │  주 2회권 ⭐    │
│  월 4회            │  월 8회         │
│  ₩XX,XXX/월        │  ₩XX,XXX/월     │
│  일반 멘토         │  일반 멘토       │
│  [선택]            │  [선택]          │
└─────────────────────────────────────┘

약정 기간 선택
[1개월] [3개월 -5%] [6개월 -10%] [12개월 -15%]

총 결제: ₩XX,XXX (10개월 약정 = 일시불 ₩XX,XXX)
[다음]
```

### 5.2 마이페이지 멤버십 카드

**컴포넌트**: `MembershipBadge` (개편)

```
┌──────────────────────────────────┐
│ 주 2회권 · 12개월 약정 (3개월차)  │
│                                  │
│ 남은 회차: 6 / 8                 │
│ 다음 갱신: 2026-06-13            │
│ 자동결제: ON 🔄                  │
│                                  │
│ [회차 사용 내역] [일시정지]      │
└──────────────────────────────────┘

📍 포인트 잔액: 35,000원
[충전하기]
```

### 5.3 환불 화면

**컴포넌트**: `RefundPage` (신규)

```
환불 신청
─────────────────────
사용 회차: 2 / 8
미사용 회차: 6

환불 산출:
  미사용 6회 × 정상가 ₩XX,XXX = ₩XX,XXX
  - 약정 할인 차액 ₩XX,XXX (사용 회차분)
  = 최종 환불 ₩XX,XXX

[환불 신청]
```

### 5.4 일시정지 화면

```
일시정지 신청
─────────────────────
현재 약정: 12개월 (3개월차)
이전 일시정지 누적: 0일
가능 한도: 최대 108일 (30%)

기간 선택:
  시작: [2026-05-15]
  종료: [2026-06-15] (총 31일)

사유 (선택): [부상·해외출장·기타]

[신청] — 정지 중엔 회차 사용 불가
```

### 5.5 결제 내역

**컴포넌트**: `PaymentHistoryPage` (신규)

- 멤버십 결제 / 포인트 결제 / 환불 / 보상권 (당일 예약권·1회권) 통합
- 필터: 종류·기간

## 6. 데이터 모델 (회원 측)

```typescript
type MembershipType = 'week1' | 'week2'
type ContractMonths = 1 | 3 | 6 | 12
type PaymentStatus = 'pending' | 'paid' | 'failed' | 'refunded'

interface Membership {
  id: string
  memberId: string
  type: MembershipType
  creditsRemaining: number  // week1=4 기준, week2=8 기준
  contractMonths: ContractMonths
  discountRate: number  // 0, 5, 10, 15
  pricePerMonth: number  // 정상가
  startedAt: string
  expiresAt: string  // 일시정지로 자동 연장
  pausedAt?: string  // 정지 중
  pauseUsedDays: number  // 누적
  autoRenew: boolean
  status: 'active' | 'paused' | 'expired' | 'cancelled'
}

interface PointBalance {
  memberId: string
  balance: number
  lastChargedAt?: string
}

interface Payment {
  id: string
  memberId: string
  type: 'membership' | 'point' | 'trial'
  amount: number
  status: PaymentStatus
  pgTransactionId: string
  paidAt: string
  refundedAt?: string
  description: string  // "주 2회권 12개월 약정 첫 결제"
}

interface Refund {
  id: string
  paymentId: string
  usedCredits: number
  refundAmount: number
  fee: number  // 위약금 (현재 0, 정책 따라)
  reason: string
  processedAt?: string
}

interface DayPass {  // 48h-6h 취소 시 받음
  id: string
  memberId: string
  issuedAt: string
  expiresAt: string  // 당일 23:59
  used: boolean
}

interface BonusCredit {  // 1회권 보상
  id: string
  memberId: string
  reason: 'pro_mentor_swap'  // Pro 예약 → 일반 변경
  expiresAt: string  // 30일 가설
  used: boolean
}
```

## 7. API 통신

### 7.1 새 엔드포인트

```
POST   /api/memberships              가입 + 첫 결제
GET    /api/memberships/me            현재 멤버십
POST   /api/memberships/me/pause      일시정지
POST   /api/memberships/me/resume     재개
POST   /api/memberships/me/cancel     중도 해지 (환불 산출)
GET    /api/memberships/me/refund-preview  환불액 미리보기

POST   /api/points/charge             포인트 충전
POST   /api/points/refund             미사용 포인트 환불

GET    /api/payments                  결제 내역
GET    /api/day-passes                보유 당일 예약권
GET    /api/bonus-credits             보유 보상권
```

### 7.2 응답 예시 (`/memberships/me`)

```json
{
  "id": "mem_xxx",
  "type": "week2",
  "creditsRemaining": 6,
  "contractMonths": 12,
  "discountRate": 15,
  "pricePerMonth": 240000,
  "startedAt": "2026-02-13",
  "expiresAt": "2027-02-13",
  "autoRenew": true,
  "status": "active",
  "pauseInfo": {
    "usedDays": 0,
    "maxDays": 108
  },
  "pointBalance": 35000,
  "dayPassesActive": 1,
  "bonusCreditsActive": 0
}
```

## 8. 엣지 케이스

| 케이스 | 처리 |
|---|---|
| 자동결제 카드 거절 | retry 3회 (24h 간격) → 알림 → 7일 grace 후 자동 해지 |
| 일시정지 한도 초과 신청 | 화면에서 차단 (시작·종료일 선택 시 검증) |
| 약정 만료 직전 일시정지 신청 | 약정 자동 연장 (만료일 = 원래 만료 + 정지 일수) |
| 청약철회 (7일 이내) 시 회차 사용 | 사용 회차 정상가 차감 후 환불 |
| 회원이 첫 결제 직후 카드 변경 | 새 카드 등록 → 다음 결제부터 적용 |
| Pro 인증 멘토 매칭 후 일반 변경 (본사 측) | 자동으로 1회권 보상 발급 + 푸시 알림 |
| 6h 이내 취소 후 회차 부족 | 패널티 적용 (회차 - 1, 최소 0). 다음 갱신부터 정상화 |
| 포인트 결제 시 잔액 부족 | 회차로 fallback (일반 멘토로 자동 매칭) |
| 양도 요청 (지원·문의) | 정책상 ❌ — 안내 메시지 |

## 9. 측정 지표

| 지표 | 목표 |
|---|---|
| 가입 → 첫 결제 전환율 | ≥ 60% |
| 약정 평균 기간 | ≥ 6개월 |
| 자동 갱신 성공률 | ≥ 95% |
| 환불 발생률 | ≤ 10% |
| 일시정지 사용률 | 20-40% (정상 범위) |
| 포인트 충전 비율 (멤버십 중) | ≥ 30% (Pro 인증 활용 신호) |

## 10. 구현 작업 분해

### 10.1 신규 페이지

- [ ] `src/pages/MembershipSelectPage.tsx` — 가입 시 멤버십·약정 선택
- [ ] `src/pages/RefundPage.tsx` — 해지·환불
- [ ] `src/pages/PausePage.tsx` — 일시정지
- [ ] `src/pages/PaymentHistoryPage.tsx` — 결제 내역
- [ ] `src/pages/PointsPage.tsx` — 포인트 충전

### 10.2 기존 페이지 개편

- [ ] `src/pages/MembershipPage.tsx` — 신규 카드 디자인 (회차·약정·자동결제·잔액)
- [ ] `src/pages/RegisterPage.tsx` — 페르소나 입력 단계 추가

### 10.3 컴포넌트

- [ ] `src/components/MembershipCard.tsx` (신규) — 멤버십 카드 + 회차 진행 바
- [ ] `src/components/ContractSlider.tsx` — 약정 슬라이더
- [ ] `src/components/PaymentForm.tsx` — PG 연동 (토스페이먼츠/포트원)
- [ ] `src/components/RefundPreview.tsx` — 환불액 실시간 계산

### 10.4 스토어 / 서비스

- [ ] `src/store/useMembershipStore.ts` (분리)
- [ ] `src/services/payment.ts` — PG 호출 wrapper
- [ ] `src/services/membership.ts` — 가입·정지·환불

### 10.5 타입

- [ ] `packages/api-types/src/membership.ts` — 위 정의 통합

---

| 2026-05-13 | 초안 |
| 2026-05-13 | 정책서 6개 cross-ref + 현재 코드 vs 새 모델 + 7 시나리오 + 5 화면 + 데이터 모델 상세화 |
