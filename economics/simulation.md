---
title: 📊 단위 경제 시뮬레이션
parent: 7. 경제성
nav_order: 0
---

# 단위 경제 시뮬레이션

> 슬라이더·드롭다운 조정 시 자동 계산. **현재 결정(주 1·2회권, 멘토 30분, 90평 8방, 직영)** 기준.

<style>
.pt-sim, .pt-sim * {
  box-sizing: border-box;
}
.pt-sim {
  background: #fafafa;
  border: 1px solid #e5e7eb;
  border-radius: 10px;
  padding: 1.3rem;
  margin: 1rem 0;
  font-family: system-ui, -apple-system, sans-serif;
  color: #1f2937;
}
.pt-sim h3 { margin: 0 0 0.8rem; font-size: 1.05rem; font-weight: 600; color: #111827; border: none !important; }
.pt-sim .pt-field {
  display: flex; align-items: center; gap: 0.8rem;
  margin: 0.6rem 0;
  background: transparent !important;
  padding: 0;
}
.pt-sim .pt-field-label {
  flex: 0 0 13rem;
  font-weight: 500;
  font-size: 0.93rem;
  color: #374151;
  background: transparent !important;
  padding: 0 !important;
  border: none !important;
}
.pt-sim input[type=range] { flex: 1; accent-color: #1a73e8; }
.pt-sim .pt-field-val {
  flex: 0 0 6rem; text-align: right;
  font-variant-numeric: tabular-nums; font-weight: 600;
  color: #1a73e8;
  background: transparent !important;
  padding: 0 !important;
  border: none !important;
}
.pt-sim select {
  padding: 0.35rem 0.6rem;
  border: 1px solid #d1d5db; border-radius: 6px;
  background: #fff; font-size: 0.92rem; flex: 1;
}
.pt-sim .pt-out {
  display: grid; grid-template-columns: repeat(2, 1fr); gap: 0 1rem;
  background: #fff; padding: 1rem 1.2rem; border-radius: 8px; margin-top: 1rem;
  border: 1px solid #e5e7eb;
}
.pt-sim .pt-row {
  display: flex; justify-content: space-between; align-items: baseline;
  padding: 0.55rem 0; border-bottom: 1px solid #f3f4f6;
}
.pt-sim .pt-row:last-child { border-bottom: none; }
.pt-sim .pt-row.pt-hi {
  background: #fffbeb; padding-left: 0.7rem; padding-right: 0.7rem;
  border-radius: 6px; border-bottom: none;
  margin: 0.2rem -0.5rem;
}
.pt-sim .pt-label {
  font-size: 0.92rem; color: #4b5563;
  background: transparent !important; padding: 0 !important; border: none !important;
}
.pt-sim .pt-num {
  font-weight: 600; font-variant-numeric: tabular-nums;
  font-size: 0.98rem; color: #111827;
  background: transparent !important; padding: 0 !important; border: none !important;
}
.pt-sim .pt-hi .pt-label { color: #92400e; font-weight: 600; }
.pt-sim .pt-hi .pt-num { color: #b45309; font-size: 1.08rem; }
.pt-sim .pt-formula {
  font-size: 0.83rem; color: #6b7280; margin-top: 0.7rem; line-height: 1.5;
}
@media (max-width: 700px) {
  .pt-sim .pt-out { grid-template-columns: 1fr; }
  .pt-sim .pt-field-label { flex: 0 0 9rem; font-size: 0.85rem; }
}
</style>

<div class="pt-sim">
  <h3>입력</h3>

  <div class="pt-field">
    <span class="pt-field-label">평당 임대료 (만원/월)</span>
    <input type="range" id="i-rent" min="6" max="13" value="10" step="0.5">
    <span class="pt-field-val"><span id="v-rent">10</span>만</span>
  </div>

  <div class="pt-field">
    <span class="pt-field-label">멘토 회당 (30분 1:1)</span>
    <input type="range" id="i-mentor" min="10000" max="35000" value="20000" step="1000">
    <span class="pt-field-val"><span id="v-mentor">20,000</span>원</span>
  </div>

  <div class="pt-field">
    <span class="pt-field-label">가동률 시나리오</span>
    <select id="i-util">
      <option value="321">공격적 (90/50/70 → 321h)</option>
      <option value="270" selected>표준 (85/35/60 → 270h)</option>
      <option value="215">보수적 (70/25/50 → 215h)</option>
    </select>
    <span class="pt-field-val"></span>
  </div>

  <div class="pt-field">
    <span class="pt-field-label">목표 흑자 (만원/지점/월)</span>
    <input type="range" id="i-margin" min="0" max="2000" value="500" step="100">
    <span class="pt-field-val"><span id="v-margin">500</span>만</span>
  </div>

  <div class="pt-field">
    <span class="pt-field-label">인건비·관리비 (만원/방/월)</span>
    <input type="range" id="i-ops" min="50" max="150" value="90" step="10">
    <span class="pt-field-val"><span id="v-ops">90</span>만</span>
  </div>

  <h3 style="margin-top:1.4rem;">결과</h3>

  <div class="pt-out">
    <div class="pt-row"><span class="pt-label">방 1개 임대료</span><span class="pt-num"><span id="o-rent-room"></span>만/월</span></div>
    <div class="pt-row"><span class="pt-label">방 1개 총 비용</span><span class="pt-num"><span id="o-cost-room"></span>만/월</span></div>
    <div class="pt-row"><span class="pt-label">효율 방시간/방/월</span><span class="pt-num"><span id="o-hours"></span>h</span></div>
    <div class="pt-row"><span class="pt-label">우리 시간당 (BEP)</span><span class="pt-num"><span id="o-take-bep"></span>원</span></div>
    <div class="pt-row"><span class="pt-label">우리 시간당 (흑자)</span><span class="pt-num"><span id="o-take-goal"></span>원</span></div>
    <div class="pt-row"><span class="pt-label">회원 결제 BEP (1세션)</span><span class="pt-num"><span id="o-pay-bep"></span>원</span></div>
    <div class="pt-row pt-hi"><span class="pt-label">회원 결제 (흑자, 1세션)</span><span class="pt-num"><span id="o-pay-goal"></span>원</span></div>
    <div class="pt-row pt-hi"><span class="pt-label">주 2회권 (월)</span><span class="pt-num"><span id="o-week2"></span>원</span></div>
    <div class="pt-row"><span class="pt-label">주 1회권 (월)</span><span class="pt-num"><span id="o-week1"></span>원</span></div>
    <div class="pt-row"><span class="pt-label">지점 월 매출 (예상)</span><span class="pt-num"><span id="o-rev"></span>만/월</span></div>
  </div>

  <div class="pt-formula">
    수식: 방 1개 비용 = (평당 × 11) + 인건비 분담 · 우리 수령 = 비용 ÷ 효율방시간 · 회원결제 = 우리수령 + 멘토회당
  </div>
</div>

<script>
(function(){
  const ids = ['i-rent','i-mentor','i-util','i-margin','i-ops'];
  const $ = id => document.getElementById(id);
  const fmt = n => n.toLocaleString('ko-KR');
  const round = (n, step) => Math.round(n / step) * step;

  function calc(){
    const rent = parseFloat($('i-rent').value);
    const mentor = parseInt($('i-mentor').value, 10);
    const util = parseInt($('i-util').value, 10);
    const marginM = parseInt($('i-margin').value, 10);
    const opsM = parseInt($('i-ops').value, 10);

    $('v-rent').textContent = rent;
    $('v-mentor').textContent = fmt(mentor);
    $('v-margin').textContent = marginM;
    $('v-ops').textContent = opsM;

    const rentRoomM = rent * 11;                  // 방 1개 임대료(만/월)
    const costRoomM = rentRoomM + opsM;           // 방 1개 총 비용(만)
    const costRoomWon = costRoomM * 10000;        // 원
    const takeBep = costRoomWon / util;           // BEP 시간당 (원)
    const marginRoomWon = (marginM * 10000) / 8;  // 방당 흑자 (원)
    const takeGoal = (costRoomWon + marginRoomWon) / util;

    const payBep = takeBep + mentor;
    const payGoal = takeGoal + mentor;

    const week2 = payGoal * 8;  // 월 8회
    const week1 = payGoal * 4;  // 월 4회

    const revPerRoomM = (payGoal * util) / 10000;  // 방 매출(만)
    const revStoreM = revPerRoomM * 8;             // 지점 매출(만)

    $('o-rent-room').textContent = rentRoomM.toFixed(0);
    $('o-cost-room').textContent = costRoomM.toFixed(0);
    $('o-hours').textContent = util;
    $('o-take-bep').textContent = fmt(Math.round(takeBep));
    $('o-take-goal').textContent = fmt(Math.round(takeGoal));
    $('o-pay-bep').textContent = fmt(round(payBep, 100));
    $('o-pay-goal').textContent = fmt(round(payGoal, 100));
    $('o-week2').textContent = fmt(round(week2, 1000));
    $('o-week1').textContent = fmt(round(week1, 1000));
    $('o-rev').textContent = revStoreM.toFixed(0);
  }

  ids.forEach(id => $(id).addEventListener('input', calc));
  calc();
})();
</script>

---

## 락된 가정 (시뮬레이터 안 변수 ❌)

- 표준 지점: 90평, 8방 (방 1개 11평 환산)
- 멘토 운영: 회원 1세션당 30분 1:1 → 멘토 1시간 = 2 회원
- 회원 1세션 = 90분 세트 (카디오 30 + 방 60)
- Phase 1 직영 (가맹 분배 ❌)

## 시나리오 의미

| 시나리오 | 골든타임 | 오프피크 | 주말 |
|---|---|---|---|
| 공격적 | 90% | 50% | 70% |
| 표준 | 85% | 35% | 60% |
| 보수적 | 70% | 25% | 50% |

---

| 2026-05-12 | 9 시나리오 매트릭스 |
| 2026-05-12 | 인터랙티브 슬라이더 시뮬레이션으로 교체 |
