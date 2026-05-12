---
title: 📣 알림 시스템
parent: 스펙 (PRD)
nav_order: 7
has_children: true
---

# 📣 알림 시스템

> Phase 1 런칭 필수. 예약·세션·결제·정산·매칭 알림.

## 채널

| 채널 | 용도 | 비용 |
|---|---|---|
| 푸시 (FCM·APNs) | 인앱 알림 (실시간) | 무료 |
| 카카오 알림톡 | 핵심 트랜잭션 (Solapi) | 회당 ~10원 |
| SMS | 알림톡 실패 시 fallback | 회당 ~20원 |
| 이메일 | 영수증·약관 변경·마케팅 | 무료 (자체 SMTP 또는 SendGrid) |
| 인앱 (벨 아이콘) | 모든 알림 보관 | 무료 |

## 알림 카테고리

### 트랜잭션 (필수, 옵트아웃 ❌)

- 예약 확정·변경·취소 (회원·멘토)
- 세션 임박 (T-1h, T-15분, T-5분)
- 매칭 (멘토에게 회원 매칭)
- 결제 성공·실패·갱신 알림
- 환불 처리
- 정산 입금 (멘토)
- 멘토 노쇼 보상

### 운영 (필수)

- 평가 요청 (T+90 후)
- 멘토 컴플레인 등록
- 등급 변동 (Pro 인증 통과·등급 보류)
- 일시정지 시작·종료
- 약정 만료 임박 (D-7)

### 마케팅 (옵트인, 별도 동의)

- 신규 멘토 추천
- 프로모션·이벤트
- AI 월간 분석

## 트리거 매트릭스

| 이벤트 | 회원 | 멘토 | 관리자 |
|---|---|---|---|
| 회원 예약 확정 | 푸시 + 알림톡 | 푸시 | - |
| 세션 임박 T-1h | 푸시 | 푸시 | - |
| 세션 임박 T-15분 | 푸시 | 푸시 (회원 정보) | - |
| 회원 노쇼 (T+15) | 푸시 (회차 차감) | - | 인앱 |
| 멘토 노쇼 (T+15) | 푸시 + 알림톡 (보상) | 푸시 (패널티) | 푸시 (긴급) |
| 멤버십 갱신 D-7 | 푸시 + 이메일 | - | - |
| 정산 입금 (격주) | - | 푸시 + 이메일 | - |
| Pro 인증 통과 | - | 푸시 + 이메일 | - |
| 컴플레인 등록 | 인앱 (접수 확인) | 푸시 + 이메일 | 푸시 (긴급) |
| 결제 실패 | 푸시 + 알림톡 | - | - |
| 6h 이내 취소 (회원) | 인앱 (회차 차감 안내) | 알림톡 (보상) | 인앱 |

## 데이터 모델

```typescript
type NotificationChannel = 'push' | 'kakao' | 'sms' | 'email' | 'in_app'
type NotificationType = 'transaction' | 'operations' | 'marketing'

interface NotificationTemplate {
  id: string
  type: NotificationType
  eventKey: string  // "session_imminent_t-1h"
  channels: NotificationChannel[]
  titleTemplate: string  // "{memberName}님 1시간 후 세션 시작"
  bodyTemplate: string
  kakaoTemplateCode?: string  // Solapi 템플릿 코드
}

interface NotificationDelivery {
  id: string
  templateId: string
  recipientType: 'member' | 'mentor' | 'admin'
  recipientId: string
  channel: NotificationChannel
  status: 'pending' | 'sent' | 'failed' | 'bounced'
  sentAt?: string
  payload: Record<string, any>
  errorMessage?: string
}

interface NotificationPreference {
  recipientType: string
  recipientId: string
  marketingOptIn: boolean
  channels: { push: boolean, kakao: boolean, sms: boolean, email: boolean }
}
```

## 카카오 알림톡 (Solapi)

- 본사 카카오 채널 (`@PT-Platform` 가설) 등록
- 알림톡 템플릿 사전 승인 (Solapi 콘솔)
- 회원·멘토에 휴대폰 본인 인증 시 동의 자동 처리
- 알림톡 실패 시 SMS fallback

## API 엔드포인트

- `POST /api/notifications/internal/send` — 시스템 내부 호출 (이벤트 기반)
- `GET /api/notifications/me` — 내 알림 리스트 (인앱)
- `PATCH /api/notifications/me/:id/read` — 읽음 처리
- `PATCH /api/notifications/me/preferences` — 채널·마케팅 설정

## 운영

- Queue 시스템 (Redis 등) — 알림 발송 비동기 처리
- 재시도 정책 (실패 시 5분·30분·2h 간격)
- 모니터링 (성공률·지연 시간)
- 옵트아웃 처리 (마케팅만 — 트랜잭션은 강제)

## 비용 추정 (Phase 1, 1지점)

- 회원 200명 × 월 평균 8 알림톡 = 1,600건 × 10원 = 16,000원/월
- 멘토 12명 × 월 100 알림 = 1,200건 × 10원 = 12,000원/월
- SMS fallback (10% 가정) = ~5,000원/월
- 푸시·이메일 = 무료
- **합 ≈ 33,000원/월/지점**

---

| 2026-05-13 | 초안 — 5채널 + 카테고리 + 트리거 매트릭스 + 데이터 모델 |
