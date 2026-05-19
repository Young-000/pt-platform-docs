---
title: 🟢 5E. 1호점 OPEN 체크리스트
parent: 5. 운영
nav_order: 5
---

# 5E. 1호점 베타 OPEN 체크리스트 (D-30 → D-Day)

**🟢 v2 봉인 (2026-05-20)** · 의존: [ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0002](../decisions/0002-license-policy.html), [5B 지점 운영](./store.html), [5C 안전](./safety.html), [partners/verification-course.md](../partners/verification-course.html)

> **📌 v2 봉인 (2026-05-20) — KPI 갱신**
>
> | KPI | 목표 (D+180) |
> |---|---|
> | **활성 회원** | **360명** (Base 시나리오) — Stretch 목표 700명 (Bull) |
> | **Util (전체 가동률)** | **50%** (월 4,320 unit 사용) |
> | **Pro 강사 풀** | **15명** (1호점 베타). P1 신입 10명 + P2~P3 시니어 5명 |
> | 월 본사 순익 | +4,744만 (Base) |
> | 자격증 보유율 | **100%** (Pro Only · 일반 멘토 ❌) |

> 코드(3 앱 + API + DB)는 거의 완성. 이 문서는 **운영 측면 준비** 일정표.

---

## D-30 — 인프라·법무

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | Supabase 운영 프로젝트 생성·migration 적용·seed | Dev | `pt_platform` 스키마 12 테이블 + seed 8 프로그램 확인 |
| [ ] | Railway(ECS) API 배포·health check | Dev | `/health` 200 OK + JWT 로그인 e2e 성공 |
| [ ] | Vercel 3 앱 prod 배포 (user / partner / admin) | Dev | 3 도메인 모두 200 + Supabase 연결 확인 |
| [ ] | 도메인 구매·연결 | Founder | DNS A/CNAME + SSL 발급 완료 |
| [ ] | PG 선정 (토스페이먼츠 / 포트원) + webhook 셋업 | Founder + Dev | 테스트 결제 1건 성공 + webhook 이벤트 수신 로그 |
| [ ] | 사업자 등록 · 체육시설업 신고 | Founder | 사업자등록증 + 신고증 사본 보관 |
| [ ] | 변호사 자문 — ADR 0002 §5 · 약관 · 면책동의 작성 | Founder | 약관·면책동의 final 버전 PDF |
| [ ] | 1호점 임대 계약 (60평 외곽·평당 10만) · 인테리어 발주 | Founder | 계약서 + 공사 일정표 + capex 1.5~2억 예산 확보 |

## D-21 — 강사·운영 (Pro Only)

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | **Pro 자격증 보유자 15명 모집** (자격증 카페·헬스장 referral·잡 포털) | Founder | 자격증 인증 신청서 15건 수신 |
| [ ] | **가맹점장 (Pro 자격 + 시설법 §26) 채용** — 본사 직고용 | Founder | 근로계약서 + 자격증 사본 |
| [ ] | **본사 아카데미 8시간 운영** (4 모듈 · 본사 직강사 1명) | 본사 직강사 | [partners/verification-course.md](../partners/verification-course.html) 4 모듈 평가 완료 |
| [ ] | 아카데미 통과자 P1 등급 부여 → 활성 강사 풀 확정 | Founder + 직강사 | admin `Mentor` 테이블 active=true, P1 부여 10명 + P2~P3 5명 |

## D-14 — 콘텐츠·테스트

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | 카테고리·프로그램 admin 입력 (4 카테고리 + 8 프로그램) | Founder | admin UI에 8 + α 입력 + active |
| [ ] | PricingConfig (회차권 5단 · 1회 35k · 4회 135k · 12회 390k · 24회 720k · 48회 1,320k) admin 입력 | Founder | PricingConfig deploy=true · 30분 unit 기준 |
| [ ] | PolicyConfig · OperationConfig admin 입력 | Founder | 3 config 모두 deploy=true |
| [ ] | 강사 등급 P1~P5 정산 단가 admin 입력 (10k/12k/14k/16k/18k 30분) | Founder | PayoutConfig deploy=true |
| [ ] | AI 추천 룰 v1 활성 · 운영 환경 테스트 | Dev | 신규 회원 시드 1명 → 추천 응답 200 |
| [ ] | 강사-프로그램 매핑 (admin UI) | Founder | 모든 active 강사에 ≥1 프로그램 매핑 |
| [ ] | 회원 첫 결제 · 예약 · 세션 흐름 dry run | Founder + Dev | 가입→결제→예약→체크인→세션→기록 5단계 e2e 통과 |
| [ ] | 약관 · 면책동의 회원 앱 노출 확인 | Dev | 가입 화면 modal + `MemberAgreement` 레코드 생성 |

## D-7 — 마케팅·CS (KOL 60% + B2B 20% + 구전 15% + 광고 5%)

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | KOL 섭외 — 2~3명 (헬스·필라테스·자기관리 KOL) | Founder | 계약·콘텐츠 일정 합의 |
| [ ] | B2B 사전 영업 — 인근 기업 1~2곳 | Founder | 단체 가입 LOI 수신 |
| [ ] | 사전 신청 페이지 공개 (1회권 35,000원 체험) | Founder | 랜딩 URL 공개 + 신청 폼 수신 가능 |
| [ ] | CS 채널 셋업 (카카오톡 채널 · 이메일) | Founder | 채널 등록 + 자동 응답 메시지 |
| [ ] | CS SOP 1차 draft | Founder | 문의 유형별 응대 스크립트 5종 이상 |
| [ ] | 비상 호출 · 안전 가이드 시설 비치 | Founder | 비상벨 동작 테스트 + AED·구급함 위치 표시 |
| [ ] | 인스타 · 당근 · 구전 첫 콘텐츠 업로드 | Founder | 채널 3개 first post |
| [ ] | Solapi 카카오 알림 셋업 (예약 확정 · 체크인 리마인드) | Dev | 테스트 카톡 수신 확인 |

## D-1 — 최종 점검

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | 시설 청결 · 기구 점검 | 가맹점장 | 점검 체크리스트 100% |
| [ ] | 강사 첫날 일정 확정 (Pro 풀 15명 중 5~7명 첫날 배치) | Founder | admin 스케줄 sync + 카톡 통보 |
| [ ] | 모니터링 대시보드 확인 (Cron · 알림 · 로그 · 감사) | Dev | 24h 무에러 + 알림 채널 정상 |
| [ ] | 비상 연락망 (가맹점장 · 본사 · 119) | Founder | 시설 내 비상 연락 카드 부착 |

## D-Day — OPEN

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | OPEN | All | 게이트 열림 + 첫 회원 체크인 1건 |
| [ ] | 첫 회원 응대 · 세션 진행 모니터링 | 가맹점장 + Founder | 첫 세션 5건 무사고 + 5분 기록 SOP 100% 준수 |
| [ ] | 24h 운영 후 1차 회고 | Founder | 회고 문서 1장 (이슈 · 개선 · 다음 액션) |

---

## D+30 / D+90 / D+180 KPI 추적

| 시점 | Util 목표 | 활성 회원 | 본사 순익 | 결정 |
|---|---|---|---|---|
| D+30 (Bear) | 20% | ~144명 | +338만 | 마케팅·KOL 강화 검토 |
| D+90 (Standard) | 30% | ~216명 | +1,806만 | Phase 1 클러스터 2호점 입지 탐색 시작 |
| **D+180 (Base)** | **50%** | **360명** | **+4,744만** | **Phase 2 진입 판단 (강남 2호점 vs 클러스터 확장)** |

## 회고 기록

| 날짜 | 단계 | 메모 |
|---|---|---|
| 2026-05-16 | 신규 | launch checklist 초안 작성 |
| 2026-05-20 | v2 봉인 | KPI 갱신 — 활성 360명·util 50%·Pro 풀 15명. 일반 멘토 모집 → Pro Only 모집. 마케팅 mix KOL 60% / B2B 20% / 구전 15% / 광고 5% 명시. 회차권 5단 30분 unit·강사 P1~P5 정산 단가 admin 입력 추가 |
