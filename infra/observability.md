---
title: 모니터링·관측 (Observability)
parent: 🚀 인프라·모니터링
nav_order: 1
---

# 🛡️ 모니터링·관측 (Observability)

**Status**: Draft · Phase 1 필수 · **Updated**: 2026-05-13

## 3 축: Logs / Metrics / Traces

### 1. Logs

- **수집**: 프론트 (console·error events) + 백엔드 (Express middleware) → CloudWatch / DataDog
- **분류**:
  - error: 자동 Sentry 알림
  - warn: 일별 요약
  - info: 행동 로그 (예약·결제·세션)
- **보관**: 90일 (분쟁 대비)

### 2. Metrics

- **시스템**: CPU·메모리·DB connection·API 응답 시간
- **비즈니스**: 가입·결제·예약·매칭·세션 완료 카운트 (시간당·일별)
- **AI**: LLM 호출·tokens·비용

### 3. Traces (선택, Phase 2+)

- 분산 추적 (OpenTelemetry)
- 느린 API 요청 분석

## 도구 선택 (가설)

| 영역 | 도구 | 이유 |
|---|---|---|
| 에러 추적 | **Sentry** | 프론트·백엔드 통합, 한국 지원 |
| APM·로그·메트릭 | **DataDog** 또는 GCP/AWS native | All-in-one |
| 비즈니스 분석 | **Mixpanel** 또는 자체 | 회원 funnel |
| 알림 | **Slack** webhook | 운영팀 즉시 |

## SLO (Service Level Objectives)

| 영역 | 목표 | 측정 |
|---|---|---|
| API 가용성 | 99.5% (월간) | downtime ≤ 3.6h/월 |
| API p95 응답 | 200ms | DataDog |
| 회원 예약 성공률 | 95%+ | 자체 메트릭 |
| AI 추천 생성 | < 3초 | DataDog |
| 결제 성공률 | 99%+ | PG 통계 |
| 푸시 전송 | 95%+ | FCM/APNs |
| 알림톡 전송 | 99%+ | Solapi |

## 알림 (Slack 즉시 알림)

### 🚨 Critical (5분 내 대응)
- API 다운 (1분 + 헬스체크 실패)
- 결제 실패율 > 5%
- 매칭 실패율 > 10%
- DB connection 고갈
- AI API 한도 초과·요금 폭증

### ⚠️ Warning (1시간 내 대응)
- API p95 > 500ms (5분+)
- 에러율 > 1%
- 디스크 사용률 > 80%
- 로그인 실패 폭증 (DoS·brute force)

### 📊 Daily Digest
- 오늘 가입·결제·예약 카운트
- 어제 대비 변화
- 멘토 시간당 매칭 비율

## 비용 모니터링

| 항목 | 모니터링 | 알림 |
|---|---|---|
| AI API (Claude·OpenAI) | LLMCallLog 테이블 | 일일 한도 초과 시 |
| AWS (ECS·RDS·S3) | Cost Explorer | 월간 예산 초과 |
| Vercel | Vercel 사용량 대시보드 | Pro 한도 임박 |
| Solapi (알림톡) | API 대시보드 | 월 한도 초과 |

## 데이터 모델 (자체 메트릭)

```typescript
interface MetricEvent {
  id: string
  type: 'reservation_created' | 'session_completed' | 'payment_succeeded' | ...
  payload: Record<string, any>
  recipientType?: string
  recipientId?: string
  storeId?: string
  occurredAt: string
}

interface ErrorLog {
  id: string
  level: 'error' | 'warn' | 'info'
  source: 'frontend' | 'backend' | 'cron' | 'webhook'
  message: string
  stackTrace?: string
  context: Record<string, any>
  loggedAt: string
}
```

## 운영 체크리스트 (1호점 오픈 직전)

- [ ] Sentry 프로젝트 설정 (frontend + backend)
- [ ] DataDog 또는 native 로그 수집 활성화
- [ ] Slack 알림 채널 (#alerts-critical / #alerts-warning / #daily-digest)
- [ ] SLO 대시보드 (Phase 1 측정값 기록)
- [ ] AI 비용 일일 한도 + 알림
- [ ] DB 백업 자동화 (RDS snapshot 일별)
- [ ] 운영자 별도 dashboard (회원·매칭·매출 KPI)

---

| 2026-05-13 | 초안 — 3축 (logs·metrics·traces) + SLO + 알림 + 비용 |
