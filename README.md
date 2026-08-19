<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover">
    <title>Block Blast Pro - Remover Penalty</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        :root {
            --bg-color: #0f172a;
            --grid-bg: #1e293b;
            --empty-cell: rgba(255, 255, 255, 0.05);

            /* Candy theme variables — level 0 defaults (Neon) */
            --theme-bg: #0f172a;
            --theme-bg-gradient: none;
            --theme-board-bg: #1e293b;
            --theme-board-border: 0px solid transparent;
            --theme-board-shadow: 0 20px 50px rgba(0, 0, 0, 0.6);
            --theme-board-radius: 16px;
            --theme-cell-bg: rgba(255, 255, 255, 0.05);
            --theme-cell-radius: 6px;
            --theme-panel-bg: rgba(15, 23, 42, 0.5);
            --theme-panel-border: 1px solid rgba(255, 255, 255, 0.08);
            --theme-panel-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            --theme-text-current: #60a5fa;
            --theme-text-best: #94a3b8;
            --theme-text-combo: #fbbf24;
            --theme-text-label: #94a3b8;
            --theme-text-white: #ffffff;
            --theme-block-border: 2px solid rgba(0, 0, 0, 0.15);
            --theme-block-shadow: inset 0 0 10px rgba(255, 255, 255, 0.25);
            --theme-block-radius: 6px;
            --theme-btn-bg: rgba(30, 41, 65, 0.6);
            --theme-btn-border: 2px solid #3b82f6;
            --theme-btn-text: #ffffff;
            --theme-btn-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            --theme-btn-border-radius: 14px;
            --theme-overlay-bg: rgba(15, 23, 42, 0.97);
            --theme-card-bg: rgba(30, 41, 65, 0.85);
            --theme-card-border: 2px solid rgba(255, 255, 255, 0.1);
            --theme-card-shadow: 0 0 40px rgba(0, 0, 0, 0.5);
            --theme-card-radius: 24px;
            --theme-gameover-text: #fbbf24;
            --theme-particle-tint: #ffffff;
            --theme-combo-icon: "";
            --theme-combo-prefix: "";
        }

        body {
            background-color: var(--theme-bg);
            background-image: var(--theme-bg-gradient);
            background-size: cover;
            background-position: center;
            color: var(--theme-text-white);
            font-family: 'Pretendard', system-ui, -apple-system, sans-serif;
            touch-action: none;
            overflow: hidden;
            margin: 0;
            display: flex;
            justify-content: center;
            height: 100dvh;
            user-select: none;
            -webkit-user-select: none;
            transition: background-color 0.8s ease, background-image 0.8s ease;
        }

        #game-container {
            width: 100%;
            max-width: 550px;
            height: 100%;
            display: flex;
            flex-direction: column;
            padding: 10px;
            box-sizing: border-box;
            position: relative;
        }

        /* 상단 점수판 */
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 70px;
            flex-shrink: 0;
            padding: 0 10px;
            gap: 8px;
        }

        .score-box {
            text-align: center;
            background: var(--theme-panel-bg);
            border: var(--theme-panel-border);
            border-radius: 14px;
            padding: 8px 14px;
            box-shadow: var(--theme-panel-shadow);
            min-width: 70px;
            transition: all 0.8s ease;
        }
        .score-box.combo-box { min-width: 75px; }
        .score-label {
            font-size: 0.7rem;
            color: var(--theme-text-label);
            font-weight: bold;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .score-value {
            font-size: 1.4rem;
            font-weight: 900;
            color: var(--theme-text-current);
            transition: color 0.8s ease, text-shadow 0.8s ease;
        }
        .score-value.best { color: var(--theme-text-best); }
        .score-value.combo { color: var(--theme-text-combo); }

        /* Pause button */
        .pause-btn {
            width: 44px; height: 44px;
            border-radius: 14px;
            background: var(--theme-btn-bg);
            border: var(--theme-btn-border);
            color: var(--theme-btn-text);
            font-size: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--theme-btn-shadow);
            transition: all 0.6s ease;
            cursor: pointer;
            touch-action: none;
            user-select: none;
        }
        .pause-btn:hover {
            transform: scale(1.05);
            filter: brightness(1.2);
        }

        /* 게임 보드 영역 */
        #board-wrapper {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 0;
            padding: 5px 0;
            position: relative;
        }

        #board-container {
            position: relative;
            width: min(96vw, 55vh);
            aspect-ratio: 1 / 1;
            background-color: var(--theme-board-bg);
            border: var(--theme-board-border);
            border-radius: var(--theme-board-radius);
            padding: 10px;
            display: grid;
            grid-template-columns: repeat(8, 1fr);
            grid-template-rows: repeat(8, 1fr);
            gap: 5px;
            box-shadow: var(--theme-board-shadow);
            z-index: 10;
            transition: background-color 0.8s ease, border 0.8s ease, box-shadow 0.8s ease, border-radius 0.8s ease;
        }

        .cell {
            background-color: var(--theme-cell-bg);
            border-radius: var(--theme-cell-radius);
            position: relative;
            transition: background-color 0.8s ease, border-radius 0.8s ease;
        }

        .block-unit {
            position: absolute;
            width: 100%; height: 100%;
            border-radius: var(--theme-block-radius);
            box-sizing: border-box;
            border: var(--theme-block-border);
            box-shadow: var(--theme-block-shadow);
            top: 0; left: 0;
            pointer-events: none;
            transition: border-radius 0.8s ease, box-shadow 0.8s ease;
        }

        /* 콤보 텍스트 효과 */
        .combo-text {
            position: absolute;
            top: 45%; left: 50%;
            transform: translate(-50%, -50%);
            font-size: 2.8rem;
            font-weight: 900;
            color: var(--theme-text-combo);
            text-shadow: 0 10px 20px rgba(0,0,0,0.5);
            z-index: 100;
            pointer-events: none;
            animation: combo-pop 0.8s cubic-bezier(0.17, 0.89, 0.32, 1.27) forwards;
            transition: color 0.8s ease;
        }
        .combo-text:before {
            content: var(--theme-combo-prefix);
            margin-right: 8px;
            opacity: 0.9;
        }

        @keyframes combo-pop {
            0% { transform: translate(-50%, 20%) scale(0.5); opacity: 0; }
            30% { transform: translate(-50%, -50%) scale(1.1); opacity: 1; }
            100% { transform: translate(-50%, -120%) scale(1); opacity: 0; }
        }

        .pop-animation {
            transition: transform 0.4s ease-out, opacity 0.4s ease-out;
            transform: scale(1.8); opacity: 0;
        }

        .particle {
            position: fixed;
            border-radius: 2px;
            pointer-events: none;
            z-index: 1000;
            animation: particle-fly 0.6s ease-out forwards;
        }

        @keyframes particle-fly {
            0% { transform: translate(0, 0) scale(1); opacity: 1; }
            100% { transform: translate(var(--dx), var(--dy)) scale(0); opacity: 0; }
        }

        /* 블록 색상 바리에이션 */
        .color-1 { background: linear-gradient(135deg, #ff5f6d, #ffc371); }
        .color-2 { background: linear-gradient(135deg, #2193b0, #6dd5ed); }
        .color-3 { background: linear-gradient(135deg, #11998e, #38ef7d); }
        .color-4 { background: linear-gradient(135deg, #ee0979, #ff6a00); }
        .color-5 { background: linear-gradient(135deg, #8e2de2, #4a00e0); }
        .color-6 { background: linear-gradient(135deg, #fceeb5, #f5d020); }
        .color-7 { background: linear-gradient(135deg, #00c6ff, #0072ff); }

        /* 제거 블록 전용 스타일 */
        .color-remover {
            background: linear-gradient(135deg, #ec4899, #f43f5e) !important;
            border: 2px dashed rgba(255, 255, 255, 0.8) !important;
            box-shadow: inset 0 0 10px rgba(255, 255, 255, 0.4), 0 0 12px rgba(236, 72, 153, 0.6) !important;
        }

        /* 제거 블록의 고스트 타겟 스타일 */
        .ghost-remover-target {
            background-color: rgba(34, 197, 94, 0.4) !important; /* 제거 대상인 블록은 녹색 빛으로 안정감 부여 */
            border: 2px solid #22c55e !important;
            box-shadow: 0 0 12px #22c55e !important;
            border-radius: 6px;
        }

        .ghost-remover-empty {
            background-color: rgba(239, 68, 68, 0.4) !important; /* 닿으면 게임오버되는 빈칸은 경고용 적색 하이라이트 */
            border: 2.5px dashed #ef4444 !important;
            box-shadow: 0 0 15px #ef4444 !important;
            border-radius: 6px;
            animation: pulse 1s infinite alternate;
        }

        @keyframes pulse {
            0% { opacity: 0.6; }
            100% { opacity: 1; }
        }

        /* 하단 슬롯 */
        #pieces-container {
            height: 160px;
            flex-shrink: 0;
            display: flex;
            justify-content: space-around;
            align-items: center;
            gap: 15px;
            padding-bottom: env(safe-area-inset-bottom);
        }

        .piece-slot {
            flex: 1;
            height: 120px;
            background: var(--theme-panel-bg);
            border: 2px solid var(--theme-panel-border);
            border-radius: 16px;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            cursor: pointer;
            transition: all 0.8s ease;
            touch-action: none;
        }

        /* 회전 가능한 슬롯 강조 */
        .slot-rotatable {
            border-color: rgba(234, 179, 8, 0.5);
            box-shadow: 0 0 15px rgba(234, 179, 8, 0.2);
            background: rgba(234, 179, 8, 0.03);
        }

        /* 제거 블록 슬롯 강조 */
        .slot-remover {
            border-color: rgba(244, 63, 94, 0.6);
            box-shadow: 0 0 15px rgba(244, 63, 94, 0.3);
            background: rgba(244, 63, 94, 0.05);
        }

        .draggable-piece {
            position: absolute;
            z-index: 100;
            pointer-events: none;
            will-change: transform;
            transform-origin: center center;
        }

        .in-slot { transform: scale(0.42); }

        .ghost-unit {
            position: absolute;
            background-color: rgba(255, 255, 255, 0.2);
            border: 1.5px dashed rgba(255, 255, 255, 0.5);
            border-radius: 6px;
            pointer-events: none;
            z-index: 5;
        }

        #overlay {
            position: fixed;
            inset: 0;
            background: var(--theme-overlay-bg);
            display: none;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            z-index: 2000;
            transition: background-color 0.8s ease;
        }

        /* ================================================================
           CANDY THEME SYSTEM — 5 levels driven by body[data-candy-level]
           Level 0 = Neon (combo 0-2), Level 4 = Candy Fever (combo 10+)
        ================================================================ */

        body[data-candy-level="0"] {
            /* Neo-네온 — all variables inherit :root defaults */
        }

        /* Level 0: Neon (combo 0-2) — explicit defaults for clarity */
        body[data-candy-level="0"] {
            --theme-bg: #0f172a;
            --theme-bg-gradient: none;
            --theme-board-bg: #1e293b;
            --theme-board-shadow: 0 20px 50px rgba(0, 0, 0, 0.6);
            --theme-cell-bg: rgba(255, 255, 255, 0.05);
            --theme-text-current: #60a5fa;
            --theme-text-best: #94a3b8;
            --theme-text-combo: #fbbf24;
            --theme-combo-icon: "";
            --theme-combo-prefix: "";
        }

        /* Level 1: Candy Weak (combo 3-4) */
        body[data-candy-level="1"] {
            --theme-bg: #0f172a;
            --theme-bg-gradient: radial-gradient(circle at 80% 20%, rgba(236, 72, 153, 0.25) 0%, transparent 50%),
                                 radial-gradient(circle at 20% 80%, rgba(168, 85, 247, 0.2) 0%, transparent 50%);
            --theme-board-bg: rgba(30, 41, 65, 0.6);
            --theme-board-border: 1px solid rgba(255, 255, 255, 0.15);
            --theme-board-shadow: 0 20px 50px rgba(236, 72, 153, 0.2);
            --theme-cell-bg: rgba(255, 255, 255, 0.08);
            --theme-panel-border: 1px solid rgba(236, 72, 153, 0.4);
            --theme-text-current: #60a5fa;
            --theme-text-best: #a78bfa;
            --theme-text-combo: #fbbf24;
            --theme-combo-icon: "🍬";
            --theme-combo-prefix: "🍬 ";
            --theme-block-radius: 8px;
            --theme-block-shadow: inset 0 0 12px rgba(255, 255, 255, 0.35);
            --theme-btn-border: 2px solid #ec4899;
            --theme-btn-bg: rgba(30, 41, 65, 0.7);
        }

        /* Level 2: Sweet (combo 5-7) */
        body[data-candy-level="2"] {
            --theme-bg: linear-gradient(160deg, #ff9a9e 0%, #fecfef 45%, #a1c4fd 100%);
            --theme-bg-gradient: none;
            --theme-board-bg: rgba(255, 255, 255, 0.92);
            --theme-board-border: 3px solid rgba(255, 255, 255, 0.4);
            --theme-board-shadow: 0 20px 50px rgba(168, 85, 247, 0.3);
            --theme-board-radius: 20px;
            --theme-cell-bg: rgba(168, 85, 247, 0.06);
            --theme-cell-radius: 10px;
            --theme-panel-bg: rgba(255, 255, 255, 0.25);
            --theme-panel-border: 1px solid rgba(255, 255, 255, 0.4);
            --theme-panel-shadow: 0 4px 20px rgba(168, 85, 247, 0.25);
            --theme-text-current: #ec4899;
            --theme-text-best: #8b5cf6;
            --theme-text-combo: #fbbf24;
            --theme-combo-icon: "🍭";
            --theme-combo-prefix: "🍭 ";
            --theme-block-border: 2px solid rgba(255, 255, 255, 0.3);
            --theme-block-shadow: inset 0 0 12px rgba(255, 255, 255, 0.6),
                                 0 0 12px rgba(236, 72, 153, 0.3);
            --theme-block-radius: 12px;
            --theme-btn-bg: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            --theme-btn-border: 2px solid #fff;
            --theme-btn-text: #8b5cf6;
            --theme-btn-shadow: 0 0 20px rgba(236, 72, 153, 0.4);
            --theme-btn-border-radius: 18px;
            --theme-overlay-bg: rgba(236, 72, 153, 0.15);
            --theme-card-bg: rgba(255, 255, 255, 0.4);
            --theme-card-border: 2px solid rgba(236, 72, 153, 0.5);
            --theme-card-shadow: 0 0 40px rgba(168, 85, 247, 0.4);
            --theme-card-radius: 28px;
            --theme-particle-tint: #ec4899;
        }

        /* Level 3: Super Sweet (combo 8-9) */
        body[data-candy-level="3"] {
            --theme-bg: linear-gradient(135deg, #ff6b9d 0%, #f7d797 40%, #a29bfe 80%, #667eea 100%);
            --theme-bg-gradient: none;
            --theme-board-bg: rgba(255, 255, 255, 0.95);
            --theme-board-border: 3px solid #fcd34d;
            --theme-board-shadow: 0 0 40px rgba(252, 211, 77, 0.4), 0 20px 50px rgba(0, 0, 0, 0.4);
            --theme-board-radius: 22px;
            --theme-cell-bg: rgba(252, 211, 77, 0.08);
            --theme-cell-radius: 14px;
            --theme-panel-bg: rgba(255, 255, 255, 0.35);
            --theme-panel-border: 1px solid rgba(252, 211, 77, 0.5);
            --theme-panel-shadow: 0 0 20px rgba(252, 211, 77, 0.3);
            --theme-text-current: #fbbf24;
            --theme-text-best: #fcd34d;
            --theme-text-combo: #fbbf24;
            --theme-combo-icon: "🌟";
            --theme-combo-prefix: "🌟 ";
            --theme-block-border: 2px solid #fff;
            --theme-block-shadow: inset 0 0 15px rgba(255, 255, 255, 0.7),
                                 0 0 15px rgba(252, 211, 77, 0.4);
            --theme-block-radius: 8px;
            --theme-btn-bg: linear-gradient(135deg, #fbbf24 0%, #fcd34d 100%);
            --theme-btn-border: 2px solid #fff;
            --theme-btn-text: #9b2121;
            --theme-btn-shadow: 0 0 25px rgba(252, 211, 77, 0.5);
            --theme-btn-border-radius: 20px;
            --theme-overlay-bg: rgba(217, 70, 124, 0.2);
            --theme-card-bg: rgba(255, 255, 255, 0.45);
            --theme-card-border: 3px solid #fcd34d;
            --theme-card-shadow: 0 0 50px rgba(252, 211, 77, 0.5);
            --theme-card-radius: 30px;
            --theme-particle-tint: #fbbf24;
        }

        /* Level 4: Candy Fever (combo 10+) */
        body[data-candy-level="4"] {
            --theme-bg: linear-gradient(20deg, #ff6b9d 0%, #a29bfe 35%, #fcd34d 65%, #667eea 100%);
            --theme-bg-gradient: none;
            --theme-board-bg: rgba(255, 255, 255, 0.98);
            --theme-board-border: 4px solid #fff;
            --theme-board-shadow: 0 0 30px rgba(236, 72, 153, 0.5), 0 0 50px rgba(252, 211, 77, 0.4), inset 0 0 20px rgba(168, 85, 247, 0.1);
            --theme-board-radius: 24px;
            --theme-cell-bg: rgba(168, 85, 247, 0.05);
            --theme-cell-radius: 16px;
            --theme-panel-bg: rgba(255, 255, 255, 0.3);
            --theme-panel-border: 2px solid rgba(252, 211, 77, 0.6);
            --theme-panel-shadow: 0 0 25px rgba(236, 72, 153, 0.4);
            --theme-text-current: #fbbf24;
            --theme-text-best: #fcd34d;
            --theme-text-combo: #fbbf24;
            --theme-combo-icon: "👑";
            --theme-combo-prefix: "👑 ";
            --theme-block-border: 3px solid #fff;
            --theme-block-shadow: inset 0 0 15px rgba(255, 255, 255, 0.8),
                                 0 0 15px rgba(236, 72, 153, 0.5);
            --theme-block-radius: 6px;
            --theme-btn-bg: linear-gradient(135deg, #fbbf24 0%, #fcd34d 50%, #ec4899 100%);
            --theme-btn-border: 2px solid #fff;
            --theme-btn-text: #fff;
            --theme-btn-shadow: 0 0 30px rgba(236, 72, 153, 0.6);
            --theme-btn-border-radius: 22px;
            --theme-overlay-bg: rgba(236, 72, 153, 0.25);
            --theme-card-bg: rgba(255, 255, 255, 0.5);
            --theme-card-border: 4px solid #fcd34d;
            --theme-card-shadow: 0 0 60px rgba(236, 72, 153, 0.5), 0 0 40px rgba(168, 85, 247, 0.4);
            --theme-card-radius: 32px;
            --theme-particle-tint: #fbbf24;
        }

        /* Candy block surface — adds jelly-like gloss on candy levels >= 2 */
        body[data-candy-level="2"] .block-unit,
        body[data-candy-level="3"] .block-unit,
        body[data-candy-level="4"] .block-unit {
            position: relative;
            overflow: hidden;
        }
        body[data-candy-level="2"] .block-unit::after,
        body[data-candy-level="3"] .block-unit::after,
        body[data-candy-level="4"] .block-unit::after {
            content: "";
            position: absolute;
            top: 0; left: 0;
            width: 100%; height: 35%;
            background: linear-gradient(180deg, rgba(255, 255, 255, 0.5) 0%, transparent 100%);
            border-radius: inherit;
            pointer-events: none;
        }

        /* Block jelly wobble on placement at level 3-4 */
        @keyframes block-jelly-wobble {
            0% { transform: scale(0.3); }
            40% { transform: scale(1.15); }
            60% { transform: scale(0.95); }
            80% { transform: scale(1.05); }
            100% { transform: scale(1); }
        }
        body[data-candy-level="3"] .block-unit,
        body[data-candy-level="4"] .block-unit {
            animation: block-jelly-wobble 0.4s cubic-bezier(0.17, 0.89, 0.32, 1.27);
        }

        /* Candy particles */
        .candy-particle {
            position: fixed;
            border-radius: 50% !important;
            pointer-events: none;
            z-index: 999;
            filter: hue-rotate(30deg) saturate(1.5);
        }
        @keyframes candy-particle-fly {
            0% { transform: translate(0, 0) scale(1); opacity: 1; filter: hue-rotate(0deg); }
            100% { transform: translate(var(--dx), var(--dy)) scale(0); opacity: 0; filter: hue-rotate(60deg); }
        }

        /* Level-up text overlays */
        .sweet-text {
            position: absolute;
            top: 35%; left: 50%;
            transform: translate(-50%, -50%);
            font-size: 3rem;
            font-weight: 900;
            color: var(--theme-text-combo);
            text-shadow: 0 0 20px rgba(236, 72, 153, 0.5),
                         0 0 40px rgba(168, 85, 247, 0.5);
            z-index: 100;
            pointer-events: none;
            animation: sweet-pop 1.2s cubic-bezier(0.17, 0.89, 0.32, 1.27) forwards;
            letter-spacing: 3px;
        }
        .sweet-text.level-2 { color: #ec4899; font-size: 2.8rem; }
        .sweet-text.level-3 { color: #fbbf24; font-size: 3.2rem; text-shadow: 0 0 30px #fcd34d; }
        .sweet-text.level-4 { color: #fff; font-size: 3.5rem;
            text-shadow: 0 0 25px #ec4899, 0 0 50px #fcd34d, 0 0 40px #a855f7; }

        @keyframes sweet-pop {
            0% { transform: translate(-50%, 20%) scale(0.3); opacity: 0; }
            20% { transform: translate(-50%, -50%) scale(1.2); opacity: 1; }
            35% { transform: translate(-50%, -50%) scale(1); opacity: 1; }
            100% { transform: translate(-50%, -110%) scale(0.9); opacity: 0; }
        }

        /* Board candy border for super candy */
        body[data-candy-level="3"] #board-container,
        body[data-candy-level="4"] #board-container {
            position: relative;
        }
        body[data-candy-level="3"] #board-container::before,
        body[data-candy-level="4"] #board-container::before {
            content: "";
            position: absolute;
            inset: -6px;
            border-radius: calc(var(--theme-board-radius) + 6px);
            padding: 6px;
            background: linear-gradient(45deg, #fbbf24, #ec4899, #a855f7, #fcd34d);
            z-index: -1;
            filter: blur(2px);
            opacity: 0.8;
        }

        /* Candy star particles */
        .candy-star {
            position: fixed;
            font-size: 14px;
            z-index: 999;
            pointer-events: none;
            animation: candy-star-float 1s ease-out forwards;
        }
        @keyframes candy-star-float {
            0% { transform: translate(0, 0) scale(1); opacity: 1; }
            100% { transform: translate(var(--dx), var(--dy)) scale(0.5); opacity: 0; }
        }

        /* Candy fade-out transition */
        .candy-fade-out {
            animation: candy-fade-transition 0.8s ease-out forwards !important;
        }
        @keyframes candy-fade-transition {
            0% { opacity: 1; }
            100% { opacity: 0; }
        }

        /* Candy border shine sweep */
        @keyframes candy-border-sweep {
            0% { background-position: -200% 0; }
            100% { background-position: 200% 0; }
        }

        /* Screen flash effect on line clear (candy levels) */
        @keyframes screen-flash {
            0% { opacity: 0; }
            50% { opacity: 0.6; }
            100% { opacity: 0; }
        }
        .screen-flash {
            position: fixed;
            top: 0; left: 0;
            width: 100vw; height: 100vh;
            background: radial-gradient(circle, var(--flash-color, #fbbf24) 0%, transparent 70%);
            opacity: 0;
            pointer-events: none;
            z-index: 999;
            animation: screen-flash 0.8s ease-out;
        }

        /* Sugar sparkle overlay */
        .sugar-sparkle {
            position: fixed;
            width: 4px; height: 4px;
            background: rgba(255, 255, 255, 0.9);
            border-radius: 50%;
            z-index: 999;
            pointer-events: none;
            animation: sugar-sparkle-anim 0.8s ease-out forwards;
            box-shadow: 0 0 4px rgba(255, 255, 255, 0.8);
        }
        @keyframes sugar-sparkle-anim {
            0% { transform: scale(0.2) rotate(0deg); opacity: 0.8; }
            50% { transform: scale(1) rotate(180deg); opacity: 1; }
            100% { transform: scale(0.2) rotate(360deg); opacity: 0; }
        }

        /* Candy crown icon for combo >= 10 */
        .combo-crown {
            display: inline-block;
            margin-left: 4px;
            animation: crown-bob 2s ease-in-out infinite;
        }
        @keyframes crown-bob {
            0%, 100% { transform: translateY(0); }
            50% { transform: translateY(-3px); }
        }

        /* Candy score number pop on candy fever */
        .score-pop {
            display: inline-block;
            animation: score-pop-in 0.6s cubic-bezier(0.17, 0.89, 0.32, 1.27);
        }
        @keyframes score-pop-in {
            0% { transform: scale(0); opacity: 0; }
            50% { transform: scale(1.3); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }

        /* Candy button variants for game over */
        .candy-btn {
            padding: 12px 24px;
            border-radius: var(--theme-btn-border-radius);
            font-weight: 700;
            font-size: 1.1rem;
            transition: all 0.4s ease;
            cursor: pointer;
            border: var(--theme-btn-border);
            background: var(--theme-btn-bg);
            color: var(--theme-btn-text);
            box-shadow: var(--theme-btn-shadow);
            touch-action: none;
        }
        .candy-btn:hover {
            transform: translateY(-2px) scale(1.03);
            filter: brightness(1.1);
        }
        .candy-btn:active {
            transform: scale(0.97);
        }
        .candy-btn-secondary {
            background: rgba(15, 23, 42, 0.5);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: #94a3b8;
        }
        .candy-btn-secondary:hover {
            background: rgba(30, 41, 65, 0.7);
        }

        /* Candy game over card variants */
        body[data-candy-level="0"] .gameover-card { background: var(--theme-card-bg); }
        body[data-candy-level="1"] .gameover-card {
            background: rgba(30, 41, 65, 0.9);
            border: 2px solid #ec4899;
            box-shadow: 0 0 40px rgba(168, 85, 247, 0.3);
        }
        body[data-candy-level="2"] .gameover-card,
        body[data-candy-level="3"] .gameover-card {
            background: rgba(255, 255, 255, 0.4);
            border: 3px solid #ec4899;
            box-shadow: 0 0 50px rgba(168, 85, 247, 0.4);
        }
        body[data-candy-level="4"] .gameover-card {
            background: rgba(255, 255, 255, 0.5);
            border: 4px solid #fcd34d;
            box-shadow: 0 0 60px rgba(236, 72, 153, 0.5), 0 0 40px rgba(168, 85, 247, 0.4);
        }

        .gameover-title {
            font-size: 2.2rem;
            font-weight: 900;
            margin-bottom: 8px;
            color: var(--theme-text-white);
        }
        .sweet-title {
            font-size: 1.6rem;
            font-weight: 700;
            margin: 8px 0;
            color: var(--theme-text-combo);
            text-shadow: 0 0 15px rgba(236, 72, 153, 0.4);
        }
        .gameover-reason {
            color: #f87171;
            font-weight: 600;
            margin: 8px 0;
        }
        .gameover-stats {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 6px 16px;
            margin: 16px 0;
            padding: 12px;
            background: rgba(0, 0, 0, 0.1);
            border-radius: 12px;
        }
        .gameover-stat-label {
            color: #94a3b8;
            font-size: 0.85rem;
            font-weight: 600;
        }
        .gameover-stat-value {
            color: var(--theme-text-current);
            font-size: 1.2rem;
            font-weight: 800;
            text-align: right;
        }
        .candy-badge {
            text-align: center;
            font-size: 0.8rem;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 20px;
            margin-top: 8px;
        }

        /* Candy overlay text for combo level-up */
        .combo-levelup-banner {
            position: fixed;
            top: 90px;
            left: 50%;
            transform: translateX(-50%);
            padding: 8px 24px;
            border-radius: 24px;
            font-weight: 700;
            font-size: 0.9rem;
            z-index: 500;
            pointer-events: none;
            animation: banner-fade 2s ease-out forwards;
            background: var(--theme-panel-bg);
            border: var(--theme-panel-border);
            box-shadow: var(--theme-panel-shadow);
            color: var(--theme-text-current);
        }
        @keyframes banner-fade {
            0% { transform: translateX(-50%) translateY(-10px); opacity: 0; }
            15% { transform: translateX(-50%) translateY(0); opacity: 1; }
            85% { transform: translateX(-50%) translateY(0); opacity: 1; }
            100% { transform: translateX(-50%) translateY(-10px); opacity: 0; }
        }

        /* Pause menu overlay */
        #pause-overlay {
            position: fixed;
            inset: 0;
            background: rgba(0, 0, 0, 0.7);
            display: none;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            z-index: 2000;
            backdrop-filter: blur(4px);
        }
        .pause-title {
            font-size: 2rem;
            font-weight: 900;
            margin-bottom: 30px;
            color: white;
        }

        /* Block color enhancements for candy mode */
        body[data-candy-level="2"] .color-1,
        body[data-candy-level="3"] .color-1,
        body[data-candy-level="4"] .color-1 {
            background: linear-gradient(135deg, #ff8fbb, #ffcce6);
        }
        body[data-candy-level="2"] .color-2,
        body[data-candy-level="3"] .color-2,
        body[data-candy-level="4"] .color-2 {
            background: linear-gradient(135deg, #7ac3ff, #a8d8ff);
        }
        body[data-candy-level="2"] .color-3,
        body[data-candy-level="3"] .color-3,
        body[data-candy-level="4"] .color-3 {
            background: linear-gradient(135deg, #6ee7b7, #a7f3d0);
        }
        body[data-candy-level="2"] .color-4,
        body[data-candy-level="3"] .color-4,
        body[data-candy-level="4"] .color-4 {
            background: linear-gradient(135deg, #f9a8d8, #fecaca);
        }
        body[data-candy-level="2"] .color-5,
        body[data-candy-level="3"] .color-5,
        body[data-candy-level="4"] .color-5 {
            background: linear-gradient(135deg, #c4b5fd, #ddd6fe);
        }
        body[data-candy-level="2"] .color-6,
        body[data-candy-level="3"] .color-6,
        body[data-candy-level="4"] .color-6 {
            background: linear-gradient(135deg, #fde047, #fef08a);
        }
        body[data-candy-level="2"] .color-7,
        body[data-candy-level="3"] .color-7,
        body[data-candy-level="4"] .color-7 {
            background: linear-gradient(135deg, #7dd3fc, #bfdbfe);
        }
    </style>
</head>
<body>

    <div id="game-container">
        <div class="header">
            <div class="score-box" id="score-box">
                <div class="score-label">SCORE</div>
                <div id="current-score" class="score-value">0</div>
            </div>
            <div class="score-box" id="best-box">
                <div class="score-label">BEST</div>
                <div id="best-score" class="score-value best">0</div>
            </div>
            <div class="score-box combo-box" id="combo-box">
                <div class="score-label">COMBO</div>
                <div id="combo-count" class="score-value combo">x0</div>
            </div>
            <button id="pause-btn" class="pause-btn" onclick="togglePause()">⏸</button>
        </div>

        <div id="board-wrapper">
            <div id="board-container"></div>
            <div id="combo-layer"></div>
        </div>

        <div id="pieces-container">
            <div class="piece-slot" id="slot-0"></div>
            <div class="piece-slot" id="slot-1"></div>
            <div class="piece-slot" id="slot-2"></div>
        </div>
    </div>

    <div id="overlay">
        <div class="gameover-card">
            <div id="gameover-title" class="gameover-title">GAME OVER</div>
            <div id="sweet-title" class="sweet-title"></div>
            <p id="game-over-reason" class="gameover-reason">더 이상 놓을 공간이 없습니다!</p>
            <div class="gameover-stats">
                <span class="gameover-stat-label">SCORE</span>
                <span id="final-score" class="gameover-stat-value">0</span>
                <span class="gameover-stat-label">BEST</span>
                <span id="final-best" class="gameover-stat-value">0</span>
                <span class="gameover-stat-label">LINES CLEARED</span>
                <span id="final-lines" class="gameover-stat-value">0</span>
                <span class="gameover-stat-label">HIGHEST COMBO</span>
                <span id="final-combo" class="gameover-stat-value">0</span>
                <span class="gameover-stat-label">CANDY LEVEL</span>
                <span id="final-candy-level" class="gameover-stat-value">NEON</span>
            </div>
            <div id="candy-badge" class="candy-badge"></div>
            <div class="gameover-buttons">
                <button class="candy-btn candy-btn-primary" onclick="resetGame()">PLAY AGAIN</button>
                <button id="btn-home" class="candy-btn candy-btn-secondary" onclick="goHome()">HOME</button>
                <button id="btn-record" class="candy-btn candy-btn-secondary" onclick="showRecord()">RECORD</button>
            </div>
        </div>
    </div>

    <div id="pause-overlay">
        <div class="gameover-card">
            <div class="gameover-title">PAUSED</div>
            <div class="gameover-buttons">
                <button class="candy-btn candy-btn-primary" onclick="togglePause()">RESUME</button>
                <button class="candy-btn candy-btn-secondary" onclick="resetGame()">RESTART</button>
            </div>
        </div>
    </div>

    <script>
        const GRID_SIZE = 8;
        let board = Array(GRID_SIZE).fill().map(() => Array(GRID_SIZE).fill(0));
        let score = 0;
        let bestScore = parseInt(localStorage.getItem('blockBlastBestScore')) || 0;
        let piecesInHand = [null, null, null];
        let comboCount = 0;
        let piecesPlacedInCurrentSet = 0;

        const boardContainer = document.getElementById('board-container');
        const currentScoreEl = document.getElementById('current-score');
        const bestScoreEl = document.getElementById('best-score');
        const overlay = document.getElementById('overlay');
        const comboLayer = document.getElementById('combo-layer');

        bestScoreEl.innerText = bestScore;

        const SHAPES = [
            { shape: [[1]], color: 1 }, { shape: [[1, 1]], color: 2 }, { shape: [[1], [1]], color: 2 },
            { shape: [[1, 1, 1]], color: 3 }, { shape: [[1], [1], [1]], color: 3 },
            { shape: [[1, 1], [1, 1]], color: 4 }, { shape: [[1, 1, 1], [1, 1, 1], [1, 1, 1]], color: 5 },
            { shape: [[1, 1, 1, 1]], color: 6 }, { shape: [[1], [1], [1], [1]], color: 6 },
            { shape: [[1, 1], [1, 0]], color: 7 }, { shape: [[1, 1, 1], [1, 0, 0], [1, 0, 0]], color: 1 },
            { shape: [[0, 1], [1, 1]], color: 7 }, { shape: [[1, 1, 1], [0, 1, 0]], color: 2 },
            { shape: [[1, 1, 0], [0, 1, 1]], color: 3 }, { shape: [[0, 1, 1], [1, 1, 0]], color: 4 },
        ];

        function initBoard() {
            boardContainer.innerHTML = '';
            for (let r = 0; r < GRID_SIZE; r++) {
                for (let c = 0; c < GRID_SIZE; c++) {
                    const cell = document.createElement('div');
                    cell.className = 'cell'; cell.id = `cell-${r}-${c}`;
                    boardContainer.appendChild(cell);
                }
            }
        }

        function rotateMatrix(matrix) {
            const rows = matrix.length;
            const cols = matrix[0].length;
            const rotated = Array(cols).fill().map(() => Array(rows).fill(0));
            for (let r = 0; r < rows; r++) {
                for (let c = 0; c < cols; c++) {
                    rotated[c][rows - 1 - r] = matrix[r][c];
                }
            }
            return rotated;
        }

        function createPieceElement(shapeData) {
            const pieceObj = document.createElement('div');
            pieceObj.className = 'draggable-piece in-slot';
            const shape = shapeData.shape;

            const boardRect = boardContainer.getBoundingClientRect();
            const cellSize = (boardRect.width - 20 - (GRID_SIZE - 1) * 5) / GRID_SIZE;
            const gap = 5;

            const width = shape[0].length * cellSize + (shape[0].length - 1) * gap;
            const height = shape.length * cellSize + (shape.length - 1) * gap;

            pieceObj.style.width = `${width}px`;
            pieceObj.style.height = `${height}px`;

            shape.forEach((row, r) => {
                row.forEach((val, c) => {
                    if (val !== 0) {
                        const unit = document.createElement('div');

                        if (shapeData.isRemover) {
                            unit.className = `block-unit color-remover`;
                        } else {
                            unit.className = `block-unit color-${shapeData.color}`;
                        }

                        unit.style.width = `${cellSize}px`; unit.style.height = `${cellSize}px`;
                        unit.style.top = `${r * (cellSize + gap)}px`; unit.style.left = `${c * (cellSize + gap)}px`;

                        if (val === 2 && !shapeData.isRemover) {
                            const bombBadge = document.createElement('div');
                            bombBadge.className = 'absolute inset-0 flex items-center justify-center bomb-badge';
                            const countdownVal = shapeData.bombCountdown || 5;
                            bombBadge.innerHTML = `<div class="bg-red-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-[10px] font-black shadow-md border border-white animate-pulse">${countdownVal}</div>`;
                            unit.appendChild(bombBadge);
                        }

                        if (shapeData.isRemover) {
                            const removeBadge = document.createElement('div');
                            removeBadge.className = 'absolute inset-0 flex items-center justify-center text-white text-base drop-shadow-md';
                            removeBadge.innerText = '🧹';
                            unit.appendChild(removeBadge);
                        }

                        pieceObj.appendChild(unit);
                    }
                });
            });
            return { element: pieceObj, width, height };
        }

        function generateNewPieces() {
            comboCount = 0;
            piecesPlacedInCurrentSet = 0;

            const hasRotatable = Math.random() < 0.25;
            const rotatableIndex = hasRotatable ? Math.floor(Math.random() * 3) : -1;

            for (let i = 0; i < 3; i++) {
                const randomShape = SHAPES[Math.floor(Math.random() * SHAPES.length)];
                const shapeCopy = JSON.parse(JSON.stringify(randomShape));
                const isRotatable = (i === rotatableIndex);

                const isRemover = Math.random() < 0.10;
                let isBomb = false;

                if (isRemover) {
                    shapeCopy.isRemover = true;
                } else {
                    isBomb = Math.random() < 0.13;
                    if (isBomb) {
                        const filledCoords = [];
                        shapeCopy.shape.forEach((row, r) => {
                            row.forEach((val, c) => {
                                if (val === 1) filledCoords.push({r, c});
                            });
                        });
                        if (filledCoords.length > 0) {
                            const target = filledCoords[Math.floor(Math.random() * filledCoords.length)];
                            shapeCopy.shape[target.r][target.c] = 2;

                            const difficultyOffset = Math.floor(score / 400);
                            const maxCountdown = Math.max(5, 10 - difficultyOffset);
                            const minCountdown = Math.max(3, maxCountdown - 3);
                            shapeCopy.bombCountdown = Math.floor(Math.random() * (maxCountdown - minCountdown + 1)) + minCountdown;
                        }
                    }
                }

                const { element, width, height } = createPieceElement(shapeCopy);
                piecesInHand[i] = { shapeData: shapeCopy, element, width, height, isRotatable, isRemover };

                const slot = document.getElementById(`slot-${i}`);
                slot.innerHTML = '';

                slot.classList.remove('slot-rotatable', 'slot-remover');

                if (isRotatable) {
                    slot.classList.add('slot-rotatable');
                    const rotateIndicator = document.createElement('div');
                    rotateIndicator.className = 'absolute top-2 right-2 bg-yellow-500 text-slate-900 rounded-full w-7 h-7 flex items-center justify-center z-50 text-sm font-bold shadow-md pointer-events-none animate-pulse';
                    rotateIndicator.innerHTML = '🔄';
                    slot.appendChild(rotateIndicator);
                }

                if (isRemover) {
                    slot.classList.add('slot-remover');
                    const removerIndicator = document.createElement('div');
                    removerIndicator.className = 'absolute top-2 right-2 bg-pink-500 text-white rounded-full w-7 h-7 flex items-center justify-center z-50 text-sm font-bold shadow-md pointer-events-none animate-pulse';
                    removerIndicator.innerHTML = '🧹';
                    slot.appendChild(removerIndicator);
                }

                slot.appendChild(element);
            }
            if (checkGameOver()) endGame();
        }

        function rotatePiece(index) {
            const piece = piecesInHand[index];
            if (!piece) return;

            piece.shapeData.shape = rotateMatrix(piece.shapeData.shape);

            const shape = piece.shapeData.shape;
            const boardRect = boardContainer.getBoundingClientRect();
            const cellSize = document.querySelector('.cell').offsetWidth;
            const gap = 5;

            const newWidth = shape[0].length * cellSize + (shape[0].length - 1) * gap;
            const newHeight = shape.length * cellSize + (shape.length - 1) * gap;

            piece.width = newWidth;
            piece.height = newHeight;

            const el = piece.element;
            el.innerHTML = '';
            el.style.width = `${newWidth}px`;
            el.style.height = `${newHeight}px`;

            shape.forEach((row, r) => {
                row.forEach((val, c) => {
                    if (val !== 0) {
                        const unit = document.createElement('div');

                        if (piece.isRemover) {
                            unit.className = `block-unit color-remover`;
                        } else {
                            unit.className = `block-unit color-${piece.shapeData.color}`;
                        }

                        unit.style.width = `${cellSize}px`; unit.style.height = `${cellSize}px`;
                        unit.style.top = `${r * (cellSize + gap)}px`; unit.style.left = `${c * (cellSize + gap)}px`;

                        if (val === 2 && !piece.isRemover) {
                            const bombBadge = document.createElement('div');
                            bombBadge.className = 'absolute inset-0 flex items-center justify-center bomb-badge';
                            const countdownVal = piece.shapeData.bombCountdown || 5;
                            bombBadge.innerHTML = `<div class="bg-red-600 text-white rounded-full w-5 h-5 flex items-center justify-center text-[10px] font-black shadow-md border border-white animate-pulse">${countdownVal}</div>`;
                            unit.appendChild(bombBadge);
                        }

                        if (piece.isRemover) {
                            const removeBadge = document.createElement('div');
                            removeBadge.className = 'absolute inset-0 flex items-center justify-center text-white text-base drop-shadow-md';
                            removeBadge.innerText = '🧹';
                            unit.appendChild(removeBadge);
                        }

                        el.appendChild(unit);
                    }
                });
            });

            el.style.transition = 'transform 0.12s cubic-bezier(0.34, 1.56, 0.64, 1)';
            el.style.transform = 'scale(0.42)';
        }

        let activeIdx = -1, dragOffsetX = 0, dragOffsetY = 0, curX = 0, curY = 0, ghostUnits = [], rAF = null;

        function setupDragEvents() {
            for (let i = 0; i < 3; i++) {
                const slot = document.getElementById(`slot-${i}`);

                slot.addEventListener('pointerdown', (e) => {
                    if (e.button !== 0 && e.pointerType === 'mouse') return;
                    if (activeIdx !== -1 || !piecesInHand[i]) return;

                    const piece = piecesInHand[i];
                    const el = piece.element;

                    const startXCoord = e.clientX;
                    const startYCoord = e.clientY;
                    curX = e.clientX;
                    curY = e.clientY;

                    let isDraggingActive = false;
                    let hasMovedPastThreshold = false;

                    slot.setPointerCapture(e.pointerId);

                    const move = (ev) => {
                        curX = ev.clientX;
                        curY = ev.clientY;

                        if (!isDraggingActive) {
                            const dist = Math.hypot(ev.clientX - startXCoord, ev.clientY - startYCoord);
                            if (dist > 12) {
                                hasMovedPastThreshold = true;
                                isDraggingActive = true;
                                activeIdx = i;

                                dragOffsetX = piece.width / 2;
                                dragOffsetY = piece.height / 2;

                                el.classList.remove('in-slot');
                                el.style.position = 'fixed';
                                el.style.zIndex = 1000;
                                el.style.transform = 'scale(1.0)';
                                el.style.transition = 'none';

                                const loop = () => {
                                    if (activeIdx === -1) return;
                                    const tx = curX - dragOffsetX;
                                    const ty = curY - dragOffsetY;
                                    el.style.transform = `translate3d(${tx}px, ${ty}px, 0)`;
                                    el.style.left = '0px'; el.style.top = '0px';
                                    updateGhostPreview(tx, ty, piecesInHand[activeIdx].shapeData, piecesInHand[activeIdx].isRemover);
                                    rAF = requestAnimationFrame(loop);
                                };
                                rAF = requestAnimationFrame(loop);
                            }
                        } else {
                            if (ev.cancelable) ev.preventDefault();
                        }
                    };

                    const end = (ev) => {
                        slot.releasePointerCapture(ev.pointerId);
                        slot.removeEventListener('pointermove', move);
                        slot.removeEventListener('pointerup', end);
                        slot.removeEventListener('pointercancel', end);

                        if (!isDraggingActive && !hasMovedPastThreshold) {
                            const finalDist = Math.hypot(ev.clientX - startXCoord, ev.clientY - startYCoord);
                            if (finalDist <= 12) {
                                if (piece.isRotatable) {
                                    rotatePiece(i);
                                }
                            }
                            return;
                        }

                        if (rAF) cancelAnimationFrame(rAF);

                        if (activeIdx === -1) return;

                        const currentPiece = piecesInHand[activeIdx];
                        const currentEl = currentPiece.element;
                        const trans = currentEl.style.transform;
                        const m = trans.match(/translate3d\(([^px]+)px,\s*([^px]+)px/);
                        const fx = m ? parseFloat(m[1]) : 0;
                        const fy = m ? parseFloat(m[2]) : 0;

                        const pos = calculateGridPosition(fx, fy, currentPiece.shapeData);

                        // 제거 블록은 경계선 내부라면 빈칸 상관없이 일시 배치는 허용하되, 후속 함수에서 게임오버 처리
                        const canBePlaced = currentPiece.isRemover
                            ? (pos && pos.row >= 0 && pos.col >= 0 && pos.row + currentPiece.shapeData.shape.length <= GRID_SIZE && pos.col + currentPiece.shapeData.shape[0].length <= GRID_SIZE)
                            : (pos && canPlace(pos.row, pos.col, currentPiece.shapeData.shape));

                        if (canBePlaced) {
                            if (currentPiece.isRemover) {
                                removeBlocks(pos.row, pos.col, currentPiece.shapeData);
                            } else {
                                placeBlock(pos.row, pos.col, currentPiece.shapeData);
                            }

                            currentEl.remove();
                            piecesInHand[activeIdx] = null;

                            if (piecesInHand.every(p => p === null)) {
                                generateNewPieces();
                            } else if (checkGameOver()) {
                                endGame();
                            }
                        } else {
                            currentEl.style.position = 'absolute';
                            currentEl.style.left = 'auto'; currentEl.style.top = 'auto';
                            currentEl.style.transform = '';
                            currentEl.classList.add('in-slot');
                            currentEl.style.zIndex = 100;
                        }
                        clearGhost();
                        activeIdx = -1;
                    };

                    slot.addEventListener('pointermove', move);
                    slot.addEventListener('pointerup', end);
                    slot.addEventListener('pointercancel', end);
                });
            }
        }

        function calculateGridPosition(px, py, shapeData) {
            const boardRect = boardContainer.getBoundingClientRect();
            const cellSize = document.querySelector('.cell').offsetWidth;
            const gap = 5;
            const rx = px - boardRect.left - 10;
            const ry = py - boardRect.top - 10;
            const col = Math.round(rx / (cellSize + gap));
            const row = Math.round(ry / (cellSize + gap));

            if (row >= 0 && col >= 0 && row + shapeData.shape.length <= GRID_SIZE && col + shapeData.shape[0].length <= GRID_SIZE) {
                return { row, col };
            }
            return null;
        }

        function updateGhostPreview(x, y, shapeData, isRemover) {
            clearGhost();
            const pos = calculateGridPosition(x, y, shapeData);
            if (!pos) return;
            const cellSize = document.querySelector('.cell').offsetWidth;
            const gap = 5;

            if (isRemover) {
                shapeData.shape.forEach((rowArr, r) => {
                    rowArr.forEach((val, c) => {
                        if (val !== 0) {
                            const targetRow = pos.row + r;
                            const targetCol = pos.col + c;
                            if (targetRow < GRID_SIZE && targetCol < GRID_SIZE) {
                                const ghost = document.createElement('div');
                                const hasBlock = board[targetRow][targetCol] !== 0;

                                if (hasBlock) {
                                    ghost.className = 'ghost-unit ghost-remover-target';
                                } else {
                                    ghost.className = 'ghost-unit ghost-remover-empty';
                                }

                                ghost.style.width = `${cellSize}px`; ghost.style.height = `${cellSize}px`;
                                ghost.style.top = `${targetRow * (cellSize + gap) + 10}px`;
                                ghost.style.left = `${targetCol * (cellSize + gap) + 10}px`;
                                boardContainer.appendChild(ghost); ghostUnits.push(ghost);
                            }
                        }
                    });
                });
            } else {
                if (!canPlace(pos.row, pos.col, shapeData.shape)) return;
                shapeData.shape.forEach((rowArr, r) => {
                    rowArr.forEach((val, c) => {
                        if (val !== 0) {
                            const ghost = document.createElement('div');
                            ghost.className = 'ghost-unit';
                            ghost.style.width = `${cellSize}px`; ghost.style.height = `${cellSize}px`;
                            ghost.style.top = `${(pos.row + r) * (cellSize + gap) + 10}px`;
                            ghost.style.left = `${(pos.col + c) * (cellSize + gap) + 10}px`;
                            boardContainer.appendChild(ghost); ghostUnits.push(ghost);
                        }
                    });
                });
            }
        }

        function clearGhost() { ghostUnits.forEach(g => g.remove()); ghostUnits = []; }

        function canPlace(row, col, shape) {
            for (let r = 0; r < shape.length; r++) {
                for (let c = 0; c < shape[0].length; c++) {
                    if (shape[r][c] !== 0 && board[row + r][col + c] !== 0) return false;
                }
            }
            return true;
        }

        function spawnParticles(r, c, colorCode) {
            const cell = document.getElementById(`cell-${r}-${c}`);
            const rect = cell.getBoundingClientRect();
            const centerX = rect.left + rect.width / 2, centerY = rect.top + rect.height / 2;
            const colorClass = `color-${colorCode}`;
            for (let i = 0; i < 8; i++) {
                const p = document.createElement('div');
                p.className = `particle ${colorClass}`;
                p.style.width = '8px'; p.style.height = '8px';
                p.style.left = `${centerX}px`; p.style.top = `${centerY}px`;
                const angle = Math.random() * Math.PI * 2, dist = 60 + Math.random() * 80;
                p.style.setProperty('--dx', `${Math.cos(angle) * dist}px`);
                p.style.setProperty('--dy', `${Math.sin(angle) * dist}px`);
                document.body.appendChild(p); setTimeout(() => p.remove(), 600);
            }
        }

        // 제거 블록 전용 소멸 기능 (빈칸 터치 시 게임오버 패널티 추가)
        function removeBlocks(row, col, shapeData) {
            let blocksRemoved = 0;
            let hitEmptySpace = false;
            piecesPlacedInCurrentSet++;

            // 1차 순회: 제거 블록 모양이 보드의 빈 자리에 매칭되는지 완전 판별
            shapeData.shape.forEach((rowArr, r) => {
                rowArr.forEach((val, c) => {
                    if (val !== 0) {
                        const targetRow = row + r;
                        const targetCol = col + c;

                        if (board[targetRow][targetCol] === 0) {
                            hitEmptySpace = true; // 단 하나라도 빈칸에 닿았다면 패널티 플래그 On
                        }
                    }
                });
            });

            // 빈칸을 단 한 칸이라도 건드렸다면 즉시 게임오버 트리거 작동
            if (hitEmptySpace) {
                renderBoard(); // 현재 보드를 재그려 폭탄이나 블록의 잔여 상황 노출
                setTimeout(() => {
                    endGame("제거 블록이 빈칸을 건드려 폭발했습니다!");
                }, 200);
                return;
            }

            // 빈칸 유효성 통과 시, 정상 제거 절차 진행
            shapeData.shape.forEach((rowArr, r) => {
                rowArr.forEach((val, c) => {
                    if (val !== 0) {
                        const targetRow = row + r;
                        const targetCol = col + c;

                        if (board[targetRow][targetCol] !== 0) {
                            spawnParticles(targetRow, targetCol, board[targetRow][targetCol].color);
                            board[targetRow][targetCol] = 0;
                            blocksRemoved++;
                        }
                    }
                });
            });

            decreaseBombCountdowns();

            if (blocksRemoved > 0) {
                score += blocksRemoved * 5;
                updateScoreUI();
            }

            renderBoard();
        }

        function placeBlock(row, col, shapeData) {
            piecesPlacedInCurrentSet++;
            shapeData.shape.forEach((rowArr, r) => {
                rowArr.forEach((val, c) => {
                    if (val !== 0) {
                        board[row + r][col + c] = {
                            color: shapeData.color,
                            bomb: val === 2,
                            countdown: val === 2 ? (shapeData.bombCountdown || 5) : 0
                        };
                        const cell = document.getElementById(`cell-${row + r}-${col + c}`);
                        const unit = document.createElement('div');
                        unit.className = `block-unit color-${shapeData.color}`;
                        cell.appendChild(unit);
                    }
                });
            });

            let turnScore = shapeData.shape.flat().filter(v => v !== 0).length * 10;
            const linesCleared = checkLines();

            decreaseBombCountdowns();

            if (linesCleared > 0) {
                comboCount++;
                turnScore += (linesCleared * 100) * comboCount;
                if (comboCount > 1) showComboText(comboCount);
            } else {
                comboCount = 0;
            }

            score += turnScore;
            updateScoreUI();

            if (linesCleared === 0) {
                renderBoard();
            }
        }

        function decreaseBombCountdowns() {
            let bombExploded = false;
            for (let r = 0; r < GRID_SIZE; r++) {
                for (let c = 0; c < GRID_SIZE; c++) {
                    if (board[r][c] !== 0 && board[r][c].bomb) {
                        board[r][c].countdown--;
                        if (board[r][c].countdown <= 0) {
                            bombExploded = true;
                        }
                    }
                }
            }

            if (bombExploded) {
                setTimeout(() => {
                    endGame("시한폭탄이 폭발했습니다!");
                }, 500);
            }
        }

        function showComboText(count) {
            const el = document.createElement('div');
            el.className = 'combo-text'; el.innerText = `${count} COMBO!`;
            comboLayer.appendChild(el); setTimeout(() => el.remove(), 800);
        }

        function checkLines() {
            let rs = [], cs = [];
            for (let r = 0; r < GRID_SIZE; r++) if (board[r].every(v => v !== 0)) rs.push(r);
            for (let c = 0; c < GRID_SIZE; c++) if (board.every(row => row[c] !== 0)) cs.push(c);

            if (rs.length > 0 || cs.length > 0) {
                rs.forEach(r => {
                    for (let c = 0; c < GRID_SIZE; c++) {
                        const unit = document.getElementById(`cell-${r}-${c}`).querySelector('.block-unit');
                        if (unit) unit.classList.add('pop-animation');
                        spawnParticles(r, c, board[r][c].color);
                    }
                });
                cs.forEach(c => {
                    for (let r = 0; r < GRID_SIZE; r++) {
                        const unit = document.getElementById(`cell-${r}-${c}`).querySelector('.block-unit');
                        if (unit && !unit.classList.contains('pop-animation')) {
                            unit.classList.add('pop-animation');
                            spawnParticles(r, c, board[r][c].color);
                        }
                    }
                });
                setTimeout(() => {
                    rs.forEach(r => board[r].fill(0));
                    cs.forEach(c => board.forEach(row => row[c] = 0));
                    renderBoard();
                }, 350);
                return rs.length + cs.length;
            }
            return 0;
        }

        function renderBoard() {
            for (let r = 0; r < GRID_SIZE; r++) {
                for (let c = 0; c < GRID_SIZE; c++) {
                    const cell = document.getElementById(`cell-${r}-${c}`);
                    cell.innerHTML = '';
                    if (board[r][c] !== 0) {
                        const unit = document.createElement('div');
                        unit.className = `block-unit color-${board[r][c].color}`;

                        if (board[r][c].bomb) {
                            const bombBadge = document.createElement('div');
                            bombBadge.className = 'absolute inset-0 flex items-center justify-center bomb-badge';
                            bombBadge.innerHTML = `<div class="bg-red-600 text-white rounded-full w-6 h-6 flex items-center justify-center text-xs font-black shadow-md border border-white animate-pulse">${board[r][c].countdown}</div>`;
                            unit.appendChild(bombBadge);
                        }

                        cell.appendChild(unit);
                    }
                }
            }
        }

        function updateScoreUI() {
            currentScoreEl.innerText = score;
            if (score > bestScore) {
                bestScore = score;
                bestScoreEl.innerText = bestScore;
                localStorage.setItem('blockBlastBestScore', bestScore);
            }
        }

        function checkGameOver() {
            const pieces = piecesInHand.filter(p => p !== null);
            if (pieces.length === 0) return false;
            return !pieces.some(p => {
                if (p.isRemover) {
                    for (let r = 0; r <= GRID_SIZE - p.shapeData.shape.length; r++) {
                        for (let c = 0; c <= GRID_SIZE - p.shapeData.shape[0].length; c++) {
                            return true;
                        }
                    }
                }

                for (let r = 0; r <= GRID_SIZE - p.shapeData.shape.length; r++) {
                    for (let c = 0; c <= GRID_SIZE - p.shapeData.shape[0].length; c++) {
                        if (canPlace(r, c, p.shapeData.shape)) return true;
                    }
                }
                return false;
            });
        }

        function endGame(reason = "더 이상 놓을 공간이 없습니다!") {
            document.getElementById('game-over-reason').innerText = reason;
            document.getElementById('final-score').innerText = score;
            overlay.style.display = 'flex';
        }

        function resetGame() {
            score = 0;
            comboCount = 0;
            board = Array(GRID_SIZE).fill().map(() => Array(GRID_SIZE).fill(0));
            updateScoreUI(); initBoard(); piecesInHand = [null, null, null];
            overlay.style.display = 'none'; setTimeout(generateNewPieces, 200);
        }

        window.onload = () => {
            initBoard();
            setupDragEvents();
            setTimeout(generateNewPieces, 400);
        };
    </script>
</body>
</html>
