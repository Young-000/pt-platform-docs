---
title: 2026-05-13 등급·Pro 인증 (멘토)
parent: 💪 멘토
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 💪 멘토 등급·Pro 인증

**Status**: Draft · **Layer**: 💪 멘토 · **Updated**: 2026-05-13
**관련 결정**: [3F 일반 멘토](../../partners/peer-leader.html) · [3H 품질·등급](../../partners/quality.html) · [3G 정산](../../partners/payout.html) · [4A 세션 종류](../../service/session-types.html) · [3A 강사 페르소나](../../partners/personas.html) · [3C 강사 VP](../../partners/value-prop.html)
**📡 API**: [멘토](../../api/catalog.html#멘토-mentor) · [어드민](../../api/catalog.html#어드민-admin)
**🗄️ Data**: [8. Mentor System](../data/08-mentor-system.html)
**현재 코드**: `apps/partner/src/pages/more/profile-page.tsx`

## 1. 배경

기존 MVP는 `coaches.status` (pending/approved/suspended) + `badges`만 존재. 새 모델은 명확한 **2-등급 체계** (일반 멘토 / Pro 인증 멘토) + **본사 검증 코스** + **Pro 인증 심사** + **자율 단가 권한** + **컴플레인 처리**.

이 시스템이 강사 입장 **수익 인센티브** + 회원 입장 **신뢰 자산** 모두 제공.

## 2. 정책서 락된 사항

### 등급 구조 (4A + 3F)
```
[지원자]
   │ 본사 검증 코스 통과 (운동·AI·CS·시범 → ~4-8h, 합격 심사)
   ▼
[일반 멘토] (verified)
   │ 자격증 보유 + 본사 심사 통과 (영상·면담)
   ▼
[Pro 인증 멘토] (pro_certified)
```

### 일반 멘토 (3F)
- 자격증 ❌ OK
- 본사 자체 검증 코스 통과 필수
- 외부 명칭 = "멘토" (PT·트레이너 ❌)
- 운동 설계 = AI (멘토가 설계 ❌)
- 단가 = 회당 고정 (본사 결정)

### Pro 인증 (4A + 3G)
- 자격증 + 본사 심사 통과
- 회원에게 "Pro 인증" 배지 노출
- **단가 자율 설정** (본사 min~max 한도 내)
- 등급 보너스 ❌ — 자율 단가가 인센티브 역할

### 등급 평가 (3H, 원칙만)
- 다축 평가: 회원 평점·재예약률·세션 기록 품질·운동 성과·출석률
- 등급은 Pro 인증 승격 자격 + 매칭 우선순위에 사용
- 단가에 직접 영향 ❌

### 컴플레인 처리 (3H)
- 1차 (단발): 강사 피드백 + 본사 기록
- 2차 (반복): 등급 보류·하향
- 3차 (심각): 자격 정지 + 회원 환불

### 멘토 입장 매력 (3C)
- "영업·정산 부담 없이, 본사 프로그램 + AI 가이드 따라 일관된 1:1 멘토링"
- "Pro 인증 통과 시 단가 자율로 수익화"

## 3. 현재 코드 vs 새 시스템

| 영역 | 현재 | 새 시스템 |
|---|---|---|
| 등급 모델 | `coaches.status` + `badges` (자유 텍스트) | tier ENUM (verified / pro_certified) |
| 검증 코스 | ❌ 없음 | 4-8h 교육 + 시범 평가 |
| Pro 인증 심사 | ❌ 없음 | 영상·면담·필기 워크플로우 |
| 단가 자율 | 모델 없음 | Pro 인증만 min~max 한도 내 |
| 등급 평가 | 모델 없음 | 다축 평가 (Phase 1 = 단순 자격 판정) |
| 컴플레인 처리 | 모델 없음 | 3단계 SOP |
| 자격증 인증 | `certifications` 텍스트 배열 | 업로드 + 외부 발행처 확인 |

## 4. 멘토 시나리오

### 4.1 가입 (`/onboarding`)

```
1. 기본 정보 입력 (이름·이메일·전화·은행 계좌)
2. 자격증 업로드 (있다면 — Pro 인증 자격)
3. 운동 경력·전문 분야 입력
4. 검증 코스 신청 (다음 회차 자동 등록)
```

### 4.2 검증 코스 (`/verification-course`)

```
[코스 진행 상황]
─────────────────
✅ 1주차 — 운동 안전·응급처치 (4h, 출석 완료)
✅ 2주차 — AI 가이드 시스템 사용법 (2h)
✅ 3주차 — 회원 커뮤니케이션 (2h)
⏳ 4주차 — 시범 세션 평가 (예정 5/20)

총 8h + 시범 1회
```

시범 통과 시:
```
🎉 합격
2026-05-22부터 활동 가능
등급: 일반 멘토 (verified)
회당 정산: 20,000원

[활동 시작]
```

### 4.3 일반 멘토 활동

- 슬롯 오픈 + 회원 매칭 + 세션 + 기록 입력
- 단가 = 본사 결정 고정 (변경 ❌)
- 평점·재예약 누적

### 4.4 Pro 인증 신청

자격 조건 충족 시 활성화:
```
🏆 Pro 인증 자격 충족

조건:
  ✅ 100 세션 이상 (현재 124)
  ✅ 평균 평점 4.3+ (현재 4.6)
  ✅ 재예약률 60%+ (현재 71%)
  ✅ 자격증 보유 (생활스포츠지도사 2급)

심사 신청 시:
  - 세션 영상 1회 평가
  - 본사 면담 (1시간)
  - 필기 (운동 지식, 안전)
  - 통과 시 단가 자율 권한

[신청]
```

심사 진행:
```
1. 신청 → 본사 admin 큐 등록
2. 영상 평가 (48h 이내) — 멘토에게 세션 영상 1회 요청
3. 면담 일정 잡힘
4. 결과 통보 (영업일 7일)
```

### 4.5 Pro 인증 통과 후

```
🏆 Pro 인증 통과
─────────────────
새 권한:
  - 회당 단가 자율 설정 (본사 min~max)
  - 회원 검색 시 "Pro 인증" 배지 노출
  - 단가 자율로 수익 ↑ 가능

현재 단가: 20,000원 (일반 기준)
새 단가 설정 [슬라이더 15,000 ~ 50,000]
─────────────────
권장 시작 단가: 22,000원 (시장 시세)
[저장]
```

### 4.6 단가 변경

- Pro 인증 멘토만 가능
- 슬라이더 (min~max 한도 내)
- 변경 시 **다음 결제부터 적용** (기존 예약은 기존 단가 유지)
- 변경 이력 기록

### 4.7 컴플레인 받음

```
⚠️ 회원 컴플레인 1건
─────────────────
회원: 김OO (3/15 19:30 세션)
사유: "운동 강도 너무 셈"
운영자 코멘트: "1차 피드백. 운동 강도 조절 권장."

→ 등급 영향 ❌ (1차 단발)
→ 본인 기록에 보관

[확인]
```

2차·3차 = 더 강한 경고 + 등급·자격 영향.

## 5. 화면 요구사항

### 5.1 등급 보드 (`/more/profile`)

**컴포넌트**: `profile-page.tsx` (개편)

```
김멘토 (일반 멘토 → Pro 인증 신청 가능 ✨)
────────────────────────────────────────

현재 등급: 일반 멘토
누적 세션: 124  ✅
평균 평점: ★4.6  ✅
재예약률: 71%  ✅
자격증: 생활스포츠지도사 2급 (인증됨) ✅

Pro 인증 조건:
  ✅ 100 세션+ (124)
  ✅ 평점 4.3+ (4.6)
  ✅ 재예약 60%+ (71%)
  ✅ 자격증 보유

[Pro 인증 신청] 🏆
```

### 5.2 검증 코스 진행 (`/verification-course`)

```
검증 코스 진행 — 5/8 시작
────────────────────────
[1] 운동 안전·응급처치 (4h) ✅
[2] AI 가이드 사용법 (2h) ✅
[3] 회원 커뮤니케이션 (2h) ✅
[4] 시범 세션 평가 ⏳ 5/20 예정

진행률: 75% [████████░░]

다음 일정: 5/20 (월) 14:00 시범 세션
```

### 5.3 Pro 인증 신청 화면

```
🏆 Pro 인증 신청
────────────────────
신청 시 진행 과정:
  1. 세션 영상 1회 평가 (48h 이내 업로드)
  2. 본사 면담 (1h, 일정 협의)
  3. 필기 (운동·안전, 30분)
  4. 결과 통보 (영업일 7일)

통과 시 권한:
  ✓ 회당 단가 자율 설정
  ✓ 회원에게 Pro 인증 배지 노출
  ✓ 매칭 우선순위 ↑

[신청 시작]
```

신청 후:
```
신청 완료
────────────────
상태: 영상 평가 대기 중
세션 영상 업로드 마감: 5/15 (3일 남음)

[영상 업로드]
```

### 5.4 단가 설정 (Pro 인증만)

```
회당 단가 설정 (Pro 인증)
────────────────────
[슬라이더: 15,000 ─ ●22,000 ─ 50,000]

본사 한도: 15,000 ~ 50,000원
현재 설정: 22,000원
시장 시세 참고: 평균 25,000원

설정 시 영향:
  - 다음 결제부터 적용
  - 기존 예약 = 기존 단가 유지
  - 자율 단가가 등급 보너스 역할 (보너스 ❌)

[저장]
```

### 5.5 컴플레인 알림

```
컴플레인 — 1건
────────────────
2026-05-13 (오늘)
회원 김OO · 3/15 세션
사유: "강도 셈"
등급: 1차 (단발) — 등급 영향 ❌

운영자 코멘트:
  "회원 컨디션 따라 강도 조절 권장.
   AI 추천보다 한 단계 낮춰서 시작 추천."

[확인] [본 세션 기록 보기]
```

### 5.6 컴플레인 누적 (3차 위기 시)

```
⚠️ 자격 정지 위기
────────────────
컴플레인 누적:
  1차 — 3/15 (강도)
  2차 — 4/2 (시간 미준수)
  3차 — 5/10 (회원 응대)

다음 단계: 자격 정지 (운영 매니저 면담 필수)

[면담 일정 잡기]
```

## 6. 데이터 모델

```typescript
type MentorTier = 'verified' | 'pro_certified'
type ApplicationStatus = 'pending' | 'video_review' | 'interview' | 'written' | 'approved' | 'rejected'

interface Mentor {
  id: string
  profileId: string  // 기존 profiles와 연결
  tier: MentorTier
  licenseNumber?: string
  licenseType?: string  // "생활스포츠지도사 2급"
  licenseVerified: boolean
  // 활동 데이터 (등급 평가용)
  sessionCount: number
  averageRating: number
  rebookRate: number  // 0-1
  recordQualityScore: number  // AI가 계산
  attendanceRate: number  // 0-1
  // Pro 인증 자율 단가
  proMinRate: number
  proMaxRate: number
  proCurrentRate?: number  // Pro만 설정 가능
  // 메타
  verifiedAt?: string
  proCertifiedAt?: string
  status: 'active' | 'suspended' | 'inactive'
}

interface VerificationCourse {
  id: string
  scheduledAt: string
  attendees: string[]  // mentor IDs
  completedModules: { mentorId: string, modules: string[] }[]
  demoSessions: { mentorId: string, passed: boolean, evaluator: string }[]
}

interface ProCertificationApplication {
  id: string
  mentorId: string
  appliedAt: string
  status: ApplicationStatus
  // 단계별 결과
  videoSubmittedAt?: string
  videoReviewScore?: number  // 1-5
  videoReviewer?: string
  interviewScheduledAt?: string
  interviewScore?: number
  writtenScore?: number
  // 최종
  decisionAt?: string
  decisionBy?: string  // admin id
  decisionNotes?: string
  approved?: boolean
}

interface MentorRateChange {  // 단가 변경 이력
  id: string
  mentorId: string
  oldRate: number
  newRate: number
  changedAt: string
  appliedFromDate: string
}

interface MentorComplaint {
  id: string
  memberId: string
  mentorId: string
  sessionId: string
  severity: 'low' | 'medium' | 'high'
  text: string
  resolution: 'feedback' | 'tier_hold' | 'tier_down' | 'suspension'
  adminNotes: string
  resolvedAt?: string
  resolvedBy?: string  // admin id
  tierImpact: boolean
}

interface TierChange {
  id: string
  mentorId: string
  fromTier: MentorTier
  toTier: MentorTier
  reason: string  // "Pro 인증 통과" / "3차 컴플레인" 등
  changedAt: string
  changedBy: string  // admin id or 'system'
}
```

## 7. API 통신

### 7.1 새 엔드포인트

```
GET    /api/mentors/me
       Response: Mentor

POST   /api/mentors/verify-application
       Body: { courseId }
       Response: { courseId, status }

GET    /api/mentors/me/verification-course
       Response: VerificationCourse | null

POST   /api/mentors/me/pro-application
       Response: ProCertificationApplication

GET    /api/mentors/me/pro-application
       Response: ProCertificationApplication | null

POST   /api/mentors/me/pro-application/video
       Body: { videoUrl }
       Response: ProCertificationApplication

PATCH  /api/mentors/me/rate
       Body: { newRate }
       Response: { rateChange, appliedFromDate }

GET    /api/mentors/me/complaints?since=:timestamp
       Response: MentorComplaint[]

GET    /api/mentors/me/tier-history
       Response: TierChange[]
```

## 8. 엣지 케이스

| 케이스 | 처리 |
|---|---|
| 검증 코스 불합격 | 재시도 가능 (3개월 후) |
| Pro 인증 신청 후 자격 미달 (세션 수 부족) | 진행 차단, 메시지 안내 |
| Pro 인증 통과 후 평점·재예약 하락 | 보류 → 보류 상태로 단가 자율 유지 / 등급 하향 시 자율 회수 |
| Pro 인증 멘토 단가가 너무 높아 매칭 0 | 시스템 알림 ("매칭 어려움, 단가 ↓ 권장") |
| 자격증 위조 발견 | 즉시 자격 정지 + 본사 조사 |
| 컴플레인 1차에서 본인이 사과 + 보상 | 1차 종결, 등급 영향 ❌ |
| 컴플레인 2차 누적인데 회원 평점은 좋음 | 운영자 재량 판단 (3H 룰 따라) |
| 일반 멘토가 단가 변경 시도 | UI에서 차단 (Pro만 가능) |

## 9. 측정 지표

| 지표 | 목표 |
|---|---|
| 검증 코스 통과율 | ≥ 80% |
| Pro 인증 신청 → 통과 비율 | ≥ 50% |
| Pro 인증 멘토 평균 평점 | ≥ 4.5 |
| 컴플레인 1차 해결률 | ≥ 80% |
| Pro 인증 멘토 풀 비율 (전체 중) | ≥ 30% |
| 단가 설정 후 매칭 유지율 | ≥ 70% |

## 10. 구현 작업 분해

### 10.1 페이지 신설·개편

- [ ] `src/pages/more/profile-page.tsx` — 등급 보드 + Pro 자격 표시
- [ ] `src/pages/onboarding/index.tsx` (신규) — 가입 + 자격증 + 검증 코스 신청
- [ ] `src/pages/verification-course-page.tsx` (신규) — 코스 진행
- [ ] `src/pages/pro-application-page.tsx` (신규) — Pro 신청·진행
- [ ] `src/pages/rate-settings-page.tsx` (신규, Pro만) — 단가 슬라이더
- [ ] `src/pages/complaints-page.tsx` (신규) — 컴플레인 모음

### 10.2 컴포넌트

- [ ] `src/components/TierBoard.tsx` — 등급 + 조건 충족 진행률
- [ ] `src/components/ProEligibilityCard.tsx` — Pro 자격 표시
- [ ] `src/components/RateSlider.tsx` — Pro 단가 슬라이더 (min~max)
- [ ] `src/components/ApplicationProgress.tsx` — 신청 단계별 상태
- [ ] `src/components/ComplaintItem.tsx` — 컴플레인 카드

### 10.3 서비스 / 스토어

- [ ] `src/services/mentor.ts` — 등급·자격증·단가 CRUD
- [ ] `src/services/application.ts` — Pro 신청·영상 업로드
- [ ] `src/services/complaints.ts` — 컴플레인 조회

### 10.4 타입

- [ ] `packages/api-types/src/mentor.ts` — Mentor, ProCertificationApplication, TierChange
- [ ] `packages/api-types/src/complaint.ts`

---

| 2026-05-13 | 초안 |
| 2026-05-13 | 정책서 6개 cross-ref + 현재 코드 비교 + 7 시나리오 + 6 화면 + API·작업 분해 상세화 |
