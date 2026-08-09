---
title: 2026-05-13 세션 진행 (회원 흐름)
parent: 👤 유저
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 👤 세션 진행 (회원 흐름)

**Status**: Draft (v1) — v2 재설계 대기 · **Layer**: 👤 유저 · **Updated**: 2026-05-13
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [4A 세션 종류](../../service/session-types.html) · [4B 세션 포맷](../../service/session.html) · [4C AI 역할](../../service/ai-role.html) · [4D 공간](../../service/space.html) · [2A 회원 여정](../../members/journey.html) · [2D 정책](../../members/policies.html)
**📡 API**: [예약](../api/catalog.html#예약-reservation) · [세션](../api/catalog.html#세션-session) · [AI](../api/catalog.html#ai) · [알림](../api/catalog.html#알림-notifications)
**🗄️ Data**: [3. Schedule](../data/03-schedule.html) · [4. Reservation](../data/04-reservation.html) · [5. Records](../data/05-records.html) · [6. AI](../data/06-ai.html) · [10. Audit](../data/10-audit.html)
**현재 코드**: `apps/mvp/src/pages/SessionDetailPage.tsx`, `BookingFlowPage.tsx`

{: .warning }
> **v2 변경 ([ADR 0001](../../decisions/0001-consumer-pivot.html))**: 세션 단위 = **30분 unit** (60분 = 2 unit 연속). "카디오 30 + 방 60 = 90분 세트" 및 stagger 운영은 v1 폐기. 본문은 v1 기준이며 회원 앱 재설계 시 v2로 갱신 필요.

## 1. 배경

회원 1세션 = **90분 세트**. 카디오존(공용)과 방(private) 둘 다 예약 단위. 멘토는 방 안에서 30분만 1:1, 나머지 30분은 AI 가이드 자율 운동. 멘토가 1시간에 2 회원 cover하기 위한 시간대 stagger 운영.

**현재 코드는 옛 Smart Session 모델 (강사 단일 60분)** — 90분 세트로 전면 개편 필요.

## 2. 정책서에서 가져온 락된 사항

### 세션 포맷 (4B)
- 회원 예약 단위 = **카디오 30분 슬롯 + 방 60분 슬롯 연속 세트**
- 카디오: 25분 운동 + 5분 휴식 (자리 단위 예약, 공용 공간)
- 방: 50분 멘토 + 10분 전환 (방 단위 예약)
- 모든 공간 예약제 (워크인 ❌)

### 방 슬롯 stagger 운영 (4D + 5A)
- 8방 중 4방 = 정각 시작 / 4방 = 30분 시작
- 멘토는 방 1에서 30분 → 방 2로 이동 30분 → 시간당 2 회원 cover

### 세션 종류 (4A)
- **단일 카테고리** "1:1 개인 맞춤 세션"
- 멘토 풀: 일반 멘토 / Pro 인증 멘토 2등급. 회원에게 등급 배지 노출.

### AI 역할 (4C) — 시스템 PT
- AI = **세션 기록 누적 + 다음 운동 자동 제안**
- ❌ 매일 챙김, 24h 챗봇, 영양·습관 풀 케어, 실시간 폼 교정

### 정책 (2D)
- 회원 노쇼 시 회차 1회 차감
- 본사·멘토 측 노쇼 시 회차 +1 보상
- 6h 이내 취소 = 노쇼

## 3. 현재 코드 vs 새 시스템

| 영역 | 현재 (MVP) | 새 시스템 |
|---|---|---|
| 세션 시간 | 60분 단일 (Smart Session) | 90분 세트 (카디오 30 + 방 60) |
| 예약 단위 | room_id 단일 | room_slot + cardio_slot 묶음 |
| 멘토 시간 | 60분 전체 (1회원/시간) | 30분 1:1 (2회원/시간) |
| 멘토 라벨 | coach (badge 자유) | 일반 / Pro 인증 2등급 |
| AI 가이드 | mock 추천 | 누적 데이터 기반 운동 시퀀스 |
| 세션 기록 | 강사 입력만 | AI 자동 요약 + 다음 추천 |

## 4. 회원 시나리오 (T = 세션 시작 시각)

### 4.1 예약 전 (D-14 ~ D-1일)

- 마이페이지 회차 잔량 확인
- 캘린더에서 시간 슬롯 선택 (피크 6-10pm = 고정 슬롯 회원만 / 비피크 = 자유)
- AI 추천 멘토 3명 노출 → 선택 (또는 자동 매칭 모드)
- 예약 확정 → 카디오 + 방 동시 점유

### 4.2 세션 당일 (T-1h ~ T+90)

| 시각 | 회원 액션 | 시스템 |
|---|---|---|
| T-1h | 푸시: "1시간 후 세션 시작" | 알림 1 |
| T-15분 | 푸시: "15분 후 카디오존 입장" | 알림 2 |
| T-5분 | 지점 도착 → 앱 QR 스캔 | 카디오 자리 번호 표시 |
| T~T+25 | 카디오존에서 25분 운동 | AI 가이드 (강도·심박) |
| T+25~T+30 | 5분 휴식 + 방 이동 | "○○방 입장하세요" 알림 |
| T+30~T+60 | 방 자율 운동 30분 | AI 운동 시퀀스 카드 |
| T+55 | "5분 후 멘토 입장" 안내 | 알림 |
| T+60~T+90 | 멘토와 1:1 코칭 30분 | 멘토 사진·이름·Pro 배지 |
| T+90 | 퇴장 + 세션 평가 (5점) | 다음 추천 미리보기 |

### 4.3 stagger 슬롯 패턴 (방 회전)

```
방 A (정각 시작):
  12:30~13:00 멘토 1:1
  13:00~13:10 전환·청소 (10분)
  13:10~13:30 자율 30분
  13:30~14:00 멘토 1:1

방 B (30분 시작):
  12:00~12:30 자율 30분
  12:30~13:00 멘토 1:1 (멘토 A가 옴)
  13:00~13:10 전환
  ...
```

## 5. 화면 요구사항

### 5.1 예약 화면 (`/booking`)

**컴포넌트**: `BookingFlowPage` (개편)

- **Step 1 — 시간 선택**: 14일 캘린더 + 시간 슬롯 (피크/비피크 색상)
- **Step 2 — 멘토 매칭**:
  - 수동 모드 (default): AI 추천 3명 카드
    - 사진 / 이름 / 평점 (★4.5) / Pro 인증 배지 / 1줄 소개
    - 이전 멘토 = 상단 + "이전에 함께 한 멘토" 표시
    - Pro 인증 선택 시: "포인트 N차감 안내" 노란 박스
  - 자동 모드: "AI가 자동 매칭. 24h 거절 가능" 안내
- **Step 3 — 확인·결제**: 회차 1 차감 / 포인트 N차감 미리보기 → 확정
- **Step 4 — 완료**: 캘린더 추가 옵션 + 푸시 알림 설정

### 5.2 세션 카드 (홈 `/`)

**컴포넌트**: `TodayHeroCard` (개편)

- 다음 예약: D-day + 시간 + 멘토 (Pro 배지)
- 오늘 추천 운동 미리보기 (AI 1줄 요약)
- "예약 확정" 후 자동 갱신

### 5.3 체크인 (`/check-in` 신규)

- QR 코드 스캐너 (또는 앱 자동 인식)
- 입장 성공 → 카디오 자리 번호 (예: "카디오 #3")
- 시간 카운트다운 (T+0)

### 5.4 카디오 가이드 (`/session/:id/cardio`)

- 25분 카운트다운
- 운동 종류 (러닝/바이크/로잉)
- AI 추천 강도 (예: "심박 130-150 유지")
- 5분 휴식 시작 알림 (T+25)
- "방으로 이동하세요" 안내 (T+30)

### 5.5 방 자율 가이드 (`/session/:id/room`)

- 방 번호·자리 표시
- AI 운동 시퀀스 카드 슬라이드 (가로 스와이프):
  - 종목명 / 세트 / 중량 / rep / 휴식 시간
  - 폼 영상 (5초)
  - 직전 세션 기록 비교 ("지난번 60kg → 오늘 65kg")
- 운동 완료 체크 (회원 자가 입력)
- "5분 후 멘토 입장" 알림 (T+55)

### 5.6 멘토 세션 (`/session/:id/mentor`)

- 멘토 입장 알림 + 멘토 정보 (사진·이름·배지·전문 분야)
- 진행 중 화면: 멘토가 입력하는 운동·세트 실시간 (선택)
- 30분 카운트다운

### 5.7 세션 종료 (`/session/:id/end`)

- 만족도 5점 평가 (별 + 자유 코멘트)
- 오늘의 운동 요약 (운동·세트·중량·총 무게)
- 멘토 피드백 핵심 3줄 (멘토가 입력한 내용)
- 다음 세션 추천 미리보기 (시간·운동·멘토)
- "다음 예약하기" CTA

### 5.8 세션 히스토리 (`/sessions`)

**컴포넌트**: `SessionDetailPage` (개편)

- 과거 세션 리스트 (날짜·멘토·운동 요약)
- 클릭 시 상세: 운동·세트·중량·멘토 피드백·인계 메모
- AI 자동 요약 카드 (이 시기 진행 상황)

## 6. 데이터 모델 (회원 측)

### 6.1 새 entities (`packages/api-types/`)

```typescript
type SessionStatus = 'booked' | 'checked-in' | 'in-progress' | 'completed' | 'no-show' | 'cancelled'
type MatchingMode = 'manual' | 'auto'
type MentorTier = 'verified' | 'pro_certified'

interface Reservation {
  id: string
  memberId: string
  sessionId: string
  mentorId: string | null  // 매칭 전엔 null (자동 매칭 대기)
  mentorTier: MentorTier
  roomSlotId: string
  cardioSlotId: string
  matchingMode: MatchingMode
  status: SessionStatus
  pointsCharged?: number   // Pro 인증 선택 시
  createdAt: string
  cancelledAt?: string
}

interface CardioSlot {
  id: string
  seatNumber: number  // 1~6
  startAt: string  // ISO
  storeId: string
}

interface RoomSlot {
  id: string
  roomNumber: number  // 1~8
  startAt: string  // ISO, 정각 또는 30분
  storeId: string
}

interface SessionRecordView {  // 회원이 보는 요약
  id: string
  sessionId: string
  performedAt: string
  exercises: Exercise[]
  formNotes: string
  trainerFeedback: string  // 핵심 3줄
  nextPlan: string         // 다음 세션 인계
  totalVolume?: number     // 자동 계산 (kg × reps)
}

interface Rating {
  id: string
  sessionId: string
  score: 1 | 2 | 3 | 4 | 5
  comment?: string
}
```

### 6.2 Zustand 스토어 변경

```typescript
// useAppStore 추가 필드
nextSessionRecommendation: AIRecommendation | null
checkInQrToken: string | null
cardioGuide: CardioGuide | null
roomGuide: RoomGuide | null

// 새 액션
checkInBySession(qrToken): Promise<{ cardioSeat, roomSlot, mentor }>
fetchAIRecommendation(sessionId): Promise<AIRecommendation>
submitRating(sessionId, score, comment): Promise<void>
```

## 7. API 통신

### 7.1 새로 필요한 엔드포인트

```
POST /api/check-in
  Body: { qrToken, sessionId }
  Response: { cardioSeatNumber, roomNumber, mentor, startAt }

GET /api/sessions/:id/ai-guide?phase=cardio|room
  Response: { duration, instructions, exercises[]}

GET /api/sessions/:id/next-recommendation
  Response: AIRecommendation

POST /api/sessions/:id/rating
  Body: { score, comment }
  Response: 200 OK

GET /api/sessions/:id/summary  (종료 후)
  Response: {
    exercises[], totalVolume,
    mentorFeedback, nextPlan, nextRecommendation
  }
```

### 7.2 변경되는 엔드포인트

```
POST /api/bookings → POST /api/reservations
  Body 변경:
    Old: { branchId, date, startTime, endTime, mode, trainerId? }
    New: { storeId, startAt, mentorId?, matchingMode, useProPoint?: boolean }

GET /api/bookings → GET /api/reservations
  Response 추가: cardioSlot, roomSlot, mentorTier, pointsCharged
```

## 8. 엣지 케이스

| 케이스 | 처리 |
|---|---|
| 회원 지각 (T+10분 이후 도착) | 카디오 단축 시작, 멘토 30분은 보장 (가능 시) |
| 회원이 카디오 거부 (이미 한 경우) | 방 입장 30분 늦게 (T+30 시작) — 카디오존 자리 풀림 |
| 멘토 노쇼 (T+15분 멘토 미도착) | 다른 멘토 자동 매칭 → 안 되면 회차 +1 보상 |
| 회원 자동 매칭 거절 (24h 내) | 다른 멘토 자동 매칭 (반복) |
| 6h 이내 취소 시도 | 회차 100% 차감 경고 → 확정 시 차감 |
| 48h-6h 취소 | 회차 차감 + 당일 예약권 자동 발급 (마이페이지에 표시) |
| 카디오 자리 부족 (6 자리 < 8방 동시) | stagger 운영으로 4명씩 → 회원에게 무관 |
| 세션 중 회원 부상 | 멘토가 즉시 종료 → 회차 보상 처리 |
| AI 추천 운동 너무 어려움 | 회원 보고 → 멘토가 강도 조절 → AI 학습 보정 |
| 회원 평가 누락 | T+90 후 24h 푸시 알림, 3회 무응답 시 자동 기본 점수 |

## 9. 측정 지표 (회원 측)

| 지표 | 목표 |
|---|---|
| 정시 체크인 비율 | ≥ 90% |
| 카디오 → 방 전환 누락률 | < 5% |
| 세션 만족도 평균 | ≥ 4.3 / 5 |
| AI 추천 채택률 (회원 따라간 비율) | ≥ 70% |
| 매칭 거절률 | ≤ 15% |
| 노쇼율 | ≤ 5% |
| 6h 이내 취소율 | ≤ 3% |

## 10. 구현 작업 분해

### 10.1 새 페이지 신설 (`apps/mvp/`)

- [ ] `src/pages/CheckInPage.tsx` — QR 스캐너 + 카디오 자리 표시
- [ ] `src/pages/SessionGuidePage.tsx` — 카디오/방 가이드 통합 (탭 또는 단계)
- [ ] `src/pages/SessionEndPage.tsx` — 평가·요약·다음 추천

### 10.2 페이지 개편

- [ ] `src/pages/BookingFlowPage.tsx` — 4단계로 재작성 (시간·멘토·확인·완료)
- [ ] `src/pages/SessionDetailPage.tsx` — AI 자동 요약 카드 추가, 90분 세트 표시
- [ ] `src/pages/HomePage.tsx`(`TodayHeroCard`) — 다음 예약 카드 + AI 추천 미리보기

### 10.3 컴포넌트 신설

- [ ] `src/components/MentorMatchCard.tsx` — 멘토 추천 카드 (Pro 배지·이전 멘토)
- [ ] `src/components/CardioCountdown.tsx` — 25분 카운트다운 + AI 강도
- [ ] `src/components/RoomGuideCarousel.tsx` — 운동 시퀀스 카드 슬라이드
- [ ] `src/components/RatingInput.tsx` — 5점 별 + 코멘트

### 10.4 스토어 / 서비스

- [ ] `src/store/useReservationStore.ts` (분리, 기존 useAppStore의 booking 부분 이관)
- [ ] `src/services/checkIn.ts`
- [ ] `src/services/ai-coach.ts` — recommendDetailedSession() 실제 API 연동
- [ ] `src/services/rating.ts`

### 10.5 타입 / 유틸

- [ ] `packages/api-types/src/reservation.ts`
- [ ] `packages/api-types/src/mentor.ts` (tier·matching)
- [ ] `packages/api-types/src/ai.ts` (AIRecommendation 확장)

### 10.6 마이그레이션

- [ ] 기존 `bookings` → `reservations` (DB는 [플랫폼 PRD](../platform/2026-05-13-session-system.html))
- [ ] 기존 회원 데이터 보존 + 새 schema로 변환

---

| 2026-05-13 | 초안 |
| 2026-05-13 | 정책서 7개 cross-ref + 현재 코드 vs 새 시스템 + 10 시나리오·화면·작업 분해 상세화 |
