---
title: 2026-05-13 예약 시스템 (회원)
parent: 👤 유저
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 👤 예약 시스템 (회원 흐름)

**Status**: Draft (v1) — v2 재설계 대기 · **Layer**: 👤 유저 · **Updated**: 2026-05-13
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html) · [5A 예약](../../operations/reservation.html) · [2D 정책](../../members/policies.html) · [2B 멤버십](../../members/membership.html) · [4A 세션 종류](../../service/session-types.html) · [4B 세션 포맷](../../service/session.html)
**📡 API**: [예약](../../api/catalog.html#예약-reservation)
**🗄️ Data**: [3. Schedule](../data/03-schedule.html) · [4. Reservation](../data/04-reservation.html) · [10. Audit](../data/10-audit.html)
**현재 코드**: `apps/mvp/src/pages/BookingFlowPage.tsx`

{: .warning }
> **v2 변경 ([ADR 0001](../../decisions/0001-consumer-pivot.html))**: 예약 대상 = **강사 + 프로그램** (룸은 자동 배정). 단위 = **30분 unit** (60분 = 2 unit 연속). 카디오 슬롯·90분 세트 모델은 폐기. 본문은 v1 기준이며 화면 재설계 시 v2로 갱신 필요.

## 1. 배경

회원이 멘토·시간·공간을 예약하는 핵심 화면. 기존 MVP는 단순 시간·강사·방 매핑. 새 모델은 **카디오 슬롯 + 방 슬롯 묶음** + **고정 슬롯** + **이전 멘토 우선 매칭** + **자동/수동 매칭 모드** + **24h 거절권**.

## 2. 정책서 락된 사항

### 예약 단위 (4B + 5A)
- 회원 1예약 = **카디오 30분 슬롯 + 방 60분 슬롯 연속 세트**
- 모든 공간 예약제 (워크인 ❌)

### 피크 6-10pm 고정 슬롯제 (5A)
- 회원: 매주 같은 요일·시간 고정 슬롯
- 멘토: 고정 ❌ (자유 슬롯 오픈)
- 일반 예약 ❌ — 고정 회원이 취소한 자리만 풀림

### 고정권 회원 핵심 권리 (5A)
- 자기 고정 슬롯에서 **이전 멘토를 이어서 받을 권리** 보장 (다른 회원 가로채기 ❌)
- 멘토가 해당 슬롯 안 오픈하면 → AI가 다른 멘토 매칭

### 매칭 모드 (5A)
- **수동 (default)**: AI 3명 추천 → 회원 선택
- **자동 매칭 ON**: AI 자동 매칭 → 회원 24h 이내 거절 가능 (거절 시 재매칭)

### 변경/취소 룰 (2D, 오프라인 기준)
- 48h 전: 무료 (회차 미차감)
- 48h-6h 전: 회차 차감 + 당일 예약권 1매 발급
- 6h 이내: 회차 100% 차감 (= 노쇼)

### 예약 가능 기간 (5A)
- 모든 회원 14일 전부터
- 고정 슬롯은 자동 갱신 (별도 액션 ❌)

### Pro 인증 멘토 선택 (2B + 4A)
- 회원이 Pro 인증 멘토 예약 시 포인트 차감
- 포인트 잔액 부족 시: 일반 멘토로 fallback

## 3. 현재 코드 vs 새 시스템

| 영역 | 현재 (MVP `BookingFlowPage`) | 새 시스템 |
|---|---|---|
| 예약 단위 | room 단일 + start/end time | cardio_slot + room_slot 묶음 |
| 멘토 선택 | trainer 자유 선택 (mode=smart_session) | AI 추천 3명 (수동) 또는 자동 |
| 고정 슬롯 | 모델 없음 | 매주 자동 갱신 |
| 매칭 거절 | 모델 없음 | 24h 거절권 |
| Pro 인증 | 멘토에 badge만 | 등급 분리 + 포인트 차감 |
| 이전 멘토 우선 | 모델 없음 | 자동 우선 매칭 |
| 변경/취소 룰 | 단순 취소 only | 48h/6h 차등 + 당일 예약권 |
| 14일 캘린더 | UI 있음 | 동일 (피크/비피크 구분 추가) |

## 4. 회원 시나리오

### 4.1 신규 예약 (비피크 시간)

```
시간 선택 → 멘토 매칭 → 확인 → 완료
```

상세:
1. `/booking` 진입 → 14일 캘린더 (피크 6-10pm = 회색 처리, 비피크 = 선택 가능)
2. 시간 슬롯 선택 (30분 단위 stagger)
3. 멘토 매칭 화면 (수동 / 자동 모드 따라 분기)
4. 회원 확인 후 회차 차감 미리보기 → 확정

### 4.2 신규 예약 (피크 시간)

피크 6-10pm = 고정 슬롯 회원만 자동 예약. 일반 회원은 예약 ❌.
**예외**: 고정 회원이 취소한 자리는 풀림 → 다른 회원도 예약 가능 (당일·임박 위주).

### 4.3 고정 슬롯 설정

신규 회원이 멤버십 가입 시:
1. 마이페이지 → "고정 슬롯 신청"
2. 매주 원하는 요일·시간 선택 (6-10pm 범위)
3. 첫 멘토 매칭 (AI 추천 3명 → 선택 또는 자동)
4. 매주 자동 예약 + 멘토 연속성 (이전 멘토 우선)

변경: 월 1회 가능 (가설). 변경 시 새 시간 + 새 멘토 매칭.

### 4.4 매칭 거절 (자동 매칭 모드)

자동 매칭 후 24h 내:
- 마이페이지 알림: "○○ 멘토와 매칭됨" + [거절] 버튼
- 거절 → 다른 멘토 자동 재매칭 → 다시 알림
- 무제한 거절 가능 (Phase 1)

### 4.5 변경

- 마이페이지 예약 → "변경" → 다른 시간 슬롯 선택
- 멘토 자동 재매칭 (가능 시)
- 48h 전 = 무료 / 48h-6h 전 = 회차 차감 + 당일 예약권 / 6h 이내 = 차감

### 4.6 취소

- 마이페이지 예약 → "취소" → 사유 확인 (선택)
- 시간대 따라 회차 처리 알림 (명확히 표시)
- 6h 이내는 강한 경고 ("이 시간 취소는 회차 1회 차감입니다. 계속?")

### 4.7 당일 예약권 사용

- 48h-6h 취소 후 발급 (당일 23:59 만료)
- 마이페이지 → "당일 예약권 사용" → 14일 이내 빈 슬롯 중 선택
- 회차 미차감

### 4.8 노쇼 (회원이 안 옴)

- T+15분 미체크인 = 자동 노쇼 처리
- 회차 1 차감 + 마이페이지 알림 ("오늘 세션 노쇼로 회차 1회 차감")

## 5. 화면별 요구사항

### 5.1 예약 진입 (`/booking`)

```
[홈 화면 CTA] → 예약 페이지

────────────────
"이번 주 예약하기"
14일 캘린더 그리드
  - 오늘 ~ +14일
  - 각 날짜 = 가능 슬롯 수 표시
  - 피크 시간 (6-10pm) = 회색·자물쇠 (고정 회원만)
────────────────
[고정 슬롯 회원] "내 고정 슬롯 보기"
```

### 5.2 시간 슬롯 선택

선택한 날짜 클릭 시:
```
2026-05-15 (화)
─────────────────
오전
  06:00 [4 자리 남음]
  06:30 [3 자리]
  ...
점심
  12:00 [6 자리]
  ...
저녁 (피크) 🔒
  18:00 [고정 회원 전용]
  18:30 [고정 회원 전용]
  19:00 [고정 회원 전용]
  19:30 [고정 회원 전용]
밤
  22:00 [5 자리]
  22:30 [4 자리]
```

### 5.3 멘토 매칭 (수동 모드)

```
"이 시간에 가능한 멘토 3명"

┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ [이전 멘토] ⭐  │  │                  │  │  [Pro 인증] 🏆  │
│  김멘토          │  │  박멘토           │  │  이멘토          │
│  ★4.7 (124)     │  │  ★4.5 (89)       │  │  ★4.8 (200)     │
│  근력·체형 전문  │  │  유산소·다이어트  │  │  재활·자세 교정  │
│  [선택]          │  │  [선택]           │  │  +5,000 포인트   │
└─────────────────┘  └─────────────────┘  └─────────────────┘

[자동 매칭 모드로 전환]
```

### 5.4 멘토 매칭 (자동 모드)

```
🤖 자동 매칭 모드

가장 적합한 멘토를 자동으로 매칭합니다.
매칭 후 24시간 내 거절 가능.

[확인 - 매칭 시작]
[수동 모드로 전환]
```

매칭 결과:
```
✅ 매칭 완료
김멘토 (★4.7, 근력·체형 전문)
이전에 함께 했던 멘토예요.

[확인] [거절·재매칭]
```

### 5.5 예약 확인

```
예약 확인
─────────────────
2026-05-15 (화) 19:00 - 20:30 (90분)

세션:
  19:00 - 19:30  카디오존 #3 (25분 + 휴식 5분)
  19:30 - 20:30  ○○방 #5 (자율 30분 + 멘토 30분)

멘토: 김멘토 (Pro 인증 🏆)
차감: 회차 1회 + 포인트 5,000원
잔여: 회차 5/8, 포인트 30,000원

변경/취소: 48h 전 무료 · 48h-6h 당일 예약권 · 6h 이내 차감

[확정]
```

### 5.6 마이페이지 예약 리스트 (`/reservations`)

각 예약 카드:
```
┌────────────────────────────────────┐
│ 2026-05-15 (화) 19:00              │
│ 김멘토 (Pro 인증) · ○○방 #5         │
│ ──────────────────                 │
│ [변경]  [취소]                      │
│ 48h 전 무료 / 6h 이내 차감          │
└────────────────────────────────────┘
```

### 5.7 고정 슬롯 관리 (`/fixed-slot`)

```
나의 고정 슬롯
─────────────────
매주 화요일 19:00
이전 멘토: 김멘토 (이번주도 우선 매칭)

지난 4주 매칭 이력:
  4/22 김멘토 ✓
  4/29 김멘토 ✓
  5/06 박멘토 (김 슬롯 안 오픈)
  5/13 김멘토 ✓

[고정 슬롯 변경] (월 1회 가능)
```

### 5.8 당일 예약권 사용 화면

```
당일 예약권 1매 (오늘 23:59 만료)

오늘 빈 슬롯:
  14:00 카디오 #2 + 방 #3 (멘토 미정)
  14:30 카디오 #5 + 방 #1
  15:30 카디오 #4 + 방 #7
  ...

[예약]
```

## 6. 데이터 모델

```typescript
interface Reservation {
  id: string
  memberId: string
  sessionId: string
  storeId: string
  // 시간·공간
  startAt: string  // 카디오 시작 (T)
  cardioSlotId: string  // T~T+30
  roomSlotId: string    // T+30~T+90
  // 멘토
  mentorId: string | null  // 자동 매칭 대기 시 null
  mentorTier: 'verified' | 'pro_certified'
  matchingMode: 'manual' | 'auto'
  autoMatchedAt?: string  // 24h 거절 카운트다운 기준
  pointsCharged?: number
  // 상태
  status: 'confirmed' | 'rejected' | 'cancelled' | 'no-show' | 'completed'
  fixedSlot: boolean  // 고정 슬롯 자동 예약 여부
  // 메타
  createdAt: string
  cancelledAt?: string
  cancelReason?: string
}

interface FixedSlot {
  id: string
  memberId: string
  weekday: 0 | 1 | 2 | 3 | 4 | 5 | 6
  hour: number  // 18, 19, 20, 21 (피크)
  minute: 0 | 30
  active: boolean
  lastMentorId?: string  // 이전 멘토 (우선 매칭)
  createdAt: string
}

interface DayPass {
  id: string
  memberId: string
  issuedAt: string
  expiresAt: string  // 당일 23:59
  reason: 'late_cancel_48_to_6'
  used: boolean
  usedReservationId?: string
}

interface MentorMatch {  // 매칭 후보
  mentorId: string
  name: string
  avatarUrl: string
  tier: 'verified' | 'pro_certified'
  rating: number
  reviewCount: number
  specialties: string[]
  bio: string
  previousMatchCount: number  // 이 회원과 진행 이력
  pricePoints?: number  // Pro 시 차감 포인트
  matchScore: number  // AI 점수 (내부, UI 노출 ❌)
}
```

## 7. API 통신

### 7.1 새 엔드포인트

```
GET    /api/slots/available?date=YYYY-MM-DD&isPeak=false
       Response: { timeSlots: [{ startAt, availableCount, isPeak }] }

POST   /api/reservations/match-candidates
       Body: { startAt, useProPoint?: boolean }
       Response: { candidates: MentorMatch[] }  // 3명, 이전 멘토 상단

POST   /api/reservations
       Body: { startAt, mentorId?, matchingMode, useProPoint? }
       Response: { reservation, cardioSeat, roomNumber }

POST   /api/reservations/:id/reject  // 자동 매칭 후 24h 거절
       Response: { newMentor: MentorMatch }  // 재매칭 결과

PATCH  /api/reservations/:id  // 변경
       Body: { newStartAt }
       Response: { reservation, refundedCredits, dayPassIssued? }

DELETE /api/reservations/:id  // 취소
       Response: { creditCharge, dayPassIssued? }

POST   /api/fixed-slots
       Body: { weekday, hour, minute }
       Response: { fixedSlot, firstMentor }

PATCH  /api/fixed-slots/:id  // 변경 (월 1회)
       Body: { weekday, hour, minute }
       Response: { fixedSlot, lastChangedAt }

POST   /api/day-passes/:id/use
       Body: { reservationId }
       Response: { reservation }
```

### 7.2 응답 예시

```json
// POST /api/reservations/match-candidates
{
  "startAt": "2026-05-15T19:00:00+09:00",
  "candidates": [
    {
      "mentorId": "mnt_kim",
      "name": "김멘토",
      "tier": "verified",
      "rating": 4.7,
      "reviewCount": 124,
      "specialties": ["근력", "체형"],
      "bio": "...",
      "previousMatchCount": 4,  // 이전 멘토 = 상단
      "matchScore": 0.95
    },
    {
      "mentorId": "mnt_park",
      "name": "박멘토",
      "tier": "verified",
      "rating": 4.5,
      "specialties": ["유산소"],
      "previousMatchCount": 0,
      "matchScore": 0.82
    },
    {
      "mentorId": "mnt_lee",
      "name": "이멘토",
      "tier": "pro_certified",
      "rating": 4.8,
      "specialties": ["재활"],
      "pricePoints": 5000,  // Pro = 포인트 차감
      "previousMatchCount": 0,
      "matchScore": 0.88
    }
  ]
}
```

## 8. 엣지 케이스

| 케이스 | 처리 |
|---|---|
| 모든 멘토 슬롯 마감 | "이 시간 매칭 불가" + 대기 큐 등록 옵션 |
| 자동 매칭 모드 + 멘토 풀 0명 | 즉시 거절 알림 + 수동 모드 전환 권유 |
| 이전 멘토가 다음 주 슬롯 안 오픈 | AI가 다른 멘토 자동 매칭 + 회원 알림 |
| 24h 거절 후 또 거절 (반복) | 무제한 가능. 단 5회+ 거절 시 수동 모드 전환 안내 |
| Pro 인증 매칭됐는데 본사 사정 일반 변경 | 자동 1회권 보상 + 알림 |
| 변경 시 새 시간에 멘토 풀 0 | 매칭 대기 큐 등록 (지점 매니저 개입 가능) |
| 6h 이내 취소 + 회차 0 | 멤버십 만료된 경우 = 환불 안 되는 패널티 부과 |
| 고정 슬롯 회원이 자기 슬롯 취소 | 그 자리 = 일반 예약 풀에 풀림 (당일·임박) |
| 고정 슬롯 자동 매칭 실패 (해당 주) | 회원 알림 + 수동 시간 변경 권유 |
| Pro 인증 멘토 선택 시 포인트 부족 | **포인트 충전 모듈 즉시 표시** → 충전 후 예약 흐름 자동 이어짐. 충전 취소 시 일반 멘토로 fallback |
| 회원 자동 매칭 ON, Pro 멘토 매칭됐으나 포인트 부족 | 일반 멘토로 자동 fallback + 알림 (충전 권유 인앱) |

## 9. 측정 지표

| 지표 | 목표 |
|---|---|
| 매칭 성공률 | ≥ 95% |
| 자동 매칭 거절률 | ≤ 15% |
| 고정 슬롯 회원 유지율 | ≥ 85% |
| 이전 멘토 매칭 성공률 (고정 슬롯) | ≥ 80% |
| 변경/취소 비율 (이상치 탐지) | < 20% (예약 대비) |
| 당일 예약권 사용률 | 50-80% (발급된 것 대비) |

## 10. 구현 작업 분해

### 10.1 페이지 개편 (`apps/mvp/`)

- [ ] `src/pages/BookingFlowPage.tsx` — 4단계로 재작성 (시간·매칭·확인·완료)
- [ ] `src/pages/ReservationsListPage.tsx` (신규) — 예약 리스트
- [ ] `src/pages/FixedSlotPage.tsx` (신규) — 고정 슬롯 관리

### 10.2 컴포넌트 신설

- [ ] `src/components/CalendarGrid.tsx` — 14일 캘린더 + 피크 처리
- [ ] `src/components/TimeSlotList.tsx` — 시간 슬롯 선택
- [ ] `src/components/MentorMatchCard.tsx` — 멘토 카드 (이전 멘토 표시·Pro 배지)
- [ ] `src/components/AutoMatchConfirm.tsx` — 자동 매칭 확인·거절
- [ ] `src/components/CancelConfirmModal.tsx` — 48h/6h 룰 명시 모달
- [ ] `src/components/DayPassList.tsx` — 보유 당일 예약권 표시·사용

### 10.3 서비스 / 스토어

- [ ] `src/services/reservation.ts` — match-candidates·create·reject·patch·delete
- [ ] `src/store/useReservationStore.ts` — 예약 상태 관리

### 10.4 타입

- [ ] `packages/api-types/src/reservation.ts` — 위 정의
- [ ] `packages/api-types/src/slot.ts` — Cardio/Room slot

### 10.5 데이터 마이그레이션

- [ ] 기존 `bookings` → `reservations` 변환 (room_id → roomSlotId, mode=smart_session → mentor 매칭)
- [ ] 기존 회원 = 고정 슬롯 ❌로 시작 (전부 ad-hoc)
- [ ] 멘토 = 모두 `verified`로 시작, 추후 Pro 신청 가능

---

| 2026-05-13 | 초안 |
| 2026-05-13 | 정책서 5개 cross-ref + 현재 코드 vs 새 모델 + 8 시나리오 + 8 화면 + API 6개 상세화 |
