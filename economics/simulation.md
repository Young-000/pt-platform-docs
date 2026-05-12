---
title: 📊 단위 경제 시뮬레이션
parent: 7. 경제성
nav_order: 0
---

# 단위 경제 시뮬레이션

> **3단계 흐름**: 공간 → 비용 → 운영 → 결과 가격대.

<style>
.pt-sim, .pt-sim * { box-sizing: border-box; }
.pt-sim {
  background: #fafafa; border: 1px solid #e5e7eb; border-radius: 10px;
  padding: 1.3rem; margin: 1rem 0;
  font-family: system-ui, -apple-system, sans-serif; color: #1f2937;
}
.pt-sim .pt-card {
  background: #fff; border: 1px solid #e5e7eb; border-radius: 8px;
  padding: 1rem 1.1rem; margin: 0.7rem 0;
}
.pt-sim .pt-card-title {
  font-size: 0.78rem; font-weight: 700; color: #6b7280;
  text-transform: uppercase; letter-spacing: 0.05em;
  margin: 0 0 0.7rem; display: flex; align-items: center; gap: 0.4rem;
}
.pt-sim .pt-card-title .badge { background: #f3f4f6; color: #4b5563; font-size: 0.7rem; padding: 0.1rem 0.4rem; border-radius: 999px; }
.pt-sim .pt-field {
  display: grid; grid-template-columns: 1fr 1.2fr auto; align-items: center; gap: 0.8rem;
  padding: 0.4rem 0;
}
.pt-sim .pt-field-label {
  font-weight: 500; font-size: 0.9rem; color: #374151;
}
.pt-sim .pt-field-label small { font-size: 0.74rem; color: #9ca3af; display: block; margin-top: 1px; font-weight: 400; }
.pt-sim input[type=range] { width: 100%; accent-color: #1a73e8; }
.pt-sim .pt-field-val {
  min-width: 5rem; text-align: right;
  font-variant-numeric: tabular-nums; font-weight: 600; color: #1a73e8;
}
.pt-sim .pt-derived {
  background: #f0f7ff; border-top: 1px solid #dbeafe;
  margin: 0.7rem -1.1rem -1rem;
  padding: 0.7rem 1.1rem; border-radius: 0 0 8px 8px;
  display: flex; flex-wrap: wrap; gap: 1.2rem;
}
.pt-sim .pt-derived .item { font-size: 0.85rem; color: #1e40af; }
.pt-sim .pt-derived .item b { color: #0c3a91; font-weight: 700; }
.pt-sim .pt-presets {
  display: flex; gap: 0.4rem; margin: 0 0 0.6rem;
}
.pt-sim .pt-preset-btn {
  flex: 1; padding: 0.45rem 0.5rem; border-radius: 6px;
  border: 1px solid #d1d5db; background: #fff;
  cursor: pointer; font-size: 0.82rem; color: #374151;
}
.pt-sim .pt-preset-btn:hover { background: #f3f4f6; }
.pt-sim .pt-preset-btn.active { background: #1a73e8; color: #fff; border-color: #1a73e8; }
.pt-sim .pt-result {
  background: #fff; border: 2px solid #fbbf24; border-radius: 8px;
  padding: 1.1rem 1.2rem; margin: 1rem 0;
}
.pt-sim .pt-result-title {
  font-size: 0.85rem; font-weight: 700; color: #92400e;
  text-transform: uppercase; letter-spacing: 0.05em;
  margin: 0 0 0.7rem;
}
.pt-sim .pt-result-grid {
  display: grid; grid-template-columns: repeat(2, 1fr); gap: 0.8rem 1.5rem;
}
.pt-sim .pt-result-row { display: flex; justify-content: space-between; align-items: baseline; padding: 0.3rem 0; }
.pt-sim .pt-result-row.pt-hi { background: #fffbeb; padding: 0.4rem 0.6rem; border-radius: 6px; }
.pt-sim .pt-result-label { font-size: 0.9rem; color: #4b5563; }
.pt-sim .pt-result-num { font-weight: 600; font-variant-numeric: tabular-nums; color: #111827; }
.pt-sim .pt-hi .pt-result-label { color: #92400e; font-weight: 600; }
.pt-sim .pt-hi .pt-result-num { color: #b45309; font-size: 1.05rem; }
.pt-sim .pt-formula { font-size: 0.78rem; color: #6b7280; margin-top: 0.7rem; line-height: 1.5; }
@media (max-width: 700px) {
  .pt-sim .pt-result-grid { grid-template-columns: 1fr; }
  .pt-sim .pt-field { grid-template-columns: 1fr; gap: 0.3rem; }
  .pt-sim .pt-field-val { text-align: left; }
}
</style>

<div class="pt-sim">

  <!-- 1. 공간 -->
  <div class="pt-card">
    <div class="pt-card-title">1️⃣ 공간 설정 <span class="badge">SPACE</span></div>
    <div class="pt-field">
      <span class="pt-field-label">방 수</span>
      <input type="range" id="i-rooms" min="4" max="12" value="8" step="1">
      <span class="pt-field-val"><span id="v-rooms">8</span>개</span>
    </div>
    <div class="pt-field">
      <span class="pt-field-label">방당 평수</span>
      <input type="range" id="i-roomArea" min="5" max="10" value="7" step="0.5">
      <span class="pt-field-val"><span id="v-roomArea">7</span>평</span>
    </div>
    <div class="pt-field">
      <span class="pt-field-label">공용 공간 비율 <small>카디오 + 라운지·탈의·샤워</small></span>
      <input type="range" id="i-commonRatio" min="20" max="50" value="38" step="2">
      <span class="pt-field-val"><span id="v-commonRatio">38</span>%</span>
    </div>
    <div class="pt-derived">
      <div class="item">방 총 면적 <b id="d-roomTotal">56</b>평</div>
      <div class="item">공용 면적 <b id="d-commonTotal">34</b>평</div>
      <div class="item">→ 전체 평수 <b id="d-totalArea">90</b>평</div>
    </div>
  </div>

  <!-- 2. 비용 -->
  <div class="pt-card">
    <div class="pt-card-title">2️⃣ 비용 설정 <span class="badge">COST</span></div>
    <div class="pt-field">
      <span class="pt-field-label">평당 임대료 <small>만원/월</small></span>
      <input type="range" id="i-rent" min="6" max="15" value="10" step="0.5">
      <span class="pt-field-val"><span id="v-rent">10</span>만</span>
    </div>
    <div class="pt-field">
      <span class="pt-field-label">인건비·관리비 <small>지점/월</small></span>
      <input type="range" id="i-ops" min="300" max="1500" value="720" step="50">
      <span class="pt-field-val"><span id="v-ops">720</span>만</span>
    </div>
    <div class="pt-field">
      <span class="pt-field-label">멘토 회당 <small>30분 1:1, 원</small></span>
      <input type="range" id="i-mentor" min="10000" max="35000" value="20000" step="1000">
      <span class="pt-field-val"><span id="v-mentor">20,000</span>원</span>
    </div>
    <div class="pt-derived">
      <div class="item">월 임대료 <b id="d-rentTotal">900</b>만</div>
      <div class="item">→ 총 고정비 <b id="d-fixedTotal">1,620</b>만/월</div>
    </div>
  </div>

  <!-- 3. 운영 -->
  <div class="pt-card">
    <div class="pt-card-title">3️⃣ 운영 설정 <span class="badge">OPERATIONS</span></div>

    <div class="pt-presets" style="margin-top: 0.3rem;">
      <button class="pt-preset-btn" data-preset="aggressive">공격적 (90/50/70)</button>
      <button class="pt-preset-btn active" data-preset="standard">표준 (85/35/60)</button>
      <button class="pt-preset-btn" data-preset="conservative">보수적 (70/25/50)</button>
    </div>

    <div class="pt-field">
      <span class="pt-field-label">🌟 골든타임 시간 <small>평일 (출근 전·저녁)</small></span>
      <input type="range" id="i-goldenHours" min="3" max="10" value="7" step="0.5">
      <span class="pt-field-val"><span id="v-goldenHours">7</span>h/일</span>
    </div>
    <div class="pt-field">
      <span class="pt-field-label">↳ 골든타임 가동률</span>
      <input type="range" id="i-golden" min="30" max="100" value="85" step="5">
      <span class="pt-field-val"><span id="v-golden">85</span>%</span>
    </div>

    <div class="pt-field">
      <span class="pt-field-label">🌤️ 오프피크 시간 <small>평일 (낮·심야)</small></span>
      <input type="range" id="i-offpeakHours" min="3" max="14" value="10" step="0.5">
      <span class="pt-field-val"><span id="v-offpeakHours">10</span>h/일</span>
    </div>
    <div class="pt-field">
      <span class="pt-field-label">↳ 오프피크 가동률</span>
      <input type="range" id="i-offpeak" min="0" max="80" value="35" step="5">
      <span class="pt-field-val"><span id="v-offpeak">35</span>%</span>
    </div>

    <div class="pt-field">
      <span class="pt-field-label">📅 주말 시간 <small>토·일</small></span>
      <input type="range" id="i-weekendHours" min="6" max="15" value="13" step="0.5">
      <span class="pt-field-val"><span id="v-weekendHours">13</span>h/일</span>
    </div>
    <div class="pt-field">
      <span class="pt-field-label">↳ 주말 가동률</span>
      <input type="range" id="i-weekend" min="20" max="100" value="60" step="5">
      <span class="pt-field-val"><span id="v-weekend">60</span>%</span>
    </div>

    <div class="pt-field" style="margin-top: 0.7rem;">
      <span class="pt-field-label">🎯 목표 흑자 <small>만원/지점/월</small></span>
      <input type="range" id="i-margin" min="0" max="2000" value="500" step="100">
      <span class="pt-field-val"><span id="v-margin">500</span>만</span>
    </div>
    <div class="pt-derived">
      <div class="item">효율 방시간/방/월 <b id="d-hours">270</b>h</div>
      <div class="item">→ 지점 가용 방시간/월 <b id="d-storeHours">2,160</b>h</div>
    </div>
  </div>

  <!-- 결과 -->
  <div class="pt-result">
    <div class="pt-result-title">📊 결과 — 가격대 산출</div>
    <div class="pt-result-grid">
      <div class="pt-result-row"><span class="pt-result-label">방시간 원가 (BEP)</span><span class="pt-result-num"><span id="o-take-bep"></span>원</span></div>
      <div class="pt-result-row"><span class="pt-result-label">방시간 목표 단가 (흑자)</span><span class="pt-result-num"><span id="o-take-goal"></span>원</span></div>
      <div class="pt-result-row"><span class="pt-result-label">회원 결제 BEP (1세션)</span><span class="pt-result-num"><span id="o-pay-bep"></span>원</span></div>
      <div class="pt-result-row pt-hi"><span class="pt-result-label">회원 결제 (흑자, 1세션)</span><span class="pt-result-num"><span id="o-pay-goal"></span>원</span></div>
      <div class="pt-result-row pt-hi"><span class="pt-result-label">주 2회권 (월)</span><span class="pt-result-num"><span id="o-week2"></span>원</span></div>
      <div class="pt-result-row"><span class="pt-result-label">주 1회권 (월)</span><span class="pt-result-num"><span id="o-week1"></span>원</span></div>
      <div class="pt-result-row"><span class="pt-result-label">지점 월 매출 (예상)</span><span class="pt-result-num"><span id="o-rev"></span>만/월</span></div>
      <div class="pt-result-row"><span class="pt-result-label">예상 회원 수 (포화)</span><span class="pt-result-num"><span id="o-members"></span>명</span></div>
    </div>
    <div class="pt-formula">
      회원 결제 = 멘토 회당 + (총 고정비 + 목표 흑자) ÷ 지점 가용 방시간
    </div>
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

  document.querySelectorAll('.pt-preset-btn').forEach(b => {
    b.addEventListener('click', () => {
      const p = presets[b.dataset.preset];
      $('i-golden').value = p.golden;
      $('i-offpeak').value = p.offpeak;
      $('i-weekend').value = p.weekend;
      calc();
    });
  });

  function calc(){
    const rooms         = parseInt($('i-rooms').value, 10);
    const roomArea      = parseFloat($('i-roomArea').value);
    const commonRatio   = parseInt($('i-commonRatio').value, 10) / 100;
    const rent          = parseFloat($('i-rent').value);
    const opsM          = parseInt($('i-ops').value, 10);
    const mentor        = parseInt($('i-mentor').value, 10);
    const goldenHours   = parseFloat($('i-goldenHours').value);
    const offpeakHours  = parseFloat($('i-offpeakHours').value);
    const weekendHours  = parseFloat($('i-weekendHours').value);
    const golden        = parseInt($('i-golden').value, 10) / 100;
    const offpeak       = parseInt($('i-offpeak').value, 10) / 100;
    const weekend       = parseInt($('i-weekend').value, 10) / 100;
    const marginM       = parseInt($('i-margin').value, 10);

    // 입력 표시
    $('v-rooms').textContent        = rooms;
    $('v-roomArea').textContent     = roomArea;
    $('v-commonRatio').textContent  = (commonRatio*100).toFixed(0);
    $('v-rent').textContent         = rent;
    $('v-ops').textContent          = opsM;
    $('v-mentor').textContent       = fmt(mentor);
    $('v-goldenHours').textContent  = goldenHours;
    $('v-offpeakHours').textContent = offpeakHours;
    $('v-weekendHours').textContent = weekendHours;
    $('v-golden').textContent       = (golden*100).toFixed(0);
    $('v-offpeak').textContent      = (offpeak*100).toFixed(0);
    $('v-weekend').textContent      = (weekend*100).toFixed(0);
    $('v-margin').textContent       = marginM;

    // 1. 공간 계산
    const roomTotal   = rooms * roomArea;
    const totalArea   = roomTotal / (1 - commonRatio);
    const commonArea  = totalArea - roomTotal;

    $('d-roomTotal').textContent   = roomTotal.toFixed(0);
    $('d-commonTotal').textContent = commonArea.toFixed(0);
    $('d-totalArea').textContent   = totalArea.toFixed(0);

    // 2. 비용 계산
    const rentTotalM = totalArea * rent;
    const fixedTotalM = rentTotalM + opsM;
    $('d-rentTotal').textContent  = rentTotalM.toFixed(0);
    $('d-fixedTotal').textContent = fmt(Math.round(fixedTotalM));

    // 3. 가동률 → 효율 방시간 (시간대 시간도 가변)
    const goldenMaxH  = goldenHours  * 5 * 4.3;
    const offpeakMaxH = offpeakHours * 5 * 4.3;
    const weekendMaxH = weekendHours * 2 * 4.3;
    const util = goldenMaxH*golden + offpeakMaxH*offpeak + weekendMaxH*weekend;
    const storeHours = util * rooms;

    $('d-hours').textContent      = util.toFixed(0);
    $('d-storeHours').textContent = fmt(Math.round(storeHours));

    // 4. 가격 산출
    const fixedTotalWon = fixedTotalM * 10000;
    const marginWon     = marginM * 10000;

    const takeBep  = storeHours > 0 ? fixedTotalWon / storeHours : 0;
    const takeGoal = storeHours > 0 ? (fixedTotalWon + marginWon) / storeHours : 0;
    const payBep   = takeBep + mentor;
    const payGoal  = takeGoal + mentor;
    const week2    = payGoal * 8;
    const week1    = payGoal * 4;
    const revStoreM = (payGoal * storeHours) / 10000;
    const memberCount = Math.round((storeHours / 8));  // 회원 1인당 월 8회 가정

    $('o-take-bep').textContent  = fmt(Math.round(takeBep));
    $('o-take-goal').textContent = fmt(Math.round(takeGoal));
    $('o-pay-bep').textContent   = fmt(round(payBep, 100));
    $('o-pay-goal').textContent  = fmt(round(payGoal, 100));
    $('o-week2').textContent     = fmt(round(week2, 1000));
    $('o-week1').textContent     = fmt(round(week1, 1000));
    $('o-rev').textContent       = fmt(Math.round(revStoreM));
    $('o-members').textContent   = fmt(memberCount);

    // preset active 표시
    const matched = Object.entries(presets).find(([k,v]) =>
      Math.round(golden*100) === v.golden &&
      Math.round(offpeak*100) === v.offpeak &&
      Math.round(weekend*100) === v.weekend
    );
    document.querySelectorAll('.pt-preset-btn').forEach(b => {
      b.classList.toggle('active', matched && b.dataset.preset === matched[0]);
    });
  }

  ['i-rooms','i-roomArea','i-commonRatio','i-rent','i-ops','i-mentor','i-margin',
   'i-goldenHours','i-offpeakHours','i-weekendHours',
   'i-golden','i-offpeak','i-weekend']
    .forEach(id => $(id).addEventListener('input', calc));
  calc();
})();
</script>

---

## 시간대 정의

| 구분 | 평일 | 주말 | 주간 시간 |
|---|---|---|---|
| 🌟 **골든타임** | 06-09 + 18-22 = 7h/일 × 5일 | - | **35h/주** |
| 🌤️ **오프피크** | 09-18 + 22-23 = 10h/일 × 5일 | - | **50h/주** |
| 📅 **주말** | - | 08-21 = 13h/일 × 2일 | **26h/주** |

## 락된 가정

- 멘토 운영: 회원 1세션당 30분 1:1 → 멘토 1시간 = 2 회원
- 회원 1세션 = 90분 세트 (카디오 30 + 방 60)
- Phase 1 직영 (가맹 분배 ❌)
- 주 평균 = 4.3주/월
- 회원 1인당 월 8회 가정 (포화 회원 수 계산용)

## 프리셋

| 시나리오 | 골든 | 오프피크 | 주말 | 평균 효율 방시간 (방 1개/월) |
|---|---|---|---|---|
| 공격적 | 90% | 50% | 70% | ~321h |
| **표준** | 85% | 35% | 60% | ~270h |
| 보수적 | 70% | 25% | 50% | ~215h |

---

| 2026-05-13 | 9 시나리오 매트릭스 |
| 2026-05-13 | 시간대별 슬라이더 |
| 2026-05-13 | 3단계 카드 흐름 (공간→비용→운영→결과) + 자동 도출 표시 |
