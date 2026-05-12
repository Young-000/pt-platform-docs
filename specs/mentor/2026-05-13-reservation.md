---
title: 2026-05-13 슬롯 오픈·매칭 (멘토)
parent: 💪 멘토
grand_parent: 스펙 (PRD)
nav_order: 2
---

# 💪 슬롯 오픈·매칭 (멘토 흐름)

**Status**: Draft · **Layer**: 💪 멘토 · **Updated**: 2026-05-13
**관련 결정**: [3A 강사 페르소나](../../partners/personas.html) · [3E 운영 모델](../../partners/model.html) · [5A 예약](../../operations/reservation.html) · [3F 일반 멘토](../../partners/peer-leader.html)
**📡 API**: [멘토](../../api/catalog.html#멘토-mentor) · [예약](../../api/catalog.html#예약-reservation)
**🗄️ Data**: [3. Schedule](../../data/03-schedule.html) · [4. Reservation](../../data/04-reservation.html) · [8. Mentor System](../../data/08-mentor-system.html)
**현재 코드**: `apps/partner/src/pages/schedule-page.tsx`

## 1. 배경

멘토는 **30분 단위 슬롯**을 자유롭게 오픈. 회원 예약이 들어오면 자동 매칭 (이전 멘토 우선). 멘토 본인은 매칭에 직접 개입하지 않고 슬롯 ON/OFF만 관리.

기존 `schedule-page.tsx`는 60분 슬롯 + 자유 매칭 모델. **30분 단위·자동 매칭·48h/6h 변경 룰** 적용 필요.

## 2. 정책서 락된 사항

### 슬롯 모델 (5A + 3E)
- 멘토 = 30분 단위로 가능 시간 ON/OFF
- 1시간 = 2 슬롯 (방 A 30분 + 방 B 30분)
- 멘토는 **고정 슬롯 ❌** (회원이 고정, 멘토는 자유)
- 본인이 원할 때 슬롯 오픈/닫음 (배달기사형)

### 이전 멘토 우선 매칭 (5A)
- 회원의 고정 슬롯에 그 멘토 슬롯 오픈 시 → 자동 우선 매칭
- 다른 회원 가로채기 ❌

### 슬롯 변경/취소 룰 (3E + 2D)
- 48h 전: 무료 (멘토 패널티 ❌)
- 48h-6h 전: 멘토 등급 영향 ❌ (단, 잦으면 평가)
- 6h 이내 본인 취소: 회원 회차 +1 보상, 멘토 등급 패널티, 정산 차감

### Pro 인증 멘토 (4A + 3H)
- Pro 인증 = 자격증 + 본사 심사 통과
- Pro 인증 시 단가 자율 권한 (별도 PRD)
- 회원에게 "Pro 인증" 배지 노출

### 의무 슬롯 (Phase 1, 3E)
- Phase 1 (1-3호점): 본사 코어 12명 = 피크 시간 의무 슬롯 (주 N시간)
- Phase 2+: 점차 약화, 자율 ↑

## 3. 현재 코드 vs 새 시스템

| 영역 | 현재 (`schedule-page.tsx`) | 새 시스템 |
|---|---|---|
| 슬롯 단위 | 60분 (start_time + end_time) | 30분 (start_at만, 30분 고정) |
| 슬롯 모델 | TimeSlot | MentorBlock |
| 매칭 | 회원이 trainer 직접 선택 | AI 자동 매칭 (멘토는 수동 ❌) |
| 변경 룰 | 단순 삭제 | 48h/6h 차등 + 패널티 |
| 의무 슬롯 | 모델 없음 | Phase 1 = 주 N시간 의무 |
| 매칭 알림 | 없음 | 회원 매칭 시 푸시 |
| 회원 정보 미리보기 | 없음 | 매칭 시 회원 프로필·이력 노출 |

## 4. 멘토 시나리오

### 4.1 슬롯 오픈

```
캘린더 페이지 진입 → 4주 보기 → 30분 단위 그리드

[화] [10:00] [10:30] [11:00] [11:30] ... [19:00] [19:30] [20:00]
       ○      ○                                    ✓      ✓

○ = open (매칭 대기)
✓ = 매칭됨 (회원 이름 hover 표시)
공백 = 닫힘 (default)
```

클릭 = 토글:
- 닫힘 → open
- open → 닫힘 (48h 전 가능)
- 매칭됨 → 비활성 (운영 매니저만 변경)

### 4.2 매칭 알림

```
📩 푸시: "5/15 (화) 19:30 회원 김OO 매칭됨"
[회원 프로필 보기]  [확인]
```

- 회원 프로필: 이름, 나이, 운동 경력, 이전 진행 멘토 (재예약 N회차 표시)
- 직전 인계 메모 (다른 멘토 → 본인) 자동 노출

### 4.3 슬롯 변경 (멘토 본인 사정)

```
[슬롯 클릭: 5/15 19:30 - 매칭됨]
─────────────────
회원 김OO 매칭 중

[변경 신청]
  - 48h 전 = 자동 처리 (회원 알림 + 다른 멘토 매칭)
  - 48h-6h = 운영 매니저 검토 (잦으면 평가)
  - 6h 이내 = 회원 회차 +1 보상, 본인 등급·정산 패널티

사유: [_______]
[취소 신청]
```

### 4.4 의무 슬롯 (Phase 1 코어 멘토)

```
이번 주 의무 슬롯: 주 12시간 (피크 6-10pm 우선)
현재 등록: 14시간 ✅ (2시간 초과)
미달 시 = 코어 멘토 인센티브 ↓

월요일 19:00-22:00 (3h)
화요일 19:00-22:00 (3h)
수요일 19:00-21:00 (2h)
...
```

Phase 2+에서는 자율 (의무 ❌).

### 4.5 멘토가 매칭에 개입할 수 없는 사항

- 회원 선택 ❌ (AI가 알아서 매칭)
- 회원 거부 ❌ (등급 평가 영향)
- 단가 협상 ❌ (Pro 인증 시만 본사 한도 내 자율)

→ 슬롯만 열어두면 시스템이 회원·결제·정산 다 처리.

## 5. 화면 요구사항

### 5.1 슬롯 캘린더 (`/schedule`)

**컴포넌트**: `schedule-page.tsx` 재작성

```
2026년 5월 (4주 보기)
────────────────────────────────────────
        월   화   수   목   금   토   일
06:00  [ ] [ ] [ ] [ ] [ ] [ ] [ ]
06:30  [ ] [ ] [ ] [ ] [ ] [ ] [ ]
...
19:00  [✓] [✓] [✓] [ ] [ ] [ ] [ ]  ← ✓ 회원 매칭
19:30  [✓] [○] [✓] [ ] [ ] [ ] [ ]  ← ○ open, 매칭 대기
20:00  [○] [○] [○] [ ] [ ] [ ] [ ]
...

범례:
  공백 = 닫힘
  [○] = open (매칭 대기, 클릭 = 닫기)
  [✓] = 매칭됨 (회원 정보 표시)
  [🔒] = 변경 불가 (6h 이내 등)

[의무 슬롯 확인]  [반복 슬롯 일괄 설정]
```

### 5.2 반복 슬롯 일괄 설정

```
매주 반복 슬롯
────────────────────
[월] 19:00-22:00 (6 슬롯)
[화] 19:00-22:00 (6 슬롯)
[수] 19:00-21:00 (4 슬롯)

저장 시 다음 4주 자동 반복 등록.

[설정]
```

### 5.3 매칭된 슬롯 상세

```
2026-05-15 (화) 19:30 - 20:00
─────────────────
회원 김OO (32세)
재예약: 4회차 (이전 멘토 = 본인)

운동 경력: 6개월
주요 목표: 체형 개선·근력
컨디션 메모: 주 2회 운동 안정

📋 직전 인계 (5/8, 박멘토):
  "코어 약함, 데드 시 허리 보호 필요"

[세션 진입 (T-15분 알림)]  [변경 신청]
```

### 5.4 매칭 알림 화면

```
📩 새 매칭 (3건)
──────────────────
🆕 5/15 (화) 19:30 - 김OO (4회차, 본인 이전 멘토)
🆕 5/15 (화) 20:00 - 이OO (첫 매칭)
🆕 5/16 (수) 19:00 - 박OO (2회차)

[전체 확인]
```

### 5.5 변경 신청

```
슬롯 변경 신청
──────────────────
대상: 5/15 (화) 19:30 (회원 김OO)
현재까지 남은 시간: 48시간 ← 48h 전이면 자유

사유: 
  [📌 부득이한 사유]
  [📌 일정 변경]
  [📌 기타]
[_____ 상세]

자동 처리:
  - 48h 전 = 회원에게 알림 + 다른 멘토 자동 매칭
  - 본인 등급 영향 ❌

[신청]
```

6h 이내 = 패널티 경고:
```
⚠️ 6시간 이내 취소
- 회원 회차 +1 보상 발급
- 멘토 등급 -1 (Top → Pro)
- 이번 격주 정산 -1세션 차감

정말 진행하시겠습니까?
[취소 신청]  [뒤로]
```

## 6. 데이터 모델

```typescript
type MentorBlockStatus = 'open' | 'assigned' | 'completed' | 'cancelled'

interface MentorBlock {
  id: string
  mentorId: string
  startAt: string  // 30분 단위 (정각 또는 30분)
  status: MentorBlockStatus
  assignedSessionId?: string
  assignedAt?: string
  cancelledAt?: string
  cancellationReason?: string
  penaltyApplied?: boolean  // 6h 이내 취소 시 true
}

interface MentorRecurringSlot {  // 반복 슬롯 설정
  mentorId: string
  weekday: 0 | 1 | 2 | 3 | 4 | 5 | 6
  hour: number
  minute: 0 | 30
  active: boolean
}

interface MentorObligationStatus {  // Phase 1 의무 슬롯
  mentorId: string
  period: string  // 주 단위
  requiredHours: number  // 의무
  registeredHours: number  // 실제 등록
  status: 'meeting' | 'shortage' | 'exceeded'
}

interface MentorCancellation {
  id: string
  mentorId: string
  blockId: string
  cancelledAt: string
  cancelledAtRelativeToSession: 'before_48h' | '48h_to_6h' | 'within_6h'
  reason: string
  penaltyApplied: boolean
  memberCompensationCredits: number  // 회원에게 발급된 보상 회차
  payoutDeduction: number  // 정산 차감액
}

interface AssignedSessionPreview {
  sessionId: string
  startAt: string
  member: {
    id: string
    name: string
    age?: number
    rebookCount: number  // 본 멘토와의 이전 진행 수
    experienceLevel?: string
    goals?: string[]
  }
  aiRecommendation?: AIRecommendation
  lastHandover?: { mentorId: string, mentorName: string, text: string, date: string }
}
```

## 7. API 통신

### 7.1 새 엔드포인트

```
GET    /api/mentors/me/blocks?from=YYYY-MM-DD&to=YYYY-MM-DD
       Response: MentorBlock[]

POST   /api/mentors/me/blocks
       Body: { startAt }
       Response: MentorBlock

POST   /api/mentors/me/blocks/bulk
       Body: { weekday, hour, minute, weeks }  // 반복 등록
       Response: MentorBlock[]

DELETE /api/mentors/me/blocks/:id
       Response: {
         success: boolean,
         cancellationCategory: 'before_48h' | '48h_to_6h' | 'within_6h',
         penaltyApplied: boolean,
         memberCompensation?: { credits: number }
       }

GET    /api/mentors/me/obligation
       Response: MentorObligationStatus  // Phase 1만

GET    /api/mentors/me/today
       Response: AssignedSessionPreview[]

GET    /api/mentors/me/assignment-notifications?since=:timestamp
       Response: { matches: AssignedSessionPreview[] }
```

### 7.2 응답 예시

```json
// DELETE /api/mentors/me/blocks/block_xxx
{
  "success": true,
  "cancellationCategory": "48h_to_6h",
  "penaltyApplied": false,
  "memberCompensation": null,
  "newMentorMatched": true  // 회원에게 다른 멘토 자동 매칭됨
}

// 6h 이내일 경우
{
  "success": true,
  "cancellationCategory": "within_6h",
  "penaltyApplied": true,
  "memberCompensation": { "credits": 1 },
  "payoutDeduction": 20000,
  "tierImpact": "Pro → Verified (보류)"
}
```

## 8. 엣지 케이스

| 케이스 | 처리 |
|---|---|
| 멘토 동시 두 슬롯 등록 시도 (같은 시각) | 시스템이 차단 (1 슬롯 = 30분 = 1 회원) |
| 30분 이상 슬롯 (60분 한 회원에게) | 불가 — 30분 단위만 |
| 의무 슬롯 미달 (Phase 1 코어) | 인센티브 ↓ + 운영 매니저 통보 |
| 슬롯 변경 후 회원 매칭 못 찾음 | 그 회원은 자동 매칭 큐로 → 다른 멘토 시도 |
| 멘토가 회원 거부 시도 (등급 우려) | UI에서 차단 — 거부 기능 ❌ |
| 본사 의무 슬롯과 본인 일정 충돌 | 본사가 우선 (자동 등록 차단 가능) |
| 같은 시간에 두 회원 매칭됐는데 한 명 노쇼 | 다른 회원과는 정상 진행. 노쇼 회원은 회차 차감 |
| 멘토가 슬롯 오픈하지 않은 시간에 회원 요청 | 매칭 실패 → 다른 멘토 |

## 9. 측정 지표

| 지표 | 목표 |
|---|---|
| 슬롯 오픈 → 매칭 비율 | ≥ 70% |
| 멘토 취소율 (전체) | ≤ 5% |
| 6h 이내 취소 | ≤ 1% |
| 의무 슬롯 달성률 (Phase 1) | ≥ 95% |
| 이전 멘토 매칭 (회원의 고정 슬롯 우선) | ≥ 80% |

## 10. 구현 작업 분해

### 10.1 페이지 개편

- [ ] `src/pages/schedule-page.tsx` — 30분 단위 그리드 재작성
- [ ] `src/pages/notifications-page.tsx` (신규) — 매칭 알림 모음

### 10.2 컴포넌트

- [ ] `src/components/SlotGrid.tsx` — 30분 그리드 (요일·시간)
- [ ] `src/components/RecurringSlotEditor.tsx` — 반복 슬롯 설정
- [ ] `src/components/CancellationModal.tsx` — 변경 사유·룰 표시
- [ ] `src/components/AssignedSessionCard.tsx` — 매칭 슬롯 상세
- [ ] `src/components/ObligationBadge.tsx` — 의무 슬롯 진행률

### 10.3 서비스 / 스토어

- [ ] `src/services/schedule.ts` — 슬롯 CRUD + 반복 등록
- [ ] `src/services/notifications.ts` — 매칭 알림
- [ ] `src/store/usePartnerStore.ts` — schedule·assignments·obligation

### 10.4 타입

- [ ] `packages/api-types/src/mentor-schedule.ts` — 위 정의

---

| 2026-05-13 | 초안 |
| 2026-05-13 | 정책서 4개 cross-ref + 현재 코드 비교 + 5 시나리오 + 5 화면 + API·작업 분해 상세화 |
