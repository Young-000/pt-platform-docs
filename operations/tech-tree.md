---
title: 🗺️ 5I. 테크트리 (의존성 맵)
parent: 5. 운영
nav_order: 9
---

# 5I. 테크트리 — 트랙 교차 의존성 맵

> 해야 할 일을 **트랙(레인)별로 펼치고, 트랙 사이를 잇는 의존성**으로 그린 테크트리.
> 실선 = 같은 트랙 진행, **점선 = 다른 트랙과 교차(선행조건)**. ◆ = 목표(게이트).
> 항목 상세·체크박스는 [5H 백로그](./backlog.html). 기준일 2026-06-05.

```mermaid
flowchart LR
  classDef done fill:#E9F1EC,stroke:#4E7D60,color:#1c2b22;
  classDef wip fill:#F6EFDD,stroke:#A9823C,color:#3a2e12;
  classDef todo fill:#F2F1EE,stroke:#9A958C,color:#2b2723;
  classDef goal fill:#141414,stroke:#141414,color:#ffffff;

  subgraph FND[기반 · 완료]
    direction LR
    F1[DB·스키마]:::done --> F2[GX API<br/>지갑·예약·정산]:::done --> F3[3앱 기본]:::done
  end

  subgraph INF[A · 인프라]
    direction LR
    A1[인프라 audit]:::done --> A2[recover 계정 확정]:::done --> A3[ALB 재생성]:::todo --> A4[API 빌드·배포]:::todo --> A5[마이그레이션 적용]:::todo --> A6[프론트 재배포]:::todo --> AG((로그인 복구)):::goal
  end

  subgraph MNT[C · 강사 오픈마켓]
    direction LR
    C1[신청·심사 API]:::done --> C2[어드민 심사 큐]:::done
    C1 --> C3[강사앱 /apply]:::done
    C2 --> C4[라이브화]:::todo
    C3 --> C4 --> C5[승인후 계정발급]:::wip
  end

  subgraph DSN[B · 디자인]
    direction LR
    B1[시스템 확정]:::done --> B2[토큰 3앱·배포]:::done --> B3[로그인 워드마크]:::done --> B4[어드민 워드마크]:::todo
    B2 --> B5[내부화면 리스킨]:::todo --> B6[토큰 공통화]:::todo
  end

  subgraph PAY[D · 결제·정산]
    direction LR
    D1[충전 멱등]:::done --> D2[취소 원자화]:::done --> D3[부킹 멱등 영속화]:::todo --> D4[실 PG 연동]:::todo
  end

  subgraph LCH[런칭 · 1호점]
    direction LR
    L1[플랜·R&R]:::done --> L2[단위경제 재산출]:::todo --> L3[자본·임대·인허가]:::todo --> L4[시공·강사 seed]:::todo --> L5((1호점 OPEN)):::goal
  end

  %% ── 트랙 교차 의존성 (점선) ──
  F3 -.-> A1
  F2 -.-> C1
  F3 -.-> B1
  F2 -.-> D1
  A4 -.->|배포 필요| C4
  A5 -.->|테이블 생성| C4
  A3 -.->|멀티 인스턴스| D3
  AG -.->|실사용 가능| L5
  B5 -.-> L5
  D4 -.-> L5
  C5 -.->|공급 확보| L5
```

## 읽는 법

- **세로 = 트랙**(인프라 A · 강사 C · 디자인 B · 결제 D · 런칭). 각 트랙은 왼→오 순서로 진행.
- **점선 = 교차 선행조건.** 예: 강사 오픈마켓(C)은 다 만들어졌지만 **라이브(C4)는 인프라의 배포(A4)·마이그레이션(A5)이 끝나야** 켜진다.
- **◆ 게이트 2개**: `로그인 복구`(A 트랙 끝) · `1호점 OPEN`(거의 모든 트랙 수렴).

## 지금의 병목

> **A(인프라)가 최대 병목.** ALB 삭제로 로그인이 죽었고, 그 때문에 ① 모든 앱 실사용 ② 강사 오픈마켓(C) 라이브 ③ 결제 멱등(D3)이 전부 막혀 있다. **A를 풀면 C가 즉시 따라 켜진다.**

```mermaid
flowchart LR
  classDef goal fill:#141414,stroke:#141414,color:#fff;
  classDef todo fill:#F2F1EE,stroke:#9A958C,color:#2b2723;
  A[A 인프라 복구]:::todo --> R((로그인 복구)):::goal
  R --> U1[3앱 실사용]:::todo
  R --> U2[C 강사 오픈마켓 라이브]:::todo
  R --> U3[D 멱등·PG 검증]:::todo
```

## 트랙 요약

| 트랙 | 완료 | 진행/대기 | 게이트·교차 |
|---|---|---|---|
| **기반** | DB·GX API·3앱 | — | 모든 트랙의 뿌리 |
| **A 인프라** | audit·계정확정 | ALB·배포·마이그레이션·재배포 | → 로그인 복구 (C·D·런칭 잠금 해제) |
| **C 강사 오픈마켓** | API·심사 큐·/apply | 라이브화·계정발급 | ← A4·A5 (배포·테이블) |
| **B 디자인** | 시스템·토큰·로그인 | 어드민 워드마크·내부화면·공통화 | → 런칭(완성도) |
| **D 결제** | 충전 멱등·취소 원자화 | 부킹 멱등 영속화·실 PG | ← A(멀티 인스턴스) |
| **런칭** | 플랜·R&R | 단위경제·자본·시공·OPEN | ← A·B·C·D 수렴 |

---

| 2026-06-05 | 초안 — 트랙 교차 의존성 테크트리(mermaid) + 병목(A) 분석 |
