---
title: 💪 멘토
parent: 스펙 (PRD)
nav_order: 2
has_children: true
---

# 💪 멘토 (강사 앱) PRDs

{: .warning }
> **PT 레일 (보류)** — 이 섹션은 1:1 PT 모델 기준이다. 2026-06 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) GX 피벗으로 제품 레일이 GX 그룹 클래스로 전환됐다. GX 정본 스펙 = 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`. 1:1 PT 레일 부활 시 본 스펙 재사용.

### GX 대응 요약

GX 전환 후 강사 앱의 핵심이 바뀐다: 강사가 **GX 클래스 시간표를 등록**하고, 수강 회원의 그룹 출석을 관리. 슬롯 ON/OFF 대신 GX 클래스 개설(`gxOpenEnabled` 권한 필요). P1~P5 등급 체계가 verified/pro_certified를 대체하며, 정산은 기본금 + 인당 보너스 + 매출 비율% **조합형**으로 확장된다.

멘토(자격증 보유 Pro 인증 / 일반)가 보고 사용하는 화면·기능·플로우.

대응 코드: `pt-platform/apps/partner/`.

## PRDs

1. [세션 진행 (1시간 = 2 회원)](./2026-05-13-session-flow.html)
2. [슬롯 오픈·매칭](./2026-05-13-reservation.html)
3. [등급·Pro 인증](./2026-05-13-mentor-tier.html)
4. [정산 (격주)](./2026-05-13-payout.html)
