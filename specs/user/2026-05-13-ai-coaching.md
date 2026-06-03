---
title: 2026-05-13 AI 가이드 (회원)
parent: 👤 유저
grand_parent: 스펙 (PRD)
nav_order: 4
---

# 👤 AI 시스템 PT (회원 흐름)

{: .warning }
> **PT 레일 (보류)** — 이 스펙은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

> **GX 레일에서 보류**: 본 AI 가이드(세션 기록 누적 → 1:1 운동 시퀀스 추천, Phase 진행, 강사 인계 메모)는 1:1 PT 자산이다. GX 레일에서는 그룹 클래스 출석 이력 기반 AI가 별도 설계되며, 개인별 1:1 추천 AI는 PT 레일 재개 시 재사용한다.

**Status**: Draft · **Layer**: 👤 유저 · **Updated**: 2026-05-13
**관련 결정**: [4C AI 역할](../../service/ai-role.html) · [1B 문제의식](../../product/problems.html) · [1D VP](../../product/value-prop.html) · [4A 세션 종류](../../service/session-types.html) · [4B 세션 포맷](../../service/session.html)
**📡 API**: [AI](../../api/catalog.html#ai)
**🗄️ Data**: [6. AI](../data/06-ai.html) · [5. Records](../data/05-records.html)
**현재 코드**: `apps/mvp/src/services/ai-coach.ts`, `pages/CoachPage.tsx`, `components/AIAnalysisCard.tsx`, `components/AIRecommendationCard.tsx`

## 1. 배경

AI = **"시스템 PT"**. 세션 기록 누적 → 다음 운동 자동 제안. 회원 입장의 핵심 차별점.

**기존 MVP는 mock 추천 + 단순 AI 채팅**. 실제 Claude API 연동·데이터 기반 학습 없음. 전면 교체 필요.

## 2. 정책서 락된 사항

### AI 역할 ✅ Scope (4C)
- 세션 기록 보관
- 다음 운동 제안 (이전 기록 기반)
- 강사 인수인계 (이력 그대로 전달)
- 본사 프로그램 가이드 + 운동 라이브러리 제공
- 세션 후 자동 요약

### AI ❌ Out of Scope
- 매일/매주 챙기는 AI 코치 ❌
- 24h 챗봇 / 일상 트래킹 ❌
- 영양·습관 풀 서포트 ❌
- 실시간 폼 교정 (인간 영역) ❌

### "시스템 PT" 핵심 매커니즘
> 회원 모든 세션 기록을 서비스가 보관 → 누적 기록 기반으로 다음 운동 제안 → 강사·Peer 리더는 그 제안 + 본사 프로그램 가이드를 활용해 코칭

### 1D Value Prop
> "AI 기반 체계화된 운동을, private room에서 1:1 멘토와 받는 개인 맞춤 세션"

## 3. 현재 코드 vs 새 시스템

| 영역 | 현재 (MVP) | 새 시스템 |
|---|---|---|
| `ai-coach.ts` | mock recommendDetailedSession() | 실제 Claude API 호출 (서버 사이드) |
| `CoachPage.tsx` | 일반 채팅 UI | ❌ 폐기 (일상 챗봇 ❌) → 운동 이력·다음 추천 페이지로 대체 |
| `AIAnalysisCard` | mock 분석 텍스트 | 실 운동 데이터 기반 분석 |
| `AIRecommendationCard` | mock 추천 | 직전 세션 기반 다음 운동 카드 |
| 데이터 기반 학습 | ❌ 없음 | 회원 누적 기록 + 강사 인수인계 → 입력 |
| Phase 진행 | ❌ 없음 | 근비대 / 다이어트 등 Phase·주차 표시 |

## 4. 회원이 보는 AI 터치포인트

### 4.1 세션 전 — 예약 직후

예약 확정 시: "이번 세션에 할 운동" 미리보기.
화면: `TodayHeroCard` 또는 `ReservationDetail`.

```
2026-05-15 (화) 19:00
김멘토 (Pro 인증)

🤖 오늘 추천 운동 (미리보기)
  • 카디오 25분 — 인터벌 러닝 (심박 130-150)
  • 자율 30분 — 데드리프트 4세트 65kg × 5
  • 멘토 30분 — 스쿼트 + 런지 보강

지난 세션 대비 데드 5kg 증량 시도.
```

### 4.2 세션 중 — 카디오 25분

화면: `CardioCountdown` + `AICardioGuide`.

```
[카운트다운: 25:00]

🏃 인터벌 러닝
─────────────────
  0-5분    웜업 (가벼운 조깅)
  5-15분   인터벌 (1분 빠르게 / 1분 천천히 × 5)
  15-22분  지속주 (심박 130-150)
  22-25분  쿨다운

심박 추천: 130-150 BPM
(스마트워치 연동 시 실시간 표시)
```

### 4.3 세션 중 — 방 자율 30분

화면: `RoomGuideCarousel` (가로 스와이프 카드).

```
운동 시퀀스 (자율 30분, 총 4개)

[Card 1/4]
─────────────────
데드리프트 (워밍업)
1세트 × 40kg × 10회
휴식 1분
[폼 영상 ▶ 5초]

[Card 2/4]
─────────────────
데드리프트 (본세트) ⭐
4세트 × 65kg × 5회
세트 간 휴식 2분
[폼 영상 ▶]

직전 세션: 60kg × 5회 성공
오늘: 5kg 증량 시도

[Card 3/4]
─────────────────
백 익스텐션
3세트 × 15회
보조 운동
...
```

회원이 운동 완료 후 체크 (간단 자가 입력).

### 4.4 세션 중 — 멘토 입장 알림

T+55 → "5분 후 김멘토 입장"
T+60 → 멘토 입장 화면 (자율 가이드 사라짐)

### 4.5 세션 종료 직후

화면: `SessionEndPage`.

```
🎉 세션 완료

오늘의 운동:
  데드리프트  4×65kg×5  ✅ +5kg 증량
  스쿼트      4×55kg×8  (멘토 진행)
  런지        3×30kg×10

총 볼륨: 4,820kg (지난 세션 4,200kg)

멘토 피드백 (요약):
  "데드 폼 안정적. 무게 더 올려도 OK.
   다음 주 67.5kg 도전 가능."

🤖 다음 세션 추천 (5/22 화 19:00)
  • 데드 67.5kg 시도
  • 스쿼트 60kg 증량
  • 상체 보강 일정 분리

[다음 예약하기]  [평가 5점]
```

### 4.6 운동 이력 (마이페이지)

화면: `ProgressPage` (개편) — 기존 코드 활용 + AI 분석 강화.

#### A. Phase 진행 카드

```
🏋️ 현재 단계
─────────────────
근비대 Phase 2 / 4
4주차 진행 중 (총 6주)

다음 단계: Phase 3 (중량 ↑)
─────────────────
[자세히]
```

#### B. 주별 운동량 그래프

```
주별 운동량 (kg × reps 총합)
─────────────────
W-3: ████████ 3,200
W-2: ██████████ 4,100
W-1: ███████████ 4,400
W-0: ███████████████ 4,820 ⬆

추세: 상승 (좋은 progression)
```

#### C. 주요 운동 중량 추이

```
데드리프트 중량 (월별)
─────────────────
3월: 50kg
4월: 55kg
5월: 60kg → 65kg ⬆

다음 목표: 67.5kg (5/22)
```

#### D. 강사 인계 메모 (요약)

```
최근 인계 메모 (최근 3세션)
─────────────────
김멘토 (5/13): 데드 폼 안정. 무게 ↑
박멘토 (5/06): 코어 약함, 플랭크 추가 권장
김멘토 (4/29): 스쿼트 깊이 좋음
```

## 5. 화면 요구사항

### 5.1 세션 전 (예약 후) — 추천 미리보기

**위치**: `TodayHeroCard` (홈) + `ReservationDetail` (예약 카드 클릭)

- 다음 예약 정보 + AI 추천 1줄 요약
- 클릭 시 상세 운동 시퀀스

### 5.2 세션 중 — 카디오 가이드

**컴포넌트**: `CardioCountdown` + `AICardioPlan`

- 25분 카운트다운 (큰 글씨)
- AI 추천 강도·인터벌·심박
- 5분 휴식 자동 전환

### 5.3 세션 중 — 방 자율 가이드

**컴포넌트**: `RoomGuideCarousel`

- 운동 카드 슬라이드 (가로 스와이프)
- 각 카드: 종목·세트·중량·rep·폼 영상
- 직전 세션 비교 ("60kg → 65kg")
- 운동 완료 체크 (간단)

### 5.4 세션 종료 — 자동 요약

**컴포넌트**: `SessionSummaryCard`

- 오늘 수행 운동 표 + 총 볼륨
- 멘토 피드백 핵심 3줄 (AI 추출)
- 다음 세션 추천 카드
- 5점 평가 → "다음 예약하기" CTA

### 5.5 운동 이력 — Phase·진행 분석

**페이지**: `ProgressPage` (대대적 개편)

기존:
- 일반 차트만

신규:
- Phase 진행 카드 (`PhaseProgressCard`)
- 주별 운동량 그래프 (`WeeklyVolumeChart`)
- 운동별 중량 추이 (`ExerciseProgressionChart`)
- 강사 인계 메모 요약 (`HandoverNotesSummary`)
- AI 월간 분석 (`AIMonthlyAnalysis`) — AI가 종합 코멘트

## 6. 데이터 모델 (회원 측 노출)

```typescript
interface AIRecommendation {
  id: string
  memberId: string
  forSessionAt: string  // 이 세션을 위한 추천
  generatedAt: string
  plan: {
    cardio: {
      type: '러닝' | '바이크' | '로잉'
      durationMin: 25
      intensity: string  // "심박 130-150"
      intervals?: { phase: string; durationSec: number }[]
    }
    roomAutonomous30Min: ExerciseSet[]
    mentor30Min: ExerciseSet[]  // 멘토에게 추천하는 부분
  }
  rationale: string  // "지난 세션 60kg → 65kg 시도"
  sourceSessionIds: string[]  // 학습에 쓴 직전 세션 IDs
}

interface ExerciseSet {
  name: string  // "데드리프트"
  sets: number
  weight?: number
  reps: number
  restSec: number
  category: 'warmup' | 'main' | 'accessory'
  formVideoUrl?: string
  rationale?: string  // "직전 60kg 성공, 5kg 증량"
}

interface Phase {
  memberId: string
  name: 'hypertrophy' | 'strength' | 'fatloss' | 'recovery' | 'custom'
  label: string  // "근비대"
  stage: 1 | 2 | 3 | 4
  weekInStage: number
  weeksTotal: number
  startedAt: string
  nextStageAt: string  // 자동 산출
}

interface SessionRecord {  // 회원이 보는 요약
  id: string
  sessionId: string
  performedAt: string
  exercises: ExercisePerformed[]
  totalVolumeKg: number  // 자동 계산
  formNotes: string  // 멘토 입력
  trainerFeedback: string  // 멘토 입력 (3줄 핵심)
  nextPlan: string  // 멘토 입력 (다음 추천)
  userCondition?: { sleepHours?, painLevel?, energyLevel? }
}

interface ExercisePerformed {
  name: string
  sets: { weight?: number, reps: number, completed: boolean }[]
  note?: string  // 멘토 보강 메모
}

interface AIMonthlyAnalysis {
  memberId: string
  month: string  // "2026-05"
  summary: string  // 3-5문장 자연어
  highlights: string[]  // ["데드 5kg 증량 성공", "주 2회 안정적 출석"]
  nextGoal: string  // "데드 70kg 도전"
  generatedAt: string
}
```

## 7. API 통신

### 7.1 새 엔드포인트

```
GET    /api/ai/recommendation?sessionId=xxx
       Response: AIRecommendation

GET    /api/ai/recommendation/next  // 다음 세션 (특정 시점)
       Response: AIRecommendation | null  // 아직 안 잡혀있으면 null

GET    /api/members/me/phase
       Response: Phase

GET    /api/members/me/progress?period=week|month
       Response: {
         weeklyVolume: { week: string, totalKg: number }[],
         exerciseProgression: { exerciseName: string, points: { date, weight }[] }[]
       }

GET    /api/members/me/handover-notes?limit=3
       Response: { notes: { sessionId, mentorName, date, text }[] }

GET    /api/ai/monthly-analysis?month=2026-05
       Response: AIMonthlyAnalysis
```

### 7.2 응답 예시

```json
// GET /api/ai/recommendation?sessionId=ses_xxx
{
  "id": "rec_yyy",
  "memberId": "mem_zzz",
  "forSessionAt": "2026-05-15T19:00:00+09:00",
  "plan": {
    "cardio": {
      "type": "러닝",
      "durationMin": 25,
      "intensity": "심박 130-150",
      "intervals": [
        { "phase": "warmup", "durationSec": 300 },
        { "phase": "interval_high", "durationSec": 60 },
        { "phase": "interval_low", "durationSec": 60 },
        // ...
      ]
    },
    "roomAutonomous30Min": [
      { "name": "데드 워밍업", "sets": 1, "weight": 40, "reps": 10, "category": "warmup" },
      {
        "name": "데드리프트 본세트",
        "sets": 4, "weight": 65, "reps": 5,
        "category": "main",
        "rationale": "직전 60kg × 5 성공"
      }
    ],
    "mentor30Min": [
      { "name": "스쿼트", "sets": 4, "weight": 55, "reps": 8, "category": "main" },
      { "name": "런지", "sets": 3, "weight": 30, "reps": 10, "category": "accessory" }
    ]
  },
  "rationale": "지난 세션 60kg 데드 5×5 성공. 5kg 증량 시도. 멘토 인계: '하체 폼 안정, 무게 ↑ OK'.",
  "sourceSessionIds": ["ses_101", "ses_105", "ses_109"]
}
```

## 8. 엣지 케이스

| 케이스 | 처리 |
|---|---|
| 신규 회원 (이력 0) | 본사 표준 프로그램 N=0 단계로 시작 (Phase 1 입문) |
| AI 추천 운동이 어려움 | 멘토가 강도 조절 (멘토 화면에서) → AI 학습 보정 |
| 운동 부상 시 | AI 추천 보류 + 멘토 인계 메모 "회복 운동" → AI 가중치 ↓ |
| 회원이 추천 운동을 안 함 (자율 30분 다른 거 함) | 멘토 화면에 표시 → AI 학습 신호 (다음에 다른 추천) |
| Phase 진행 정체 (중량 안 늘어남) | AI가 보강 운동 추천 또는 휴식 추천 |
| AI 추천 생성 timeout | 룰 기반 fallback (직전 세션 + Phase 진행 규칙) |
| 회원 컨디션 입력 "통증 있음" | 강도 ↓ 추천 + 멘토 알림 |

## 9. 측정 지표

| 지표 | 목표 |
|---|---|
| AI 추천 채택률 (회원이 따라간 비율) | ≥ 70% |
| 추천 만족도 ("도움 됨" 평가) | ≥ 4.0 / 5 |
| 운동 이력 페이지 진입율 (월간) | ≥ 50% |
| Phase 진행률 (3개월 누적) | ≥ 80% 회원이 Phase 1+ 진입 |
| 강사 인계 메모 활용 (다음 세션에 반영된 비율) | ≥ 60% |

## 10. 구현 작업 분해

### 10.1 페이지 개편

- [ ] `src/pages/ProgressPage.tsx` — Phase 카드 + 운동량 그래프 + 인계 메모 + AI 분석 통합
- [ ] `src/pages/SessionEndPage.tsx` (신규) — 세션 종료 자동 요약
- [ ] `src/pages/CoachPage.tsx` — **폐기** (일상 챗봇 ❌)
  - 또는 "운동 이력" 페이지로 redirect

### 10.2 컴포넌트

- [ ] `src/components/AICardioPlan.tsx` (신규) — 카디오 인터벌 시각화
- [ ] `src/components/RoomGuideCarousel.tsx` (신규) — 운동 카드 슬라이드
- [ ] `src/components/PhaseProgressCard.tsx` (신규)
- [ ] `src/components/WeeklyVolumeChart.tsx` (개편) — 기존 ProgressChart 활용
- [ ] `src/components/ExerciseProgressionChart.tsx` (신규)
- [ ] `src/components/HandoverNotesSummary.tsx` (신규)
- [ ] `src/components/AIMonthlyAnalysis.tsx` (개편) — 기존 AIAnalysisCard 활용
- [ ] `src/components/SessionSummaryCard.tsx` (신규) — 세션 종료 요약

### 10.3 서비스

- [ ] `src/services/ai-coach.ts` — mock 제거 + 실 API 연동
  - `getRecommendation(sessionId)`
  - `getNextRecommendation()`
  - `getMonthlyAnalysis(month)`
- [ ] `src/services/progress.ts` (신규)
  - `getPhase()`
  - `getProgress(period)`
  - `getHandoverNotes(limit)`

### 10.4 스토어

- [ ] `src/store/useAIStore.ts` (신규) — AI 추천·분석 상태

### 10.5 타입

- [ ] `packages/api-types/src/ai.ts` — AIRecommendation 확장 (위 정의)
- [ ] `packages/api-types/src/phase.ts` (신규)

---

| 2026-05-13 | 초안 |
| 2026-05-13 | 정책서 5개 cross-ref + 현재 코드 비교 + 5 터치포인트 + 5 화면 + 데이터 모델·API 상세화 |
