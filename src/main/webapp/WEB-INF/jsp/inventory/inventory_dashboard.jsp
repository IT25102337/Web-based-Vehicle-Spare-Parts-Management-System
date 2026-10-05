<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Depot Inventory Dashboard | AutoParts PartTrack</title>

    <!-- Theme Initialization BEFORE Render -->
    <script>
        (function(){
            var t = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', t);
        })();
    </script>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@600&display=swap" rel="stylesheet">
    
    <!-- Bootstrap 5 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --bg: #f8fafc;
            --card: #ffffff;
            --card-subtle: #f4f4f5;
            --border: #e4e4e7;
            --border-hover: #d4d4d8;
            --txt: #09090b;
            --txt2: #52525b;
            --txt-muted: #71717a;
            --brand-red: #cc1d24;
            --brand-red-hover: #b0151b;
            --brand-dark: #09090b;
            --pill-bg: #f4f4f5;
            --sidebar-bg: #ffffff;
            --table-head: #fafafa;
            --table-hover: #f8fafc;
            --radius-lg: 20px;
            --radius-md: 14px;
            --radius-sm: 8px;
            --shadow-subtle: 0 1px 3px rgba(0,0,0,0.04), 0 8px 24px -4px rgba(0,0,0,0.04);
            --shadow-modal: 0 20px 40px -10px rgba(0,0,0,0.18);
            --input-bg: #ffffff;
            --modal-bg: #ffffff;
        }

        [data-theme="dark"] {
            --bg: #09090b;
            --card: #141416;
            --card-subtle: #1c1c1f;
            --border: #27272a;
            --border-hover: #3f3f46;
            --txt: #f4f4f5;
            --txt2: #a1a1aa;
            --txt-muted: #71717a;
            --brand-red: #e11d48;
            --brand-red-hover: #f43f5e;
            --brand-dark: #ffffff;
            --pill-bg: #1f1f23;
            --sidebar-bg: #141416;
            --table-head: #18181b;
            --table-hover: #1b1b1f;
            --shadow-subtle: 0 1px 3px rgba(0,0,0,0.4), 0 8px 24px -4px rgba(0,0,0,0.35);
            --shadow-modal: 0 20px 40px -10px rgba(0,0,0,0.7);
            --input-bg: #0b1120;
            --modal-bg: #141416;
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', -apple-system, BlinkMacSystemFont, sans-serif;
            background-color: var(--bg);
            color: var(--txt);
            min-height: 100vh;
            margin: 0;
            display: flex;
            transition: background-color 0.2s ease, color 0.2s ease;
            -webkit-font-smoothing: antialiased;
        }

        /* ── SIDEBAR RAIL ── */
        .sidebar-rail {
            width: 76px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1.5rem 0;
            z-index: 1030;
            transition: background 0.2s, border-color 0.2s;
        }

        .brand-logo-icon {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            background: var(--brand-dark);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            margin-bottom: 2rem;
            text-decoration: none;
            transition: transform 0.2s;
        }
        [data-theme="dark"] .brand-logo-icon {
            background: #ffffff;
            color: #09090b;
        }
        .brand-logo-icon:hover { transform: scale(1.05); }

        .sidebar-nav {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            width: 100%;
            align-items: center;
        }

        .sidebar-icon-link {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--txt2);
            font-size: 1.2rem;
            text-decoration: none;
            transition: all 0.2s ease;
            position: relative;
        }
        .sidebar-icon-link:hover {
            background-color: var(--card-subtle);
            color: var(--txt);
        }
        .sidebar-icon-link.active {
            background-color: var(--brand-dark);
            color: #ffffff;
        }
        [data-theme="dark"] .sidebar-icon-link.active {
            background-color: #ffffff;
            color: #09090b;
        }

        .badge-dot {
            width: 8px;
            height: 8px;
            background-color: var(--brand-red);
            border: 2px solid var(--sidebar-bg);
            border-radius: 50%;
            position: absolute;
            top: 7px;
            right: 7px;
        }

        .sidebar-bottom {
            margin-top: auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
        }

        .theme-toggle-sidebar, .logout-icon-link {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--txt2);
            font-size: 1.1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .theme-toggle-sidebar:hover, .logout-icon-link:hover {
            color: var(--txt);
            border-color: var(--border-hover);
            background: var(--card-subtle);
        }

        /* ── MAIN CONTENT ── */
        .main-content {
            margin-left: 76px;
            padding: 2.25rem 3rem;
            width: calc(100% - 76px);
            min-height: 100vh;
            max-width: 1600px;
        }

        /* ── TOPBAR ── */
        .topbar-clean {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }
        .topbar-title {
            font-size: 1.35rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            text-transform: uppercase;
            margin: 0;
            color: var(--txt);
        }
        .topbar-sub {
            font-size: 0.82rem;
            color: var(--txt-muted);
            margin: 0;
            font-weight: 500;
        }

        .depot-status-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--card);
            color: var(--txt);
            font-size: 0.82rem;
            font-weight: 600;
            padding: 0.45rem 1rem;
            border-radius: 9999px;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-subtle);
        }

        .dot-green {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #10b981;
            display: inline-block;
        }

        /* ── BUTTONS ── */
        .btn-pill-dark {
            background: var(--brand-dark);
            color: #ffffff !important;
            border: 1px solid var(--brand-dark);
            border-radius: 9999px;
            padding: 0.55rem 1.35rem;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        [data-theme="dark"] .btn-pill-dark {
            background: #ffffff;
            color: #09090b !important;
            border-color: #ffffff;
        }
        .btn-pill-dark:hover {
            opacity: 0.9;
            transform: translateY(-1px);
        }

        .btn-pill-white {
            background: #ffffff;
            color: #09090b !important;
            border: 1px solid #ffffff;
            border-radius: 9999px;
            padding: 0.55rem 1.35rem;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-pill-white:hover {
            background: #f4f4f5;
            transform: translateY(-1px);
        }

        .btn-pill-ghost {
            background: rgba(255, 255, 255, 0.12);
            color: #ffffff !important;
            border: 1px solid rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(8px);
            border-radius: 9999px;
            padding: 0.55rem 1.35rem;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-pill-ghost:hover {
            background: rgba(255, 255, 255, 0.22);
            transform: translateY(-1px);
        }

        /* ── HERO BANNER: MINIMALIST AUTOMOTIVE EV STYLE ── */
        .hero-ev {
            position: relative;
            height: 340px;
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 2.25rem;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 2.5rem 3rem;
            background: #09090b;
        }
        .hero-ev-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center 40%;
            opacity: 0.62;
            transition: transform 0.5s ease;
        }
        .hero-ev:hover .hero-ev-bg { transform: scale(1.02); }
        .hero-ev-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(180deg, rgba(9,9,11,0.2) 0%, rgba(9,9,11,0.65) 50%, rgba(9,9,11,0.94) 100%);
        }
        .hero-ev-content {
            position: relative;
            z-index: 2;
            color: #ffffff;
            max-width: 900px;
        }

        .hero-metrics-strip {
            display: flex;
            gap: 2rem;
            margin-bottom: 1.1rem;
            flex-wrap: wrap;
        }
        .hero-metric-item {
            display: flex;
            flex-direction: column;
        }
        .hero-metric-num {
            font-size: 1.35rem;
            font-weight: 800;
            color: #ffffff;
            letter-spacing: -0.02em;
            line-height: 1.1;
        }
        .hero-metric-lbl {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            color: rgba(255, 255, 255, 0.65);
            font-weight: 600;
        }

        .hero-ev-title {
            font-size: 2.2rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            text-transform: uppercase;
            line-height: 1.15;
            margin: 0 0 0.5rem 0;
            color: #ffffff;
        }
        .hero-ev-sub {
            font-size: 0.92rem;
            color: rgba(255, 255, 255, 0.82);
            margin: 0 0 1.5rem 0;
            max-width: 680px;
            font-weight: 400;
        }

        /* ── 4 KPI CARDS (CLEAN MINIMALIST BLACK & WHITE) ── */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }

        .kpi-card {
            background-color: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 1.5rem;
            position: relative;
            overflow: hidden;
            box-shadow: var(--shadow-subtle);
            transition: transform 0.2s ease, box-shadow 0.2s ease, border-color 0.2s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .kpi-card:hover {
            transform: translateY(-2px);
            border-color: var(--border-hover);
            box-shadow: 0 12px 28px -6px rgba(0, 0, 0, 0.08);
        }

        .kpi-card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.1rem;
        }

        .kpi-icon-box {
            width: 42px;
            height: 42px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.2rem;
            background: var(--card-subtle);
            color: var(--txt);
            border: 1px solid var(--border);
        }

        .kpi-chip-label {
            font-size: 0.72rem;
            font-weight: 700;
            padding: 0.25rem 0.65rem;
            border-radius: 9999px;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            background: var(--pill-bg);
            color: var(--txt2);
            border: 1px solid var(--border);
        }

        .kpi-lbl {
            font-size: 0.78rem;
            font-weight: 700;
            color: var(--txt-muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 0.35rem;
        }

        .kpi-num {
            font-size: 2.1rem;
            font-weight: 800;
            color: var(--txt);
            line-height: 1.1;
            letter-spacing: -0.03em;
            font-family: 'Plus Jakarta Sans', sans-serif;
            margin-bottom: 0.85rem;
        }

        .kpi-sub-text {
            font-size: 0.8rem;
            color: var(--txt2);
            display: flex;
            align-items: center;
            gap: 0.4rem;
            padding-top: 0.75rem;
            border-top: 1px solid var(--border);
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        /* ── BOTTOM PANELS ── */
        .panel-bento-card {
            background-color: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-subtle);
            height: 100%;
            display: flex;
            flex-direction: column;
            transition: transform 0.2s ease, border-color 0.2s ease;
        }

        .panel-bento-card:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }

        .panel-photo-header {
            height: 160px;
            position: relative;
            overflow: hidden;
            background: #09090b;
        }

        .panel-photo-header img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }

        .panel-bento-card:hover .panel-photo-header img {
            transform: scale(1.04);
        }

        .panel-photo-overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(9, 9, 11, 0.88) 0%, rgba(9, 9, 11, 0.25) 100%);
        }

        .panel-photo-pill {
            position: absolute;
            bottom: 1rem;
            left: 1.25rem;
            background: var(--brand-dark);
            color: #ffffff;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 0.3rem 0.85rem;
            border-radius: 9999px;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            border: 1px solid rgba(255,255,255,0.2);
        }
        [data-theme="dark"] .panel-photo-pill {
            background: #ffffff;
            color: #09090b;
        }

        .panel-card-body {
            padding: 1.75rem 2rem;
            flex: 1;
            display: flex;
            flex-direction: column;
        }

        .panel-title-text {
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--txt-muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 0.35rem;
        }

        .panel-hero-metric {
            font-size: 2.1rem;
            font-weight: 800;
            color: var(--txt);
            letter-spacing: -0.03em;
            margin-bottom: 1.25rem;
        }

        .panel-hero-metric span {
            font-size: 1rem;
            font-weight: 600;
            color: var(--txt-muted);
        }

        .rack-progress-track {
            height: 8px;
            border-radius: 9999px;
            background-color: var(--card-subtle);
            border: 1px solid var(--border);
            overflow: hidden;
            margin-bottom: 1rem;
        }

        .rack-progress-fill {
            height: 100%;
            border-radius: 9999px;
            transition: width 0.4s ease;
        }

        .qc-status-box {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 0.9rem 1.1rem;
            border-radius: var(--radius-sm);
            background-color: var(--card-subtle);
            border: 1px solid var(--border);
            margin-bottom: 0.85rem;
        }

        .qc-status-icon {
            width: 38px;
            height: 38px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.15rem;
            flex-shrink: 0;
            background: var(--card);
            border: 1px solid var(--border);
            color: var(--txt);
        }

        /* ── RESPONSIVE DESIGN ── */
        @media (max-width: 1100px) {
            .kpi-grid { grid-template-columns: repeat(2, 1fr); }
            .main-content { padding: 1.8rem 1.8rem 3rem; }
        }

        @media (max-width: 768px) {
            .sidebar-rail { display: none; }
            .main-content { margin-left: 0; width: 100%; padding: 1.25rem 1rem 3rem; }
            .kpi-grid { grid-template-columns: 1fr; }
            .hero-ev { height: auto; padding: 2rem 1.5rem; }
            .hero-ev-title { font-size: 1.8rem; }
        }
    </style>
</head>
<body>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  1. LEFT SIDEBAR                                  -->
    <!-- ═════════════════════════════════════════════════ -->
    <aside class="sidebar-rail">
        <!-- Upper Account Details Changes -->
        <a href="javascript:void(0)" onclick="openAccountModal()" class="brand-logo-icon" title="My Account & Profile Details">
            <i class="bi bi-person-circle"></i>
        </a>

        <!-- 4 Depot Interfaces Navigation -->
        <ul class="sidebar-nav">
            <!-- 1. Depot Dashboard (Active) -->
            <li>
                <a href="/inventory/dashboard" class="sidebar-icon-link active" title="Depot Dashboard">
                    <i class="bi bi-speedometer2"></i>
                </a>
            </li>
            <!-- 2. Stock Repository -->
            <li>
                <a href="/inventory" class="sidebar-icon-link" title="Stock Repository">
                    <i class="bi bi-layers-fill"></i>
                </a>
            </li>
            <!-- 3. Reorder Alerts -->
            <li>
                <a href="/reorder" class="sidebar-icon-link" title="Reorder Center">
                    <i class="bi bi-bell-fill"></i>
                    <c:if test="${lowStockCount > 0}">
                        <span class="badge-dot"></span>
                    </c:if>
                </a>
            </li>
            <!-- 4. Reports & Audits -->
            <li>
                <a href="/inventory/reports" class="sidebar-icon-link" title="Reports & Audits">
                    <i class="bi bi-file-earmark-bar-graph-fill"></i>
                </a>
            </li>
        </ul>

        <!-- Lower Controls: Theme Toggle & Logout -->
        <div class="sidebar-bottom">
            <button class="theme-toggle-sidebar" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
                <i class="bi bi-moon-stars-fill" id="themeSideIcon"></i>
            </button>
            <a href="/logout" class="logout-icon-link" title="Sign Out">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </aside>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  2. MAIN CONTENT                                  -->
    <!-- ═════════════════════════════════════════════════ -->
    <main class="main-content">

        <!-- Topbar Clean Minimalist -->
        <div class="topbar-clean">
            <div>
                <h1 class="topbar-title">DEPOT OPERATIONS DASHBOARD</h1>
                <p class="topbar-sub">Central inventory telemetry &amp; live stock status</p>
            </div>

            <div class="d-flex align-items-center gap-2 flex-wrap">
                <span class="depot-status-pill">
                    <span class="dot-green"></span> Depot Online &amp; Synchronized
                </span>
            </div>
        </div>

        <!-- Flash alerts -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 rounded-4 mb-3 py-2 px-3 small border" role="alert">
                <i class="bi bi-check-circle-fill text-success fs-5"></i>
                <span class="fw-semibold text-success">${successMessage}</span>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 rounded-4 mb-3 py-2 px-3 small border" role="alert">
                <i class="bi bi-exclamation-triangle-fill text-danger fs-5"></i>
                <span class="fw-semibold text-danger">${errorMessage}</span>
                <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- ═════════════════════════════════════════════ -->
        <!--  3. HERO BANNER: EV AUTOMOTIVE MINIMALIST     -->
        <!-- ═════════════════════════════════════════════ -->
        <div class="hero-ev">
            <img src="/images/hero_red_car.jpg" alt="Automotive Depot" class="hero-ev-bg">
            <div class="hero-ev-overlay"></div>
            <div class="hero-ev-content">
                <div class="hero-metrics-strip">
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${totalItems}</span>
                        <span class="hero-metric-lbl">Catalog Models</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${totalStock} / ${maxCapacity}</span>
                        <span class="hero-metric-lbl">Units In Storage (${capacityPct}%)</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">Rs. <fmt:formatNumber value="${totalValue}" pattern="#,##0"/></span>
                        <span class="hero-metric-lbl">Asset Valuation</span>
                    </div>
                    <c:if test="${lowStockCount > 0}">
                        <div class="hero-metric-item">
                            <span class="hero-metric-num" style="color:#f87171;">${lowStockCount}</span>
                            <span class="hero-metric-lbl" style="color:#fca5a5;">Low Stock Alerts</span>
                        </div>
                    </c:if>
                </div>

                <h1 class="hero-ev-title">INVENTORY DEPOT &amp; STORAGE CENTER</h1>
                <p class="hero-ev-sub">Precision spare parts repository, automated 4-rack capacity telemetry, and quality control receiving pipeline.</p>

                <div class="d-flex align-items-center gap-2 flex-wrap">
                    <a href="/inventory" class="btn-pill-white">
                        <i class="bi bi-layers-fill"></i> Stock Repository
                    </a>
                    <a href="/reorder" class="btn-pill-ghost">
                        <i class="bi bi-bell-fill"></i> Reorder Alerts (${lowStockCount})
                    </a>
                    <c:if test="${not empty approvedProducts && approvedProducts.size() > 0}">
                        <a href="/inventory" class="btn-pill-ghost">
                            <i class="bi bi-box-arrow-in-down"></i> ${approvedProducts.size()} QA Batch(es) Ready
                        </a>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- ═════════════════════════════════════════════ -->
        <!--  4. 4 KPI BENTO CARDS (MINIMALIST B&W)        -->
        <!-- ═════════════════════════════════════════════ -->
        <div class="kpi-grid">
            <!-- 1: Total Parts -->
            <div class="kpi-card">
                <div>
                    <div class="kpi-card-header">
                        <div class="kpi-icon-box">
                            <i class="bi bi-box-seam"></i>
                        </div>
                        <span class="kpi-chip-label">Catalog</span>
                    </div>
                    <div class="kpi-lbl">Total Parts</div>
                    <div class="kpi-num">${totalItems}</div>
                </div>
                <div class="kpi-sub-text">
                    <i class="bi bi-check2-circle text-muted"></i> Unique spare parts cataloged
                </div>
            </div>

            <!-- 2: Units in Depot -->
            <div class="kpi-card">
                <div>
                    <div class="kpi-card-header">
                        <div class="kpi-icon-box">
                            <i class="bi bi-layers"></i>
                        </div>
                        <span class="kpi-chip-label">On-Shelf</span>
                    </div>
                    <div class="kpi-lbl">Units in Depot</div>
                    <div class="kpi-num">${totalStock}</div>
                </div>
                <div class="kpi-sub-text" title="Total on-shelf inventory units across warehouse storage racks">
                    <i class="bi bi-boxes text-muted"></i> Physical stock across all racks
                </div>
            </div>

            <!-- 3: Low Stock Alerts -->
            <div class="kpi-card">
                <div>
                    <div class="kpi-card-header">
                        <div class="kpi-icon-box" style="${lowStockCount > 0 ? 'color:var(--brand-red);' : ''}">
                            <i class="bi bi-${lowStockCount > 0 ? 'bell-fill' : 'shield-check'}"></i>
                        </div>
                        <span class="kpi-chip-label" style="${lowStockCount > 0 ? 'color:var(--brand-red);border-color:rgba(225,29,72,0.3);' : ''}">
                            ${lowStockCount > 0 ? 'Restock Needed' : 'Healthy'}
                        </span>
                    </div>
                    <div class="kpi-lbl">Low Stock Alerts</div>
                    <div class="kpi-num" style="${lowStockCount > 0 ? 'color:var(--brand-red);' : ''}">${lowStockCount}</div>
                </div>
                <div class="kpi-sub-text" style="${lowStockCount > 0 ? 'color:var(--brand-red);' : ''}">
                    <c:choose>
                        <c:when test="${lowStockCount > 0}">
                            <i class="bi bi-exclamation-circle-fill"></i> Requires replenishment
                        </c:when>
                        <c:otherwise>
                            <i class="bi bi-check-all text-muted"></i> All SKU thresholds satisfied
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- 4: Total Value -->
            <div class="kpi-card">
                <div>
                    <div class="kpi-card-header">
                        <div class="kpi-icon-box">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                        <span class="kpi-chip-label">Valuation</span>
                    </div>
                    <div class="kpi-lbl">Total Inventory Worth</div>
                    <div class="kpi-num" style="font-size:1.75rem;">
                        Rs.&nbsp;<fmt:formatNumber value="${totalValue}" pattern="#,##0"/>
                    </div>
                </div>
                <div class="kpi-sub-text">
                    <i class="bi bi-graph-up text-muted"></i> Combined asset valuation
                </div>
            </div>
        </div>

        <!-- ═════════════════════════════════════════════ -->
        <!--  5. BOTTOM PANELS                             -->
        <!-- ═════════════════════════════════════════════ -->
        <div class="row g-4">
            <!-- Panel 1: Storage Capacity -->
            <div class="col-lg-6">
                <div class="panel-bento-card">
                    <div class="panel-photo-header">
                        <img src="https://images.unsplash.com/photo-1553413077-190dd305871c?w=900&q=85&fit=crop" alt="Storage racks">
                        <div class="panel-photo-overlay"></div>
                        <div class="panel-photo-pill">
                            <i class="bi bi-archive me-1"></i>Storage Capacity
                        </div>
                    </div>
                    <div class="panel-card-body">
                        <div class="panel-title-text">Rack Utilization</div>
                        <div class="panel-hero-metric">${capacityPct}% <span>Total Used</span></div>

                        <!-- Rack A -->
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small fw-bold"><i class="bi bi-hdd-rack text-muted me-1"></i>Rack A</span>
                            <span class="small text-muted font-monospace">${rackA} / ${rackCapacity}</span>
                        </div>
                        <div class="rack-progress-track">
                            <div class="rack-progress-fill" style="width:${rackA * 100 / rackCapacity}%;background:${(rackA * 100 / rackCapacity) > 80 ? 'var(--brand-red)' : 'var(--txt)'};"></div>
                        </div>

                        <!-- Rack B -->
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small fw-bold"><i class="bi bi-hdd-rack text-muted me-1"></i>Rack B</span>
                            <span class="small text-muted font-monospace">${rackB} / ${rackCapacity}</span>
                        </div>
                        <div class="rack-progress-track">
                            <div class="rack-progress-fill" style="width:${rackB * 100 / rackCapacity}%;background:${(rackB * 100 / rackCapacity) > 80 ? 'var(--brand-red)' : 'var(--txt)'};"></div>
                        </div>

                        <!-- Rack C -->
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small fw-bold"><i class="bi bi-hdd-rack text-muted me-1"></i>Rack C</span>
                            <span class="small text-muted font-monospace">${rackC} / ${rackCapacity}</span>
                        </div>
                        <div class="rack-progress-track">
                            <div class="rack-progress-fill" style="width:${rackC * 100 / rackCapacity}%;background:${(rackC * 100 / rackCapacity) > 80 ? 'var(--brand-red)' : 'var(--txt)'};"></div>
                        </div>

                        <!-- Rack D -->
                        <div class="d-flex justify-content-between align-items-center mb-1">
                            <span class="small fw-bold"><i class="bi bi-hdd-rack text-muted me-1"></i>Rack D</span>
                            <span class="small text-muted font-monospace">${rackD} / ${rackCapacity}</span>
                        </div>
                        <div class="rack-progress-track">
                            <div class="rack-progress-fill" style="width:${rackD * 100 / rackCapacity}%;background:${(rackD * 100 / rackCapacity) > 80 ? 'var(--brand-red)' : 'var(--txt)'};"></div>
                        </div>

                        <div class="mt-auto pt-3 d-flex justify-content-between align-items-center border-top">
                            <span class="small text-muted"><i class="bi bi-archive me-1"></i>Racks A &middot; B &middot; C &middot; D Active</span>
                            <a href="/inventory" class="small fw-bold text-decoration-none" style="color:var(--txt);">View All Stock &rarr;</a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Panel 2: Quality Intake -->
            <div class="col-lg-6">
                <div class="panel-bento-card">
                    <div class="panel-photo-header">
                        <img src="https://images.unsplash.com/photo-1615906655593-ad0386982a0f?auto=format&fit=crop&w=800&q=85" alt="Quality inspection">
                        <div class="panel-photo-overlay"></div>
                        <div class="panel-photo-pill">
                            <i class="bi bi-shield-check me-1"></i>QC Verified
                        </div>
                    </div>
                    <div class="panel-card-body">
                        <div class="panel-title-text">Quality Intake Gate</div>
                        <div class="panel-hero-metric">
                            <c:choose>
                                <c:when test="${not empty approvedProducts}">
                                    <span style="font-size:2.1rem;font-weight:800;color:var(--txt);">${approvedProducts.size()} Batch(es) Ready</span>
                                </c:when>
                                <c:otherwise>All Clear</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="qc-status-box">
                            <div class="qc-status-icon">
                                <i class="bi bi-shield-check"></i>
                            </div>
                            <div>
                                <div class="small fw-bold" style="color:var(--txt);">Parts Quality Checked</div>
                                <div class="small text-muted">All incoming spare parts are inspected before storage</div>
                            </div>
                        </div>

                        <div class="qc-status-box">
                            <div class="qc-status-icon">
                                <i class="bi bi-box-arrow-in-down"></i>
                            </div>
                            <div style="flex:1;">
                                <div class="small fw-bold" style="color:var(--txt);">
                                    <c:choose>
                                        <c:when test="${not empty approvedProducts}">${approvedProducts.size()} batch(es) awaiting depot entry</c:when>
                                        <c:otherwise>No batches waiting — depot stock synchronized</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="small text-muted">Transmitted from Quality Inspection department</div>
                            </div>
                        </div>

                        <div class="mt-auto pt-3 d-flex justify-content-between align-items-center border-top">
                            <span class="small text-muted"><i class="bi bi-door-open me-1"></i>Inventory Intake Gate</span>
                            <a href="/inventory" class="btn-pill-dark" style="padding:0.45rem 1.15rem;font-size:0.8rem;">
                                <i class="bi bi-box-arrow-in-down"></i> Intake to Stock
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </main>

    <!-- ═════════════════════════════════════════════ -->
    <!--  MODAL: PROFILE UPDATE                        -->
    <!-- ═════════════════════════════════════════════ -->
    <div class="modal fade" id="accountModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered" style="max-width:440px;">
            <div class="modal-content" style="background:var(--modal-bg);border:1px solid var(--border);border-radius:var(--radius-md);">
                <div class="modal-header border-bottom" style="background:var(--card-subtle);border-radius:var(--radius-md) var(--radius-md) 0 0;">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-person-gear fs-4" style="color:var(--txt);"></i>
                        <div>
                            <h6 class="modal-title fw-bold mb-0" style="color:var(--txt);">My Account</h6>
                            <small class="text-muted">Update profile credentials &amp; password</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <form action="/account/update-profile" method="post" id="profileUpdateForm" autocomplete="off">
                        <input type="hidden" name="redirectUrl" value="/inventory/dashboard">

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Username</label>
                            <input type="text" class="form-control" value="${sessionScope.currentUser}" readonly style="background:var(--card-subtle);color:var(--txt);border-color:var(--border);">
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Full Name</label>
                            <input type="text" name="fullName" class="form-control" value="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.currentUser}" placeholder="Your full name" required style="background:var(--input-bg);color:var(--txt);border-color:var(--border);">
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Email Address</label>
                            <input type="email" name="email" class="form-control" value="${not empty sessionScope.email ? sessionScope.email : 'inventory@parttrack.com'}" placeholder="your@email.com" required style="background:var(--input-bg);color:var(--txt);border-color:var(--border);">
                        </div>

                        <hr class="my-3" style="border-color:var(--border);">
                        <p class="small text-muted mb-2"><i class="bi bi-lock me-1"></i>Change Password <span class="small">(leave blank to keep current)</span></p>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">New Password</label>
                            <div class="input-group">
                                <span class="input-group-text" style="background:var(--card-subtle);border-color:var(--border);color:var(--txt2);"><i class="bi bi-lock"></i></span>
                                <input type="password" name="newPassword" id="profileNewPass" class="form-control" placeholder="Min 4 characters" minlength="4" autocomplete="new-password" style="background:var(--input-bg);color:var(--txt);border-color:var(--border);">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassVisibility('profileNewPass','profilePassIcon')" style="border-color:var(--border);">
                                    <i class="bi bi-eye" id="profilePassIcon"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold text-muted">Confirm New Password</label>
                            <div class="input-group">
                                <span class="input-group-text" style="background:var(--card-subtle);border-color:var(--border);color:var(--txt2);"><i class="bi bi-shield-check"></i></span>
                                <input type="password" name="confirmNewPassword" id="profileConfirmPass" class="form-control" placeholder="Re-enter new password" autocomplete="new-password" style="background:var(--input-bg);color:var(--txt);border-color:var(--border);">
                            </div>
                            <span id="profilePassError" class="text-danger small fw-bold mt-1" style="display:none;"></span>
                        </div>

                        <div class="d-flex gap-2 mt-4">
                            <button type="button" class="btn btn-outline-secondary btn-sm flex-fill" data-bs-dismiss="modal" style="border-radius:9999px;">Cancel</button>
                            <button type="submit" class="btn-pill-dark flex-fill justify-content-center" onclick="return validateProfileForm()">
                                <i class="bi bi-check-circle-fill me-1"></i> Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        function openAccountModal() {
            new bootstrap.Modal(document.getElementById('accountModal')).show();
        }

        function togglePassVisibility(inputId, iconId) {
            var input = document.getElementById(inputId);
            var icon  = document.getElementById(iconId);
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }

        function validateProfileForm() {
            var newPass = document.getElementById('profileNewPass').value;
            var confPass = document.getElementById('profileConfirmPass').value;
            var err = document.getElementById('profilePassError');
            err.style.display = 'none';

            if (newPass.length > 0 && newPass.length < 4) {
                err.textContent = 'Password must be at least 4 characters.';
                err.style.display = 'block';
                return false;
            }
            if (newPass !== confPass) {
                err.textContent = 'Passwords do not match.';
                err.style.display = 'block';
                return false;
            }
            return true;
        }

        function toggleTheme() {
            var html = document.documentElement;
            var isDark = html.getAttribute('data-theme') === 'dark';
            var next = isDark ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            updateThemeIcons(next);
        }

        function updateThemeIcons(theme) {
            var icon = document.getElementById('themeSideIcon');
            if (icon) {
                icon.className = (theme === 'dark') ? 'bi bi-sun-fill text-warning' : 'bi bi-moon-stars-fill';
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            var cur = localStorage.getItem('theme') || 'light';
            updateThemeIcons(cur);
        });
    </script>
</body>
</html>
