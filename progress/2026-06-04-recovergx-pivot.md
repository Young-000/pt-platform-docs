---
title: "2026-06-04 — recoverGX GX 피벗 (ADR 0011 봉인 + 문서 전면 리뉴얼)"
parent: 진행 로그
nav_order: 5
---

# 2026-06-04 — recoverGX GX 피벗

슈퍼몽키 벤치마크 결론에 따라 제품 레일을 **1:1 PT → 오픈형 GX 그룹 클래스**로 전환. [ADR 0011](../decisions/0011-recovergx-gx-pivot.html) 봉인 + 본 문서 사이트 전면 리뉴얼.

## 배경

- AI 개인화·강사 증폭 moat은 **1:1 PT 레일에서만** 유효. GX는 저개인화·드롭인이라 AI 자리 약함.
- 슈퍼몽키는 IP·명인·광고 없이 ① 모델 자체(강매 없음) ② 내부 강사 ③ 입소문(성장 80% 口碑)으로 브랜드. 콜드스타트에 강함.
- → 진입 레일을 GX로. 1:1 PT는 **보류**(코드·데이터 보존), PMF 후 AI moat 레일 부활.

## 결정 (ADR 0011)

- 상품: 그룹 클래스(정원 N, 룸당 시간당 1세션)
- 결제: **지갑 충전금 + 클래스별 가격 차감** (회차권/티어 폐기)
- 공급: 어드민 큐레이션 룰 + 검증 강사(gxOpenEnabled) 개설
- 정산: 조합형 (기본금 + 인당 + 매출 비율%), 완료 시 정책 스냅샷
- 취소/환불: 6h 전 전액·이내 0 (좌석 항상 복구) / 폐강 전원 환불 / 노쇼 패널티 없음
- AI: GX 레일 보류

## 구현 (레포 pt-platform main 머지·푸시 완료)

- DB: Wallet·WalletTransaction·ChargePackage·GxPolicy·GxPayoutPolicy·GxSettlement + GxClass.price·Mentor.gxOpenEnabled
- API: `/api/gx/*`·`/api/wallet/*`·`/api/gx-admin/*` + 어드민 로그인(admin.service)
- 3앱 GX 전용 전환 + 랜딩 GX 단일 + recoverGX 브랜드. Playwright e2e 검증
- 정본 스펙/정책서: 레포 `docs/superpowers/specs/2026-06-03-recovergx-open-gx-platform-design.md` · `docs/pivot/2026-06-04-recovergx-concept.md`

## 문서 사이트 리뉴얼 (이 레포)

- ADR 0011 신규 + decisions/index 갱신
- index.md(홈)·_config.yml·onboarding GX로
- product/members/service/partners/operations/economics/expansion 본문 GX로 덮어쓰기 (PT 레일 보류 명시)
- specs는 실제 recoverGX 구현(api/wallet/gx-admin·wallet/gx 모델)에 정렬, PT-era 상세 스펙은 보류 표기

## 다음

- [ ] API ECS 배포 + 실 PG 연동
- [ ] GX 정원·드롭인 기준 단위 경제 재산출
- [ ] recoverGX 브랜딩(오렌지) 3앱 적용
