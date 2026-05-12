---
title: 2026-05-13 어드민 콘솔 (본사 운영자)
parent: 🏢 플랫폼
grand_parent: 스펙 (PRD)
nav_order: 7
---

# 🏢 어드민 콘솔 — 수익·시스템·현황·분석

**Status**: Draft · **Layer**: 🏢 플랫폼 · **Updated**: 2026-05-13
**관련 결정**: [6B 본사 R&R](../../expansion/responsibility.html) · [모든 정책 결정](../../product/decision-tree.html)
**📡 API**: [어드민](../../api/catalog.html#어드민-admin) · [정산](../../api/catalog.html#정산-payout)
**🗄️ Data**: [전체 도메인](../data/)
**현재 코드**: `apps/admin/`

## 1. 배경

본사 운영자(admin)가 사용하는 통합 콘솔. 4 영역:
1. **💰 수익 대시보드** — 매출·정산·본사 수익 추적
2. **⚙️ 시스템 설정** — 가격·분배·정책·운영 변수 운영
3. **👥 회원·강사 현황** — 사람 관리 (가입·등급·컴플레인)
4. **📊 데이터 분석** — KPI·깔때기·이상 탐지

## 2. 어드민 역할 (Role) 분리

```
super       — 모든 권한 (가설: CEO 1명)
operator    — 운영팀 (멘토 심사·컴플레인·CS)
finance     — 재무팀 (정산·환불·세무)
analyst     — 데이터·KPI 조회 (수정 ❌)
```

권한 매트릭스:

| 영역 | super | operator | finance | analyst |
|---|---|---|---|---|
| 수익 대시보드 | ✓ | view | ✓ | view |
| 시스템 설정 | ✓ | partial | partial | ❌ |
| 멘토 심사 | ✓ | ✓ | ❌ | ❌ |
| 컴플레인 | ✓ | ✓ | ❌ | view |
| 정산 처리 | ✓ | ❌ | ✓ | view |
| 환불 처리 | ✓ | ❌ | ✓ | ❌ |
| 회원 데이터 | ✓ | view | ❌ | view |
| 분석 보고서 | ✓ | view | view | ✓ |

## 3. 💰 수익 대시보드

### 화면 (`/admin/revenue`)

**일간/주간/월간** 토글.

### 핵심 지표

| 지표 | 정의 | 시각화 |
|---|---|---|
| **본사 매출** | 회원 결제액 합 (escrow 7일 후 인식) | 라인 차트 |
| **본사 수익 (net)** | 매출 - 멘토 정산 - 가맹점주 분배 - PG 수수료 | 라인 + Phase 누적 |
| **지점별 매출** | Store별 분해 | 막대 |
| **멘토 정산 합계** | 격주 입금액 합 | 라인 |
| **환불액** | 일간 환불 합 | 라인 (이상 탐지) |
| **AI 비용** | LLM API 누적 | 회원당 평균 |

### 드릴다운

- 매출 → 결제 리스트 (Payment) → 회원·시점 필터
- 정산 → MentorPayout 리스트 → 멘토별 명세
- 환불 → Refund 리스트 → 사유 분포

## 4. ⚙️ 시스템 설정

### A. 가격 설정 (`/admin/system/pricing`)

**대응 데이터**: [PricingConfig](../data/09-payout.html)

- 활성 config 리스트 (global + scope별)
- 새 config 생성 (피크 가산·고정 슬롯 우대 등)
- 가격 변경 효력 시점 설정 (effectiveFrom)
- 변경 이력 (오래된 config snapshot 보존)

### B. 분배 설정 (`/admin/system/distribution`)

**대응 데이터**: [RevenueDistributionConfig](../data/09-payout.html)

- 활성 분배 정책 (멘토·본사·가맹점주 비율)
- 정액 / 비율 / 혼합 모드 선택
- scope별 차등 (Pro 인증 자율, 피크 보너스 등)
- 미리보기 (현재 매출 기준 분배 시뮬레이션)

### C. 정책 설정 (`/admin/system/policies`)

**대응 데이터**: ReservationPolicy 정적 모델 + 정책 결정 페이지 참조

- 변경/취소 윈도우 (현재 48h/6h)
- 노쇼 차감 회차
- 본사 노쇼 보상
- 일시정지 한도 (현재 30%)
- 약정 할인율 (1·3·6·12개월)
- 자동 갱신 grace 기간

### D. 운영 변수 (`/admin/system/operations`)

- 매칭 알고리즘 가중치 (페르소나·이력·평점)
- 자동 매칭 거절 한도
- AI 추천 비용 한도 (회원당 월 X원)
- 본사 API 한도 (Solapi·LLM)

### E. 지점 설정 (`/admin/system/stores`)

- 지점 추가·수정
- 운영 시간·휴일
- 방·카디오 자리 구성
- Stagger 그룹 (정각 4방 + 30분 4방)

## 5. 👥 회원·강사 현황

### A. 회원 현황 (`/admin/members`)

**대시보드 카드**:
- 활성 회원 수 (Membership status='active')
- 가입·이탈 추이
- 멤버십 분포 (주 1·주 2)
- 약정 분포 (1·3·6·12개월)
- 평균 LTV·재방문율

**회원 리스트**:
- 검색 (이름·이메일·전화)
- 필터 (상태·멤버십·지점·가입일)
- 회원 상세 → 멤버십·예약·세션 이력·결제·평가

**회원 액션**:
- 수동 환불 처리
- 수동 일시정지 적용·해제
- 회원 데이터 열람·삭제 요청 처리 (PIPA)

### B. 멘토 현황 (`/admin/mentors`)

**대시보드 카드**:
- 활성 멘토 수 (verified + pro_certified)
- 가입 진행 중 (검증 코스)
- Pro 인증 대기열
- 평균 평점·재예약률
- 컴플레인 누적

**멘토 리스트**:
- 검색·필터 (등급·지점·평점)
- 멘토 상세 → 슬롯·세션 이력·평가·컴플레인·정산

**멘토 액션**:
- 신청서 심사 (`/admin/applications`) — [MentorApplication](../data/08-mentor-system.html)
- 검증 코스 통과 처리
- Pro 인증 심사 (영상·면담·필기)
- 등급 변경 (강등·복권)
- 자격 정지·복권

### C. 멘토 자격 검토 큐 (`/admin/mentors/review`)

**대응 데이터**: [Mentor.tier='under_review'](../data/01-identity.html)

> 멘토는 별도 모집 페이지 ❌. 멘토 앱 가입 후 그 안에서 자격 신청 (자격증·경력·시범 영상 제출) → 이 큐에 노출.

```
멘토 자격 검토 큐
─────────────────
[under_review] 12건  [pending_review] 5건 (자격 미신청)

각 행:
  김OO (32, 생활스포츠지도사 2급, 경력 4년) — 5분 전 신청
  [상세 보기] [verified 승인] [반려·rejected]
```

진행:
1. 멘토 앱 가입 → `tier=pending_review, status=active` (활동 불가)
2. 멘토가 자격 신청 → `tier=under_review`
3. admin 검토 → `verified` (활동 가능) or `rejected` (3개월 후 재신청)

### D. 컴플레인 큐 (`/admin/complaints`)

**대응 데이터**: [MentorComplaint](../data/08-mentor-system.html)

- 우선순위 큐 (severity DESC, createdAt)
- 각 컴플레인 = 회원 신고 텍스트 + 세션 정보 + 멘토 누적 이력
- 액션: 1차 피드백 / 2차 등급 보류 / 3차 자격 정지

### E. 예약·세션 모니터링 (`/admin/operations`)

- 오늘 진행 중 세션 실시간
- 미체크인 알림 (T+15 노쇼 임박)
- 멘토 노쇼·지각 알림
- 슬롯 충돌·매칭 실패 알림

## 6. 📊 데이터 분석

### A. 깔때기 (Funnel)

```
방문 (랜딩) → 가입 → 첫 결제 → 첫 세션 → 재예약 → 갱신
   100       60     35       30      25      18
```

각 단계 전환율 + 이탈 사유 분석.

### B. KPI 대시보드

| 지표 | 목표 | 현재 |
|---|---|---|
| 가입→첫 결제 전환 | ≥ 60% | - |
| 갱신율 | ≥ 70% | - |
| 환불율 | ≤ 10% | - |
| 매칭 성공률 | ≥ 95% | - |
| AI 추천 채택률 | ≥ 70% | - |
| 멘토 정시 입장 | ≥ 95% | - |
| 세션 만족도 | ≥ 4.3/5 | - |
| 본사 BEP | 30호점 | - |

### C. 코호트 분석

- 가입 월별 코호트 retention
- 멤버십 타입별 LTV
- 페르소나 (운동 경력)별 행동

### D. 이상 탐지

- 환불 폭증 (전주 대비 +50%)
- 매칭 실패율 ↑
- AI 비용 폭증
- 멘토 노쇼 누적

### E. 보고서·내보내기

- 일간·주간·월간 자동 이메일 (PDF)
- Excel/CSV 다운로드
- 외부 BI 도구 연동 (선택)

## 7. 시스템 운영 도구

### 로그·디버깅 (`/admin/system/logs`)

- ErrorLog 검색 (시간·source·level)
- Sentry 연동 (외부 링크)
- 회원·멘토별 행동 로그

### Cron 모니터링 (`/admin/system/cron`)

- 실행 이력 (성공·실패)
- 수동 트리거 (장애 복구)
- 다음 실행 시각

### 알림 발송 이력 (`/admin/system/notifications`)

- 채널별 통계 (푸시·알림톡·SMS·이메일)
- 실패 사유·재시도 상태
- 마케팅 알림 옵트인 비율

## 8. 데이터 모델

기존 [전체 데이터](../data/) + 추가 필요:

```typescript
// MentorApplication 모델 ❌ — Mentor 모델로 통합
// 가입 시 tier='pending_review', 자격 신청 시 'under_review' 전환

interface MentorApplicationData {  // Mentor row에 직접 저장 (또는 1:1 sub-table)
  licenseImageUrl?: string
  experienceYears?: number
  experienceText: string
  motivationText: string
  demoVideoUrl?: string  // 시범 세션 영상
  submittedAt?: string
  reviewedBy?: string  // admin id
  reviewedAt?: string
  decisionNotes?: string
}

interface AdminAuditLog {  // 모든 admin 액션 기록
  id: string
  adminId: string
  action: string  // "config_update" / "tier_change" / "refund_approved"
  targetType?: string  // "member" / "mentor" / "config"
  targetId?: string
  before: Json
  after: Json
  reason?: string
  createdAt: string
}
```

## 9. API 매트릭스 (어드민 전용)

전체 endpoint는 [API 카탈로그 - 어드민](../../api/catalog.html#어드민-admin)에서.

핵심:

| 도메인 | 주요 endpoints |
|---|---|
| 대시보드 | `GET /admin/dashboard` (KPI), `GET /admin/revenue/summary` |
| 회원 | `GET /admin/members` (검색), `GET /admin/members/:id` |
| 멘토 | `GET /admin/mentors`, `POST /admin/mentors/:id/verify`, `POST /admin/mentors/:id/suspend` |
| 신청서 | `GET /admin/applications`, `POST /admin/applications/:id/invite`, `POST /admin/applications/:id/reject` |
| 컴플레인 | `GET /admin/complaints`, `POST /admin/complaints/:id/resolve` |
| 정산 | `GET /admin/payouts/:periodId`, `POST /admin/payouts/:id/retry` |
| 가격·분배 설정 | `POST /admin/system/pricing-configs`, `POST /admin/system/distribution-configs` |
| 분석 | `GET /admin/analytics/funnel`, `GET /admin/analytics/cohort` |
| 감사 | `GET /admin/audit-logs` |

## 10. 측정 지표

| 지표 | 목표 |
|---|---|
| admin 화면 응답 p95 | < 500ms |
| 신청서 검토 SLA | 영업일 3일 이내 |
| 컴플레인 처리 SLA | 1차 24h / 2-3차 영업일 3일 |
| 정산 입금 SLA | 격주 마감 + 영업일 2일 |
| KPI 대시보드 데이터 신선도 | < 1시간 (실시간 ideal) |

## 11. 구현 작업 분해

### 페이지 (apps/admin/)

- [ ] `/` 대시보드 — KPI 요약 (개편)
- [ ] `/revenue` (신규) — 수익 대시보드
- [ ] `/members` — 회원 관리 (개편)
- [ ] `/mentors` — 멘토 관리 (개편 — coaches → mentors)
- [ ] `/applications` (신규) — 신청서 큐
- [ ] `/complaints` (신규) — 컴플레인 큐
- [ ] `/operations` (신규) — 운영 모니터링
- [ ] `/system/pricing` (신규) — PricingConfig 운영
- [ ] `/system/distribution` (신규) — RevenueDistributionConfig
- [ ] `/system/policies` (신규) — 정책 변수
- [ ] `/system/stores` — 지점 관리 (개편)
- [ ] `/system/cron` (신규) — cron 모니터링
- [ ] `/system/notifications` (신규) — 알림 통계
- [ ] `/system/logs` (신규) — 로그·에러
- [ ] `/analytics/funnel` (신규)
- [ ] `/analytics/cohort` (신규)
- [ ] `/analytics/reports` (신규) — 자동 보고서
- [ ] `/audit-logs` (신규) — admin 액션 감사

### 백엔드

- [ ] `MentorApplication` 모델 + 신청서 API
- [ ] `AdminAuditLog` 미들웨어 (모든 admin 액션 자동 로깅)
- [ ] PricingConfig·RevenueDistributionConfig CRUD
- [ ] 분석 쿼리 (cohort·funnel) 성능 최적화

---

| 2026-05-13 | 초안 — 4영역 (수익·시스템·현황·분석) + 권한·페이지·API·데이터 모델 통합 |
