---
title: 0001 — 모노레포 채택
parent: 의사결정
nav_order: 1
---

# 0001. 5개 분산 레포 → Turborepo 모노레포 통합

- **상태**: Accepted
- **결정일**: 2026-05-05
- **결정자**: Young

## 맥락

PT Platform 초기엔 빠른 개발을 위해 5개 레포로 분리했음:
- `pt-platform-mvp` (유저 앱)
- `pt-platform-partner` (강사 앱)
- `pt-platform-admin` (어드민)
- `pt-platform-api` (API 서버)
- `pt-platform-simulator` (시뮬레이터)

문제:
- 3개 프론트가 거의 동일한 타입을 중복 정의 → API 응답 shape 변경 시 3곳 동기화 필요
- shadcn/ui 컴포넌트 3번 복사
- API endpoint 정의 중복
- PR 단위가 레포별로 쪼개져 변경 추적 어려움

## 결정

**Turborepo + pnpm workspace 단일 레포**로 통합.

```
pt-platform/
├── apps/{mvp, partner, admin, api, simulator}/
└── packages/{db, api-types, ui, config}/
```

- `@pt/api-types` — API 응답 타입 단일 출처
- `@pt/ui` — shadcn 컴포넌트 공유
- `@pt/db` — Prisma 스키마 (api에서만 사용)

## 검토한 대안

- **A. Nx**: 더 강력하지만 설정 복잡, 러닝커브 큼
- **B. Lerna**: 유지보수 둔화 (Nx에 인수됨)
- **C. Yarn workspaces**: pnpm 대비 디스크 효율 낮음
- **D. 현 구조 유지 + shared 패키지만 npm 배포**: 사설 레지스트리 비용·복잡도 ↑

→ Turborepo + pnpm 선택. 캐싱 강력, 설정 단순.

## 결과

**긍정적**
- 타입 단일화로 API 변경 시 빌드 타임에 frontends 3개 동시 검증
- PR 1개로 풀스택 변경 가능
- `pnpm build` 5/5 success, 2초

**부정적**
- Vercel 4개 프로젝트 재연결 필요 (수동 작업)
- API ECS Dockerfile 컨텍스트 변경 필요
- partner/admin types와 mvp types shape 불일치 (의도적 deferred)

**중립**
- simulator는 tailwind v4 격리 유지 (다른 앱 v3와 분리)
