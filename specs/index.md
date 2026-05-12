---
title: 스펙 (PRD)
nav_order: 9
has_children: true
---

# 스펙 (PRD)

> 결정된 시스템을 **실제 코드로 구축**하기 위한 명세 문서.

## 3-레이어 구조

PRD는 stakeholder별로 분리:

- **[👤 유저](./user/)** — 회원 앱 (4개 PRD)
- **[💪 멘토](./mentor/)** — 강사 앱 (4개 PRD)
- **[🏢 플랫폼](./platform/)** — 본사·API·어드민·AI (6개 PRD)

각 PRD는 하나의 기능 단위. cross-layer 영향이 있으면 각 layer에서 상호 참조.

## 작성 규칙

- 파일명: `YYYY-MM-DD-feature-name.md`
- [`_template.md`](./_template.html) 복사
- frontmatter `parent`로 레이어 지정

## 기능별 PRD 매트릭스

| 기능 | 👤 유저 | 💪 멘토 | 🏢 플랫폼 |
|---|---|---|---|
| 세션·멘토 모델 | [✓](./user/2026-05-13-session-flow.html) | [✓](./mentor/2026-05-13-session-flow.html) | [✓](./platform/2026-05-13-session-system.html) |
| 멤버십·결제·정책 | [✓](./user/2026-05-13-membership-payment.html) | — | [✓](./platform/2026-05-13-membership-system.html) |
| 예약 시스템 | [✓](./user/2026-05-13-reservation.html) | [✓](./mentor/2026-05-13-reservation.html) | [✓](./platform/2026-05-13-reservation-system.html) |
| AI 시스템 PT | [✓](./user/2026-05-13-ai-coaching.html) | (멘토 세션 PRD 안에) | [✓](./platform/2026-05-13-ai-engine.html) |
| 멘토 등급·Pro 인증 | (멘토 프로필 화면) | [✓](./mentor/2026-05-13-mentor-tier.html) | [✓](./platform/2026-05-13-mentor-tier-system.html) |
| 정산·분배 | (결제 PRD 안에) | [✓](./mentor/2026-05-13-payout.html) | [✓](./platform/2026-05-13-payout-system.html) |

**총 14개 PRD**. 모두 Draft 상태. 1호점 오픈 직전 Review·Approve로 전환.

## 다음 단계

1. PRD 리뷰 (협업자)
2. 우선순위·의존성 분석 → 개발 순서 결정
3. 첫 sprint = 세션·멘토 모델 + 예약 시스템 (가장 foundational)
4. ADR 봉인 — 큰 결정 (예: PG 선택, AI 모델 선택) 결정 후
