---
title: 품질 기준
parent: 🎨 디자인 시스템
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 디자인 품질 기준

**Status**: Draft · **Updated**: 2026-05-13

## 목표

> **런칭 가능한 수준의 premium UX**. 페르소나(1A)가 회차권 가격대(회당 25~40k, [ADR 0004](../../decisions/0004-one-time-ticket-pricing.html))에 부합하는 신뢰감을 느끼게.

벤치마크: 부티크 PT·premium SaaS 수준의 완성도.

## 핵심 원칙

### 1. **명료함 (Clarity)**
- 한 화면 = 한 가지 주요 액션
- 핵심 정보 첫눈에 (3초 룰)
- 텍스트 위계 명확 (제목·본문·보조)

### 2. **숨 쉴 공간 (Whitespace)**
- 빽빽 ❌, 넓은 여백
- 카드·섹션 간 충분한 spacing
- 시선이 자연스럽게 흘러가게

### 3. **일관성 (Consistency)**
- 같은 액션 = 같은 버튼 스타일
- 같은 정보 = 같은 컴포넌트
- 색상·폰트·간격 토큰 사용

### 4. **세련됨 (Refinement)**
- 자극적 색상 ❌ (밝은 파랑 그라데이션 등)
- 차분한 톤 + 강조 색 1-2종 절제
- 미세한 그림자·라운드·트랜지션

### 5. **모바일 우선 (Mobile-first)**
- 한 손 조작 가능
- Touch target 44px+
- 가로 스와이프 활용

## 톤 (Tone)

| 차원 | 우리 톤 | ❌ 피할 톤 |
|---|---|---|
| 색상 | 차분한 neutral + 절제된 accent | 자극적 그라데이션·네온 |
| 폰트 | 깔끔·균형 (Pretendard·Inter) | 둥근 폰트·과한 굵기 |
| 카피 | 짧고 친근 | 광고 같은 강요·과장 |
| 일러스트 | 미니멀·아이콘 위주 | 캐릭터·만화풍 |
| 모션 | 부드럽고 짧음 (200-300ms) | 과한 튀어오름·바운스 |

## 핵심 컴포넌트 품질

### 카드 (Card)
- 부드러운 border (1px #e5e7eb)
- 라운드 10-12px
- 그림자 최소 (shadow-sm 또는 없음)
- padding 16-24px

### 버튼 (Button)
- Primary: 진한 단색 (navy 또는 dark teal)
- Secondary: outline
- Touch target ≥ 44px
- 비활성 상태 = 명확히 구분

### 입력 (Input)
- border 1px + focus ring (subtle blue)
- placeholder = 회색 (#9ca3af)
- 에러 = 부드러운 빨강 + 메시지 명확

### 슬롯 / 캘린더
- 가용 = 흰 배경, 불가 = 옅은 회색
- 선택 = primary 색 + 굵기 ↑
- 피크 시간 = 별도 구분 (subtle gold accent)

### 멘토 카드
- 사진·이름·평점·배지 한눈에
- Pro 인증 = gold/navy 배지
- 이전 멘토 = soft highlight (이전에 함께)

## 마이크로 인터랙션

- 버튼 hover: subtle scale + shadow ↑
- 카드 hover: border 색 ↑ (없으면 +1px solid)
- 로딩: skeleton + 부드러운 펄스
- 트랜지션: ease-in-out, 200ms
- 성공 알림: subtle slide + 자동 dismiss

## 한국 시장 컨텍스트

- 모바일 ≥ 80% (PC 부차)
- 카카오 로그인·결제 옵션 (Phase 2)
- 부동산·가격 표기 = 만원 단위
- 시간 = 24h 또는 오전/오후 (혼합 가능)

## 디자인 검증 체크리스트

런칭 전 디자이너·운영자 함께:

- [ ] 5명 회원에게 화면 보여줘서 "이 가격 (4회 14만 / 12회 36만) 낼 만하나?" 즉시 응답 ≥ 4/5
- [ ] 5명 멘토에게 강사 앱 보여줘서 "쓸만한가?" ≥ 4/5
- [ ] 부티크 PT·premium SaaS와 1:1 비교 시 손색없음
- [ ] 모바일 한 손 조작 가능
- [ ] 다크/라이트 모드 모두 OK (Phase 2 다크)
- [ ] 폰트 가독성 (50대 회원 가설)

## 디자인 시스템 작성 책임자

- **디자이너 영입 필수** (Phase 1 직전)
- shadcn 기반이라 처음부터 새로 만들 필요 ❌, but premium 변형 필요
- 디자인 리뷰 매주 (런칭 전)

---

| 2026-05-13 | 초안 — 품질 기준·원칙·톤·컴포넌트·체크리스트 |
