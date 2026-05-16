---
title: 2026-05-13 어드민 콘솔 (본사 운영자)
parent: 🏢 플랫폼
grand_parent: 스펙 (PRD)
nav_order: 7
---

# 🏢 어드민 콘솔 — 수익·시스템·현황·분석

**Status**: 🟡 Updated (2026-05-16) · v2 본문 적용
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0002](../../decisions/0002-license-policy.html) · [ADR 0003](../../decisions/0003-free-gym-add-on.html) · [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html)
**의존**: [6B 본사 R&R](../../expansion/responsibility.html) · [5A 예약](../../operations/reservation.html) · [5D 자유 헬스](../../operations/free-gym.html)
**📡 API**: [v2 카테고리](../api/v2-categories.html) · [v2 프로그램](../api/v2-programs.html) · [v2 예약](../api/v2-reservations.html) · [v2 자유 헬스](../api/v2-free-gym.html) · [어드민/정산](../api/catalog.html#어드민-admin)
**🗄️ Data**: [전체 도메인](../data/)
**현재 코드**: `apps/admin/` (v2 페이지 — Categories·Programs·자유 헬스 분석 구현됨)

{: .note }
> **v2 (2026-05-16)**: 카테고리·프로그램 마스터 운영 + 회차권 5단 PricingConfig + 자유 헬스 분석 + Mentor-Program 매핑이 v2에서 신규로 admin 책임에 추가 ([ADR 0001](../../decisions/0001-consumer-pivot.html), [ADR 0003](../../decisions/0003-free-gym-add-on.html), [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html)). v1의 "매칭 알고리즘 가중치" 운영 변수는 폐기.

## 1. 배경

본사 운영자(admin)가 사용하는 통합 콘솔. 4 영역:
1. **💰 수익 대시보드** — 매출·정산·본사 수익 추적
2. **⚙️ 시스템 설정** — 카테고리·프로그램·가격·정책 운영
3. **👥 회원·강사 현황** — 사람 관리 (가입·등급·컴플레인)
4. **📊 데이터 분석** — KPI·깔때기·자유 헬스 출입·이상 탐지

## 2. 어드민 역할 (Role) 분리

```
super       — 모든 권한 (가설: CEO 1명)
operator    — 운영팀 (강사 심사·컴플레인·CS·카테고리/프로그램 운영)
finance     — 재무팀 (정산·환불·세무·PricingConfig)
analyst     — 데이터·KPI 조회 (수정 ❌)
```

권한 매트릭스:

| 영역 | super | operator | finance | analyst |
|---|---|---|---|---|
| 수익 대시보드 | ✓ | view | ✓ | view |
| 카테고리·프로그램 (v2) | ✓ | ✓ | ❌ | view |
| 가격·분배·정책 | ✓ | partial | ✓ | ❌ |
| 강사 심사 | ✓ | ✓ | ❌ | ❌ |
| 컴플레인 | ✓ | ✓ | ❌ | view |
| 정산 처리 | ✓ | ❌ | ✓ | view |
| 환불 처리 | ✓ | ❌ | ✓ | ❌ |
| 회원 데이터 | ✓ | view | ❌ | view |
| 자유 헬스 분석 (v2) | ✓ | view | view | ✓ |
| 분석 보고서 | ✓ | view | view | ✓ |

## 3. 💰 수익 대시보드

### 화면 (`/admin/revenue`)

**일간/주간/월간** 토글.

### 핵심 지표

| 지표 | 정의 | 시각화 |
|---|---|---|
| **본사 매출** | 회차권 결제액 합 (escrow 7일 후 인식) | 라인 차트 |
| **본사 수익 (net)** | 매출 - 강사 정산 - 가맹점주 분배 - PG 수수료 | 라인 + Phase 누적 |
| **지점별 매출** | Store별 분해 | 막대 |
| **카테고리별 매출** (v2) | CourseCategory별 분해 (스트레칭/PT/필라테스 …) | 막대 |
| **강사 정산 합계** | 격주 입금액 합 | 라인 |
| **Pro 옵션 포인트** (v2) | 회원이 차감한 Pro surcharge 합 | 라인 |
| **환불액** | 일간 환불 합 | 라인 (이상 탐지) |
| **AI 비용** | LLM API 누적 | 회원당 평균 |

### 드릴다운

- 매출 → 결제 리스트 (Payment) → 회원·회차권 타입·시점 필터
- 정산 → MentorPayout 리스트 → 강사별 명세
- 환불 → Refund 리스트 → 사유 분포

## 4. ⚙️ 시스템 설정

### A. 프로그램 그룹 (`/admin/system/categories`, `/admin/system/programs`) — **v2 신규**

**대응 데이터**: `CourseCategory`, `Program`, `MentorProgram`
**대응 API**: [v2 카테고리](../api/v2-categories.html) · [v2 프로그램](../api/v2-programs.html)

- **카테고리 CRUD**: 이름·slug·`requiresPrivateRoom`·`requiresMentor`·`defaultDurationMinutes`·`allowedDurations`·sortOrder·isActive
- **프로그램 CRUD**: 카테고리 → 프로그램 (level·duration 상속/override)
- **Mentor-Program 매핑** (현재 admin read-only — 강사가 본인 앱에서 PUT으로 관리): 강사별 매핑 현황 조회. admin CRUD endpoint는 후속 작업.
- 소프트 삭제만 허용 (`isActive=false`). 미래 예약 있으면 비활성화만.

### B. 회차권 가격 (`/admin/system/pricing`) — **v2 신규 5단 매트릭스**

**대응 데이터**: `PricingConfig` ([ADR 0004](../../decisions/0004-one-time-ticket-pricing.html))
**라인업**: 1회 · 4회 · 12회 · 24회 · 48회

| Field | 비고 |
|---|---|
| ticketType | one / four / twelve / twenty_four / forty_eight |
| priceKrw | 회차권 가격 |
| validityDays | 사용 기한 |
| scope | global / branch / promo |
| effectiveFrom | 효력 시점 |

- 활성 config 매트릭스 (5단 × scope)
- 새 config 생성 (피크 가산·promo 등)
- 변경 이력 (오래된 snapshot 보존, 회원 결제 시점 가격 보존)

### C. 분배 설정 (`/admin/system/distribution`)

**대응 데이터**: `RevenueDistributionConfig`

- 활성 분배 정책 (강사·본사·가맹점주 비율)
- 정액 / 비율 / 혼합 모드 선택
- scope별 차등 (Pro 인증·피크 보너스 등)
- 강사 30분 정산 상한 20,000원 강제 ([ADR 0001](../../decisions/0001-consumer-pivot.html))
- 미리보기 (현재 매출 기준 분배 시뮬레이션)

### D. 정책 변수 (`/admin/system/policies`)

**대응 데이터**: `PolicyConfig` (동적 조회, [예약 시스템 §5](./2026-05-13-reservation-system.html))

- `change_window_hours` (기본 48)
- `partial_window_hours` (기본 6)
- `no_show_credit_charge` (기본 1.0)
- `compensation_credit_on_provider_noshow` (기본 1)
- `pro_mentor_surcharge_per_session` (기본 5,000)
- 일시정지 한도 (기본 30%)
- 약정 할인율 (회차권 5단별)
- `free_gym.enabled` (지점별)
- `free_gym.grace_days_after_expiry` (기본 30)
- `free_gym.max_session_minutes` (기본 180)

### E. 운영 변수 (`/admin/system/operations`)

> v1의 "매칭 알고리즘 가중치·자동 매칭 거절 한도"는 **폐기** (v2 자동 매칭 ❌).

- AI 추천 비용 한도 (회원당 월 X원)
- 본사 API 한도 (Solapi·LLM)
- cron 주기·on/off (FixedSlot 자동 예약, no-show check, free-gym auto-exit)

### F. 지점 설정 (`/admin/system/stores`)

- 지점 추가·수정
- 운영 시간·휴일
- 룸 수 (기본 8) + 오픈 공간 구성
- 자유 헬스 토글 (`free_gym.enabled`)
- 무인 시간대 정의 (`free_gym.unmanned_hours`)

## 5. 👥 회원·강사 현황

### A. 회원 현황 (`/admin/members`)

**대시보드 카드**:
- 활성 회원 수 (활성 회차권 보유)
- 가입·이탈 추이
- 회차권 분포 (1·4·12·24·48회) — v2 5단
- 평균 LTV·재방문율
- 자유 헬스 활용도 (v2) — 회차권 회원의 free_gym visit 빈도

**회원 리스트**:
- 검색 (이름·이메일·전화)
- 필터 (상태·회차권 타입·지점·가입일)
- 회원 상세 → 회차권·예약·세션 이력·결제·평가·자유 헬스 visit

**회원 액션**:
- 수동 환불 처리
- 수동 일시정지 적용·해제
- 회원 데이터 열람·삭제 요청 처리 (PIPA)

### B. 강사 현황 (`/admin/mentors`)

**대시보드 카드**:
- 활성 강사 수 (verified + pro_certified)
- 가입 진행 중 (검증 코스)
- Pro 인증 대기열
- 평균 평점·재예약률
- 컴플레인 누적
- 카테고리별 강사 풀 (v2) — 카테고리별 매핑된 강사 수

**강사 리스트**:
- 검색·필터 (등급·지점·평점·매핑 카테고리)
- 강사 상세 → MentorProgram 매핑·MentorBlock 오픈 패턴·세션 이력·평가·컴플레인·정산

**강사 액션**:
- 신청서 심사 (`/admin/applications`)
- 검증 코스 통과 처리
- Pro 인증 심사 (영상·면담·필기)
- 등급 변경 (강등·복권)
- 자격 정지·복권
- (후속) Mentor-Program 매핑 admin override

### C. 강사 자격 검토 큐 (`/admin/mentors/review`)

**대응 데이터**: `Mentor.tier='under_review'`

> 강사는 별도 모집 페이지 ❌. 강사 앱 가입 후 자격 신청 (자격증·경력·시범 영상) → 이 큐 노출.

진행:
1. 강사 앱 가입 → `tier=pending_review, status=active` (활동 불가)
2. 강사가 자격 신청 → `tier=under_review`
3. admin 검토 → `verified` (활동 가능) or `rejected` (3개월 후 재신청)
4. Pro 인증 별도 트랙 → `pro_certified` ([ADR 0002](../../decisions/0002-license-policy.html))

### D. 컴플레인 큐 (`/admin/complaints`)

**대응 데이터**: `MentorComplaint`

- 우선순위 큐 (severity DESC, createdAt)
- 각 컴플레인 = 회원 신고 + 세션 정보 + 강사 누적 이력
- 액션: 1차 피드백 / 2차 등급 보류 / 3차 자격 정지

### E. 예약·세션 모니터링 (`/admin/operations`)

- 오늘 진행 중 세션 실시간 (카테고리별 색상)
- 미체크인 알림 (T+15 노쇼 임박)
- 강사 노쇼·지각 알림
- 룸 점유 현황 (8 룸 × 시간)
- MentorBlock 충돌·트랜잭션 실패(`BLOCK_TAKEN` 빈발) 알림
- FixedSlot 자동 예약 결과 (성공/실패 알림)

## 6. 📊 데이터 분석

### A. 깔때기 (Funnel)

```
방문 (랜딩) → 가입 → 첫 회차권 결제 → 첫 세션 → 재예약 → 갱신
   100        60       35              30       25       18
```

각 단계 전환율 + 이탈 사유 분석. 회차권 타입별 분기(1회·4회 진입 → 12회+ 전환율).

### B. KPI 대시보드

| 지표 | 목표 | 현재 |
|---|---|---|
| 가입→첫 결제 전환 | ≥ 60% | - |
| 1회권 → 4회+ 전환 (v2) | ≥ 40% | - |
| 갱신율 | ≥ 70% | - |
| 환불율 | ≤ 10% | - |
| 룸 부족(`INSUFFICIENT_ROOM`) 비율 | < 5% | - |
| AI 추천 채택률 | ≥ 70% | - |
| 강사 정시 입장 | ≥ 95% | - |
| 세션 만족도 | ≥ 4.3/5 | - |
| 자유 헬스 활용률 (v2) | ≥ 50% (회차권 회원) | - |
| 본사 BEP | 30호점 | - |

### C. 코호트 분석

- 가입 월별 코호트 retention
- 회차권 타입별 LTV (1/4/12/24/48)
- 페르소나(운동 경력)·카테고리 선호별 행동

### D. 자유 헬스 출입 분석 (`/admin/analytics/free-gym`) — **v2 신규**

**대응 데이터**: `FreeGymVisit` ([v2 자유 헬스 API §2.4](../api/v2-free-gym.html))

- 회원별 visit 빈도·평균 체류 시간
- 시간대별 입장률 (무인 시간대 vs 유인)
- 지점별 활용도
- 회차권 만료 grace 기간 내 visit 비율 → 갱신 예측 지표
- autoClosed 비율 (180분 초과)
- 비상 호출 이력 (5C 안전 연계)

### E. 이상 탐지

- 환불 폭증 (전주 대비 +50%)
- `INSUFFICIENT_ROOM` 비율 ↑
- AI 비용 폭증
- 강사 노쇼 누적
- 자유 헬스 무인 시간 단독 입장 누적 (안전)

### F. 보고서·내보내기

- 일간·주간·월간 자동 이메일 (PDF)
- Excel/CSV 다운로드
- 외부 BI 도구 연동 (선택)

## 7. 시스템 운영 도구

### 로그·디버깅 (`/admin/system/logs`)

- ErrorLog 검색 (시간·source·level)
- Sentry 연동 (외부 링크)
- 회원·강사별 행동 로그

### Cron 모니터링 (`/admin/system/cron`)

- 실행 이력 (성공·실패)
- 수동 트리거 (장애 복구)
- 다음 실행 시각
- v2 신규 cron: `reservation-noshow-check` (1분), `fixed-slot-auto-book` (주간), `free-gym-auto-exit` (5분)

### 알림 발송 이력 (`/admin/system/notifications`)

- 채널별 통계 (푸시·알림톡·SMS·이메일)
- 실패 사유·재시도 상태
- 마케팅 알림 옵트인 비율

## 8. 데이터 모델

기존 [전체 데이터](../data/) + admin 전용:

```typescript
interface AdminAuditLog {  // 모든 admin 액션 기록
  id: string
  adminId: string
  action: string        // "category_update" / "pricing_update" / "tier_change" / "refund_approved"
  targetType?: string   // "category" / "program" / "member" / "mentor" / "config"
  targetId?: string
  before: Json
  after: Json
  reason?: string
  createdAt: string
}

interface MentorApplicationData {  // Mentor row sub-table (1:1)
  licenseImageUrl?: string
  experienceYears?: number
  experienceText: string
  motivationText: string
  demoVideoUrl?: string
  submittedAt?: string
  reviewedBy?: string
  reviewedAt?: string
  decisionNotes?: string
}
```

## 9. API 매트릭스 (어드민 전용)

전체 endpoint는 [API 카탈로그 - 어드민](../api/catalog.html#어드민-admin)에서.

핵심:

| 도메인 | 주요 endpoints |
|---|---|
| 대시보드 | `GET /admin/dashboard`, `GET /admin/revenue/summary` |
| **카테고리** (v2) | `POST/PATCH/DELETE /api/categories` ([v2 카테고리](../api/v2-categories.html)) |
| **프로그램** (v2) | `POST/PATCH/DELETE /api/programs` ([v2 프로그램](../api/v2-programs.html)) |
| 회원 | `GET /admin/members`, `GET /admin/members/:id` |
| 강사 | `GET /admin/mentors`, `POST /admin/mentors/:id/verify`, `POST /admin/mentors/:id/suspend` |
| 신청서 | `GET /admin/applications`, `POST /admin/applications/:id/invite`, `POST /admin/applications/:id/reject` |
| 컴플레인 | `GET /admin/complaints`, `POST /admin/complaints/:id/resolve` |
| 정산 | `GET /admin/payouts/:periodId`, `POST /admin/payouts/:id/retry` |
| 가격(5단) | `POST /admin/system/pricing-configs` |
| 분배 | `POST /admin/system/distribution-configs` |
| 정책 | `GET/PATCH /admin/system/policy-config` |
| **자유 헬스 분석** (v2) | `GET /api/admin/free-gym/visits` ([v2 자유 헬스](../api/v2-free-gym.html)) |
| 분석 | `GET /admin/analytics/funnel`, `GET /admin/analytics/cohort` |
| 감사 | `GET /admin/audit-logs` |

## 10. 측정 지표

| 지표 | 목표 |
|---|---|
| admin 화면 응답 p95 | < 500ms |
| 신청서 검토 SLA | 영업일 3일 이내 |
| 컴플레인 처리 SLA | 1차 24h / 2-3차 영업일 3일 |
| 정산 입금 SLA | 격주 마감 + 영업일 2일 |
| KPI 대시보드 데이터 신선도 | < 1시간 |
| 자유 헬스 visit 데이터 신선도 | 실시간 (< 1분) |

## 11. 구현 작업 분해

### 페이지 (apps/admin/) — v2 신규/개편

- [x] `/system/categories` (v2 신규) — CourseCategory CRUD
- [x] `/system/programs` (v2 신규) — Program CRUD
- [x] `/analytics/free-gym` (v2 신규) — 자유 헬스 출입 분석
- [ ] `/system/pricing` (v2 5단 매트릭스 개편) — 1·4·12·24·48회
- [ ] `/system/policies` (PolicyConfig 동적 변수)
- [ ] `/system/operations` (v2: 매칭 가중치 ❌, AI/cron 변수만)
- [ ] `/mentors/:id/programs` (admin read-only 매핑 조회)
- [ ] `/operations` — MentorBlock 충돌·룸 점유 실시간
- [ ] `/revenue` — 카테고리별 매출 분해, Pro 옵션 포인트
- [ ] `/members` — 회차권 5단 분포, 자유 헬스 활용도
- [ ] `/mentors` — 카테고리 매핑 강사 풀
- [ ] `/applications`, `/complaints`, `/operations`
- [ ] `/system/distribution`, `/system/stores`, `/system/cron`, `/system/notifications`, `/system/logs`
- [ ] `/analytics/funnel`, `/analytics/cohort`, `/analytics/reports`
- [ ] `/audit-logs`

### 폐기 (v1)

- ❌ "매칭 알고리즘 가중치" 운영 변수 화면
- ❌ "자동 매칭 거절 한도" 화면
- ❌ "Stagger 그룹" 지점 설정 (v2는 30분 unit 자유 오픈, stagger ❌)
- ❌ 카디오 자리 구성 (CardioSlot 폐기)

### 백엔드

- [x] CourseCategory·Program·MentorProgram CRUD (v2)
- [x] FreeGymVisit 분석 endpoint (v2)
- [ ] PricingConfig 5단 매트릭스 모델
- [ ] PolicyConfig 동적 조회 API
- [ ] AdminAuditLog 미들웨어 (모든 admin 액션 자동 로깅)
- [ ] 분석 쿼리 (cohort·funnel·자유 헬스) 성능 최적화
- [ ] Mentor-Program admin CRUD endpoint (후속)

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-13 | 초안 — 4영역 (수익·시스템·현황·분석) + 권한·페이지·API·데이터 모델 통합 (v1) |
| 2026-05-16 | v2 본문 재작성 — 프로그램 그룹(카테고리·프로그램 CRUD)·회차권 5단 PricingConfig·자유 헬스 출입 분석·Mentor-Program 매핑 신규. v1 매칭 가중치·stagger·카디오 자리 페이지 폐기 ([ADR 0001](../../decisions/0001-consumer-pivot.html), [ADR 0003](../../decisions/0003-free-gym-add-on.html), [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html)) |
