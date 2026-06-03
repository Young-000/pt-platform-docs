---
title: 📊 단위 경제 시뮬레이션
parent: 7. 경제성
nav_order: 0
---

# 단위 경제 시뮬레이션

> **3단계 흐름**: 공간 → 비용 → 운영 → 결과.

> **⚠️ GX 피벗 전환 (2026-06-04) — 시뮬레이터 본문 갱신**
>
> 아래 임베드 시뮬레이터는 **별도 레포(`apps/simulator`)** 에서 관리되며, 이 페이지에서 직접 수정하지 않습니다.
> 시뮬레이터 자체의 GX 드라이버 반영은 `apps/simulator` 프로젝트에서 별도 진행됩니다.
>
> 본 페이지의 설명 텍스트는 **recoverGX 드라이버 기준**으로 갱신되었습니다.

> **📌 GX 단위 경제 드라이버 (재산출 대상)**
>
> | 드라이버 | GX 의미 | PT 레일 대비 변경점 |
> |---|---|---|
> | **클래스 가격** | 클래스당 이용 단가 (1~5만원 범위, 예시) | PT unit당 회당가(30k) → 클래스 단위로 전환 |
> | **정원** | 클래스당 수용 인원 (기본 N명, 예: 20명) | 슬롯 = 1명(PT) → 슬롯 = N명(GX) |
> | **가동률 (U)** | 클래스 정원 충족률 × 슬롯 가동률 복합 | PT 슬롯 가동률과 정의 상이 |
> | **조합형 정산** | 기본금 + 인당×출석 + 매출×비율% | PT P1~P5 unit 고정 단가와 구조 상이 |
> | **플랫폼 마진** | 매출 − 강사 지급액 (음수 가능) | unit 마진 17k(PT 기준)는 재산출 대상 |
>
> **GX 공식 (정성)**:
> ```
> 클래스 매출 = 클래스 가격 × 출석 인원 (no-show 포함 예약 차감)
> 월 매출     = Σ (전체 클래스 매출)
> 강사 정산   = 기본금 + (인당 단가 × 출석) + (매출 × 비율%)
> 플랫폼 마진 = 월 매출 − Σ 강사 정산
> 월 순익     = 플랫폼 마진 − 월 고정비
> ```
>
> 구체 수치(가격·정원·정산 비율·BEP util)는 베타 운영 실측 후 확정. 수치 창작 금지.
> ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html) · [ADR 0010](../decisions/0010-unit-economics-3vars.html))

## PT 레일 기준 시나리오 (구버전 참고 — GX 재산출 전)

| 시나리오 | 시점 | Util | 월 unit (PT 기준) | 본사 마진 (PT 기준) | 순익 (PT 기준) |
|---|---|---|---|---|---|
| Bear | D+30 | **20%** | 1,728 | 2,938만 | **+338만** |
| Standard | D+90 | **30%** | 2,592 | 4,406만 | **+1,806만** |
| **Base** | **D+180** | **50%** | **4,320** | **7,344만** | **+4,744만** |
| Bull | Mature | **70%** | 6,048 | 10,282만 | **+7,682만** |

*PT 레일 기준 추정치, GX 재산출 대상.*

> Capex 1.5~2억 가정 시 PT 레일 Base BEP = **약 3~4개월**. GX 순익 재산출 후 갱신.

## 강사 등급 mix — PT 레일 기준 (GX 조합형 정산으로 대체 예정)

| 등급 | 비중 (Base) | 30분 정산 | 가중치 |
|---|---|---|---|
| P1 신입 | 20% | 10,000 | 2,000 |
| P2 검증 | 30% | 12,000 | 3,600 |
| P3 시니어 | 25% | 14,000 | 3,500 |
| P4 전문 | 15% | 16,000 | 2,400 |
| P5 마스터 | 10% | 18,000 | 1,800 |
| **평균** | 100% | | **13,300원 ≈ 13,000원** |

*PT 레일 기준 추정치. GX 조합형 정산(기본금 + 인당 × 출석 + 매출 × 비율%) 확정 후 대체 예정.*

## 이용 인원 추정 (GX 재산출 대상)

> 아래는 **PT 레일 30분 unit 기준** 추정치입니다. GX 전환 후 클래스 정원·드롭인 비중 기반으로 재산출 필요.

- PT 레일 Base: 월 unit = 4,320 / 회원 평균 월 사용 12 unit → 활성 회원 ≈ 360명 (PT 기준 추정)
- GX 이용 인원은 클래스 정원 × 가동률로 재정의됨 → 베타 실측 후 갱신
- ARPU도 클래스 단위 매출 집계 방식으로 재산출 대상

> **아래 인터랙티브 시뮬레이터는 PT 레일(1:1 30분 unit) 기준** 모델입니다.
> GX 드라이버(클래스 가격·정원·조합형 정산) 반영은 **`apps/simulator` 레포에서 별도 진행**됩니다.
> 이 페이지에 임베드된 시뮬레이터 코드(HTML·CSS·JS)는 `apps/simulator` 프로젝트가 담당하며 여기서 수정하지 않습니다.

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
.pt-sim .pt-time-range {
  display: flex; align-items: center; gap: 0.4rem;
}
.pt-sim .pt-time-range input[type=number] {
  width: 3.5rem; padding: 0.3rem 0.4rem; border: 1px solid #d1d5db; border-radius: 4px;
  font-size: 0.88rem; text-align: center; font-variant-numeric: tabular-nums;
}
.pt-sim .pt-time-range .sep { color: #9ca3af; }
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
      <input type="range" id="i-roomArea" min="3" max="10" value="5" step="0.5">
      <span class="pt-field-val"><span id="v-roomArea">5</span>평</span>
    </div>
    <div class="pt-field">
      <span class="pt-field-label">공용 공간 비율 <small>오픈·라운지·탈의·샤워</small></span>
      <input type="range" id="i-commonRatio" min="20" max="50" value="33" step="2">
      <span class="pt-field-val"><span id="v-commonRatio">33</span>%</span>
    </div>
    <div class="pt-derived">
      <div class="item">방 총 면적 <b id="d-roomTotal">40</b>평</div>
      <div class="item">공용 면적 <b id="d-commonTotal">20</b>평</div>
      <div class="item">→ 전체 평수 <b id="d-totalArea">60</b>평</div>
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
      <input type="range" id="i-ops" min="500" max="3000" value="2000" step="100">
      <span class="pt-field-val"><span id="v-ops">2,000</span>만</span>
    </div>
    <div class="pt-field">
      <span class="pt-field-label">강사 평균 unit 정산 <small>30분 1:1, 원</small></span>
      <input type="range" id="i-mentor" min="10000" max="18000" value="13000" step="500">
      <span class="pt-field-val"><span id="v-mentor">13,000</span>원</span>
    </div>
    <div class="pt-derived">
      <div class="item">월 임대료 <b id="d-rentTotal">600</b>만</div>
      <div class="item">→ 총 고정비 <b id="d-fixedTotal">2,600</b>만/월</div>
    </div>
  </div>

  <!-- 3. 운영 -->
  <div class="pt-card">
    <div class="pt-card-title">3️⃣ 운영 설정 <span class="badge">OPERATIONS</span></div>

    <div class="pt-presets" style="margin-top: 0.3rem;">
      <button class="pt-preset-btn" data-preset="bear">D+30 Bear (20%)</button>
      <button class="pt-preset-btn" data-preset="standard">D+90 Std (30%)</button>
      <button class="pt-preset-btn active" data-preset="base">D+180 Base (50%)</button>
      <button class="pt-preset-btn" data-preset="bull">Bull (70%)</button>
    </div>

    <div class="pt-field">
      <span class="pt-field-label">⏰ 평일 운영 시간</span>
      <div class="pt-time-range">
        <input type="number" id="i-weekdayOpen" min="0" max="23" value="10" step="1"> 시
        <span class="sep">~</span>
        <input type="number" id="i-weekdayClose" min="1" max="24" value="22" step="1"> 시
      </div>
      <span class="pt-field-val"><span id="v-weekdayHours">12</span>h/일</span>
    </div>

    <div class="pt-field">
      <span class="pt-field-label">전체 가동률 (U)</span>
      <input type="range" id="i-util" min="10" max="90" value="50" step="5">
      <span class="pt-field-val"><span id="v-util">50</span>%</span>
    </div>

    <div class="pt-field" style="margin-top: 0.7rem;">
      <span class="pt-field-label">🎯 목표 흑자 <small>만원/지점/월</small></span>
      <input type="range" id="i-margin" min="0" max="8000" value="4744" step="100">
      <span class="pt-field-val"><span id="v-margin">4,744</span>만</span>
    </div>
    <div class="pt-derived">
      <div class="item">시간당 capacity <b id="d-cap">24</b> unit</div>
      <div class="item">월 unit capacity <b id="d-storeUnits">8,640</b> unit</div>
    </div>
  </div>

  <!-- 결과 -->
  <div class="pt-result">
    <div class="pt-result-title">📊 결과 — v2 봉인 기준</div>
    <div class="pt-result-grid">
      <div class="pt-result-row"><span class="pt-result-label">월 사용 unit</span><span class="pt-result-num"><span id="o-used"></span> unit</span></div>
      <div class="pt-result-row"><span class="pt-result-label">unit당 마진</span><span class="pt-result-num"><span id="o-margin-unit"></span>원</span></div>
      <div class="pt-result-row pt-hi"><span class="pt-result-label">월 본사 마진 (회당 평균가 − 강사 평균)</span><span class="pt-result-num"><span id="o-margin-month"></span>만</span></div>
      <div class="pt-result-row pt-hi"><span class="pt-result-label">월 순익 (고정비 차감)</span><span class="pt-result-num"><span id="o-net"></span>만</span></div>
      <div class="pt-result-row"><span class="pt-result-label">BEP util (운영)</span><span class="pt-result-num"><span id="o-bep"></span>%</span></div>
      <div class="pt-result-row"><span class="pt-result-label">활성 회원 수 (월 12 unit/명)</span><span class="pt-result-num"><span id="o-members"></span>명</span></div>
      <div class="pt-result-row"><span class="pt-result-label">지점 월 매출</span><span class="pt-result-num"><span id="o-rev"></span>만/월</span></div>
      <div class="pt-result-row"><span class="pt-result-label">시간당 비용</span><span class="pt-result-num"><span id="o-hourly"></span>원</span></div>
    </div>
    <div class="pt-formula">
      월 본사 마진 = capacity (24 unit/h) × 영업시간 × 30일 × U × unit당 마진<br>
      회원 평균 회당가 = 30,000원 / 강사 평균 정산 = 13,000원 / unit당 마진 = 17,000원
    </div>
  </div>
</div>

<script>
(function(){
  const $ = id => document.getElementById(id);
  const fmt = n => n.toLocaleString('ko-KR');
  const round = (n, step) => Math.round(n / step) * step;

  const presets = {
    bear:     { util: 20 },
    standard: { util: 30 },
    base:     { util: 50 },
    bull:     { util: 70 }
  };

  document.querySelectorAll('.pt-preset-btn').forEach(b => {
    b.addEventListener('click', () => {
      const p = presets[b.dataset.preset];
      $('i-util').value = p.util;
      calc();
    });
  });

  function calc(){
    const rooms          = parseInt($('i-rooms').value, 10);
    const roomArea       = parseFloat($('i-roomArea').value);
    const commonRatio    = parseInt($('i-commonRatio').value, 10) / 100;
    const rent           = parseFloat($('i-rent').value);
    const opsM           = parseInt($('i-ops').value, 10);
    const mentor         = parseInt($('i-mentor').value, 10);
    const weekdayOpen    = parseInt($('i-weekdayOpen').value, 10);
    const weekdayClose   = parseInt($('i-weekdayClose').value, 10);
    const util           = parseInt($('i-util').value, 10) / 100;
    const marginM        = parseInt($('i-margin').value, 10);

    const weekdayHours = Math.max(0, weekdayClose - weekdayOpen);

    $('v-rooms').textContent       = rooms;
    $('v-roomArea').textContent    = roomArea;
    $('v-commonRatio').textContent = (commonRatio*100).toFixed(0);
    $('v-rent').textContent        = rent;
    $('v-ops').textContent         = fmt(opsM);
    $('v-mentor').textContent      = fmt(mentor);
    $('v-weekdayHours').textContent = weekdayHours;
    $('v-util').textContent        = (util*100).toFixed(0);
    $('v-margin').textContent      = fmt(marginM);

    // 공간
    const roomTotal   = rooms * roomArea;
    const totalArea   = roomTotal / (1 - commonRatio);
    const commonArea  = totalArea - roomTotal;

    $('d-roomTotal').textContent   = roomTotal.toFixed(0);
    $('d-commonTotal').textContent = commonArea.toFixed(0);
    $('d-totalArea').textContent   = totalArea.toFixed(0);

    // 비용
    const rentTotalM = totalArea * rent;
    const fixedTotalM = rentTotalM + opsM;
    $('d-rentTotal').textContent  = fmt(Math.round(rentTotalM));
    $('d-fixedTotal').textContent = fmt(Math.round(fixedTotalM));

    // capacity (룸 + 오픈 1:1 대략 4명)
    const openPT = Math.max(2, Math.round(commonArea / 5));
    const concurrent = rooms + openPT;
    const unitsPerHour = concurrent * 2;  // 30분 unit
    const monthUnits = unitsPerHour * weekdayHours * 30;
    const usedUnits = monthUnits * util;

    $('d-cap').textContent       = unitsPerHour;
    $('d-storeUnits').textContent = fmt(Math.round(monthUnits));

    // unit 마진 = 회원 평균 30,000 − 강사 평균
    const memberPerUnit = 30000;
    const unitMargin = memberPerUnit - mentor;
    const monthMargin = usedUnits * unitMargin;   // 원
    const monthMarginM = monthMargin / 10000;
    const netM = monthMarginM - fixedTotalM;

    const fixedWon = fixedTotalM * 10000;
    const bepUtil = (fixedWon / (monthUnits * unitMargin)) * 100;

    const revWon = usedUnits * memberPerUnit;
    const revM = revWon / 10000;
    const members = Math.round(usedUnits / 12);
    const hourlyCost = (fixedTotalM * 10000) / (weekdayHours * 30);

    $('o-used').textContent       = fmt(Math.round(usedUnits));
    $('o-margin-unit').textContent = fmt(unitMargin);
    $('o-margin-month').textContent = fmt(Math.round(monthMarginM));
    $('o-net').textContent        = fmt(Math.round(netM));
    $('o-bep').textContent        = bepUtil.toFixed(1);
    $('o-members').textContent    = fmt(members);
    $('o-rev').textContent        = fmt(Math.round(revM));
    $('o-hourly').textContent     = fmt(Math.round(hourlyCost));

    const matched = Object.entries(presets).find(([k,v]) =>
      Math.round(util*100) === v.util
    );
    document.querySelectorAll('.pt-preset-btn').forEach(b => {
      b.classList.toggle('active', matched && b.dataset.preset === matched[0]);
    });
  }

  ['i-rooms','i-roomArea','i-commonRatio','i-rent','i-ops','i-mentor','i-margin',
   'i-weekdayOpen','i-weekdayClose','i-util']
    .forEach(id => $(id).addEventListener('input', calc));
  calc();
})();
</script>

---

## PT 레일 가정 (구버전 — GX 재산출 대상)

> 아래 가정은 **PT 레일 기준**이며, GX 전환 후 각 항목의 재산출 방향을 병기합니다.

| 가정 항목 | PT 레일 값 | GX 재산출 방향 |
|---|---|---|
| 표준 1지점 면적 | **60평** (룸 8 + 오픈 22평) | 60평 승계, 공간 배치 재검토 |
| 동시 capacity | **12명** / 시간당 **24 unit** | 클래스 정원 N명으로 재정의 |
| 월 unit capacity | 8,640 unit/월 | GX 클래스 슬롯 수로 재산출 |
| 매출 단위 | 회당가 30,000원 (ARPU) | 클래스 가격 × 출석 인원 |
| 강사 정산 | 13,000원/30분 unit (P1~P5 mix) | 조합형 정산으로 전환 |
| unit당 본사 마진 | 17,000원 | GX 클래스 마진으로 재산출 |
| 월 고정비 | 임대 600 + 운영비 2,000 = **2,600만** | 구조 유사, GX 재확인 필요 |
| BEP util | 15.2% (운영) · 18.7% (Capex 12개월) | GX 재산출 대상 |
| Phase 1 | 직영 (가맹 분배 ❌ — Phase 2+ [6C](../expansion/revenue-share.html)) | 동일 방향 유지 |

## PT 레일 시나리오 매트릭스 (참고 — GX 재산출 전)

| 시나리오 | 시점 | Util | 월 사용 unit (PT) | 본사 마진 (PT) | 순익 (PT) |
|---|---|---|---|---|---|
| Bear | D+30 | 20% | 1,728 | 2,938만 | +338만 |
| Standard | D+90 | 30% | 2,592 | 4,406만 | +1,806만 |
| **Base** | **D+180** | **50%** | **4,320** | **7,344만** | **+4,744만** |
| Bull | Mature | 70% | 6,048 | 10,282만 | +7,682만 |

*PT 레일 기준 추정치, GX 재산출 대상. ([ADR 0011](../decisions/0011-recovergx-gx-pivot.html))*

---

| 2026-05-13 | 9 시나리오 매트릭스 + 시간대별 슬라이더 |
| 2026-05-16 | v2 본문 정합 갱신 — 30분 unit |
| 2026-05-18 | 베타 default callout — 평당 10만 |
| 2026-05-20 | v2 봉인 — 3변수 모델 (capacity 24·U·unit 마진 17k) 명시·시뮬레이터 갱신 (PT 레일 기준) |
| 2026-06-04 | **GX 피벗 전환** — 설명 텍스트를 GX 드라이버 기준으로 갱신. PT 레일 수치 전체를 "재산출 대상"으로 명기. 시뮬레이터 HTML/CSS/JS 미변경 (apps/simulator 별도 관리). ADR 0011·0010 참조 |
