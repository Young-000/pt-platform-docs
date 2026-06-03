---
title: 4. 서비스
nav_order: 5
has_children: true
---

# 4. 서비스 (Service / What)

> 우리가 회원에게 무엇을 제공하는가. **GX 그룹 클래스 + 어드민 큐레이션 룰 + 공간**의 결합. ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html))

## 결정 노드 (Level 4)

- [4A. 클래스 종류 — 어드민 큐레이션 GX 카테고리](./session-types.html)
- [4B. 클래스 포맷 — 그룹 클래스 (정원 N, 룸 배타)](./session.html)
- [4C. AI 역할 범위 — GX 레일 보류](./ai-role.html)
- [4D. 공간 구조 — 60평 (룸 + 오픈)](./space.html)

## 핵심 원칙

- **그룹 클래스(1:N)** — 정원 N명(기본 20). 1:1 PT 레일은 보류 ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html)).
- **드롭인 예약** — 지점 → 날짜 → 시간표에서 잔여석 확인 후 즉시 예약. 약정·티어 없음.
- **어드민 큐레이션** — 어드민이 카테고리·가격 상한/하한·강사 개설 권한을 정의. 강사는 룰 안에서 클래스 개설.
- **AI는 GX 레일에서 보류** — 데이터 플라이휠·AI 코칭은 1:1 PT 레일 자산. GX는 접근성·큐레이션·입소문으로 승부.
