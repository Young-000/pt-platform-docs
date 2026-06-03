---
title: 백업·복구
parent: 🚀 인프라·모니터링
grand_parent: 스펙 (PRD)
nav_order: 4
---

# 백업·복구

**Status**: Draft · **Updated**: 2026-06-04

> recoverGX 피벗 반영 — GX 스케줄·예약·지갑·크레딧 등 6종 테이블이 `pt_platform` 스키마에 추가됨. 기존 RDS 백업 정책으로 자동 커버. [ADR 0011](../decisions/0011-recovergx-gx-pivot.html) 참조.

## RDS Backup
- 일별 자동 snapshot (7일 보관) — `pt_platform` 스키마 전체 (GX 테이블 포함)
- 주별 long-term (35일)

## S3
- 회원 영상·자격증 업로드
- versioning + cross-region

## 복구 SOP
- 데이터 손실 시 cron snapshot 적용
- 24h 이내 복구 목표

---

| 2026-05-13 | 초안 |
| 2026-06-04 | recoverGX 피벗 — GX 테이블 6종 RDS 커버 명시 |
