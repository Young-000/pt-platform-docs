---
title: ERD
parent: 🗄️ 데이터
grand_parent: 스펙 (PRD)
nav_order: 2
---

# ERD (Entity Relationship Diagram)

{: .highlight }
> **recoverGX 피벗 (2026-06-04)**: 현재 활성 모델은 아래 **GX 오픈 플랫폼 ERD**다 ([ADR 0011](../../decisions/0011-recovergx-gx-pivot.html)). 그 아래 "PT 레일 ERD"는 1:1 PT 모델 기준으로 **보류**(코드·테이블 보존). 실제 스키마: `pt-platform/packages/db/prisma/schema.prisma`.

## GX 오픈 플랫폼 관계 (현재 활성)

지갑 충전금 → 클래스별 차감 드롭인, 강사 개설, 조합형 정산.

```mermaid
erDiagram
    Member ||--o| Wallet : owns
    Wallet ||--o{ WalletTransaction : records
    ChargePackage ||--o{ WalletTransaction : "charges (refType)"

    Member ||--o{ GxBooking : books
    GxClass ||--o{ GxBooking : "holds (capacity)"
    GxClass }o--|| Store : "at"
    GxClass }o--|| Room : "in"
    GxClass }o--|| Category : "typed"
    Mentor ||--o{ GxClass : opens

    GxClass ||--o| GxSettlement : "settles (1:1)"
    Mentor }o--o| GxPayoutPolicy : assigned
    GxPayoutPolicy ||--o{ GxSettlement : "applied (snapshot)"

    GxPolicy ||--|| Platform : "singleton (가격범위·환불마감)"
```

핵심 불변식·제약:
- `Wallet.memberId` unique (회원당 1지갑) · `WalletTransaction.idempotencyKey` unique (충전 멱등)
- `GxBooking` `@@unique(classId, memberId)` (더블부킹 차단, cancelled 재활성화 허용)
- `GxClass.bookedCount < capacity` 가드로 좌석 원자 점유 · `status` open↔full 불변식 유지
- `GxSettlement.classId` unique (이중 정산 차단) · 완료 시 `policySnapshot` 값 복사 → 정책 변경 불변
- `GxPolicy`/`ChargePackage`는 어드민 큐레이션 설정(단일 행/목록), `Mentor.gxOpenEnabled`로 개설 권한

## PT 레일 ERD (보류)

{: .warning }
> 아래는 1:1 PT 세션 모델 ERD. 코드·테이블은 보존되어 있으나 GX 피벗 이후 **보류 상태**다. 재활성화 여부는 [ADR 0011](../../decisions/0011-recovergx-gx-pivot.html) 참조.

## 핵심 도메인 관계

```mermaid
erDiagram
    Member ||--o{ Membership : has
    Member ||--o| PointBalance : has
    Member ||--o{ Reservation : makes
    Member ||--o{ FixedSlot : owns
    Member ||--o{ Payment : pays
    Member ||--o{ Rating : gives

    Mentor ||--o{ MentorBlock : opens
    Mentor ||--o{ Reservation : assigned
    Mentor ||--o| MentorBankAccount : has
    Mentor ||--o{ MentorPayout : earns
    Mentor ||--o{ MentorRateChange : history
    Mentor ||--o{ MentorComplaint : received

    Store ||--o{ Room : contains
    Store ||--o{ CardioSeat : contains
    Room ||--o{ RoomSlot : provides
    CardioSeat ||--o{ CardioSlot : provides

    Reservation }o--|| Session : creates
    Reservation }o--|| RoomSlot : occupies
    Reservation }o--|| CardioSlot : occupies
    Reservation }o--o| MentorBlock : matches

    Session ||--o| SessionRecord : has
    Session ||--o| Rating : rated
    Session ||--o| AIRecommendation : recommended

    Member ||--o{ DayPass : holds
    Member ||--o{ BonusCredit : holds

    Payment ||--o| Refund : refunded
    PaymentLedger ||--o{ DistributionEntry : splits
```

## 그룹별 미니 ERD

### 예약 흐름

```mermaid
flowchart LR
    Member --예약--> Reservation
    Reservation --점유--> CardioSlot
    Reservation --점유--> RoomSlot
    Reservation --매칭--> MentorBlock
    MentorBlock --소속--> Mentor
    Reservation --생성--> Session
    Session --기록--> SessionRecord
    Session --평가--> Rating
    Session --추천--> AIRecommendation
```

### 결제·분배 흐름

```mermaid
flowchart LR
    Member --결제--> Payment
    Payment --원장--> PaymentLedger
    PaymentLedger --escrow 7일--> Releasable
    Releasable --분배--> DistributionEntry
    DistributionEntry --멘토--> MentorPayout
    DistributionEntry --본사--> HQ
    DistributionEntry --가맹점주--> FranchiseePayout
```

### 멘토 등급·심사 흐름

```mermaid
stateDiagram-v2
    [*] --> 검증코스: 가입
    검증코스 --> Verified: 통과
    검증코스 --> 재시도: 불합격
    Verified --> Application: Pro 신청 (자격 충족 시)
    Application --> VideoReview: 영상 평가
    VideoReview --> Interview: 통과
    Interview --> Written: 통과
    Written --> ProCertified: 통과
    Written --> Verified: 보류
    ProCertified --> Verified: 컴플레인 3차
    Verified --> Suspended: 자격 정지
```

## 인덱스 추천

| 인덱스 | 이유 |
|---|---|
| `RoomSlot(roomId, startAt)` | 슬롯 조회 |
| `MentorBlock(mentorId, startAt)` | 멘토 슬롯 조회 |
| `MentorBlock(startAt, status)` | 매칭 가능 슬롯 검색 |
| `Reservation(memberId, startAt)` | 회원 예약 리스트 |
| `Reservation(mentorId, startAt)` | 멘토 일정 |
| `Payment(memberId, paidAt)` | 결제 내역 |
| `Membership(memberId, status)` | 활성 멤버십 조회 |
| `Rating(mentorId)` | 멘토 평점 |
| `MentorPayout(mentorId, periodId)` | 정산 조회 |

---

| 2026-05-13 | 초안 — 핵심 관계 + 그룹별 + 인덱스 추천 |
| 2026-06-04 | recoverGX 피벗 — GX 오픈 플랫폼 ERD(지갑·클래스·정산) 추가, 기존 PT ERD는 보류 표기 ([ADR 0011](../../decisions/0011-recovergx-gx-pivot.html)) |
