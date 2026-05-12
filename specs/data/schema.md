---
title: 전체 스키마
parent: 🗄️ 데이터
grand_parent: 스펙 (PRD)
nav_order: 1
---

# 전체 DB 스키마 (Prisma) — 최종

**Status**: Draft · **Updated**: 2026-05-13
**참고 PRD**: 모든 플랫폼 PRD ([session](../platform/2026-05-13-session-system.html) · [membership](../platform/2026-05-13-membership-system.html) · [reservation](../platform/2026-05-13-reservation-system.html) · [ai](../platform/2026-05-13-ai-engine.html) · [mentor-tier](../platform/2026-05-13-mentor-tier-system.html) · [payout](../platform/2026-05-13-payout-system.html) · [admin-console](../platform/2026-05-13-admin-console.html))

> **Phase 1 MVP 풀 스키마.** 13건 정합성 이슈 모두 반영.

## 도메인 그룹

```
1. Identity        — Member · Mentor · Admin
2. Space           — Store · Room · CardioSeat
3. Schedule        — RoomSlot · CardioSlot · MentorBlock · FixedSlot
4. Reservation     — Reservation · Session · DayPass · BonusCredit
5. Records         — SessionRecord · Rating
6. AI              — ExerciseLibrary · ProgramTemplate · Phase · AIRecommendation · LLMCallLog
7. Membership      — Membership · PointBalance · Payment · Refund
8. Mentor System   — VerificationCourse · VerificationAttendance · ProCertificationApplication · MentorRateChange · MentorComplaint · TierChange
9. Payout          — PricingConfig · RevenueDistributionConfig · PayoutPeriod · PaymentLedger · DistributionEntry · MentorPayout · PayoutLineItem · PayoutDeduction · MentorBankAccount · TaxReport
10. Audit          — PolicyEvent · CancellationLog · AdminAuditLog
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
  ageRange      String?
  experience    String?
  goals         String[]
  weeklyTarget  Int?
  status        MemberStatus @default(active)
  deletedAt     DateTime?    // soft delete
  createdAt     DateTime     @default(now())

  memberships     Membership[]
  reservations    Reservation[]
  pointBalance    PointBalance?
  fixedSlots      FixedSlot[]
  ratings         Rating[]
  complaints      MentorComplaint[]
  payments        Payment[]
  dayPasses       DayPass[]
  bonusCredits    BonusCredit[]
  phase           Phase?

  @@index([status, createdAt])
}

enum MemberStatus { active inactive deleted }

model Mentor {
  id                 String       @id @default(cuid())
  email              String       @unique
  phone              String       @unique
  passwordHash       String
  name               String
  avatarUrl          String?
  // 가입·자격 신청 데이터 (멘토 앱 안에서 입력)
  licenseNumber      String?
  licenseType        String?
  licenseImageUrl    String?      // 자격증 업로드
  licenseVerified    Boolean      @default(false)
  experienceYears    Int?
  experienceText     String?
  motivationText     String?
  demoVideoUrl       String?
  applicationSubmittedAt DateTime?
  // 등급 (라이프사이클)
  tier               MentorTier   @default(pending_review)
  reviewedBy         String?      // admin id (검토자)
  reviewedAt         DateTime?
  rejectionReason    String?
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
  deletedAt          DateTime?    // soft delete
  createdAt          DateTime     @default(now())

  blocks             MentorBlock[]
  reservations       Reservation[]
  sessionRecords     SessionRecord[]
  ratings            Rating[]
  complaints         MentorComplaint[]
  bankAccount        MentorBankAccount?
  payouts            MentorPayout[]
  rateChanges        MentorRateChange[]
  tierChanges        TierChange[]
  fixedSlotPrev      FixedSlot[]  @relation("PreviousMentor")
  verifAttendances   VerificationAttendance[]
  proApplications    ProCertificationApplication[]

  @@index([tier, status])
  @@index([averageRating])
  @@index([reviewedAt])  // admin 큐
}

enum MentorTier { pending_review under_review verified pro_certified rejected }
enum MentorStatus { active suspended inactive }

model Admin {
  id           String   @id @default(cuid())
  email        String   @unique
  passwordHash String
  name         String
  role         AdminRole
  status       String   @default("active")
  lastLoginAt  DateTime?
  createdAt    DateTime @default(now())

  tierChanges     TierChange[]
  auditLogs       AdminAuditLog[]
}

enum AdminRole { super operator finance analyst }
```

## 2. Space

```prisma
model Store {
  id              String   @id @default(cuid())
  name            String
  address         String
  totalArea       Decimal  @db.Decimal(5,2)
  roomCount       Int      @default(8)
  cardioSeatCount Int      @default(6)
  openingTime     String   @default("06:00")
  closingTime     String   @default("23:00")
  weekendOpen     String?
  weekendClose    String?
  status          String   @default("active")
  openedAt        DateTime
  createdAt       DateTime @default(now())

  rooms           Room[]
  cardioSeats     CardioSeat[]
  reservations    Reservation[]

  @@index([status])
}

model Room {
  id           String @id @default(cuid())
  storeId      String
  number       Int
  area         Decimal @db.Decimal(4,2)
  staggerGroup String @default("A")  // A 정각 / B 30분
  status       String @default("active")
  createdAt    DateTime @default(now())

  store        Store @relation(fields: [storeId], references: [id])
  slots        RoomSlot[]

  @@unique([storeId, number])
  @@index([storeId, status])
}

model CardioSeat {
  id        String @id @default(cuid())
  storeId   String
  number    Int
  equipment String?
  status    String @default("active")
  createdAt DateTime @default(now())

  store     Store @relation(fields: [storeId], references: [id])
  slots     CardioSlot[]

  @@unique([storeId, number])
  @@index([storeId, status])
}
```

## 3. Schedule

```prisma
model RoomSlot {
  id                 String     @id @default(cuid())
  roomId             String
  storeId            String
  startAt            DateTime
  status             SlotStatus @default(available)
  reservedByMemberId String?

  room               Room @relation(fields: [roomId], references: [id])

  @@unique([roomId, startAt])
  @@index([startAt, status])
}

model CardioSlot {
  id                 String     @id @default(cuid())
  seatId             String
  storeId            String
  startAt            DateTime
  status             SlotStatus @default(available)
  reservedByMemberId String?

  seat               CardioSeat @relation(fields: [seatId], references: [id])

  @@unique([seatId, startAt])
  @@index([startAt, status])
}

enum SlotStatus { available reserved completed }

model MentorBlock {
  id                  String      @id @default(cuid())
  mentorId            String
  startAt             DateTime
  status              BlockStatus @default(open)
  assignedSessionId   String?     @unique
  assignedAt          DateTime?
  cancelledAt         DateTime?
  cancellationReason  String?
  penaltyApplied      Boolean     @default(false)

  mentor              Mentor @relation(fields: [mentorId], references: [id])

  @@unique([mentorId, startAt])
  @@index([startAt, status])
}

enum BlockStatus { open assigned completed cancelled }

model FixedSlot {
  id            String   @id @default(cuid())
  memberId      String
  weekday       Int      // 0-6
  hour          Int      // 18-21 피크 가설
  minute        Int      // 0 or 30
  active        Boolean  @default(true)
  lastMentorId  String?  // 이전 멘토 (우선 매칭)
  lastChangedAt DateTime?
  createdAt     DateTime @default(now())

  member        Member @relation(fields: [memberId], references: [id])
  lastMentor    Mentor? @relation("PreviousMentor", fields: [lastMentorId], references: [id])

  @@unique([memberId, weekday, hour, minute])
  @@index([active])
}
```

## 4. Reservation

```prisma
// ⚠️ Reservation 생성 시 cardioSlot + roomSlot + mentorBlock 동시 점유 트랜잭션 필수
// SERIALIZABLE isolation + row lock으로 처리 (application layer)

model Reservation {
  id              String            @id @default(cuid())
  memberId        String
  sessionId       String            @unique
  storeId         String
  cardioSlotId    String            @unique
  roomSlotId      String            @unique
  mentorBlockId   String?           @unique
  mentorId        String?
  mentorTier      MentorTier
  startAt         DateTime
  matchingMode    MatchingMode
  autoMatchedAt   DateTime?
  pointsCharged   Int?
  isFixed         Boolean           @default(false)
  status          ReservationStatus
  createdAt       DateTime          @default(now())
  cancelledAt     DateTime?
  cancelReason    String?

  member          Member @relation(fields: [memberId], references: [id])
  session         Session @relation(fields: [sessionId], references: [id])
  store           Store @relation(fields: [storeId], references: [id])
  mentor          Mentor? @relation(fields: [mentorId], references: [id])

  @@index([memberId, startAt])
  @@index([mentorId, startAt])
  @@index([storeId, status, startAt])
  @@index([startAt, status])
}

enum MatchingMode { manual auto }
enum ReservationStatus { confirmed rejected cancelled no_show completed }

model Session {
  id                String        @id @default(cuid())
  reservationId     String        @unique  // 1:1 (양방향 unique)
  memberId          String
  mentorId          String?
  storeId           String
  startAt           DateTime
  checkedInAt       DateTime?
  startedAt         DateTime?
  mentorEnteredAt   DateTime?
  completedAt       DateTime?
  cancelledAt       DateTime?
  status            SessionStatus @default(booked)

  reservation       Reservation?
  record            SessionRecord?
  rating            Rating?
  recommendation    AIRecommendation? @relation("ForSession")

  @@index([startAt, status])
  @@index([memberId, startAt])
  @@index([mentorId, startAt])
}

enum SessionStatus { booked checked_in in_progress completed no_show cancelled }

model DayPass {
  id                String   @id @default(cuid())
  memberId          String
  issuedAt          DateTime @default(now())
  expiresAt         DateTime  // 발급일 23:59
  reason            String   // late_cancel_48_to_6
  sourceReservationId String?
  used              Boolean  @default(false)
  usedAt            DateTime?
  usedReservationId String?

  member            Member @relation(fields: [memberId], references: [id])

  @@index([memberId, used, expiresAt])
}

model BonusCredit {
  id                String   @id @default(cuid())
  memberId          String
  issuedAt          DateTime @default(now())
  expiresAt         DateTime  // +30일
  reason            String   // pro_mentor_swap / mentor_no_show
  sourceReservationId String?
  used              Boolean  @default(false)
  usedAt            DateTime?
  usedReservationId String?

  member            Member @relation(fields: [memberId], references: [id])

  @@index([memberId, used, expiresAt])
}
```

## 5. Records

```prisma
model SessionRecord {
  id               String   @id @default(cuid())
  sessionId        String   @unique
  mentorId         String
  performedAt      DateTime
  exercises        Json     // ExercisePerformed[]
  formNotes        String   @db.Text
  handoverNotes    String   @db.Text  // AI 학습용
  memberCondition  String?  @db.Text
  totalVolumeKg    Decimal? @db.Decimal(7,2)
  enteredAt        DateTime  @default(now())
  modifiedAt       DateTime?

  session          Session @relation(fields: [sessionId], references: [id])
  mentor           Mentor @relation(fields: [mentorId], references: [id])

  @@index([mentorId, performedAt])
}

model Rating {
  id              String @id @default(cuid())
  sessionId       String @unique
  memberId        String
  mentorId        String
  score           Int    // 1-5
  comment         String? @db.Text
  publicOnProfile Boolean @default(true)
  createdAt       DateTime @default(now())

  session         Session @relation(fields: [sessionId], references: [id])
  member          Member @relation(fields: [memberId], references: [id])
  mentor          Mentor @relation(fields: [mentorId], references: [id])

  @@index([mentorId])
}
```

## 6. AI

```prisma
model ExerciseLibrary {
  id              String   @id @default(cuid())
  name            String
  nameEn          String?
  category        String   // upper/lower/cardio/core/fullbody
  muscleGroups    String[]
  defaultSets     Int?
  defaultRepsMin  Int?
  defaultRepsMax  Int?
  intensityCurve  Json?
  formVideoUrl    String?
  safetyNotes     String?  @db.Text
  status          String   @default("active")
  createdAt       DateTime @default(now())

  @@index([category, status])
}

model ProgramTemplate {
  id          String @id @default(cuid())
  phaseType   String
  phaseLabel  String
  stage       Int
  weekInStage Int
  exercises   Json
  difficulty  String   // beginner/intermediate/advanced
  status      String   @default("active")

  @@unique([phaseType, stage, weekInStage, difficulty])
}

model Phase {
  id              String   @id @default(cuid())
  memberId        String   @unique
  phaseType       String
  phaseLabel      String
  stage           Int      @default(1)
  weekInStage     Int      @default(1)
  weeksTotal      Int      @default(24)
  startedAt       DateTime @default(now())
  nextStageAt     DateTime?
  progressPercent Decimal?
  customNotes     String?  @db.Text

  member          Member @relation(fields: [memberId], references: [id])
}

model AIRecommendation {
  id              String   @id @default(cuid())
  memberId        String
  forSessionId    String?  @unique
  forSessionAt    DateTime
  generatedAt     DateTime @default(now())
  plan            Json     // cardio + room_autonomous + mentor_30
  rationale       String?  @db.Text
  sourceSessionIds String[]
  modelVersion    String?
  llmCostKrw      Decimal? @db.Decimal(8,2)
  status          String   @default("active")

  forSession      Session? @relation("ForSession", fields: [forSessionId], references: [id])

  @@index([memberId, generatedAt(sort: Desc)])
}

model LLMCallLog {
  id          String   @id @default(cuid())
  model       String
  provider    String
  tokensIn    Int
  tokensOut   Int
  costKrw     Decimal  @db.Decimal(8,2)
  memberId    String?
  sessionId   String?
  purpose     String   // recommendation/monthly_analysis/summary
  latencyMs   Int?
  success     Boolean  @default(true)
  errorMessage String?
  createdAt   DateTime @default(now())

  @@index([memberId, createdAt])
  @@index([provider, createdAt])
  @@index([purpose])
}
```

## 7. Membership

```prisma
model Membership {
  id              String           @id @default(cuid())
  memberId        String
  type            MembershipType
  creditsRemaining Int
  contractMonths  Int
  discountRate    Decimal          @db.Decimal(3,2)
  pricePerMonth   Int
  priceCharged    Int
  paidAt          DateTime
  activatedAt     DateTime?         // 첫 사용 시점 (status=active 전환)
  autoActivateBy  DateTime          // paidAt + 30일
  expiresAt       DateTime?         // 활성화 시점 + contractMonths
  pausedAt        DateTime?
  resumedAt       DateTime?
  pauseUsedDays   Int               @default(0)
  autoRenew       Boolean           @default(true)
  extensionCount  Int               @default(0)
  status          MembershipStatus  @default(created)
  createdAt       DateTime          @default(now())

  member          Member @relation(fields: [memberId], references: [id])

  @@index([memberId, status])
  @@index([expiresAt])
  @@index([autoRenew, expiresAt])
  @@index([autoActivateBy])  // cron 자동 활성화
}

enum MembershipType { week1 week2 }
enum MembershipStatus { created active paused expired cancelled }

model PointBalance {
  memberId       String   @id
  balance        Int      @default(0)
  lifetimeCharged Int     @default(0)
  lifetimeSpent  Int      @default(0)
  lastChargedAt  DateTime?
  lastSpentAt    DateTime?

  member         Member @relation(fields: [memberId], references: [id])
}

model Payment {
  id              String        @id @default(cuid())
  memberId        String
  type            PaymentType
  referenceId     String?
  amount          Int
  currency        String        @default("KRW")
  status          PaymentStatus
  pgProvider      String?
  pgTransactionId String?       @unique
  pgRawResponse   Json?
  paidAt          DateTime?
  refundedAt      DateTime?
  description     String?
  createdAt       DateTime      @default(now())

  member          Member @relation(fields: [memberId], references: [id])
  refund          Refund?
  ledger          PaymentLedger?

  @@index([memberId, paidAt])
  @@index([status, createdAt])  // pending 추적
}

enum PaymentType { membership point trial bonus }
enum PaymentStatus { pending paid failed refunded }

model Refund {
  id            String   @id @default(cuid())
  paymentId     String   @unique
  usedCredits   Int      @default(0)
  refundAmount  Int
  fee           Int      @default(0)
  reason        String
  status        String   @default("pending")
  pgRefundId    String?
  processedAt   DateTime?

  payment       Payment @relation(fields: [paymentId], references: [id])

  @@index([status, createdAt])
}
```

## 8. Mentor System

```prisma
model VerificationCourse {
  id           String   @id @default(cuid())
  scheduledAt  DateTime
  durationHours Int     @default(8)
  modules      String[]
  capacity     Int      @default(20)
  status       String   @default("scheduled")
  createdAt    DateTime @default(now())

  attendances  VerificationAttendance[]
}

model VerificationAttendance {
  id               String   @id @default(cuid())
  courseId         String
  mentorId         String
  attendedModules  String[]
  demoPassed       Boolean  @default(false)
  evaluatorAdminId String?
  approvedAt       DateTime?

  course           VerificationCourse @relation(fields: [courseId], references: [id])
  mentor           Mentor @relation(fields: [mentorId], references: [id])

  @@unique([courseId, mentorId])
}

model ProCertificationApplication {
  id                   String            @id @default(cuid())
  mentorId             String
  appliedAt            DateTime          @default(now())
  status               ApplicationStatus @default(pending)
  videoUrl             String?
  videoSubmittedAt     DateTime?
  videoReviewScore     Decimal?          @db.Decimal(2,1)
  videoReviewerAdminId String?
  interviewScheduledAt DateTime?
  interviewScore       Decimal?          @db.Decimal(2,1)
  writtenScore         Decimal?          @db.Decimal(2,1)
  decisionAt           DateTime?
  decisionByAdminId    String?
  decisionNotes        String?           @db.Text

  mentor               Mentor @relation(fields: [mentorId], references: [id])

  @@index([mentorId, status])  // 멘토당 1 active enforcement (app-level)
  @@index([status, appliedAt])
}

enum ApplicationStatus { pending video_review interview written approved rejected }

model MentorRateChange {
  id              String   @id @default(cuid())
  mentorId        String
  oldRate         Int
  newRate         Int
  changedAt       DateTime @default(now())
  appliedFromDate DateTime

  mentor          Mentor @relation(fields: [mentorId], references: [id])

  @@index([mentorId, appliedFromDate])
}

model MentorComplaint {
  id                 String    @id @default(cuid())
  memberId           String
  mentorId           String
  sessionId          String?
  severity           String    // low/medium/high
  text               String    @db.Text
  status             String    @default("pending")  // pending/in_review/resolved/escalated
  resolution         String?   // feedback/tier_hold/tier_down/suspension
  adminNotes         String?   @db.Text
  resolvedAt         DateTime?
  resolvedByAdminId  String?
  tierImpact         Boolean   @default(false)
  memberCompensation Int?
  createdAt          DateTime  @default(now())

  member             Member @relation(fields: [memberId], references: [id])
  mentor             Mentor @relation(fields: [mentorId], references: [id])

  @@index([mentorId, status])
  @@index([status, severity, createdAt])
}

model TierChange {
  id                  String     @id @default(cuid())
  mentorId            String
  fromTier            MentorTier
  toTier              MentorTier
  reason              String
  changedAt           DateTime   @default(now())
  changedByAdminId    String?    // null = system
  relatedApplicationId String?
  relatedComplaintId  String?

  mentor              Mentor @relation(fields: [mentorId], references: [id])
  changedBy           Admin? @relation(fields: [changedByAdminId], references: [id])

  @@index([mentorId, changedAt(sort: Desc)])
}
```

## 9. Payout

```prisma
// ⚠️ PricingConfig·RevenueDistributionConfig는 admin이 운영 중 가변 설정
// 진행 중 예약은 configSnapshot으로 보존

model PricingConfig {
  id                String   @id @default(cuid())
  name              String
  sessionPriceWon   Int
  pointSurchargeWon Int?
  scope             String   // global/time_band/slot_type/mentor_tier
  scopeValue        String?
  priority          Int      @default(0)
  active            Boolean  @default(true)
  effectiveFrom     DateTime
  effectiveUntil    DateTime?
  createdAt         DateTime @default(now())
  createdByAdminId  String

  @@index([scope, scopeValue, active, priority])
  @@index([effectiveFrom, effectiveUntil])
}

model RevenueDistributionConfig {
  id                  String   @id @default(cuid())
  name                String
  scope               String
  scopeValue          String?
  priority            Int      @default(0)
  mode                String   // percentage/flat/hybrid
  mentorPercent       Decimal? @db.Decimal(4,2)
  mentorFlatRate      Int?
  hqPercent           Decimal? @db.Decimal(4,2)
  hqFlatRate          Int?
  franchiseePercent   Decimal? @db.Decimal(4,2)
  franchiseeFlatRate  Int?
  active              Boolean  @default(true)
  effectiveFrom       DateTime
  effectiveUntil      DateTime?
  createdAt           DateTime @default(now())
  createdByAdminId    String

  @@index([scope, scopeValue, active, priority])
  @@index([effectiveFrom, effectiveUntil])
}

model PayoutPeriod {
  id          String   @id @default(cuid())
  startDate   DateTime
  endDate     DateTime
  cutoffAt    DateTime
  paymentDate DateTime
  status      String   @default("open")  // open/calculating/paid
  createdAt   DateTime @default(now())

  mentorPayouts MentorPayout[]
}

model PaymentLedger {
  id          String       @id @default(cuid())
  paymentId   String       @unique
  memberId    String
  amount      Int
  paidAt      DateTime
  status      LedgerStatus @default(escrow)
  releasedAt  DateTime?

  payment     Payment @relation(fields: [paymentId], references: [id])
  distributions DistributionEntry[]

  @@index([status, paidAt])  // 7일 후 cron
}

enum LedgerStatus { escrow releasable refunded distributed }

model DistributionEntry {
  id                  String   @id @default(cuid())
  paymentLedgerId     String
  // 다형 참조 — 두 필드 중 하나만 NOT NULL
  mentorRecipientId   String?
  franchiseeStoreId   String?
  recipientType       String   // mentor/hq/franchisee
  amount              Int
  appliedRate         Decimal? @db.Decimal(4,3)
  configSnapshot      Json     // 적용된 config 전체
  configId            String?
  paidInPeriodId      String?
  status              String   @default("pending")  // pending/paid
  createdAt           DateTime @default(now())

  ledger              PaymentLedger @relation(fields: [paymentLedgerId], references: [id])

  @@index([paymentLedgerId])
  @@index([recipientType, mentorRecipientId, status])
  @@index([recipientType, franchiseeStoreId, status])
}

model MentorPayout {
  id            String       @id @default(cuid())
  mentorId      String
  periodId      String
  sessionCount  Int
  grossAmount   Int
  deductions    Int          @default(0)
  netAmount     Int
  status        PayoutStatus @default(calculated)
  paidAt        DateTime?
  transactionId String?
  failureReason String?

  mentor        Mentor @relation(fields: [mentorId], references: [id])
  period        PayoutPeriod @relation(fields: [periodId], references: [id])
  lineItems     PayoutLineItem[]
  deductionsList PayoutDeduction[]

  @@unique([mentorId, periodId])
  @@index([status, periodId])
}

enum PayoutStatus { calculated paid failed }

model PayoutLineItem {
  id                String     @id @default(cuid())
  payoutId          String
  sessionId         String
  sessionDate       DateTime
  rateApplied       Int
  mentorTierAtTime  MentorTier
  amount            Int

  payout            MentorPayout @relation(fields: [payoutId], references: [id])

  @@index([payoutId])
}

model PayoutDeduction {
  id        String @id @default(cuid())
  payoutId  String
  type      String  // no_show/late_cancel/tier_demotion
  sessionId String?
  amount    Int
  reason    String

  payout    MentorPayout @relation(fields: [payoutId], references: [id])

  @@index([payoutId])
}

model MentorBankAccount {
  mentorId          String   @id  // 1:1
  bank              String
  accountNumberEnc  String   // AES-256
  accountNumberLast4 String
  accountHolder     String
  verifiedAt        DateTime?
  lastUpdatedAt     DateTime @default(now())

  mentor            Mentor @relation(fields: [mentorId], references: [id])
}

model TaxReport {
  id            String   @id @default(cuid())
  recipientType String   // mentor/franchisee
  recipientId   String
  period        String   // "2026-04"
  grossIncome   Int
  withholding   Int
  netIncome     Int
  reportUrl     String?
  generatedAt   DateTime @default(now())

  @@unique([recipientType, recipientId, period])
}
```

## 10. Audit

```prisma
model PolicyEvent {
  id          String   @id @default(cuid())
  memberId    String?
  mentorId    String?
  storeId     String?
  type        String   // refund/pause/cancel/no_show/compensation/tier_change
  subType     String?
  payload     Json
  triggeredBy String   // system/member_xxx/admin_xxx
  createdAt   DateTime @default(now())

  @@index([memberId, createdAt])
  @@index([mentorId, createdAt])
  @@index([type, createdAt])
  @@index([storeId, createdAt])
}

model CancellationLog {
  id                 String   @id @default(cuid())
  reservationId      String
  sessionStartAt     DateTime
  cancelledBy        String   // member/mentor/system/admin
  cancelledById      String
  cancelledAt        DateTime @default(now())
  hoursBeforeSession Decimal  @db.Decimal(5,2)
  category           String   // before_48h/48h_to_6h/within_6h/mentor_no_show/member_no_show
  creditCharged      Int      @default(0)
  dayPassIssued      Boolean  @default(false)
  dayPassId          String?
  bonusCreditIssued  Int      @default(0)
  bonusCreditId      String?
  penaltyOnMentor    Boolean  @default(false)
  mentorPayoutDeduction Int   @default(0)
  reason             String?

  @@index([cancelledBy, cancelledAt])
  @@index([category, cancelledAt])
}

model AdminAuditLog {
  id          String   @id @default(cuid())
  adminId     String
  action      String   // config_update/tier_change/refund_approved 등
  targetType  String?
  targetId    String?
  before      Json
  after       Json
  reason      String?
  createdAt   DateTime @default(now())

  admin       Admin @relation(fields: [adminId], references: [id])

  @@index([adminId, createdAt])
  @@index([action, createdAt])
}
```

---

## 🔒 Constraints & Triggers (Application Layer)

스키마 외 application-level validation 의무:

### A. 트랜잭션 보장

| 작업 | 필수 |
|---|---|
| Reservation 생성 | cardioSlot + roomSlot + mentorBlock 3 슬롯 동시 점유 SERIALIZABLE + row lock |
| 환불 (Refund) | Payment status='refunded' + PaymentLedger 회수 + DistributionEntry 차감 트랜잭션 |
| 멘토 정산 산출 | PaymentLedger.distributed 전환 + MentorPayout 생성 + LineItem·Deduction 추가 트랜잭션 |
| Pro 인증 통과 | Mentor.tier 변경 + TierChange 기록 + ProCertificationApplication.status='approved' 트랜잭션 |

### B. State Machine 검증

| 모델 | 룰 |
|---|---|
| Membership | created → active 전환 시 activatedAt·expiresAt 필수 set |
| Mentor.tier | 변경 시 TierChange 기록 의무 |
| Mentor.proCurrentRate | 변경 시 MentorRateChange 기록 의무 |
| Reservation | 생성 시 점유 슬롯 status='reserved' 변경 동시 |

### C. 비즈니스 룰

| 룰 | 검증 |
|---|---|
| 한 회원 = 1 active/created Membership | unique partial index 또는 app-level check |
| 멘토당 1 active ProCertificationApplication | app-level (status NOT IN approved/rejected) |
| Rating 평가 기간 = session.completedAt + 7일 | app-level check |
| BonusCredit 만료 30일 | cron 자동 archive |
| DayPass 만료 = 발급일 23:59 | cron 자동 archive |
| 일시정지 한도 = 약정 30% | app-level + UI 차단 |
| autoRenew=false 만료 시 자동 해지 | cron |

### D. Soft Delete 정책

| 모델 | 정책 |
|---|---|
| Member | status='deleted' + deletedAt (5년 후 hard delete) |
| Mentor | status='inactive'/'suspended', 활동 데이터 보존 |
| Session·SessionRecord·Rating | hard delete ❌ (감사 추적) |
| Payment·Refund·CancellationLog·PolicyEvent | append-only, 삭제 ❌ |
| Reservation | cancelled 상태 유지 (deletion ❌) |

### E. Cron Jobs

| Job | 주기 | 작업 |
|---|---|---|
| no-show-detection | 매분 | T+15 미체크인 → status='no_show' + PolicyEvent + 회차 차감 |
| fixed-slot-auto-book | 매주 일요일 자정 | active FixedSlot에 다음 주 자동 예약 시도 |
| payment-ledger-release | 매시간 | escrow + 7일 경과 → releasable |
| payout-calculate | 격주 마감일 자정 | MentorPayout 산출 |
| membership-auto-activate | 매일 자정 | autoActivateBy 도달 + status='created' → active 전환 |
| membership-renewal | 매일 자정 | D-1 만료 + autoRenew=true → 결제·갱신 |
| tax-report-generate | 월말 | 멘토·가맹점주 TaxReport 생성 |
| bonus-credit-expire | 매일 | BonusCredit 만료 archive |
| day-pass-expire | 매일 자정 | DayPass 만료 archive |

---

## 📊 정합성 체크리스트 (감사 13건 반영)

| # | 이슈 | 상태 |
|---|---|---|
| 1 | SessionRecord.mentorId FK | ✅ 추가 |
| 2 | FixedSlot.lastMentorId FK | ✅ 추가 (relation "PreviousMentor") |
| 3 | PayoutLineItem·PayoutDeduction 모델 | ✅ 추가 |
| 4 | DistributionEntry 다형 참조 분리 | ✅ mentorRecipientId·franchiseeStoreId |
| 5 | PricingConfig·RevenueDistributionConfig | ✅ 추가 |
| 6 | Reservation 동시 점유 보장 | ✅ 트랜잭션 명시 + composite unique |
| 7 | Session.reservationId @unique | ✅ 양방향 unique |
| 8 | VerificationAttendance 모델 | ✅ 추가 |
| 9 | ProCertificationApplication 1 active enforcement | ✅ app-level 명시 |
| 10 | Soft delete 정책 | ✅ 섹션 추가 (deletedAt 컬럼) |
| 11 | Performance index 누락 | ✅ composite index 추가 (PaymentLedger·Membership 등) |
| 12 | Mentor.tier·rate 변경 시 기록 의무 | ✅ application trigger 명시 |
| 13 | Rating·BonusCredit·DayPass 만료 검증 | ✅ cron 작업 명시 |

---

## 📘 사용 PRD

[모든 플랫폼 PRD](../platform/) · [어드민 콘솔](../platform/2026-05-13-admin-console.html)

---

| 2026-05-13 | 초안 (10 도메인) |
| 2026-05-13 | 13건 정합성 + 멘토 흐름 + 회원권 라이프사이클 + 가변 config 일괄 반영 |
