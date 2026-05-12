---
title: 2026-05-13 멘토 등급 (시스템)
parent: 🏢 플랫폼
grand_parent: 스펙 (PRD)
nav_order: 5
---

# 🏢 멘토 등급·심사 시스템

**Status**: Draft
**관련 결정**: [3F 일반 멘토](../../partners/peer-leader.html) · [3H 품질·등급](../../partners/quality.html) · [3G 정산](../../partners/payout.html)
**📡 API**: [멘토](../../api/catalog.html#멘토-mentor) · [어드민](../../api/catalog.html#어드민-admin)
**🗄️ Data**: [8. Mentor System](../../data/08-mentor-system.html)

## 1. 핵심 컴포넌트

- **검증 코스 운영** (가입 → 일반 멘토)
- **Pro 인증 심사 워크플로우** (일반 → Pro 인증)
- **등급 평가 알고리즘** (회원 평점·재예약·기록 품질·운동 성과·출석)
- **단가 검증 (Pro 자율 단가 한도 enforcement)**
- **컴플레인 처리** (회원 → 멘토 등급 영향)

## 2. 검증 코스 (가입 단계)

- 운영자가 코스 일정 등록 → 멘토 신청 → 출석·과제·시범 → 합격 판정
- 코스 콘텐츠 (운동 안전·AI 사용·CS·시범) = 본사 운영팀 관리
- 합격 시 자동으로 `tier = verified` + 활동 가능

## 3. Pro 인증 심사

```
멘토 신청 → 본사 admin 큐 등록 → 심사 (영상·면담·필기)
  ├─ 통과 → tier = pro_certified + 단가 자율 권한 부여
  └─ 보류 → 코멘트와 함께 멘토에게 반환
```

심사 기준 (Phase 1 가설):
- 일반 활동 ≥ 100 세션
- 평균 평점 ≥ 4.3
- 재예약률 ≥ 60%
- 자격증 유효성 확인

## 4. 등급 평가 알고리즘 (TBD, [3H](../../partners/quality.html))

```
score = w1·rating + w2·rebook + w3·record_quality + w4·outcome + w5·attendance
```

Phase 1 = 단순 통과/보류 판정, Phase 2+ = 가중치 정밀화.

## 5. 데이터 모델

```
Mentor
  ├─ id, tier ENUM(verified, pro_certified)
  ├─ rating_avg, session_count, rebook_rate, record_quality_score
  ├─ pro_certified_at, pro_min_rate, pro_max_rate, pro_current_rate

VerificationCourse (검증 코스 회차)
  ├─ id, scheduled_at, attendees[], passed[]

ProCertificationApplication
  ├─ id, mentor_id, applied_at
  ├─ status ENUM(pending, approved, rejected)
  ├─ reviewer_admin_id, decision_notes, decided_at

MentorComplaint
  ├─ id, member_id, mentor_id, session_id, severity ENUM(low, medium, high)
  ├─ resolved (bool), resolution_notes
  ├─ tier_impact (bool) — 등급에 영향 줬는지

TierChange (감사 로그)
  ├─ id, mentor_id, from_tier, to_tier, reason, changed_at, changed_by
```

## 6. 컴플레인 처리 SOP

```
1차 (단발 컴플레인): 멘토에게 피드백 + 기록만
2차 (반복): 등급 보류·하향
3차 (심각 — 안전·예의 문제): 자격 정지 + 회원 환불
```

## 7. API 엔드포인트

- `POST /verification-courses` (admin) — 코스 일정 등록
- `POST /mentors/:id/verify` (admin) — 검증 통과 처리
- `POST /pro-applications` (mentor) — Pro 인증 신청
- `POST /pro-applications/:id/decide` (admin) — 심사 결정
- `PATCH /mentors/:id/rate` (mentor) — 단가 변경 (Pro만)
- `POST /complaints` (member) — 컴플레인 등록

## 8. 다른 레이어 영향

- **👤 유저**: 멘토 프로필 + Pro 인증 배지 + 컴플레인 신고 화면
- **💪 멘토**: 등급 보드 + 심사 신청 + 단가 설정 화면

## 9. 엣지 케이스

- 동시 심사 신청 폭증: 큐 시스템 (선착순 처리)
- 자격증 위조: 본사가 발행처 확인 (외부 API)
- Pro 인증 멘토 단가 자율인데 너무 높아 매칭 0: 멘토 본인이 조정

## 10. 측정 지표

- Pro 인증 심사 처리 SLA: 신청 후 영업일 7일
- 컴플레인 1차 해결률 ≥ 80%
- Pro 인증 멘토 풀 비율 ≥ 30% (전체 멘토 중)

---

| 2026-05-13 | 초안 |
