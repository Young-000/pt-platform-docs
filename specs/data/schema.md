---
title: 전체 스키마
parent: 🗄️ 데이터
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 전체 DB 스키마 (Prisma)

**Status**: Draft · **Updated**: 2026-05-13
**참고 PRD**: 모든 플랫폼 PRD ([session](../platform/2026-05-13-session-system.html) · [membership](../platform/2026-05-13-membership-system.html) · [reservation](../platform/2026-05-13-reservation-system.html) · [ai](../platform/2026-05-13-ai-engine.html) · [mentor-tier](../platform/2026-05-13-mentor-tier-system.html) · [payout](../platform/2026-05-13-payout-system.html))

## 도메인 그룹

```
1. Identity        — Member · Mentor · Admin
2. Space           — Store · Room · CardioSeat
3. Schedule        — RoomSlot · CardioSlot · MentorBlock · FixedSlot
4. Reservation     — Reservation · Session · Attendance · DayPass · BonusCredit
5. Records         — SessionRecord · ExercisePerformed · Rating
6. AI              — ExerciseLibrary · ProgramTemplate · AIRecommendation · Phase
7. Membership      — Membership · PointBalance · Payment · Refund
8. Mentor System   — VerificationCourse · ProCertificationApplication · MentorRateChange · MentorComplaint · TierChange
9. Payout          — PayoutPeriod · PaymentLedger · DistributionEntry · MentorPayout · TaxReport · MentorBankAccount
10. Audit          — PolicyEvent · CancellationLog
```

## 1. Identity

```prisma
model Member {
  id            String       @id @default(cuid())
  email         String       @unique
  phone         String       @unique
  passwordHash  String
  name          String
  avatarUrl     String?
  // 페르소나 (가입 시)
  ageRange      String?      // "20-30"
  experience    String?      // "신규/재개/중급"
  goals         String[]
  weeklyTarget  Int?         // 주 N회 목표
  createdAt     DateTime     @default(now())
  status        MemberStatus @default(active)

  memberships   Membership[]
  reservations  Reservation[]
  pointBalance  PointBalance?
  fixedSlots    FixedSlot[]
  ratings       Rating[]
  complaints    MentorComplaint[]
  payments      Payment[]
}

enum MemberStatus { active inactive deleted }

model Mentor {
  id                 String       @id @default(cuid())
  profileId          String       @unique  // shared profile (선택)
  email              String       @unique
  phone              String       @unique
  passwordHash       String
  name               String
  avatarUrl          String?
  // 등급
  tier               MentorTier   @default(verified)
  licenseNumber      String?
  licenseType        String?      // "생활스포츠지도사 2급"
  licenseVerified    Boolean      @default(false)
  // 활동 지표
  sessionCount       Int          @default(0)
  averageRating      Decimal?     @db.Decimal(2,1)
  rebookRate         Decimal?     @db.Decimal(3,2)
  attendanceRate     Decimal?     @db.Decimal(3,2)
  recordQualityScore Decimal?     @db.Decimal(3,2)
  // Pro 단가
  proMinRate         Int?
  proMaxRate         Int?
  proCurrentRate     Int?
  // 메타
  verifiedAt         DateTime?
  proCertifiedAt     DateTime?
  status             MentorStatus @default(active)
  createdAt          DateTime     @default(now())

  blocks             MentorBlock[]
  reservations       Reservation[]
  bankAccount        MentorBankAccount?
  payouts            MentorPayout[]
  rateChanges        MentorRateChange[]
  complaints         MentorComplaint[]
}

enum MentorTier { verified pro_certified }
enum MentorStatus { active suspended inactive }

model Admin {
  id           String   @id @default(cuid())
  email        String   @unique
  passwordHash String
  name         String
  role         String   // "operator" | "finance" | "super"
}
```

## 2. Space

```prisma
model Store {
  id          String  @id @default(cuid())
  name        String
  address     String
  // 표준 90평 8방 + 카디오 6
  totalArea   Decimal @db.Decimal(5,2)  // 평
  rooms       Room[]
  cardioSeats CardioSeat[]
  status      String  @default("active")
  openedAt    DateTime
}

model Room {
  id        String @id @default(cuid())
  storeId   String
  number    Int    // 1-8
  area      Decimal @db.Decimal(4,2)
  status    String @default("active")

  store     Store @relation(fields: [storeId], references: [id])
  slots     RoomSlot[]
  @@unique([storeId, number])
}

model CardioSeat {
  id      String @id @default(cuid())
  storeId String
  number  Int    // 1-6
  status  String @default("active")

  store   Store @relation(fields: [storeId], references: [id])
  slots   CardioSlot[]
  @@unique([storeId, number])
}
```

## 3. Schedule

```prisma
model RoomSlot {
  id        String       @id @default(cuid())
  roomId    String
  storeId   String
  startAt   DateTime     // 정각 또는 30분 (stagger)
  status    SlotStatus   @default(available)
  reservedBy String?      // memberId

  room      Room @relation(fields: [roomId], references: [id])
  reservation Reservation? @relation(fields: [reservedBy], references: [memberId])
  @@unique([roomId, startAt])
  @@index([startAt])
}

model CardioSlot {
  id        String       @id @default(cuid())
  seatId    String
  storeId   String
  startAt   DateTime     // 30분 단위
  status    SlotStatus   @default(available)
  reservedBy String?

  seat      CardioSeat @relation(fields: [seatId], references: [id])
  @@unique([seatId, startAt])
  @@index([startAt])
}

enum SlotStatus { available reserved completed }

model MentorBlock {
  id                  String     @id @default(cuid())
  mentorId            String
  startAt             DateTime   // 30분 단위 (정각 or 30분)
  status              BlockStatus @default(open)
  assignedSessionId   String?    @unique
  assignedAt          DateTime?
  cancelledAt         DateTime?
  cancellationReason  String?
  penaltyApplied      Boolean    @default(false)

  mentor              Mentor @relation(fields: [mentorId], references: [id])
  session             Session? @relation(fields: [assignedSessionId], references: [id])
  @@unique([mentorId, startAt])
  @@index([startAt, status])
}

enum BlockStatus { open assigned completed cancelled }

model FixedSlot {
  id           String @id @default(cuid())
  memberId     String
  weekday      Int    // 0-6
  hour         Int    // 18-21 (피크)
  minute       Int    // 0 or 30
  active       Boolean @default(true)
  lastMentorId String?  // 이전 멘토 (우선 매칭)
  createdAt    DateTime @default(now())

  member       Member @relation(fields: [memberId], references: [id])
  @@unique([memberId, weekday, hour, minute])
}
```

## 4. Reservation · Session

```prisma
model Reservation {
  id              String         @id @default(cuid())
  memberId        String
  sessionId       String         @unique
  cardioSlotId    String
  roomSlotId      String
  mentorId        String?
  mentorTier      MentorTier
  startAt         DateTime
  matchingMode    MatchingMode
  pointsCharged   Int?
  isFixed         Boolean        @default(false)
  status          ReservationStatus
  createdAt       DateTime       @default(now())
  cancelledAt     DateTime?
  cancelReason    String?

  member          Member @relation(fields: [memberId], references: [id])
  session         Session @relation(fields: [sessionId], references: [id])
  @@index([memberId, startAt])
  @@index([mentorId, startAt])
}

enum MatchingMode { manual auto }
enum ReservationStatus { confirmed rejected cancelled no_show completed }

model Session {
  id              String   @id @default(cuid())
  reservation     Reservation?
  startAt         DateTime
  checkedInAt     DateTime?
  startedAt       DateTime?
  completedAt     DateTime?
  cancelledAt     DateTime?
  status          SessionStatus

  record          SessionRecord?
  rating          Rating?
  recommendation  AIRecommendation? @relation("ForSession")
}

enum SessionStatus { booked checked_in in_progress completed no_show cancelled }

model DayPass {
  id          String @id @default(cuid())
  memberId    String
  issuedAt    DateTime @default(now())
  expiresAt   DateTime   // 발급일 23:59
  used        Boolean    @default(false)
  usedAt      DateTime?
  usedReservationId String?
  reason      String   // "late_cancel_48_to_6"

  member      Member @relation(fields: [memberId], references: [id])
}

model BonusCredit {
  id          String @id @default(cuid())
  memberId    String
  reason      String  // "pro_mentor_swap" | "mentor_no_show"
  expiresAt   DateTime  // 30일
  used        Boolean   @default(false)
  usedAt      DateTime?

  member      Member @relation(fields: [memberId], references: [id])
}
```

## 5. Records

```prisma
model SessionRecord {
  id               String   @id @default(cuid())
  sessionId        String   @unique
  mentorId         String
  performedAt      DateTime
  exercises        Json     // ExercisePerformed[] structured
  formNotes        String   @db.Text
  handoverNotes    String   @db.Text   // AI 학습 핵심
  memberCondition  String?  @db.Text
  totalVolumeKg    Decimal? @db.Decimal(7,2)
  enteredAt        DateTime  // 5분 내 SLA 측정

  session          Session @relation(fields: [sessionId], references: [id])
}

model Rating {
  id          String @id @default(cuid())
  sessionId   String @unique
  memberId    String
  mentorId    String
  score       Int    // 1-5
  comment     String? @db.Text
  createdAt   DateTime @default(now())

  session     Session @relation(fields: [sessionId], references: [id])
  @@index([mentorId])
}
```

## 6. AI

```prisma
model ExerciseLibrary {
  id              String @id @default(cuid())
  name            String
  category        String  // upper/lower/cardio/core/fullbody
  defaultSets     Int?
  defaultRepsMin  Int?
  defaultRepsMax  Int?
  intensityCurve  Json?
  formVideoUrl    String?
  safetyNotes     String?  @db.Text
}

model ProgramTemplate {
  id        String @id @default(cuid())
  phase     String  // hypertrophy/strength/fatloss/recovery
  stage     Int     // 1-4
  week      Int
  exercises Json    // library refs + intensity rules
}

model Phase {
  id          String @id @default(cuid())
  memberId    String @unique
  name        String  // "근비대"
  stage       Int
  weekInStage Int
  weeksTotal  Int
  startedAt   DateTime
  nextStageAt DateTime
}

model AIRecommendation {
  id              String @id @default(cuid())
  memberId        String
  forSessionId    String? @unique
  generatedAt     DateTime @default(now())
  plan            Json    // cardio + room_autonomous + mentor_30
  rationale       String? @db.Text
  sourceSessionIds String[]
  modelVersion    String?
  llmCostKrw      Decimal? @db.Decimal(8,2)
  
  forSession      Session? @relation("ForSession", fields: [forSessionId], references: [id])
}

model LLMCallLog {
  id          String @id @default(cuid())
  model       String  // "claude-sonnet-4-6"
  tokensIn    Int
  tokensOut   Int
  costKrw     Decimal @db.Decimal(8,2)
  memberId    String?
  sessionId   String?
  createdAt   DateTime @default(now())
}
```

## 7. Membership

```prisma
model Membership {
  id              String       @id @default(cuid())
  memberId        String
  type            MembershipType
  creditsRemaining Int          // week1=4 / week2=8
  contractMonths  Int           // 1,3,6,12
  discountRate    Decimal       @db.Decimal(3,2)  // 0, 0.05, 0.10, 0.15
  priceAtPurchase Int
  startedAt       DateTime
  expiresAt       DateTime
  pausedAt        DateTime?
  resumedAt       DateTime?
  pauseUsedDays   Int           @default(0)
  autoRenew       Boolean       @default(true)
  status          MembershipStatus
  createdAt       DateTime      @default(now())

  member          Member @relation(fields: [memberId], references: [id])
  @@index([memberId, status])
}

enum MembershipType { week1 week2 }
enum MembershipStatus { active paused expired cancelled }

model PointBalance {
  memberId      String @id
  balance       Int    @default(0)
  lastChargedAt DateTime?

  member        Member @relation(fields: [memberId], references: [id])
}

model Payment {
  id               String        @id @default(cuid())
  memberId         String
  type             PaymentType
  amount           Int
  currency         String        @default("KRW")
  status           PaymentStatus
  pgTransactionId  String?       @unique
  paidAt           DateTime?
  refundedAt       DateTime?
  description      String?

  member           Member @relation(fields: [memberId], references: [id])
  refund           Refund?
  @@index([memberId, paidAt])
}

enum PaymentType { membership point trial bonus }
enum PaymentStatus { pending paid failed refunded }

model Refund {
  id            String @id @default(cuid())
  paymentId     String @unique
  usedCredits   Int
  refundAmount  Int
  fee           Int    @default(0)
  reason        String
  processedAt   DateTime?

  payment       Payment @relation(fields: [paymentId], references: [id])
}
```

## 8. Mentor System

```prisma
model VerificationCourse {
  id          String @id @default(cuid())
  scheduledAt DateTime
  attendees   String[]  // mentor IDs
}

model ProCertificationApplication {
  id              String @id @default(cuid())
  mentorId        String
  appliedAt       DateTime @default(now())
  status          ApplicationStatus
  videoUrl        String?
  videoReviewScore Decimal?
  interviewAt     DateTime?
  interviewScore  Decimal?
  writtenScore    Decimal?
  decisionAt      DateTime?
  decisionBy      String?
  decisionNotes   String? @db.Text

  mentor          Mentor @relation(fields: [mentorId], references: [id])
}

enum ApplicationStatus { pending video_review interview written approved rejected }

model MentorRateChange {
  id              String @id @default(cuid())
  mentorId        String
  oldRate         Int
  newRate         Int
  changedAt       DateTime @default(now())
  appliedFromDate DateTime

  mentor          Mentor @relation(fields: [mentorId], references: [id])
}

model MentorComplaint {
  id           String @id @default(cuid())
  memberId     String
  mentorId     String
  sessionId    String
  severity     String  // low/medium/high
  text         String  @db.Text
  resolution   String? // feedback/tier_hold/tier_down/suspension
  adminNotes   String? @db.Text
  resolvedAt   DateTime?
  resolvedBy   String?
  tierImpact   Boolean @default(false)
  createdAt    DateTime @default(now())

  member       Member @relation(fields: [memberId], references: [id])
  mentor       Mentor @relation(fields: [mentorId], references: [id])
}

model TierChange {
  id        String @id @default(cuid())
  mentorId  String
  fromTier  MentorTier
  toTier    MentorTier
  reason    String
  changedAt DateTime @default(now())
  changedBy String

  mentor    Mentor @relation(fields: [mentorId], references: [id])
}
```

## 9. Payout

```prisma
model PayoutPeriod {
  id          String @id @default(cuid())
  startDate   DateTime  // 격주 시작 (월요일)
  endDate     DateTime
  cutoffAt    DateTime
  paymentDate DateTime
}

model PaymentLedger {
  id            String @id @default(cuid())
  paymentId     String @unique
  memberId      String
  amount        Int
  paidAt        DateTime
  status        LedgerStatus
  releasedAt    DateTime?  // 7일 후
}

enum LedgerStatus { escrow releasable refunded distributed }

model DistributionEntry {
  id              String @id @default(cuid())
  paymentLedgerId String
  recipientType   String  // mentor/hq/franchisee
  recipientId     String
  amount          Int
  appliedRate     Decimal?
  status          String  @default("pending")
}

model MentorPayout {
  id              String @id @default(cuid())
  mentorId        String
  periodId        String
  sessionCount    Int
  grossAmount     Int
  deductions      Int    @default(0)
  netAmount       Int
  status          PayoutStatus
  paidAt          DateTime?
  transactionId   String?

  mentor          Mentor @relation(fields: [mentorId], references: [id])
  @@index([mentorId, periodId])
}

enum PayoutStatus { calculated paid failed }

model MentorBankAccount {
  mentorId          String @id
  bank              String
  accountNumberEnc  String   // encrypted
  accountHolder     String
  verifiedAt        DateTime?
  lastUpdatedAt     DateTime @default(now())

  mentor            Mentor @relation(fields: [mentorId], references: [id])
}

model TaxReport {
  id            String @id @default(cuid())
  recipientType String   // mentor / franchisee
  recipientId   String
  period        String   // "2026-04"
  grossIncome   Int
  withholding   Int
  netIncome     Int
  reportUrl     String?  // PDF
  generatedAt   DateTime @default(now())
}
```

## 10. Audit / Policy

```prisma
model PolicyEvent {
  id          String @id @default(cuid())
  memberId    String?
  mentorId    String?
  type        String   // refund/pause/cancel/no_show/compensation/tier_change
  payload     Json
  createdAt   DateTime @default(now())
}

model CancellationLog {
  id                String @id @default(cuid())
  reservationId     String
  cancelledBy       String   // member/mentor/system
  cancelledAt       DateTime
  hoursBeforeSession Int
  category          String   // before_48h / 48h_to_6h / within_6h
  creditCharged     Int      @default(0)
  dayPassIssued     Boolean  @default(false)
  bonusCreditIssued Int      @default(0)
}
```

---

| 2026-05-13 | 초안 — 10 도메인 그룹 / 40+ 모델 통합 |
