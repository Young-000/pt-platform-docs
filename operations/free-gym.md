---
title: 🟢 5D. 자유 헬스 운영 SOP
parent: 5. 운영
nav_order: 4
---

# 5D. 자유 헬스 운영 SOP

**🟢 신규 (2026-05-16)** · 의존: [ADR 0003](../decisions/0003-free-gym-add-on.html), [5A 예약](./reservation.html), [5B 지점 운영](./store.html), [5C 안전](./safety.html), [2D 정책](../members/policies.html)

> **컨셉**: 자유 헬스(오픈 공간 자유 이용)는 **멤버십 부가** — 회차권 보유 회원만 입장. 단독 결제 ❌. 회차 차감 ❌. ([ADR 0003](../decisions/0003-free-gym-add-on.html))

## 1. 출입 룰

- **회차권(1·4·12·24·48) 보유 회원**만 입장. 잔여 회차 1 이상 또는 만료 30일 이내까지.
- **앱 QR 체크인** — 게이트 출입. `FreeGymVisit` 레코드 생성.
- 입장 시 회차 소비 ❌ (멤버십 부가). Pro 옵션 포인트 차감 ❌.
- 멤버십 만료 후 30일 grace period 종료 시 자동 입장 불가.

## 2. 운영 시간

- 비피크 (6am-6pm, 10pm-12am): 자유 이용
- 피크 (6-10pm): 강사 세션 우선. 자유 헬스도 가능하지만 룸·기구 점유 시 강사 회원 우선.

## 3. 안전 가이드

- 자유 헬스는 **무인 시간대 운영 가능** — 비상 호출 SOP 필수 ([5C](./safety.html))
- 비상벨 + CCTV 24시간. 한 사람만 입장 시 자동 알림 (가맹점장 모니터링)
- AED·구급함 비치, 위치 안내
- 첫 입장 회원: 안전 가이드 영상 (앱 내) 시청 + 동의 체크박스

## 4. 비상 호출

- 비상벨 누를 시 (1) 가맹점장 모바일 (2) 본사 CS (3) 119 자동 연동 알림
- 사고 발생 시 [5C 안전](./safety.html) SOP 적용

## 5. 청소 주기

- 비피크 시간대: 4시간마다 청소 인력 순회 (1지점 기준)
- 회원 자율 — 사용 후 기구 닦기 (소독 티슈 비치)
- 일 1회 마감 청소 (자정 후)

## 6. FreeGymVisit 기록 흐름

```
1. QR 체크인 → FreeGymVisit { memberId, branchId, enterAt }
2. 게이트 체크아웃 또는 자동 마감(180분 무활동) → exitAt 채움
3. AI 대시보드: 회원의 자유 헬스 빈도·체류 시간 추적 → 멤버십 갱신 예측 지표
```

> 회차 소비 ❌, 정산 ❌. 운영 비용은 멤버십 가격에 흡수.

## 7. 정책 변수 (admin)

- `free_gym.enabled` (지점별 토글)
- `free_gym.grace_days_after_expiry` (기본 30)
- `free_gym.unmanned_hours` (무인 시간대 정의)
- `free_gym.max_session_minutes` (자동 체크아웃 기본 180)

---

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-16 | 신규 — Critical 리뷰 High 8건 fix. ADR 0003 운영 SOP 노드 신설 |
