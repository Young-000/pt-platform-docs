---
title: 5. 운영
nav_order: 6
has_children: true
---

# 5. 운영 (Operations)

> 회원·강사·지점이 일상적으로 어떻게 작동하는가. **회원 운영 흐름이 1순위**.

## 결정 노드 (Level 5)

- [5A. 예약 시스템 — 그룹 클래스 시간표 드롭인](./reservation.html) ★ user flow
- [5B. 지점 운영 — 무인/유인·시간·SOP](./store.html)
- [5C. 안전·보험·사고처리](./safety.html)
- [5D. 자유 헬스 운영 SOP](./free-gym.html) (GX 레일과 분리된 접근성 채널)
- [5E. 1호점 OPEN 체크리스트 (D-30 → D-Day)](./launch-checklist.html) 🟢 신규

## 회원 일상 흐름 (User Flow)

```
앱에서 지점 → 날짜 → 클래스 시간표 탐색 (잔여석 확인) → 드롭인 예약(지갑 차감) → 입장(QR) → 그룹 클래스 → 퇴장
```

> recoverGX 피벗: 1:1 PT 슬롯 예약 → 그룹 클래스 드롭인 전환 ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html)). 자유 헬스는 GX 레일과 분리된 접근성 포지션 ([ADR 0003](../decisions/0003-free-gym-add-on.html)).

각 단계의 룰·SOP가 위 결정 노드에서 정의됩니다.

> 세션 종류·포맷·AI·공간 (Level 4 서비스 정의)는 [4. 서비스](../service/) 카테고리 참고.
