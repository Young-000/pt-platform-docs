---
title: 인증·권한
parent: 🔌 API
grand_parent: 스펙 (PRD)
nav_order: 3
---

# 인증·권한

**Status**: Draft · **Updated**: 2026-05-13

## JWT 발급
- 로그인 시 access (1h) + refresh (7일)
- HS256, 비밀키 환경변수

## 역할 (Role)
- `member`
- `mentor`
- `admin` (operator / finance / super)

## 권한 매트릭스

| 리소스 | member | mentor | admin |
|---|---|---|---|
| 본인 프로필 | ✓ | ✓ | ✓ |
| 본인 결제 | ✓ (own) | - | view all |
| 회원 데이터 | - | own session만 | view |
| 멘토 슬롯 | - | own | view |
| 정산 | - | own | manage |
| 컴플레인 처리 | - | view own | manage |

## 미들웨어
- `authMiddleware`: JWT 검증
- `requireRole(role)`: 권한 체크
- `requireOwner(resource)`: 본인 리소스만

---

| 2026-05-13 | 초안 |
