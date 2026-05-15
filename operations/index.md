---
title: 5. 운영
nav_order: 6
has_children: true
---

# 5. 운영 (Operations)

> 회원·강사·지점이 일상적으로 어떻게 작동하는가. **회원 운영 흐름이 1순위**.

## 결정 노드 (Level 5)

- [5A. 예약 시스템 — 강사+프로그램 자율 선택](./reservation.html) ★ user flow
- [5B. 지점 운영 — 무인/유인·시간·SOP](./store.html)
- [5C. 안전·보험·사고처리](./safety.html)
- [5D. 자유 헬스 운영 SOP](./free-gym.html) (ADR 0003 — 멤버십 부가)

## 회원 일상 흐름 (User Flow)

```
앱에서 강사+프로그램 선택 (30분 unit) → 입장(QR) → 세션 (룸 또는 오픈 공간) → 세션 기록 → 퇴장 → AI 다음 추천
```

> v2: 룸은 프로그램 속성에 따라 자동 배정 ([ADR 0001](../decisions/0001-consumer-pivot.html)). 자유 헬스는 강사 코스 회원에게만 부가 ([ADR 0003](../decisions/0003-free-gym-add-on.html)).

각 단계의 룰·SOP가 위 결정 노드에서 정의됩니다.

> 세션 종류·포맷·AI·공간 (Level 4 서비스 정의)는 [4. 서비스](../service/) 카테고리 참고.
