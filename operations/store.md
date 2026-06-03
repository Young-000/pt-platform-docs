---
title: 🟢 5B. 지점 운영
parent: 5. 운영
nav_order: 2
---

# 5B. 지점 운영 SOP

**🟢 확정 (2026-06-04)** · 의존: [ADR 0011](../decisions/0011-recovergx-gx-pivot.html), [6B 가맹점주 R&R](../expansion/responsibility.html), [4D 공간](../service/space.html), [ADR 0002](../decisions/0002-license-policy.html), [5D 자유 헬스](./free-gym.html)

> 1호점 베타 OPEN 시점 운영 SOP. 모든 시간·주기·비율은 `OperationConfig` admin 변수로 조정 가능.

---

## 1. 운영 시간

- **기본**: 06:00 – 24:00 (18h, 비피크 12h + 피크 6h)
- **유인 시간 (가맹점장 의무 배치)**: 06:00 – 10:00, 17:00 – 23:00 (자격증 보유자)
- **하이브리드 시간**: 10:00 – 17:00 (그룹 클래스 중심, 가맹점장 대기 가능)
- **무인 시간**: 23:00 – 06:00 (자유 헬스 회원만, CCTV + 비상벨)
- 정책 변수: `operation.hours.weekday` / `operation.hours.weekend` / `operation.unmanned_window`

## 2. 인력 구성

| 역할 | 자격 | 근무 형태 | 비고 |
|---|---|---|---|
| 가맹점장 | 자격증 보유 (시설법용) | 본사 직고용, full-time | ADR 0002 §가맹점장 — 슈퍼바이저 역할 |
| 강사 (GX 클래스) | 프로그램 매핑 | 클래스 단위 셰어 | partners/peer-leader.md |
| 청소 인력 | — | 1일 2회 순회 (오전·자정) | 외주 가능 |

> 사고·법적 책임은 가맹점장(자격증)이 떠안고, 본사가 배상보험으로 백업 ([5C](./safety.html)).

## 3. 회원 체크인 SOP

1. **회원 앱 QR 체크인** (기본 경로)
   - 게이트 QR 스캐너 → `Booking` 예약 확인 → 입장 허용 → `enterAt` 기록
2. **Front desk fallback** — 가맹점장 수동 입력 (앱 오류 · 신규 가입자 즉시 입장)
   - admin UI `Booking → manual check-in`
3. **자유 헬스 입장** — [5D](./free-gym.html) `FreeGymVisit` 생성
4. 입장 실패 시 (잔여 지갑 부족, 만료 grace 초과) → CS 응대 + 지갑 충전 유도

## 4. 클래스 스케줄 운영

- 강사가 클래스를 등록 → admin 승인 → 시간표 노출
- 정원 미달(최소 인원 미충족) 클래스는 강사 또는 운영자가 폐강 처리 → 전원 자동 환불
- 정원·최소인원은 admin `ClassConfig`에서 클래스 종류별로 관리
- 정책 변수: `operation.class.min_headcount` / `operation.class.default_capacity`

## 5. 청소 주기

- **오전 마감 청소** (06:00 직전): 전체 룸 · 오픈 · 락커룸
- **순회 청소** (4시간마다): 매트 · 손잡이 · 비치 소독 티슈 보충
- **마감 청소** (00:00 직후): 전체 + 비품 보충 + CCTV 라이브 점검
- 회원 자율: 사용 후 기구 닦기 (티슈 비치)
- 정책 변수: `operation.cleaning_interval_hours` (기본 4)

## 6. 기구 점검 일정

| 주기 | 항목 | 담당 |
|---|---|---|
| 일 1회 | 전 기구 외관 · 안전핀 · 와이어 | 가맹점장 |
| 주 1회 | 케이블·머신 윤활 · 매트 마모도 | 외부 점검 인력 |
| 월 1회 | AED 배터리 · 비상벨 동작 · 소화기 | 가맹점장 |
| 분기 1회 | 전기·소방 안전 점검 (외부) | 외주 업체 |

> 모든 점검 결과는 `EquipmentCheck` 레코드(admin 입력)로 보관 — 사고 발생 시 책임 증빙.

## 7. 본사 ↔ 가맹점장 R&R

- 본사: 시스템 · 결제 · CS 1차 · 가격·정책 · 마케팅 · 배상보험
- 가맹점장: 일상 운영 · 시설 점검 · 사고 1차 대응 · 강사 클래스 일정 조율
- 자세한 경계는 [6B 가맹점주 R&R](../expansion/responsibility.html) 참조.

---

## 변경 이력

| 날짜 | 변경 |
|---|---|
| 2026-05-12 | TBD 초안 |
| 2026-05-16 | TBD 해소 — 1호점 OPEN SOP 확정 (시간·인력·체크인·청소·점검) |
| 2026-06-04 | recoverGX 피벗 — 강사 세션 → GX 클래스 운영 용어 통일. 클래스 스케줄·폐강·정원 운영 섹션 추가 ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html)) |
