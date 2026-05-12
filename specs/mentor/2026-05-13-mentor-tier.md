---
title: 2026-05-13 등급·Pro 인증 (멘토)
parent: 💪 멘토
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 💪 멘토 등급·Pro 인증

**Status**: Draft
**관련 결정**: [3F 일반 멘토](../../partners/peer-leader.html) · [3H 품질·등급](../../partners/quality.html) · [3G 정산](../../partners/payout.html) · [4A 세션 종류](../../service/session-types.html)

## 1. 멘토 등급 구조

```
[지원자]
   │ 본사 검증 코스 통과 (운동 안전·AI 사용·커뮤니케이션·시범)
   ▼
[일반 멘토] — 회당 고정 단가
   │ 자격증 취득 + 본사 심사 통과
   ▼
[Pro 인증 멘토] — 회당 자율 단가 (본사 min~max 한도 내)
```

## 2. 멘토 시나리오

| 흐름 | 액션 |
|---|---|
| 가입 | 자격증·이력 업로드 → 검증 코스 신청 |
| 검증 코스 | 4-8h 교육 (운동·AI·CS·안전) + 시범 세션 → 합격 시 일반 멘토 활동 |
| Pro 인증 신청 | 일정 세션 수·평점 도달 시 신청 가능 |
| 본사 심사 | 세션 영상 평가 + 면담 + 필기 (변경 가능) |
| Pro 인증 통과 | 회당 자율 단가 권한 부여 |
| 단가 설정 | 본사 min~max 한도 내 자율 설정 (변경 가능) |

## 3. 화면 요구사항

### 가입·검증 화면
- 자격증 업로드 + 운동 경력 입력
- 검증 코스 일정·진행 상황
- 시범 세션 영상 업로드

### 등급 보드
- 현재 등급 (일반 / Pro 인증)
- 진행률 (Pro 인증 자격 조건 — 세션 수·평점)
- 다음 등급 도달 조건 시각화

### Pro 인증 신청 화면
- 자격 조건 충족 시 활성화
- 신청 → 본사 심사 일정 잡힘
- 심사 결과 알림

### 단가 설정 (Pro 인증만)
- 일반 회당 단가 = 본사 고정 (변경 ❌)
- Pro 인증 자율 단가 = 슬라이더 (min ~ max 한도)
- 설정 변경 시 = 다음 결제부터 적용

### 세션 기록 품질 표시
- 본인 평가 + 회원 평점 평균 + 재예약률
- 등급 평가 입력값으로 사용됨을 안내

## 4. 등급 평가 지표 (원칙만, 세부 TBD — [3H](../../partners/quality.html))

- 회원 평점
- 재예약률
- 세션 기록 품질
- 회원 운동 성과
- 출석·노쇼율

→ 가중치·임계값은 1호점 데이터 후 결정.

## 5. 데이터 모델

```
Mentor
  ├─ id, profile, license_url (자격증)
  ├─ tier ENUM(verified, pro_certified)
  ├─ session_count, average_rating, rebook_rate
  ├─ pro_min_rate, pro_max_rate, pro_current_rate (Pro만)

MentorVerification (검증 코스 이수)
  ├─ id, mentor_id, course_completed_at, demo_session_passed
  ├─ approved_by (admin_id), approved_at

ProCertification (Pro 인증 심사)
  ├─ id, mentor_id, applied_at
  ├─ status ENUM(pending, approved, rejected)
  ├─ review_notes, decided_at, decided_by
```

## 6. 다른 레이어 영향

- **👤 유저**: 멘토 프로필 화면에 "Pro 인증" 배지 노출 → 회원 선택·포인트 차감
- **🏢 플랫폼**: 심사 워크플로우·등급 평가 알고리즘·단가 검증

## 7. 엣지 케이스

- 검증 코스 불합격: 재시도 가능 (X개월 후)
- Pro 인증 후 평점·재예약 하락: 등급 보류 또는 강등 (3H 룰 따라)
- Pro 인증 자율 단가가 너무 높아 매칭 안 됨: 멘토 본인이 조정

## 8. 측정 지표

- 검증 코스 통과율 ≥ 80%
- Pro 인증 통과율 ≥ 50% (신청 대비)
- Pro 인증 멘토 평균 평점 ≥ 4.5

---

| 2026-05-13 | 초안 |
