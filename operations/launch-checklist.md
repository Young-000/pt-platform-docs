---
title: 🟢 5E. 1호점 OPEN 체크리스트
parent: 5. 운영
nav_order: 5
---

# 5E. 1호점 베타 OPEN 체크리스트 (D-30 → D-Day)

**🟢 신규 (2026-05-16)** · 의존: [ADR 0001](../decisions/0001-consumer-pivot.html), [ADR 0002](../decisions/0002-license-policy.html), [5B 지점 운영](./store.html), [5C 안전](./safety.html), [partners/verification-course.md](../partners/verification-course.html)

> 코드(3 앱 + API + DB)는 거의 완성. 이 문서는 **운영 측면 준비** 일정표.
> 각 체크박스 = 담당자·완료 기준 명시. 완료 시 ☑로 갱신.

---

## D-30 — 인프라·법무

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | Supabase 운영 프로젝트 생성·migration 적용·seed | Dev | `pt_platform` 스키마 12 테이블 + `20260516000000_program_v2` 적용 + seed 8 프로그램 확인 |
| [ ] | Railway(ECS) API 배포·health check | Dev | `/health` 200 OK + JWT 로그인 e2e 성공 |
| [ ] | Vercel 3 앱 prod 배포 (user / partner / admin) | Dev | 3 도메인 모두 200 + Supabase 연결 확인 |
| [ ] | 도메인 구매·연결 (`pt-platform.com` 또는 결정 후보) | Founder | DNS A/CNAME + SSL 발급 완료 |
| [ ] | PG 선정 (토스페이먼츠 / 포트원) + webhook 셋업 | Founder + Dev | 테스트 결제 1건 성공 + webhook 이벤트 수신 로그 |
| [ ] | 사업자 등록 · 체육시설업 신고 (자유업 분류 가능성 확인) | Founder | 사업자등록증 + 신고증 사본 보관 |
| [ ] | 변호사 자문 — ADR 0002 §5 법안 진척 · 약관 · 면책동의 작성 | Founder | 약관·면책동의 final 버전 PDF |
| [ ] | 1호점 임대 계약 · 인테리어 발주 | Founder | 계약서 + 공사 일정표 |

## D-21 — 멘토·운영

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | 일반 멘토 10명 모집 (배달·인스타·당근 알바) | Founder | 신청 폼 10건 수신 |
| [ ] | 가맹점장(자격증 보유 슈퍼바이저) 채용 — 본사 직고용 | Founder | 근로계약서 체결 + 자격증 사본 |
| [ ] | 멘토 검증 코스 8시간 운영 (Phase 1 본사 직강사 1명) | 본사 직강사 | [partners/verification-course.md §운영](../partners/verification-course.html) 4 모듈 평가 완료 |
| [ ] | 첫 멘토 풀 확정 (검증 통과자만) | Founder + 직강사 | admin `Mentor` 테이블 active=true 5명 이상 |

## D-14 — 콘텐츠·테스트

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | 카테고리·프로그램 admin 입력 (4 카테고리 + 8 프로그램 외 추가 가능) | Founder | admin UI에 8 + α 입력 + active |
| [ ] | PricingConfig · PolicyConfig · OperationConfig admin 입력 | Founder | 3 config 모두 deploy=true |
| [ ] | AI 추천 룰 v1 활성 · 운영 환경 테스트 | Dev | 신규 회원 시드 1명 → 추천 응답 200 |
| [ ] | 멘토-프로그램 매핑 (admin Mentor-Program UI) | Founder | 모든 active 멘토에 ≥1 프로그램 매핑 |
| [ ] | 회원 첫 결제 · 예약 · 세션 흐름 dry run (내부 인원) | Founder + Dev | 가입→결제→예약→체크인→세션→기록 5단계 e2e 통과 |
| [ ] | 약관 · 면책동의 회원 앱 노출 확인 | Dev | 가입 화면 modal + 동의 시 `MemberAgreement` 레코드 생성 |

## D-7 — 마케팅·CS

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | 사전 신청 페이지 공개 (1회차 4만원 체험권) | Founder | 랜딩 URL 공개 + 신청 폼 수신 가능 |
| [ ] | CS 채널 셋업 (카카오톡 채널 · 이메일) | Founder | 채널 등록 + 자동 응답 메시지 |
| [ ] | CS SOP 1차 draft | Founder | 문의 유형별 응대 스크립트 5종 이상 |
| [ ] | 비상 호출 · 안전 가이드 시설 비치 ([5D 자유 헬스 §안전](./free-gym.html), [5C 안전](./safety.html)) | Founder | 비상벨 동작 테스트 + AED·구급함 위치 표시 |
| [ ] | 인스타 · 당근 등 콘텐츠 첫 업로드 | Founder | 채널 3개 first post |
| [ ] | Solapi 카카오 알림 셋업 (예약 확정 · 체크인 리마인드) | Dev | 테스트 카톡 수신 확인 |

## D-1 — 최종 점검

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | 시설 청결 · 기구 점검 | 가맹점장 | 점검 체크리스트 (5B 참조) 100% |
| [ ] | 멘토 첫날 일정 확정 | Founder | admin 스케줄 sync + 카톡 통보 |
| [ ] | 모니터링 대시보드 확인 (Cron · 알림 · 로그 · 감사) | Dev | 24h 무에러 + 알림 채널 정상 |
| [ ] | 비상 연락망 (가맹점장 · 본사 · 119) | Founder | 시설 내 비상 연락 카드 부착 |

## D-Day — OPEN

| 완료 | 항목 | 담당 | 완료 기준 |
|---|---|---|---|
| [ ] | OPEN | All | 게이트 열림 + 첫 회원 체크인 1건 |
| [ ] | 첫 회원 응대 · 세션 진행 모니터링 | 가맹점장 + Founder | 첫 세션 5건 무사고 |
| [ ] | 24h 운영 후 1차 회고 | Founder | 회고 문서 1장 (이슈 · 개선 · 다음 액션) |

---

## 회고 기록

| 날짜 | 단계 | 메모 |
|---|---|---|
| 2026-05-16 | 신규 | launch checklist 초안 작성 |
