---
title: 온보딩
nav_order: 99
---

# 협업자 온보딩

## 이 문서가 뭐야?

**recoverGX**(오픈형 GX 그룹 클래스 플랫폼) 프로젝트의 **모든 의사결정·정책·기능 스펙**이 모이는 곳입니다.
구두로 합의한 내용도 여기에 적어야 "결정"으로 인정됩니다.

{: .note }
> 2026-06 제품 레일이 1:1 PT → GX 그룹 클래스로 전환됐습니다. 먼저 [ADR 0011](./decisions/0011-recovergx-gx-pivot.html)과 [홈](./)을 읽으세요. 옛 문서 일부는 PT 레일(보류) 기준입니다.

## 어떻게 보면 돼?

좌측 사이드바에서 카테고리 선택 → 우측 본문 읽기.
상단 검색창으로 키워드 검색 가능합니다.

## 어떻게 수정해?

### 방법 1. GitHub 웹에서 (가장 쉬움)
1. 페이지 우상단 "Edit this page on GitHub" 클릭
2. 연필 아이콘 → 직접 편집
3. 하단 "Propose changes" → PR 자동 생성
4. Young이 리뷰 후 머지하면 사이트에 반영 (~1분 후)

### 방법 2. 새 페이지 추가
- 카테고리 폴더(`product/`, `policies/`, `specs/`, `decisions/`) 안에 `.md` 파일 생성
- 파일 상단에 frontmatter 필수:

```yaml
---
title: 페이지 제목
parent: 카테고리명
nav_order: 정렬순서
---
```

## 페이지 작성 규칙

- **결정 사항** → `decisions/` 에 ADR 형식
- **정책** (환불·노쇼 등) → `policies/`
- **기능 스펙** → `specs/YYYY-MM-DD-feature-name.md`
- **컨셉/로드맵** → `product/`

## 모르겠으면?

Slack `#proj-pt-platform` 채널에서 Young에게 물어보세요.
