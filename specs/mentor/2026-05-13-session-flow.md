---
title: 2026-05-13 세션 진행 (멘토 흐름)
parent: 💪 멘토
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 💪 세션 진행 (멘토 흐름)

**Status**: Draft · **Layer**: 💪 멘토 · **Updated**: 2026-05-13
**관련 결정**: [3A 강사 페르소나](../../partners/personas.html) · [3E 운영 모델](../../partners/model.html) · [4A 세션 종류](../../service/session-types.html) · [4B 세션 포맷](../../service/session.html) · [4C AI 역할](../../service/ai-role.html) · [3G 정산](../../partners/payout.html)
**📡 API**: [세션](../../api/catalog.html#세션-session) · [멘토](../../api/catalog.html#멘토-mentor) · [AI](../../api/catalog.html#ai)
**🗄️ Data**: [3. Schedule](../data/03-schedule.html) · [4. Reservation](../data/04-reservation.html) · [5. Records](../data/05-records.html) · [6. AI](../data/06-ai.html)
**현재 코드**: `apps/partner/src/pages/session-detail-page.tsx`, `dashboard-page.tsx`

## 1. 배경

멘토 = **1시간에 2 회원 cover** (방 A 30분 → 방 B 30분 stagger). 기존 강사 앱은 60분 단일 세션 모델. 30분 단위 stagger 운영 + AI 가이드 협력 + Pro 인증 단가 자율 + 5분 내 기록 입력 등 전면 개편.

## 2. 정책서 락된 사항

### 강사 페르소나 (3A) — 파트타임 잡 모델
- 배달기사처럼, 원할 때 슬롯 오픈, 원하는 만큼 일함
- 자격증 보유자 누구나 (Pro 인증) + 자격증 없는 일반 멘토
- 영업·CS·정산 부담 ❌ (본사 처리)

### 강사 운영 모델 (3E) — Hybrid
- 프리랜서 계약 (직고용 ❌)
- 본사가 마케팅·예약·결제·CS·세금 전부 대행
- 슬롯 자유 오픈 + 의무 슬롯 (Phase 1 코어 12명)

### 세션 구조 (4B + 4D + 5A)
- 회원 1세션 = 90분 (카디오 30분 + 방 60분)
- 방 60분 중 **멘토 30분 1:1** + 자율 30분 (AI 가이드)
- 30분 stagger: 정각 시작 4방 + 30분 시작 4방
- 멘토 1시간 = 방 A (T~T+30) + 이동 (T+30~T+35) + 방 B (T+35~T+60)

### AI 역할 (4C)
- AI가 회원 세션 운동 설계
- 멘토는 그 가이드 + 본사 프로그램에 따라 코칭 (설계 ❌)
- 본사가 강사 교육 프로그램 제공

### 정산 (3G)
- 일반 멘토: 회당 X원 고정 (회원 1명 30분 = 1회)
- Pro 인증: 회당 자율 단가 (본사 min~max)
- 격주 입금

## 3. 현재 코드 vs 새 시스템

| 영역 | 현재 (`apps/partner`) | 새 시스템 |
|---|---|---|
| 세션 단위 | 60분 1 회원/방 | 30분 1:1 × 2 방 (1시간에 2 회원) |
| 슬롯 모델 | TimeSlot (60분, 자유) | MentorBlock (30분 단위, stagger) |
| 멘토 라벨 | coach (general) | verified / pro_certified |
| 단가 | 고정 (settlement에서 계산) | 일반 고정 + Pro 자율 |
| AI 가이드 | ❌ 없음 | 세션 전 회원 추천 운동 노출 |
| 세션 기록 | 564줄 페이지 (입력 무겁) | 5분 내 입력 UX 재설계 |
| 인계 메모 | next_plan 텍스트 | next_plan + AI 학습용 |
| 본사 프로그램 | ❌ 없음 | Exercise Library + Phase 가이드 |

## 4. 멘토 시나리오 (1시간 = 2 회원 cover)

### 4.1 슬롯 오픈 (D-N일 전)

```
캘린더 (4주 보기) → 30분 단위 그리드 (요일 × 시간)
  - 회색 = 미선택
  - 흰색 = 가능 (open 등록 가능)
  - 클릭 → open으로 토글
  - 파랑 = 예약 잡힘 (회원 매칭됨)
```

저장 후 = 자동 매칭 큐에 진입.

### 4.2 매칭 알림 (회원 예약 시 받음)

```
📩 푸시:
"5/15 (화) 19:30 방 A에 회원 X 매칭됨"
[회원 프로필 보기]  [확인]
```

마이페이지 일정에 자동 추가.

### 4.3 세션 당일 (T-15분 ~ T+90)

| 시각 | 멘토 액션 | 시스템 |
|---|---|---|
| T-30분 | 푸시: "30분 후 방 A 진입 (회원 X)" | 알림 |
| T-15분 | 푸시 + 회원 프로필 미리보기 화면 | 회원 이력·인계 메모·오늘 추천 |
| T~T+25 | (멘토 대기 시간 — 다른 일정 가능) | 회원은 카디오존에서 운동 |
| T+25 | "방 A 회원이 자율 운동 시작" 알림 | 회원 = 방 A 자율 30분 시작 |
| T+30 | (다음 1시간 슬롯 시작) | |
| T+30~T+60 | 방 A에서 회원 X 30분 1:1 | 운동 가이드·체크리스트 |
| T+60~T+65 | 방 B로 이동·체크 | |
| T+65~T+90 | 방 B에서 회원 Y 30분 1:1 | |
| T+90 | 두 세션 모두 기록 입력 (10분 내) | 5분 내 입력 UX |

→ 결과: 1시간(60분) 동안 2 회원 = 정산 2회 회수.

### 4.4 세션 기록 입력 (T+90 이후)

- 운동·세트·중량·rep (대부분 AI가 default 채움, 멘토 보정)
- 폼 이슈 (1-2줄)
- 다음 세션 인수인계 (3-5줄, AI에 학습됨)
- 회원 컨디션 메모 (선택)

### 4.5 멘토 노쇼·지각 처리

| 케이스 | 결과 |
|---|---|
| T+10분 미도착 | 알림 → 운영 매니저 통보 |
| T+15분 미도착 (노쇼) | 회원에게 회차 +1 보상, 멘토 등급 패널티 + 정산 차감 |
| 6h 전 본인 취소 | 패널티 ❌ |
| 6h 이내 본인 취소 | 회원 회차 +1 보상, 멘토 등급 패널티 |

## 5. 화면 요구사항

### 5.1 슬롯 캘린더 (`/schedule`)

**컴포넌트**: `schedule-page.tsx` (개편)

```
2026년 5월
────────────────────────────────
        월   화   수   목   금   토   일
06:00  [ ] [ ] [ ] [ ] [ ] [ ] [ ]
06:30  [ ] [ ] [ ] [ ] [ ] [ ] [ ]
...
19:00  [✓] [✓] [✓] [ ] [ ] [ ] [ ]  ← 예약 잡힘 (파랑)
19:30  [✓] [○] [✓] [ ] [ ] [ ] [ ]  ← ○ = 매칭 대기 (회색)
20:00  [○] [○] [○] [ ] [ ] [ ] [ ]
...

범례: [ ] 미선택 · [○] open (매칭 대기) · [✓] 매칭됨
```

- 클릭 = 토글 (미선택 ↔ open)
- 48h 이내 변경 = 운영 매니저 승인 필요
- 6h 이내 = 패널티 경고

### 5.2 오늘 일정 (`/`)

**컴포넌트**: `dashboard-page.tsx` (개편)

```
오늘 일정 — 2026-05-15 (화)
────────────────────────
19:30  방 A · 회원 김OO (재예약 4회차)
20:00  방 B · 회원 이OO (첫 세션)
21:00  방 A · 회원 박OO
21:30  방 B · 회원 정OO

이번 격주 누적: 12 세션 · 예상 정산 240,000원

[일정 보기]  [슬롯 변경]
```

### 5.3 세션 진입 화면 (T-15분 자동 진입)

**컴포넌트**: `session-pre-page.tsx` (신규)

```
T-15분 알림 → 클릭

회원 김OO (32세, 4회차)
────────────────────────────
🎯 오늘 목표 (AI 추천)
  • 자율 30분: 데드 4×65kg (지난번 60kg 성공)
  • 멘토 30분: 스쿼트 4×55kg, 런지 3×30kg

📋 직전 세션 인계 (5/8 박멘토)
  "코어 약함, 데드 시 허리 보호 신경.
   다음에 플랭크 보강 추천."

📊 회원 컨디션 (사전 입력)
  수면: 7h, 통증: 없음, 에너지: 보통

[운동 라이브러리]  [세션 시작]
```

### 5.4 세션 진행 중 (T+30 입장 시)

**컴포넌트**: `session-active-page.tsx` (신규)

```
회원 김OO · 방 A · 19:30
─────────────────────────
[남은 시간: 28:00]

오늘 진행 운동:
  ✓ 스쿼트
    1세트: 50kg × 8 [완료]
    2세트: 55kg × 8 [완료]
    3세트: 55kg × 7 (1회 모자람)
    4세트: ___ [입력]

  □ 런지 (3세트 × 10)
  □ 사이드 플랭크 (3세트 × 30초)

[다음 운동]  [메모 추가]
```

세트마다 빠른 입력 (숫자만, 5초 이내).

### 5.5 세션 기록 입력 (T+90 이후)

**컴포넌트**: `session-detail-page.tsx` (재설계 — 5분 내)

```
세션 완료 - 회원 김OO (5/15 19:30)
────────────────────────────────

1️⃣ 운동 기록 (대부분 자동 채워짐)
   ✏️ 수정만 필요 — [편집]

2️⃣ 폼 이슈 (1-2줄)
   [_____ 데드 시 허리 약간 굽음. 무게 ↓ 후 자세 잡고 ↑ 추천]

3️⃣ 다음 세션 인계 (3-5줄, AI 학습) ⭐
   [_____ 데드 폼 안정 시 67.5kg 시도 가능.
          하체 보강 (런지 ↑) 추천.
          코어 약점 - 플랭크 시작.]

4️⃣ 컨디션 메모 (선택)
   [_____]

[다음 회원으로]  [기록 저장]
```

UX 목표: **3 필드 5분 내 입력**.

### 5.6 정산 화면 (`/earnings`)

**컴포넌트**: `earnings-page.tsx` (개편 — [정산 PRD](./2026-05-13-payout.html) 참고)

```
이번 격주 (5/1 - 5/14)
──────────────────────
누적 세션: 24 회
예상 정산: 480,000원

기본 정산 (24회 × 20,000) = 480,000
차감 항목: 0

다음 입금: 5/16 (금)

[명세서 다운로드]
```

## 6. 데이터 모델 (멘토 측)

```typescript
type MentorTier = 'verified' | 'pro_certified'
type MentorBlockStatus = 'open' | 'assigned' | 'completed' | 'cancelled'

interface MentorBlock {
  id: string
  mentorId: string
  startAt: string  // 30분 단위 (정각 또는 30분)
  status: MentorBlockStatus
  assignedSessionId?: string
  assignedAt?: string
}

interface MentorSchedule {
  mentorId: string
  blocks: MentorBlock[]
  weeklyRecurrence?: {  // 매주 반복 슬롯 (옵션)
    weekday: number
    hour: number
    minute: 0 | 30
  }[]
}

interface SessionRecord {
  id: string
  sessionId: string
  mentorId: string
  performedAt: string
  exercises: ExercisePerformed[]
  formNotes: string  // 1-2줄
  handoverNotes: string  // 3-5줄 — AI 학습용
  memberCondition?: string
  enteredAt: string  // 입력 시각 (5분 내 SLA 측정)
  totalVolumeKg?: number  // 자동 계산
}

interface ExercisePerformed {
  name: string
  sets: ExerciseSet[]
  note?: string
}

interface ExerciseSet {
  weight?: number
  reps: number
  completed: boolean
  modifiedBy?: 'mentor' | 'ai'  // 누가 입력했는지
}

interface MentorTodaySchedule {
  date: string
  sessions: {
    sessionId: string
    memberId: string
    memberName: string
    memberRebookCount: number  // 재예약 N회차
    startAt: string
    roomNumber: number
    aiRecommendation: AIRecommendation
    memberCondition?: string
  }[]
  estimatedEarning: number
}
```

## 7. API 통신

### 7.1 새 엔드포인트

```
GET    /api/mentors/me/schedule?from=YYYY-MM-DD&to=YYYY-MM-DD
       Response: MentorSchedule

POST   /api/mentors/me/blocks
       Body: { startAt }
       Response: MentorBlock

DELETE /api/mentors/me/blocks/:id  // 슬롯 닫기
       Response: { cancellationFee?: number, penalty?: 'tier_warning' }

GET    /api/mentors/me/today
       Response: MentorTodaySchedule

GET    /api/sessions/:id/pre-info  // 세션 직전 회원 정보
       Response: {
         memberId, memberName, rebookCount,
         aiRecommendation,
         lastHandoverNotes: [{date, mentor, text}],
         memberCondition
       }

POST   /api/sessions/:id/record
       Body: { exercises, formNotes, handoverNotes, memberCondition? }
       Response: { sessionRecord, aiUpdated: true }

GET    /api/mentors/me/exercise-library?category=lower|upper|core|cardio
       Response: { exercises: ExerciseTemplate[] }
```

## 8. 엣지 케이스

| 케이스 | 처리 |
|---|---|
| 멘토 지각 (T+10) | 자동 알림 (회원·운영) |
| 멘토 노쇼 (T+15 미도착) | 회원 회차 +1 보상, 멘토 등급 -1 + 정산 차감 |
| 6h 이내 본인 취소 | 회원 보상 + 멘토 패널티 |
| 6h 전 본인 취소 | 패널티 ❌. 회원에게 다른 멘토 자동 재매칭 |
| 동시 두 방 cover 어려움 (회원 1명 지각 등) | 운영 매니저 알림 → 1 회원 일정 조정 |
| 회원 노쇼 | 멘토는 정상 정산 (회원 회차만 차감) |
| 멘토가 회원 운동을 수정 (AI 추천 따르지 않음) | 시스템 기록 → AI 학습 신호 (다음 추천 보정) |
| 멘토가 본사 프로그램과 다른 운동 가르침 | 1차 = 가이드 알림 / 반복 = 등급 평가 영향 |
| 세션 기록 입력 24h 누락 | 알림 → 48h 후 자동 default 기록 (정산 영향 ↓) |

## 9. 측정 지표

| 지표 | 목표 |
|---|---|
| 멘토 정시 입장 비율 | ≥ 95% |
| 세션 기록 5분 내 입력 비율 | ≥ 80% |
| 24h 내 기록 입력 비율 | ≥ 99% |
| AI 추천 채택 비율 (멘토가 따라간 비율) | ≥ 70% |
| 멘토 슬롯 안정성 (취소율) | ≤ 5% |
| 6h 이내 취소 | ≤ 1% |

## 10. 구현 작업 분해

### 10.1 페이지 개편 (`apps/partner/`)

- [ ] `src/pages/schedule-page.tsx` — 30분 단위 그리드 + 48h/6h 룰
- [ ] `src/pages/dashboard-page.tsx` — 오늘 일정 + 예상 정산
- [ ] `src/pages/session-detail-page.tsx` — 5분 내 입력 UX (564줄 → 200줄 목표)
- [ ] `src/pages/session-pre-page.tsx` (신규) — 세션 전 회원 정보·AI 추천
- [ ] `src/pages/session-active-page.tsx` (신규) — 세션 진행 중 운동 체크
- [ ] `src/pages/earnings-page.tsx` — 정산 화면 ([별도 PRD](./2026-05-13-payout.html))

### 10.2 컴포넌트

- [ ] `src/components/SlotGrid.tsx` — 30분 단위 캘린더
- [ ] `src/components/SessionPreCard.tsx` — 회원 정보 + AI 추천 + 인계
- [ ] `src/components/ExerciseSetInput.tsx` — 빠른 세트 입력 (5초 이내)
- [ ] `src/components/HandoverNoteEditor.tsx` — AI 학습 안내 + 3-5줄 입력

### 10.3 서비스 / 스토어

- [ ] `src/services/schedule.ts` — 슬롯 CRUD
- [ ] `src/services/session.ts` — 세션 기록 저장
- [ ] `src/store/usePartnerStore.ts` — 일정·세션·정산 상태

### 10.4 타입

- [ ] `packages/api-types/src/mentor.ts` — MentorBlock, MentorSchedule
- [ ] `packages/api-types/src/session-record.ts` — 위 정의

---

| 2026-05-13 | 초안 |
| 2026-05-13 | 정책서 6개 cross-ref + 현재 코드 vs 새 모델 + 5 시나리오 + 6 화면 + API·작업 분해 상세화 |
