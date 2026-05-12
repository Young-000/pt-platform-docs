---
title: 2026-05-13 세션 시스템 (백엔드)
parent: 🏢 플랫폼
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 🏢 세션 시스템 (플랫폼 백엔드)

**Status**: Draft
**관련 결정**: [4A 세션 종류](../../service/session-types.html) · [4B 포맷](../../service/session.html) · [4D 공간](../../service/space.html) · [4C AI 역할](../../service/ai-role.html) · [5A 예약](../../operations/reservation.html)

## 1. 배경

본사 시스템이 슬롯 스케줄링·매칭·세션 데이터·AI 학습을 책임. 회원·멘토 둘 다 본사 시스템 위에서 움직임.

## 2. 핵심 컴포넌트

### A. 슬롯 스케줄러

- **방 슬롯**: 60분 단위, 30분 stagger (정각 4방 + 30분 4방)
- **카디오 슬롯**: 30분 단위, 자리 수 = 6
- **방 슬롯의 멘토 점유**: 방 60분 중 멘토 30분 (T+30~T+60) — 멘토 입장에서 별도 트랙
- **회원 예약 = 카디오 30 + 방 60 연속 세트**

### B. 멘토 매칭

- 슬롯 오픈 시 = 멘토가 본인 가능 슬롯을 30분 단위로 등록 (1시간 = 2 슬롯)
- 회원 예약 시 AI가 가능한 멘토 3명 추천 (수동 모드) 또는 자동 매칭 (자동 모드)
- 이전 멘토 우선 매칭 (회원 익숙함 + 멘토 인수인계 연속성)
- 회원 24h 거절권: 거절 시 다른 멘토 재매칭

### C. AI 운동 설계

- 입력: 회원 직전 N세션 기록 + 본사 표준 프로그램 + 회원 컨디션
- 출력: 다음 세션 운동 시퀀스 (자율 30분 + 멘토 30분)
- 강사 인계 메모도 입력에 포함 (암묵지 명시화)

### D. 세션 기록 저장

- 세션마다 표준 schema로 저장 (운동·세트·중량·rep·폼·인수인계·컨디션)
- AI 학습 데이터로 누적
- 회원 본인이 열람 가능 (운동 이력 시각화)

## 3. 데이터 모델

```
Member (회원)
  ├─ id, profile, persona signals
  └─ exercise history (joined)

Mentor (멘토)
  ├─ id, profile, 인증 등급 (일반 / Pro 인증)
  └─ slot opens (joined)

Room (방, 지점당 8개)
  ├─ id, store_id, capacity
  └─ slots (joined)

CardioSeat (카디오 자리, 지점당 6)
  ├─ id, store_id

RoomSlot (방 60분 슬롯, 30분 stagger)
  ├─ id, room_id, start_at (정각 / 30분)
  ├─ member_id (예약 시), status

CardioSlot (카디오 30분 슬롯)
  ├─ id, seat_id, start_at, member_id

MentorBlock (멘토 30분 단위 가능 시간)
  ├─ id, mentor_id, start_at, status (open/assigned)

Session (회원 1세션 = 카디오 + 방 + 멘토 30분 묶음)
  ├─ id, member_id, mentor_id (방의 T+60 30분 동안의 멘토)
  ├─ cardio_slot_id, room_slot_id, mentor_block_id
  ├─ status (booked / checked-in / in-progress / completed / no-show / cancelled)

SessionRecord (멘토 입력)
  ├─ id, session_id
  ├─ exercises (jsonb): [{name, sets, weight, reps, ...}]
  ├─ form_notes (text)
  ├─ handover_notes (text, AI 학습용)
  ├─ member_condition (text)

AIRecommendation (다음 세션 추천)
  ├─ id, member_id, generated_at
  ├─ next_session_plan (jsonb)
  ├─ source: 최근 N세션 기록 IDs

Rating (회원 평가)
  ├─ id, session_id, member_id, mentor_id, score (1-5), comment
```

## 4. API 엔드포인트 (주요)

- `POST /reservations` — 회원 예약 생성 (카디오+방+멘토 동시 점유)
- `POST /mentor/slots` — 멘토 슬롯 오픈
- `GET /sessions/today` — 회원·멘토 오늘 일정
- `POST /sessions/:id/check-in` — 회원 QR 체크인
- `POST /sessions/:id/record` — 멘토 세션 기록 저장
- `GET /members/:id/next-recommendation` — AI 다음 운동 제안
- `POST /sessions/:id/rating` — 회원 평가

## 5. 슬롯 stagger 알고리즘 (예시)

```
시각  | 방 A (정각 시작) | 방 B (30분 시작) | 카디오 자리 사용
12:00 | 회원 X 방 입장   | 회원 W 진행 중   | 회원 Y가 12:00-12:30 사용
12:30 | 회원 X 자율 끝, 멘토 입장 | 회원 W 종료, 청소 | 회원 Z가 12:30-13:00 사용
13:00 | 회원 X 종료, 청소 | 회원 Y 방 입장 | 회원 A가 13:00-13:30 사용
13:30 | 회원 Z 방 입장 | 회원 Y 자율 끝, 멘토 입장 | ...
```

→ 멘토 1명이 12:30~13:00 방 A, 13:30~14:00 방 B 식으로 1시간에 2 회원.

## 6. 다른 레이어 영향

- **👤 유저**: 예약·체크인·AI 가이드·평가 UI는 이 API 위에서
- **💪 멘토**: 슬롯 오픈·일정·세션 기록·정산 UI도 이 API 위에서

## 7. 엣지 케이스

- 멘토 슬롯과 방 슬롯 매칭 실패 (멘토 풀 부족): 회원에게 예약 불가 안내 + 대기 큐
- 카디오 자리 부족 (6자리 < 동시 회원 8명): 회원 동선 stagger로 4명씩 카디오 → 시간 안 맞으면 거절
- 세션 중 회원 부상: 즉시 종료 처리 + 회차 보상

## 8. 측정 지표

- 슬롯 매칭 성공률 ≥ 95%
- API p95 응답 200ms 이내
- AI 추천 생성 시간 < 3초

---

| 2026-05-13 | 초안 |
