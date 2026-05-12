---
title: 스펙 (PRD)
nav_order: 9
has_children: true
---

# 스펙 (PRD)

> 결정된 시스템을 **실제 코드로 구축**하기 위한 명세 문서.

## 3-레이어 구조

PRD는 stakeholder별로 분리:

- **[👤 유저](./user/)** — 회원 앱 화면·기능·플로우
- **[💪 멘토](./mentor/)** — 강사 앱 화면·기능·플로우
- **[🏢 플랫폼](./platform/)** — 본사 운영 시스템·어드민·API·데이터

각 PRD는 하나의 기능 단위. cross-layer 영향이 있으면 각 layer에서 상호 참조.

## 작성 규칙

- 파일명: `YYYY-MM-DD-feature-name.md`
- [`_template.md`](./_template.html) 복사
- frontmatter `parent`로 레이어 지정 (👤 유저 / 💪 멘토 / 🏢 플랫폼)

## 작성 예정 (기능 단위)

1. **세션·멘토 모델** (foundational — 다른 PRD 입력)
2. **멤버십·결제·정책**
3. **예약 시스템** (고정 슬롯 + 자유 + 카디오)
4. **AI 시스템 PT** (세션 기록 + 다음 운동 제안)
5. **멘토 등급** (일반 / Pro 인증 + 본사 심사)
6. **정산·분배**

각 기능 = 👤·💪·🏢 3 PRD 묶음.
