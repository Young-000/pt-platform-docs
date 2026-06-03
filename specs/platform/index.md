---
title: 🏢 플랫폼
parent: 스펙 (PRD)
nav_order: 3
has_children: true
---

# 🏢 플랫폼 (본사) PRDs

{: .warning }
> **PT 레일 (보류)** — 이 섹션은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

### GX 대응 요약

GX 전환으로 어드민 콘솔에 **recoverGX 섹션**이 추가된다: GX 클래스(시간표) 관리, 강사별 GX 개설 권한(`gxOpenEnabled`), GX 룰(정원·예약 창·취소 정책) 설정, GX 정산(기본금 + 수강 인당 보너스 + 매출 비율% 조합형). 멤버십 시스템은 지갑 충전 → 드롭인 차감 모델로, 예약 시스템은 시간표 기반 그룹 예약으로, 세션 시스템은 그룹 출석 체크로 각각 확장된다. P1~P5 강사 등급 체계 및 조합형 정산 구조는 PT 레일의 S1/S2·Pro 체계를 GX 레일로 계승한다.

본사 운영 시스템·어드민·API·데이터·AI 시스템.

대응 코드: `pt-platform/apps/admin/`, `pt-platform/apps/api/`, `pt-platform/packages/db/`.

## PRDs

1. [세션 시스템 — 슬롯·매칭·기록](./2026-05-13-session-system.html)
2. [멤버십·결제·정책 시스템](./2026-05-13-membership-system.html)
3. [예약 시스템 — 매칭·우선권·정책](./2026-05-13-reservation-system.html)
4. [AI 엔진 — 시스템 PT 추천](./2026-05-13-ai-engine.html)
5. [멘토 등급·심사 시스템](./2026-05-13-mentor-tier-system.html)
6. [정산·자동 분배 시스템](./2026-05-13-payout-system.html)
