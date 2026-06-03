---
title: 스펙 (PRD)
nav_order: 9
has_children: true
---

# 스펙 (PRD)

> 결정된 시스템을 **실제 코드로 구축**하기 위한 명세 문서.

{: .highlight }
> **recoverGX 피벗 (2026-06-03)**: 플랫폼이 1:1 PT에서 **GX 오픈 플랫폼**으로 전환됨 ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html)). 아래 PRD 매트릭스의 PT 레일 문서는 **보류 상태**이며, GX 신규 구현이 현재 활성 스펙. 정본: `pt-platform/docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md`.

## 3-레이어 구조

PRD는 stakeholder별로 분리:

- **[👤 유저](./user/)** — 회원 앱
- **[💪 멘토](./mentor/)** — 강사 앱
- **[🏢 플랫폼](./platform/)** — 본사·API·어드민·AI

각 PRD는 하나의 기능 단위. cross-layer 영향이 있으면 각 layer에서 상호 참조.

## 기능별 PRD 매트릭스

### GX 오픈 플랫폼 (현재 활성)

| 기능 | 구현 상태 | 정본 |
|---|---|---|
| 지갑·충전·드롭인 예약 | ✅ 구현 완료 | [결제 흐름](./payments/flow.html) · [데이터 7](./data/07-membership.html) |
| GX 클래스 개설·시간표 | ✅ 구현 완료 | [API 카탈로그](./api/catalog.html) |
| GX 정산 (조합형 정책) | ✅ 구현 완료 | [정산·세무](./payments/settlement.html) · [데이터 9](./data/09-payout.html) |
| 어드민 룰 (정책·패키지·검증) | ✅ 구현 완료 | [API 카탈로그](./api/catalog.html) |

### PT 레일 (보류)

{: .warning }
> 아래 PRD는 1:1 PT 모델 기준 초안. 코드·라우트는 보존되어 있으나 UI에서 숨겨진 상태. recoverGX 이후 재활성화 여부 미결정.

| 기능 | 👤 유저 | 💪 멘토 | 🏢 플랫폼 |
|---|---|---|---|
| 세션·멘토 모델 | [Draft](./user/2026-05-13-session-flow.html) | [Draft](./mentor/2026-05-13-session-flow.html) | [Draft](./platform/2026-05-13-session-system.html) |
| 멤버십·결제·정책 | [Draft](./user/2026-05-13-membership-payment.html) | — | [Draft](./platform/2026-05-13-membership-system.html) |
| 예약 시스템 | [Draft](./user/2026-05-13-reservation.html) | [Draft](./mentor/2026-05-13-reservation.html) | [Draft](./platform/2026-05-13-reservation-system.html) |
| AI 시스템 PT | [Draft](./user/2026-05-13-ai-coaching.html) | (멘토 세션 PRD 안에) | [Draft](./platform/2026-05-13-ai-engine.html) |
| 멘토 등급·Pro 인증 | (멘토 프로필 화면) | [Draft](./mentor/2026-05-13-mentor-tier.html) | [Draft](./platform/2026-05-13-mentor-tier-system.html) |
| 정산·분배 | (결제 PRD 안에) | [Draft](./mentor/2026-05-13-payout.html) | [Draft](./platform/2026-05-13-payout-system.html) |

## 작성 규칙

- 파일명: `YYYY-MM-DD-feature-name.md`
- [`_template.md`](./_template.html) 복사
- frontmatter `parent`로 레이어 지정

## 다음 단계

1. recoverGX 구현 검증 (지갑 충전 멱등 통합 테스트)
2. 실 PG(토스/포트원) 지갑 충전 연동
3. recoverGX 브랜딩·테마 3앱 적용
4. PT 레일 재활성화 여부 결정 (ADR)
