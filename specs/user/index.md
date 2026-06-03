---
title: 👤 유저
parent: 스펙 (PRD)
nav_order: 1
has_children: true
---

# 👤 유저 (회원 앱) PRDs

{: .warning }
> **PT 레일 (보류)** — 이 섹션은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

### GX 대응 요약

GX 전환 후 회원 앱의 핵심 흐름이 바뀐다: **지갑 충전 → 시간표 드롭인 예약 → 출석**. 멤버십·결제 화면은 지갑 잔액·충전·드롭인 내역으로 재편되고, 예약 화면은 GX 클래스 시간표(요일·시간·강사·정원 현황)를 탐색·예약하는 흐름으로 바뀐다. 세션 흐름은 그룹 체크인·클래스 출석으로 전환되며, AI 가이드는 GX 레일에서 보류된다.

회원이 직접 보고 사용하는 모든 화면·기능·플로우.

대응 코드: `pt-platform/apps/mvp/`.

## PRDs

1. [세션 진행 (30분 unit 흐름)](./2026-05-13-session-flow.html)
2. [멤버십·결제·정책](./2026-05-13-membership-payment.html)
3. [예약 시스템](./2026-05-13-reservation.html)
4. [AI 가이드 (시스템 PT)](./2026-05-13-ai-coaching.html)
