---
title: 🟢 5D. 자유 헬스 운영 SOP
parent: 5. 운영
nav_order: 4
---

# 5D. 자유 헬스 운영 SOP

**🟢 신규 (2026-05-16) · 포지셔닝 메모 추가 (2026-06-04)** · 의존: [ADR 0003](../decisions/0003-free-gym-add-on.html), [ADR 0011](../decisions/0011-recovergx-gx-pivot.html), [5A 예약](./reservation.html), [5B 지점 운영](./store.html), [5C 안전](./safety.html), [2D 정책](../members/policies.html)

> **컨셉**: 자유 헬스(오픈 공간 자유 이용)는 **GX 레일과 분리된 멤버십 부가** — 지갑 잔액 보유 회원만 입장. 단독 결제 ❌. 드롭인 차감 ❌.
>
> **포지셔닝**: 자유 헬스의 차별점은 AI 코치가 아니라 **싸고 편한 접근성**. 가까운 거리·충분한 운영 시간·낮은 가격으로 포지셔닝. AI 코치는 GX 클래스 레일에서 부가 가치로 작동. ([ADR 0003](../decisions/0003-free-gym-add-on.html), [ADR 0011](../decisions/0011-recovergx-gx-pivot.html))

## 1. 출입 룰

- **지갑 잔액 보유 회원**만 입장. 잔액 1원 이상 또는 만료 30일 이내까지.
- **앱 QR 체크인** — 게이트 출입. `FreeGymVisit` 레코드 생성.
- 입장 시 지갑 차감 ❌ (멤버십 부가). Pro 옵션 포인트 차감 ❌.
- 멤버십 만료 후 30일 grace period 종료 시 자동 입장 불가.

## 2. 운영 시간

- 비피크 (6am-6pm, 10pm-12am): 자유 이용
- 피크 (6-10pm): GX 클래스 우선. 자유 헬스도 가능하지만 룸·기구 점유 시 클래스 회원 우선.

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
3. 대시보드: 회원의 자유 헬스 빈도·체류 시간 추적 → 멤버십 갱신 예측 지표
```

> 지갑 차감 ❌, 정산 ❌. 운영 비용은 멤버십 가격에 흡수.

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
| 2026-06-04 | recoverGX 피벗 — 포지셔닝 메모 추가 (접근성 중심, AI 코치 차별점 배제). GX 클래스 피크 충돌 규칙 명시. 회차권 → 지갑 잔액 용어 통일 ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html)) |
