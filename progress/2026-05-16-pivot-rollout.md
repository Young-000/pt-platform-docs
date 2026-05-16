---
title: "2026-05-16 — 피벗 후속 작업 일괄 반영"
parent: 진행 로그
nav_order: 2
---

# 2026-05-16 — 5/15 회의 피벗 후속 작업 일괄 반영

5/15 회의 결정(ADR 0001 소비자향 피벗)을 받아 하루 동안 일괄 반영한 작업의 히스토리입니다.

## 봉인된 결정 (ADR)

| ADR | 제목 | 의미 |
|---|---|---|
| [0001](../decisions/0001-consumer-pivot.html) | 소비자향 PT 시장 피벗 | 다종목·강사+프로그램 예약·30분 unit·60평·강사 2시나리오 |
| [0002](../decisions/0002-license-policy.html) | 멘토 자격증 정책 | 일반 ❌ / Pro ✅ / 가맹점장 시설법용 / 법안 대응 admin 토글 |
| [0003](../decisions/0003-free-gym-add-on.html) | 자유 헬스 = 부가 | 강사 코스 회원에게만 개방, 단독 가입 ❌ |
| [0004](../decisions/0004-one-time-ticket-pricing.html) | 회차권 라인업 5단 | 1·4·12·24·48회 통일 모델, Pro 옵션 +5천/회 |
| [0005](../decisions/0005-pricing-phase-strategy.html) | Phase별 가격 책정 전략 | Phase 0~4+ 가격 매트릭스, 2D sensitivity, LTV, Pro 인상 트리거 |

## 영향받은 PRD (callout 추가)

| 파일 | 변경 |
|---|---|
| `product/decision-tree.md` | 상위 노드 5개 v2 요약 |
| `service/session-types.md` | 다종목 코스로 확장 |
| `service/space.md` | 90평 → 60평 (8 룸 + 오픈) |
| `members/membership.md` | 회차권 5단 라인업 |
| `members/pricing.md` | 회차권 5단 가격표 + Pro 옵션 |
| `members/policies.md` | 1회권(=1회차권) 정책 분기 |
| `partners/peer-leader.md` | 강사 2 시나리오 + 검증 코스 링크 + 법적 정리 |
| `partners/payout.md` | 강사 정산 30분 2만원 상한선 |
| `partners/verification-course.md` (신규) | 4 모듈·8시간 SOP |
| `partners/recruitment.md` | 모집 → 검증 코스 → 활성 흐름 |
| `legal/pt-license.md` | 법적 사실관계 (체육시설법·국민체육진흥법·의료법) |
| `economics/simulation.md` | 두 강사 시나리오 표 + 1회차·Pro 옵션 매출 영향 |

## 5 트랙 병렬 실행 결과

| 트랙 | 작업 | 산출물 | 커밋 |
|---|---|---|---|
| A | DB 스키마 v2 | `CourseCategory`·`Program`·`MentorProgram`·`FreeGymVisit` + `Membership.ticketType` 통일 + seed 8 프로그램 + migration `20260516000000_program_v2` | `a977a32` + `d5f7ec8` |
| B | 시뮬레이터 v2 | `HomeV2` 페이지: 두 강사 시나리오 토글 + 하이브리드 mix + 민감도 분석 | `39271b0` (sim repo) |
| C | 회원 앱 예약 UI | `/booking` 흐름: CategorySelect → TimeSelect → MentorList → Confirm → Done + `/free-gym` 입구 + 회차권 5단 구매 모달 | `653b445` |
| D | 회차권 가격 책정 | ADR 0004 작성 (3단 → 5단 갱신) | `425697b` + `bcc1225` (docs repo) |
| E | 검증 코스 SOP | `partners/verification-course.md` (4 모듈·평가·탈락 룰) + ADR 0002 후속 작업 완료 | `1b3c923` (docs repo) |

## 핵심 모델 정합성 (v2)

```
회원 예약 흐름:
1. 카테고리 선택 (스트레칭·필라테스·1:1 PT·자유 헬스 + admin 가변)
2. 30분 unit 시간 슬롯
3. 강사 선택 (해당 카테고리 제공 강사)
4. 회차권 잔여 확인 → 부족 시 5단 구매
5. 예약 확정

회차권 = 단일 Membership 모델
  ├─ ticketType: single | monthly | six_month
  ├─ creditsTotal: 1 · 4 · 12 · 24 · 48
  └─ 카테고리 무관 + Pro 강사 옵션 (+5천 포인트)

공간:
  ├─ 8 private room (룸 필요 카테고리)
  ├─ 오픈 28평 (PT + 자유 헬스)
  └─ 자유 헬스 = FreeGymVisit (예약 ❌, 출입만)

강사 풀:
  ├─ S1 파트타이머 (베타 위주, 30분 정산 12,000원)
  └─ S2 전문 강사 (Pro 인증, 30분 정산 최대 20,000원 상한)
```

## 검증

- `pnpm build` — **5/5 패키지 통과**
- 3 레포 모두 main push 완료 (`pt-platform`·`pt-platform-docs`·`pt-platform-simulator`)
- 빌드·typecheck·정합성 검증 통과

## 남은 후속 작업 (다음 우선순위)

| 우선순위 | 작업 | 비고 |
|---|---|---|
| 🔴 즉시 | RDS migration 적용 (`20260516000000_program_v2`) | 운영 DB에 deploy |
| 🔴 즉시 | 회원 앱 mock 모드 → 실 API 연결 | 백엔드 v2 endpoint 구현 |
| 🟡 단기 | 시뮬레이터에 5단 카드 결과 노출 | 가시화 차원 |
| 🟡 단기 | v1 `RoomSlot`·`CardioSlot`·`MentorBlock` 폐기 시점 결정 | 별도 migration |
| 🟢 후속 | 디자인 톤 개선 (회원/멘토 앱 카드 위계·empty state) | 사용자 지적 사항 |
| 🟢 후속 | Pro 강사 옵션·1회차권 운영 데이터로 가격 재검토 (2026-11) | ADR 0004 §7 후속 |

## 변경 이력

| 시각 | 이벤트 |
|---|---|
| 2026-05-15 | 회의: 소비자향 피벗 결정 |
| 2026-05-16 오전 | ADR 0001~0003 작성 + PRD 6개 callout 추가 |
| 2026-05-16 오후 | 5 트랙 병렬 dispatch (DB·시뮬·MVP·가격·검증코스) |
| 2026-05-16 오후 | 회차권 통일 모델 결정 (1회권 → 회차권 1회로 흡수) |
| 2026-05-16 오후 | 회차권 5단 라인업 결정 (1·4·12·24·48회) |
| 2026-05-16 저녁 | 5 트랙 완료·머지·푸시 |
| 2026-05-16 저녁 | 본 진행 로그 작성 |
| 2026-05-16 야간 | ADR 0005 (Phase별 가격 전략) 봉인 + 시뮬레이터 v3 (시나리오 저장·12개월 P&L·2D 히트맵·LTV) |
| 2026-05-16 야간 | 1호점 베타 OPEN launch checklist 작성 (`operations/launch-checklist.md`) + `store.md`·`safety.md` TBD 해소 |
