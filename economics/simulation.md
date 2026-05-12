---
title: 📊 단위 경제 시뮬레이션
parent: 7. 경제성
nav_order: 0
---

# 단위 경제 시뮬레이션

> 슬라이더·드롭다운 조정 시 자동 계산. **현재 결정(주 1·2회권, 멘토 30분, 90평 8방, 직영)** 기준.

<style>
.pt-sim, .pt-sim * { box-sizing: border-box; }
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
.pt-sim h4 { margin: 1.1rem 0 0.5rem; font-size: 0.92rem; font-weight: 600; color: #374151; border: none !important; }
.pt-sim .pt-field {
  display: flex; align-items: center; gap: 0.8rem;
  margin: 0.55rem 0;
  background: transparent !important; padding: 0;
}
.pt-sim .pt-field-label {
  flex: 0 0 16rem; font-weight: 500; font-size: 0.92rem;
  color: #374151;
  background: transparent !important; padding: 0 !important; border: none !important;
}
.pt-sim .pt-field-label small { font-size: 0.78rem; color: #9ca3af; display: block; margin-top: 1px; }
.pt-sim input[type=range] { flex: 1; accent-color: #1a73e8; }
.pt-sim .pt-field-val {
  flex: 0 0 5.5rem; text-align: right;
  font-variant-numeric: tabular-nums; font-weight: 600;
  color: #1a73e8;
  background: transparent !important; padding: 0 !important; border: none !important;
}
.pt-sim select {
  padding: 0.35rem 0.6rem; border: 1px solid #d1d5db; border-radius: 6px;
  background: #fff; font-size: 0.92rem; flex: 1;
}
.pt-sim .pt-presets {
  display: flex; gap: 0.5rem; margin: 0.7rem 0 0.3rem;
}
.pt-sim .pt-preset-btn {
  flex: 1; padding: 0.5rem; border-radius: 6px;
  border: 1px solid #d1d5db; background: #fff;
  cursor: pointer; font-size: 0.85rem; color: #374151;
}
.pt-sim .pt-preset-btn:hover { background: #f3f4f6; }
.pt-sim .pt-preset-btn.active { background: #1a73e8; color: #fff; border-color: #1a73e8; }
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
  border-radius: 6px; border-bottom: none; margin: 0.2rem -0.5rem;
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
  .pt-sim .pt-field-label { flex: 0 0 11rem; font-size: 0.85rem; }
}
</style>

<div class="pt-sim">

  <h3>입력</h3>

  <h4>비용</h4>
  <div class="pt-field">
    <span class="pt-field-label">평당 임대료 <small>(만원/월)</small></span>
    <input type="range" id="i-rent" min="6" max="13" value="10" step="0.5">
    <span class="pt-field-val"><span id="v-rent">10</span>만</span>
  </div>
  <div class="pt-field">
    <span class="pt-field-label">인건비·관리비 <small>(만원/방/월)</small></span>
    <input type="range" id="i-ops" min="50" max="150" value="90" step="10">
    <span class="pt-field-val"><span id="v-ops">90</span>만</span>
  </div>

  <h4>멘토</h4>
  <div class="pt-field">
    <span class="pt-field-label">멘토 회당 <small>(30분 1:1, 원)</small></span>
    <input type="range" id="i-mentor" min="10000" max="35000" value="20000" step="1000">
    <span class="pt-field-val"><span id="v-mentor">20,000</span>원</span>
  </div>

  <h4>가동률 (시간대별)</h4>

  <div class="pt-presets">
    <button class="pt-preset-btn" data-preset="aggressive">공격적 (90/50/70)</button>
    <button class="pt-preset-btn active" data-preset="standard">표준 (85/35/60)</button>
    <button class="pt-preset-btn" data-preset="conservative">보수적 (70/25/50)</button>
  </div>

  <div class="pt-field">
    <span class="pt-field-label">🌟 골든타임 <small>평일 6-9 / 18-22 = 35h/주</small></span>
    <input type="range" id="i-golden" min="30" max="100" value="85" step="5">
    <span class="pt-field-val"><span id="v-golden">85</span>%</span>
  </div>
  <div class="pt-field">
    <span class="pt-field-label">🌤️ 오프피크 <small>평일 9-18 / 22-23 = 50h/주</small></span>
    <input type="range" id="i-offpeak" min="0" max="80" value="35" step="5">
    <span class="pt-field-val"><span id="v-offpeak">35</span>%</span>
  </div>
  <div class="pt-field">
    <span class="pt-field-label">📅 주말 <small>토·일 8-21 = 26h/주</small></span>
    <input type="range" id="i-weekend" min="20" max="100" value="60" step="5">
    <span class="pt-field-val"><span id="v-weekend">60</span>%</span>
  </div>

  <h4>운영 목표</h4>
  <div class="pt-field">
    <span class="pt-field-label">목표 흑자 <small>(만원/지점/월)</small></span>
    <input type="range" id="i-margin" min="0" max="2000" value="500" step="100">
    <span class="pt-field-val"><span id="v-margin">500</span>만</span>
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
    수식: 효율 방시간 = (35×골든% + 50×오프% + 26×주말%) × 4.3주<br/>
    방 1개 비용 = (평당 × 11) + 인건비 분담 · 우리 수령 = 비용 ÷ 효율방시간 · 회원결제 = 우리수령 + 멘토회당
  </div>
</div>

<script>
(function(){
  const $ = id => document.getElementById(id);
  const fmt = n => n.toLocaleString('ko-KR');
  const round = (n, step) => Math.round(n / step) * step;

  const presets = {
    aggressive:  { golden: 90, offpeak: 50, weekend: 70 },
    standard:    { golden: 85, offpeak: 35, weekend: 60 },
    conservative:{ golden: 70, offpeak: 25, weekend: 50 }
  };

  function applyPreset(name){
    const p = presets[name];
    $('i-golden').value = p.golden;
    $('i-offpeak').value = p.offpeak;
    $('i-weekend').value = p.weekend;
    document.querySelectorAll('.pt-preset-btn').forEach(b => {
      b.classList.toggle('active', b.dataset.preset === name);
    });
    calc();
  }

  document.querySelectorAll('.pt-preset-btn').forEach(b => {
    b.addEventListener('click', () => applyPreset(b.dataset.preset));
  });

  function calc(){
    const rent    = parseFloat($('i-rent').value);
    const ops     = parseInt($('i-ops').value, 10);
    const mentor  = parseInt($('i-mentor').value, 10);
    const golden  = parseInt($('i-golden').value, 10) / 100;
    const offpeak = parseInt($('i-offpeak').value, 10) / 100;
    const weekend = parseInt($('i-weekend').value, 10) / 100;
    const marginM = parseInt($('i-margin').value, 10);

    $('v-rent').textContent    = rent;
    $('v-ops').textContent     = ops;
    $('v-mentor').textContent  = fmt(mentor);
    $('v-golden').textContent  = (golden*100).toFixed(0);
    $('v-offpeak').textContent = (offpeak*100).toFixed(0);
    $('v-weekend').textContent = (weekend*100).toFixed(0);
    $('v-margin').textContent  = marginM;

    // 가동률 시간대별로 효율 방시간 계산 (방 1개/월)
    // 평일 골든 7h/일 × 5일 × 4.3주 = 150.5h (max)
    // 평일 오프피크 10h × 5 × 4.3 = 215h
    // 주말 13h × 2 × 4.3 = 111.8h
    const goldenMaxH  = 7 * 5 * 4.3;
    const offpeakMaxH = 10 * 5 * 4.3;
    const weekendMaxH = 13 * 2 * 4.3;
    const util = goldenMaxH*golden + offpeakMaxH*offpeak + weekendMaxH*weekend;

    const rentRoomM   = rent * 11;
    const costRoomM   = rentRoomM + ops;
    const costRoomWon = costRoomM * 10000;
    const takeBep     = util > 0 ? costRoomWon / util : 0;
    const marginRoom  = (marginM * 10000) / 8;
    const takeGoal    = util > 0 ? (costRoomWon + marginRoom) / util : 0;

    const payBep  = takeBep + mentor;
    const payGoal = takeGoal + mentor;
    const week2 = payGoal * 8;
    const week1 = payGoal * 4;
    const revStoreM = (payGoal * util * 8) / 10000;

    $('o-rent-room').textContent = rentRoomM.toFixed(0);
    $('o-cost-room').textContent = costRoomM.toFixed(0);
    $('o-hours').textContent     = util.toFixed(0);
    $('o-take-bep').textContent  = fmt(Math.round(takeBep));
    $('o-take-goal').textContent = fmt(Math.round(takeGoal));
    $('o-pay-bep').textContent   = fmt(round(payBep, 100));
    $('o-pay-goal').textContent  = fmt(round(payGoal, 100));
    $('o-week2').textContent     = fmt(round(week2, 1000));
    $('o-week1').textContent     = fmt(round(week1, 1000));
    $('o-rev').textContent       = revStoreM.toFixed(0);

    // 슬라이더 직접 조작 시 preset active 해제
    const matched = Object.entries(presets).find(([k,v]) =>
      Math.round(golden*100) === v.golden &&
      Math.round(offpeak*100) === v.offpeak &&
      Math.round(weekend*100) === v.weekend
    );
    document.querySelectorAll('.pt-preset-btn').forEach(b => {
      b.classList.toggle('active', matched && b.dataset.preset === matched[0]);
    });
  }

  ['i-rent','i-mentor','i-margin','i-ops','i-golden','i-offpeak','i-weekend']
    .forEach(id => $(id).addEventListener('input', calc));
  calc();
})();
</script>

---

## 시간대 정의

| 구분 | 평일 | 주말 | 주간 시간 |
|---|---|---|---|
| 🌟 **골든타임** | 06:00-09:00 (출근 전) + 18:00-22:00 (저녁 피크) = 7h/일 × 5일 | - | **35h/주** |
| 🌤️ **오프피크** | 09:00-18:00 (낮) + 22:00-23:00 (심야) = 10h/일 × 5일 | - | **50h/주** |
| 📅 **주말** | - | 08:00-21:00 = 13h/일 × 2일 | **26h/주** |
| 합 (운영 가능) | 평일 17h × 5 = 85h | 주말 13h × 2 = 26h | **111h/주** |

## 락된 가정 (시뮬레이터 안 변수 ❌)

- 표준 지점: 90평, 8방 (방 1개 11평 환산)
- 멘토 운영: 회원 1세션당 30분 1:1 → 멘토 1시간 = 2 회원
- 회원 1세션 = 90분 세트 (카디오 30 + 방 60)
- Phase 1 직영 (가맹 분배 ❌)
- 주 평균 = 4.3주/월

## 프리셋

| 시나리오 | 골든 | 오프피크 | 주말 | 평균 효율 방시간 |
|---|---|---|---|---|
| 공격적 | 90% | 50% | 70% | ~321h/월 |
| **표준** | 85% | 35% | 60% | ~270h/월 |
| 보수적 | 70% | 25% | 50% | ~215h/월 |

---

| 2026-05-13 | 9 시나리오 매트릭스 → 인터랙티브 슬라이더 |
| 2026-05-13 | 가동률 = 시간대별 개별 슬라이더 (골든/오프/주말) + 시간대 명시 |
