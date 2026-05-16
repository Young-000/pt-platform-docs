---
title: 2026-05-13 세션 시스템 (백엔드)
parent: 🏢 플랫폼
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 🏢 세션 시스템 (플랫폼 백엔드)

**Status**: 🟡 Updated (2026-05-16) · v2 본문 적용
**관련 결정**: [ADR 0001](../../decisions/0001-consumer-pivot.html) · [ADR 0002](../../decisions/0002-license-policy.html) · [ADR 0003](../../decisions/0003-free-gym-add-on.html) · [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html)
**의존**: [4A 세션 종류](../../service/session-types.html) · [4B 포맷](../../service/session.html) · [4D 공간](../../service/space.html) · [4C AI 역할](../../service/ai-role.html) · [5A 예약](../../operations/reservation.html) · [5D 자유 헬스](../../operations/free-gym.html)
**📡 API**: [v2 예약](../api/v2-reservations.html) · [v2 카테고리](../api/v2-categories.html) · [v2 자유 헬스](../api/v2-free-gym.html)
**🗄️ Data**: [3. Schedule](../data/03-schedule.html) · [4. Reservation](../data/04-reservation.html) · [5. Records](../data/05-records.html) · [6. AI](../data/06-ai.html)

{: .note }
> **v2 (2026-05-16)**: 90분 세트(카디오 30 + 방 60) 모델·CardioSlot·stagger 알고리즘은 **폐기** ([ADR 0001](../../decisions/0001-consumer-pivot.html)). 세션 단위 = **30분 unit** (60분 = 2 unit 연속). 다종목 코스(스트레칭·필라테스·1:1 PT·자유 헬스)를 카테고리·프로그램 마스터로 분기.

## 1. 배경

본사 시스템이 슬롯·예약·세션 기록·AI 학습을 책임. 회원·강사 모두 본사 시스템 위에서 움직임. v2는 예약 흐름이 **회원 직접 선택**으로 단순화됐고, 세션도 **카테고리에 따라 체크인·공간 사용 분기**가 명확해졌다.

## 2. 핵심 컴포넌트

### A. MentorBlock 스케줄러

- 강사가 본인 가능 시간을 **30분 unit**으로 자유 오픈 (`status='open'`)
- 회원 예약 시 1개 또는 연속 2개 점유 (`status='assigned'`)
- 강사 취소(6h 이내)는 모든 영향 회원에게 회차 +1 보상

### B. Room 자동 배정

- 카테고리 `requiresPrivateRoom=true`만 룸 점유
- 예약 트랜잭션에서 가용 Room 1개 자동 lock & 배정
- 룸 부족이면 `INSUFFICIENT_ROOM` (회원 다른 시간/오픈 공간 카테고리 안내)

### C. 체크인 분기

| 카테고리 종류 | 체크인 흐름 |
|---|---|
| 룸 필요 (`requiresPrivateRoom=true`) | QR 체크인 → 배정된 `assignedRoomId` 입장 |
| 오픈 공간 강사 코스 (PT) | QR 체크인 → 오픈 공간 대기 → 강사가 호출 |
| 자유 헬스 (`requiresMentor=false`) | 별도 게이트 — `POST /api/free-gym/enter` (예약 ❌, 회차 차감 ❌) |

체크인 윈도우: `startAt - 15m` ~ `startAt + 15m`. T+15 미체크인 → cron이 `no-show` 전환 + 회차 차감.

### D. AI 운동 설계

- 입력: 회원 직전 N세션 SessionRecord + 카테고리/프로그램 표준 시퀀스 + 강사 인계 메모 + 회원 컨디션
- 출력: 다음 세션 운동 시퀀스 (30분 unit 기준)
- 다종목 회원의 경우 카테고리별 별도 트랙 (스트레칭 이력 / PT 이력 분리)

### E. 세션 기록 (SessionRecord)

- 강사가 세션 종료 시 작성 (5분 내 입력 가능한 표준 schema)
- 운동·세트·중량·rep·폼·인계 메모·회원 컨디션
- AI 학습 데이터로 누적, 회원이 본인 이력 열람 가능

## 3. 데이터 모델

```
Member
  ├─ id, profile, persona signals
  └─ exercise history (joined)

Mentor
  ├─ id, profile, tier (pending_review / verified / pro_certified / rejected)
  └─ MentorProgram[] (매핑한 프로그램)

MentorBlock (30분 unit)
  ├─ id, mentorId, startAt, status (open / assigned / closed)

Room (지점 private 룸)
  ├─ id, storeId, name, capacity=1

Reservation
  ├─ id, memberId, mentorId, programId, categoryId
  ├─ startAt, duration (30 / 60), unitCount (1 / 2)
  ├─ mentorBlockIds (Int[]), assignedRoomId?
  ├─ ticketId, isPro, pointsCharged
  └─ status

Session (1 reservation = 1 session)
  ├─ id, reservationId
  ├─ checkedInAt?, startedAt?, endedAt?
  └─ status (booked / checked-in / in-progress / completed / no-show / cancelled)

SessionRecord (강사 입력, 1 session = 0..1 record)
  ├─ id, sessionId
  ├─ exercises (jsonb): [{name, sets, weight, reps, ...}]
  ├─ formNotes (text)
  ├─ handoverNotes (text, AI 학습용)
  ├─ memberCondition (text)
  └─ createdAt

FreeGymVisit (자유 헬스 — 세션 ❌, 별도 모델)
  ├─ id, memberId, storeId
  ├─ enteredAt, exitedAt?, autoClosed (bool)
  └─ ticketSnapshot (jsonb)

AIRecommendation
  ├─ id, memberId, categoryId, generatedAt
  ├─ nextSessionPlan (jsonb)
  └─ sourceRecordIds (Int[])

Rating
  ├─ id, sessionId, memberId, mentorId, score (1-5), comment
```

## 4. API 엔드포인트 (주요)

| Method | Path | 비고 |
|---|---|---|
| POST | `/api/reservations` | 예약 생성 ([v2 예약 §2](../api/v2-reservations.html)) |
| POST | `/api/mentor-blocks` | 강사 슬롯 오픈 (30분 unit) |
| GET | `/api/sessions/today` | 회원·강사 오늘 일정 |
| POST | `/api/reservations/:id/check-in` | QR 체크인 (룸/오픈) |
| POST | `/api/free-gym/enter` | 자유 헬스 입장 ([v2 자유 헬스](../api/v2-free-gym.html)) |
| POST | `/api/free-gym/exit` | 자유 헬스 퇴장 |
| POST | `/api/sessions/:id/record` | 강사 세션 기록 저장 |
| GET | `/api/members/:id/next-recommendation?categoryId=` | AI 다음 운동 제안 |
| POST | `/api/sessions/:id/rating` | 회원 평가 |

## 5. 세션 운영 흐름 (예시)

### 룸 코스 (스트레칭 30분)

```
T-15  회원 QR 체크인 → Session.checkedInAt, 배정된 Room 입장
T+0   강사 시작 → Session.startedAt, status='in-progress'
T+30  강사 종료 + SessionRecord 입력 → Session.endedAt, status='completed'
       AI 학습 큐에 enqueue
```

### 오픈 공간 PT (60분 = 2 unit)

```
T-15  회원 QR 체크인 → 오픈 공간 대기
T+0   강사 호출 → 세션 시작
T+60  강사 종료 + SessionRecord 입력
       MentorBlock 2개 모두 status='closed'
```

### 자유 헬스

```
회원 게이트 QR → POST /api/free-gym/enter
  FreeGymVisit { enteredAt, ticketSnapshot } insert (회차 차감 ❌)
운동 (강사 ❌)
게이트 exit 또는 180분 후 cron auto-close
  exitedAt 채움, autoClosed=true
```

## 6. AI 추천 룰 (v1 유지, 30분 unit 적용)

- 카테고리별 별도 트랙 (스트레칭/PT/필라테스 이력 분리 학습)
- 직전 N세션(default 5)의 SessionRecord + 강사 handoverNotes 가중치 우선
- 표준 프로그램 시퀀스 = 카테고리 마스터의 기본 템플릿
- 회원 컨디션 입력 시 강도 자동 조정
- 출력 단위 = 30분 unit (60분 예약이면 2 unit 합성)

## 7. 다른 레이어 영향

- **👤 유저 앱**: 예약(카테고리·강사 직접 선택)·체크인·AI 가이드·평가 UI는 이 API 위에서
- **💪 강사 앱**: MentorBlock 오픈·일정·세션 기록·정산 UI도 이 API 위에서
- **🛠 admin**: 카테고리·프로그램·정책·세션 모니터링 ([어드민 콘솔](./2026-05-13-admin-console.html))

## 8. 엣지 케이스

- 강사 노쇼(T+30m 체크인·세션 기록 ❌): 회원 회차 +1 자동 보상 (cron)
- 회원 부상 중도 종료: 강사가 `endedAt` 조기 입력 + SessionRecord에 사유 명기, 운영 검토 후 회차 환원
- 자유 헬스 활성 visit 1건 제한: `ALREADY_INSIDE` 에러
- 자유 헬스 180분 초과: cron auto-exit (`autoClosed=true`)
- 카테고리 비활성화: 진행 중 세션 무영향, 신규 예약만 차단

## 9. 측정 지표

- API p95 응답 < 200ms (체크인·세션 조회)
- 예약 생성 p95 < 500ms (트랜잭션 전체, [예약 시스템 §10](./2026-05-13-reservation-system.html))
- AI 추천 생성 < 3초
- 세션 기록 입력률 ≥ 95% (강사 SLA: 종료 후 5분 이내)
- 룸 부족 비율 < 5% (피크)

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-13 | 초안 (v1) — 카디오+방 90분 세트, 30분 stagger, CardioSlot 모델 |
| 2026-05-16 | v2 본문 재작성 — 90분 세트·CardioSlot·stagger 폐기, 30분 unit MentorBlock + 카테고리 분기 체크인(룸/오픈/자유 헬스) + Room 자동 배정 ([ADR 0001](../../decisions/0001-consumer-pivot.html), [ADR 0003](../../decisions/0003-free-gym-add-on.html)) |
