---
title: 🟢 5A. 예약 시스템
parent: 5. 운영
nav_order: 1
---

# 5A. 예약 시스템

**🟢 Updated (2026-06-04)** · 의존: [ADR 0011](../decisions/0011-recovergx-gx-pivot.html), [4B 세션 포맷](../service/session.html), [4D 공간](../service/space.html), [2B 멤버십](../members/membership.html), [3E 강사 모델](../partners/model.html), [2D 정책](../members/policies.html)

## 예약 단위

회원 1예약 = **그룹 클래스 1세션 드롭인**. 룸당 시간당 1세션 배타 운영 (`@@unique[roomId, startAt]`). 정원(capacity) 초과 예약 불가.

## 예약 흐름 (drob-in)

```
1. 회원이 지점 선택
2. 날짜 선택 → 당일 클래스 시간표 탐색 (시간·종류·강사·잔여석)
3. 원하는 클래스 선택 (bookedCount < capacity 가드)
4. 지갑 차감 확인 → 예약 확정 (bookedCount 원자적 +1)
5. 입장일 QR 체크인
```

> 룸 배정은 클래스 생성 시점에 확정 (회원 워크인 ❌). 잔여석이 0이면 예약 버튼 비활성.

## 시간표 구성

- 강사가 클래스를 등록할 때 `roomId · startAt · capacity` 지정
- **배타 제약** (`@@unique[roomId, startAt]`): 같은 룸·같은 시각에 중복 클래스 생성 불가
- 클래스 종류·정원은 admin `ClassConfig`에서 관리

## 피크 시간 (6-10pm)

- 인기 시간표는 선착순 드롭인
- 정원 소진 → 대기 등록 (Phase 2 검토)

## 비피크 시간

- 14일 전부터 자유 예약 가능 (선착순)
- 모든 회원 동일 오픈 시점

## 변경·취소 룰

| 시점 | 처리 |
|---|---|
| 6h 전까지 | 무료 취소 (지갑 환불 + bookedCount -1) |
| 6h 이내 | 환불 없음 (0원). 좌석은 복구 |
| 폐강 (강사 취소) | 전원 100% 환불 + bookedCount 초기화 |

> 취소 시 좌석 즉시 복구 — 대기 회원 알림(Phase 2). 폐강 처리는 admin에서 강사 또는 운영자가 트리거.

## 다이나믹 프라이싱

Phase 1 ❌ / Phase 2+ 검토.

---

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-12 | 옵션 검토 |
| 2026-05-16 | v2 본문 정합 갱신 — 강사+프로그램 예약·30분 unit·룸 자동 배정 ([ADR 0001](../decisions/0001-consumer-pivot.html)) |
| 2026-06-04 | recoverGX 피벗 — 1:1 슬롯 예약 → 그룹 클래스 드롭인 전환 ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html)). 시간표 탐색·잔여석·원자적 점유·폐강 환불 SOP 반영 |
