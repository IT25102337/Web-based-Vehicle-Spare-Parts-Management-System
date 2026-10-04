<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stock Repository | AutoParts Depot</title>

    <script>
        (function(){
            var t = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', t);
        })();
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    
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

        /* SIDEBAR RAIL */
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

        /* MAIN CONTENT */
        .main-content {
            margin-left: 76px;
            padding: 2.25rem 3rem;
            width: calc(100% - 76px);
            min-height: 100vh;
            max-width: 1600px;
        }

        /* TOPBAR */
        .topbar-clean {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
            margin-bottom: 2rem;
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

        .search-pill-box {
            display: flex;
            align-items: center;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 9999px;
            padding: 0.45rem 1rem;
            width: 280px;
            transition: all 0.2s;
        }
        .search-pill-box:focus-within {
            border-color: var(--txt);
            box-shadow: 0 0 0 1px var(--txt);
        }
        .search-pill-box input {
            border: none;
            background: transparent;
            outline: none;
            font-size: 0.85rem;
            color: var(--txt);
            width: 100%;
            margin-left: 0.5rem;
        }

        /* BUTTONS */
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

        .btn-pill-outline {
            background: transparent;
            color: var(--txt) !important;
            border: 1px solid var(--border);
            border-radius: 9999px;
            padding: 0.55rem 1.35rem;
            font-size: 0.82rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-pill-outline:hover {
            border-color: var(--txt);
            background: var(--card-subtle);
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

        .btn-pill-red {
            background: var(--brand-red);
            color: #ffffff !important;
            border: 1px solid var(--brand-red);
            border-radius: 9999px;
            padding: 0.45rem 1.15rem;
            font-size: 0.8rem;
            font-weight: 700;
            letter-spacing: 0.02em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-pill-red:hover {
            background: var(--brand-red-hover);
            transform: translateY(-1px);
        }

        /* HERO - MINIMALIST AUTOMOTIVE HERO */
        .hero-ev {
            position: relative;
            height: 380px;
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 2.5rem;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 2.75rem 3rem;
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
            opacity: 0.65;
            transition: transform 0.5s ease;
        }
        .hero-ev:hover .hero-ev-bg { transform: scale(1.02); }
        .hero-ev-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(180deg, rgba(9,9,11,0.15) 0%, rgba(9,9,11,0.5) 45%, rgba(9,9,11,0.92) 100%);
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
            margin-bottom: 1.25rem;
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
            font-size: 2.4rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            text-transform: uppercase;
            line-height: 1.1;
            margin: 0 0 0.6rem 0;
            color: #ffffff;
        }
        .hero-ev-sub {
            font-size: 0.95rem;
            color: rgba(255, 255, 255, 0.82);
            margin: 0 0 1.5rem 0;
            max-width: 680px;
            font-weight: 400;
        }

        /* 3 BENTO CARDS TRIO */
        .section-headline-box {
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
            margin-bottom: 1.5rem;
            gap: 1.5rem;
            flex-wrap: wrap;
        }
        .section-title-huge {
            font-size: 1.65rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            text-transform: uppercase;
            line-height: 1.1;
            margin: 0;
            color: var(--txt);
        }
        .section-sub-clean {
            font-size: 0.88rem;
            color: var(--txt-muted);
            margin: 0;
            max-width: 520px;
        }

        .bento-card-clean {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-subtle);
            transition: all 0.25s ease;
            height: 100%;
            display: flex;
            flex-direction: column;
            padding: 1.75rem 1.85rem;
        }
        .bento-card-clean:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
            box-shadow: 0 12px 28px -6px rgba(0, 0, 0, 0.08);
        }
        .bento-card-header-clean {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.1rem;
        }
        .bento-icon-box {
            width: 44px;
            height: 44px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            background: var(--card-subtle);
            color: var(--txt);
            border: 1px solid var(--border);
        }
        .bento-tag {
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--txt-muted);
            padding: 0.25rem 0.65rem;
            border-radius: 9999px;
            background: var(--pill-bg);
            border: 1px solid var(--border);
        }
        .bento-card-title {
            font-size: 1.35rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            margin: 0 0 0.5rem 0;
            color: var(--txt);
            line-height: 1.2;
        }
        .bento-card-desc {
            font-size: 0.88rem;
            color: var(--txt2);
            line-height: 1.55;
            margin: 0 0 1.5rem 0;
            flex: 1;
        }

        /* TABLES */
        .table-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow-subtle);
            margin-bottom: 2.5rem;
            overflow: hidden;
        }
        .table-card-header {
            padding: 1.5rem 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            border-bottom: 1px solid var(--border);
            flex-wrap: wrap;
        }
        .table-card-title {
            font-size: 1.1rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            text-transform: uppercase;
            margin: 0;
            color: var(--txt);
            display: flex;
            align-items: center;
            gap: 0.65rem;
        }
        .table-card-sub {
            font-size: 0.82rem;
            color: var(--txt-muted);
            margin: 0.2rem 0 0 0;
        }

        .table-minimal {
            width: 100%;
            margin-bottom: 0;
            border-collapse: separate;
            border-spacing: 0;
        }
        .table-minimal th {
            background: var(--table-head);
            color: var(--txt-muted);
            font-size: 0.72rem;
            font-weight: 700;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            padding: 0.9rem 1.5rem;
            border-bottom: 1px solid var(--border);
            border-top: none;
            white-space: nowrap;
        }
        .table-minimal td {
            padding: 1.1rem 1.5rem;
            color: var(--txt);
            font-size: 0.88rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
            background: transparent;
            transition: background 0.15s;
        }
        .table-minimal tbody tr:last-child td {
            border-bottom: none;
        }
        .table-minimal tbody tr:hover td {
            background: var(--table-hover);
        }

        .sku-code {
            font-family: 'JetBrains Mono', monospace;
            font-weight: 600;
            font-size: 0.82rem;
            color: var(--txt);
            letter-spacing: 0.02em;
        }

        .tag-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
            background: var(--pill-bg);
            color: var(--txt);
            border: 1px solid var(--border);
        }

        .badge-stock-ok {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(16, 185, 129, 0.1);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.25);
        }

        .badge-stock-low {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(225, 29, 72, 0.1);
            color: var(--brand-red);
            border: 1px solid rgba(225, 29, 72, 0.25);
        }

        .btn-icon-action {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--txt2);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .btn-icon-action:hover {
            border-color: var(--txt);
            color: var(--txt);
            transform: scale(1.04);
        }
        .btn-icon-action.danger:hover {
            border-color: var(--brand-red);
            color: var(--brand-red);
            background: rgba(225, 29, 72, 0.08);
        }

        /* MODALS */
        .modal-content {
            border-radius: var(--radius-lg);
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--txt);
            box-shadow: var(--shadow-modal);
            overflow: hidden;
        }
        .modal-header {
            padding: 1.25rem 1.75rem;
            border-bottom: 1px solid var(--border);
            background: var(--card);
        }
        .modal-body { padding: 1.75rem; }
        .modal-footer {
            padding: 1.25rem 1.75rem;
            border-top: 1px solid var(--border);
            background: var(--card);
        }
        .form-control, .form-select {
            background-color: var(--card);
            color: var(--txt);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 0.55rem 0.85rem;
            font-size: 0.88rem;
        }
        .form-control:focus, .form-select:focus {
            background-color: var(--card);
            color: var(--txt);
            border-color: var(--txt);
            box-shadow: 0 0 0 1px var(--txt);
        }
        .form-label {
            font-size: 0.78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--txt-muted);
            margin-bottom: 0.4rem;
        }
        .info-panel {
            background: var(--card-subtle);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1rem 1.25rem;
        }
    </style>
</head>
<body>

    <!-- 1. SIDEBAR RAIL -->
    <aside class="sidebar-rail">
        <!-- Upper Account Details Changes -->
        <a href="javascript:void(0)" onclick="openAccountModal()" class="brand-logo-icon" title="My Account & Profile Details">
            <i class="bi bi-person-circle"></i>
        </a>

        <!-- 4 Depot Interfaces Navigation -->
        <ul class="sidebar-nav">
            <!-- 1. Depot Dashboard -->
            <li>
                <a href="/inventory/dashboard" class="sidebar-icon-link" title="Depot Dashboard">
                    <i class="bi bi-speedometer2"></i>
                </a>
            </li>
            <!-- 2. Stock Repository (Active) -->
            <li>
                <a href="/inventory" class="sidebar-icon-link active" title="Stock Repository">
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

    <!-- 2. MAIN CONTENT -->
    <main class="main-content">

        <!-- Topbar -->
        <div class="topbar-clean">
            <div>
                <h1 class="topbar-title">STOCK REPOSITORY</h1>
                <p class="topbar-sub">Central inventory stock &amp; shelf storage</p>
            </div>

            <div class="d-flex align-items-center gap-2">
                <div class="search-pill-box">
                    <i class="bi bi-search text-muted"></i>
                    <input type="text" id="searchInput" placeholder="Search SKU, name, rack..." onkeyup="searchTable()">
                </div>

                <c:choose>
                    <c:when test="${not empty approvedProducts}">
                        <button class="btn-pill-dark" data-bs-toggle="modal" data-bs-target="#intakeModal">
                            <i class="bi bi-plus-lg"></i> Intake Part
                        </button>
                    </c:when>
                    <c:otherwise>
                        <button class="btn-pill-outline" onclick="showNoApprovedAlert()">
                            <i class="bi bi-lock-fill text-muted"></i> Intake Part
                        </button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <!-- HERO BANNER: EV AUTOMOTIVE MINIMALIST STYLE -->
        <div class="hero-ev">
            <img src="/images/car_top_down.jpg" alt="EV Chassis &amp; Powertrain Depot" class="hero-ev-bg" id="inventoryHeroImg">
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
                        <span class="hero-metric-lbl">Total Asset Valuation</span>
                    </div>
                    <c:if test="${lowStockCount > 0}">
                        <div class="hero-metric-item">
                            <span class="hero-metric-num" style="color:#f87171;">${lowStockCount}</span>
                            <span class="hero-metric-lbl" style="color:#fca5a5;">Low Stock Alerts</span>
                        </div>
                    </c:if>
                </div>

                <h1 class="hero-ev-title">ONE PLATFORM. COMPLETE DEPOT CONTROL.</h1>
                <p class="hero-ev-sub">Precision spare parts repository, automated shelf capacity tracking, and quality control receiving pipeline.</p>

                <div class="d-flex align-items-center gap-2 flex-wrap">
                    <c:choose>
                        <c:when test="${not empty approvedProducts}">
                            <button class="btn-pill-white" data-bs-toggle="modal" data-bs-target="#intakeModal">
                                <i class="bi bi-plus-circle-fill"></i> Intake Shipment
                            </button>
                        </c:when>
                        <c:otherwise>
                            <button class="btn-pill-ghost" onclick="showNoApprovedAlert()">
                                <i class="bi bi-lock-fill"></i> Intake Shipment
                            </button>
                        </c:otherwise>
                    </c:choose>

                    <a href="/reorder" class="btn-pill-ghost">
                        <i class="bi bi-bell-fill"></i> Reorder Alerts (${lowStockCount})
                    </a>
                </div>
            </div>
        </div>

        <!-- Flash Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 rounded-4 mb-4 py-2 px-3 border" role="alert">
                <i class="bi bi-check-circle-fill text-success fs-5"></i>
                <div class="small fw-semibold text-success">${successMessage}</div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage || not empty sessionScope.sessionErrorMessage}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 rounded-4 mb-4 py-2 px-3 border" role="alert">
                <i class="bi bi-exclamation-triangle-fill text-danger fs-5"></i>
                <div class="small fw-semibold text-danger">${not empty errorMessage ? errorMessage : sessionScope.sessionErrorMessage}</div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="sessionErrorMessage" scope="session"/>
        </c:if>

        <!-- 3 BENTO CARDS (EV TRIO) -->
        <div class="section-headline-box">
            <div>
                <h2 class="section-title-huge">PRECISION INVENTORY ECOSYSTEM</h2>
                <p class="section-sub-clean">Engineered for seamless inventory flow, real-time rack telemetry, and rapid dispatch.</p>
            </div>
        </div>

        <div class="row g-4 mb-4">
            <!-- Card 1: Active Models -->
            <div class="col-lg-4">
                <div class="bento-card-clean">
                    <div class="bento-card-header-clean">
                        <div class="bento-icon-box">
                            <i class="bi bi-box-seam"></i>
                        </div>
                        <span class="bento-tag">REPOSITORY</span>
                    </div>
                    <h3 class="bento-card-title">${totalItems} Active Part Models</h3>
                    <p class="bento-card-desc">Comprehensive mechanical components and automotive assemblies with live pricing.</p>
                    <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-auto">
                        <span class="small text-muted fw-bold">VALUATION</span>
                        <span class="small fw-bold">Rs. <fmt:formatNumber value="${totalValue}" pattern="#,##0"/></span>
                    </div>
                </div>
            </div>

            <!-- Card 2: Shelf Occupancy -->
            <div class="col-lg-4">
                <div class="bento-card-clean">
                    <div class="bento-card-header-clean">
                        <div class="bento-icon-box">
                            <i class="bi bi-hdd-rack"></i>
                        </div>
                        <span class="bento-tag">SHELF OCCUPANCY</span>
                    </div>
                    <h3 class="bento-card-title">${totalStock} of ${maxCapacity} Units</h3>
                    <p class="bento-card-desc">Dynamic 4-rack storage capacity with automated threshold alerts and space optimization.</p>
                    <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-auto">
                        <span class="small text-muted fw-bold">DEPOT CAPACITY</span>
                        <span class="small fw-bold">${capacityPct}% UTILIZED</span>
                    </div>
                </div>
            </div>

            <!-- Card 3: Quality Gate -->
            <div class="col-lg-4">
                <div class="bento-card-clean">
                    <div class="bento-card-header-clean">
                        <div class="bento-icon-box">
                            <i class="bi bi-shield-check"></i>
                        </div>
                        <span class="bento-tag">DISPATCH &amp; REORDER</span>
                    </div>
                    <h3 class="bento-card-title">${lowStockCount} Safety Alerts</h3>
                    <p class="bento-card-desc">Instant replenishment requests dispatched directly to Quality Inspection teams.</p>
                    <div class="d-flex justify-content-between align-items-center pt-3 border-top mt-auto">
                        <a href="/reorder" class="small fw-bold text-decoration-none" style="color:var(--brand-red);">Open Reorder Center &rarr;</a>
                        <span class="tag-pill">${approvedProducts != null ? approvedProducts.size() : 0} QA Ready</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- TABLE 1: QUALITY GATE (IF APPROVED PRODUCTS EXIST) -->
        <c:if test="${not empty approvedProducts}">
            <div class="table-card">
                <div class="table-card-header">
                    <div>
                        <h3 class="table-card-title">
                            <i class="bi bi-patch-check-fill text-success"></i> APPROVED SHIPMENTS WAITING FOR INTAKE
                        </h3>
                        <p class="table-card-sub">Inspected supplier batches ready for shelf rack assignment</p>
                    </div>
                    <span class="tag-pill">${approvedProducts.size()} Batches in Queue</span>
                </div>

                <div class="table-responsive">
                    <table class="table-minimal">
                        <thead>
                            <tr>
                                <th style="width: 110px;">Batch ID</th>
                                <th style="width: 140px;">Part SKU</th>
                                <th>Part Description</th>
                                <th>Supplier</th>
                                <th class="text-center" style="width: 140px;">Approved Units</th>
                                <th class="text-end" style="width: 140px;">Supplier Cost</th>
                                <th class="text-center" style="width: 160px;">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="prod" items="${approvedProducts}">
                                <tr>
                                    <td><span class="tag-pill">#${prod.batchId}</span></td>
                                    <td><span class="sku-code">${prod.partId}</span></td>
                                    <td class="fw-bold">${prod.partName}</td>
                                    <td class="text-muted"><i class="bi bi-building me-1"></i>${prod.supplierName}</td>
                                    <td class="text-center">
                                        <span class="badge-stock-ok">${prod.availableQty} Units</span>
                                    </td>
                                    <td class="text-end font-monospace">
                                        Rs. <fmt:formatNumber value="${prod.supplierPrice}" pattern="#,##0.00"/>
                                    </td>
                                    <td class="text-center">
                                        <button class="btn-pill-red btn-sm"
                                                onclick="openIntakeForBatch('${prod.batchId}', '${prod.partId}', '${prod.partName}', ${prod.availableQty}, ${prod.supplierPrice})">
                                            <i class="bi bi-box-arrow-in-down"></i> Add to Stock
                                        </button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>

        <!-- TABLE 2: CURRENT STOCK REPOSITORY -->
        <div class="table-card">
            <div class="table-card-header">
                <div>
                    <h3 class="table-card-title">
                        <i class="bi bi-layers-fill"></i> CURRENT STOCK REPOSITORY
                    </h3>
                    <p class="table-card-sub">${totalItems} cataloged items across Depot racks</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="tag-pill">
                        Occupancy: <strong style="color:var(--txt); margin-left:4px;">${totalStock}</strong>&nbsp;/ ${maxCapacity} Units
                    </span>
                    <a href="/reorder" class="btn-pill-outline btn-sm">
                        <i class="bi bi-bell text-danger"></i> Reorder Alerts
                        <c:if test="${lowStockCount > 0}">
                            <span class="badge bg-danger rounded-pill ms-1">${lowStockCount}</span>
                        </c:if>
                    </a>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table-minimal" id="inventoryTable">
                    <thead>
                        <tr>
                            <th style="width: 140px;">Part ID</th>
                            <th>Part Description</th>
                            <th style="width: 150px;">Location</th>
                            <th class="text-center" style="width: 140px;">Depot Stock</th>
                            <th class="text-center" style="width: 140px;">Reorder Level</th>
                            <th class="text-end" style="width: 140px;">Unit Price</th>
                            <th class="text-end" style="width: 150px;">Valuation</th>
                            <th class="text-center" style="width: 170px;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty inventoryList && empty itemList}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        <div class="fw-bold" style="color:var(--txt);">No Spare Parts Cataloged</div>
                                        <small>Intake verified batches from the Quality Gate above.</small>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${not empty inventoryList ? inventoryList : itemList}">
                                    <tr class="part-row">
                                        <td><span class="sku-code">${item.partId}</span></td>
                                        <td><div class="fw-bold">${item.partName}</div></td>
                                        <td>
                                            <span class="tag-pill">
                                                <i class="bi bi-geo-alt text-danger"></i> ${item.storageLocation}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <span class="${item.quantity <= item.reorderLevel ? 'badge-stock-low' : 'badge-stock-ok'}">
                                                ${item.quantity} Units
                                            </span>
                                        </td>
                                        <td class="text-center text-muted">
                                            Min ${item.reorderLevel} Units
                                        </td>
                                        <td class="text-end font-monospace">
                                            Rs. <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/>
                                        </td>
                                        <td class="text-end font-monospace fw-bold">
                                            Rs. <fmt:formatNumber value="${item.totalValue}" pattern="#,##0.00"/>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-inline-flex gap-1">
                                                <!-- Restock Request -->
                                                <button class="btn-icon-action" title="Request Restock"
                                                        onclick="openRequestModal('${item.partId}', '${item.partName}', ${item.quantity}, ${item.reorderLevel})">
                                                    <i class="bi bi-send-fill text-primary"></i>
                                                </button>
                                                <!-- Dispatch Stock -->
                                                <button class="btn-icon-action" title="Dispatch / Outbound Stock"
                                                        onclick="openStockModal('${item.partId}', '${item.partName}', ${item.quantity})">
                                                    <i class="bi bi-box-arrow-up-right text-warning"></i>
                                                </button>
                                                <!-- Edit Part -->
                                                <button class="btn-icon-action" title="Edit Part Details"
                                                        onclick="openEditModal('${item.partId}', '${item.partName}', ${item.reorderLevel}, ${item.unitPrice}, '${item.storageLocation}')">
                                                    <i class="bi bi-pencil-square text-info"></i>
                                                </button>
                                                <!-- Delete Part -->
                                                <button class="btn-icon-action danger" title="Delete Part"
                                                        onclick="openDeleteModal('${item.partId}', '${item.partName}')">
                                                    <i class="bi bi-trash-fill text-danger"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <!-- MODAL 1: INTAKE FROM QA -->
    <div class="modal fade" id="intakeModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="/inventory/intake" method="post">
                    <div class="modal-header">
                        <div class="d-flex align-items-center gap-2">
                            <span class="tag-pill">INVENTORY INTAKE</span>
                            <h6 class="modal-title mb-0">Accept Approved Shipment</h6>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Select Approved Batch *</label>
                            <select name="batchId" id="intakeBatchSelect" class="form-select" onchange="onBatchSelected(this)" required>
                                <option value="">-- Choose an inspected shipment batch --</option>
                                <c:forEach var="ap" items="${approvedProducts}">
                                    <option value="${ap.batchId}"
                                            data-partid="${ap.partId}"
                                            data-partname="${ap.partName}"
                                            data-available="${ap.availableQty}"
                                            data-cost="${ap.supplierPrice}">
                                        Batch #${ap.batchId} - ${ap.partName} (${ap.availableQty} units available)
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="row g-2 mb-3 info-panel">
                            <div class="col-6">
                                <label class="form-label mb-0" style="font-size:0.75rem;">Part ID</label>
                                <input type="text" name="partId" id="intakePartId" class="form-control form-control-sm font-monospace" readonly required>
                            </div>
                            <div class="col-6">
                                <label class="form-label mb-0" style="font-size:0.75rem;">Approved Available</label>
                                <div class="fw-bold text-success mt-1" id="intakeAvailableBadge">0 Units</div>
                            </div>
                            <div class="col-12 mt-2">
                                <label class="form-label mb-0" style="font-size:0.75rem;">Part Name</label>
                                <input type="text" name="partName" id="intakePartName" class="form-control form-control-sm" readonly required>
                            </div>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label">Intake Quantity *</label>
                                <input type="number" name="quantity" id="intakeQty" class="form-control form-control-sm" min="1" max="${availableSpace}" placeholder="e.g. 5" required>
                                <div class="form-text small" style="font-size: 0.72rem; color:var(--txt-muted);">Available Space: ${availableSpace} units</div>
                            </div>
                            <div class="col-6">
                                <label class="form-label">Reorder Level *</label>
                                <input type="number" name="reorderLevel" class="form-control form-control-sm" min="0" value="5" required>
                            </div>
                        </div>

                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label">Supplier Cost (Rs.)</label>
                                <input type="text" id="intakeSupplierCost" class="form-control form-control-sm font-monospace" readonly value="Rs. 0.00">
                            </div>
                            <div class="col-6">
                                <label class="form-label">Selling Price (Rs.) *</label>
                                <input type="number" step="0.01" name="unitPrice" id="intakePrice" class="form-control form-control-sm font-monospace" min="0" placeholder="1500.00" required>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">Shelf / Rack Location *</label>
                            <select name="storageLocation" id="intakeStorageLocation" class="form-select form-select-sm" required>
                                <option value="Rack A" ${rackA < rackCapacity ? '' : 'disabled'}>Rack A (${rackA} / ${rackCapacity})</option>
                                <option value="Rack B" ${rackB < rackCapacity ? '' : 'disabled'}>Rack B (${rackB} / ${rackCapacity})</option>
                                <option value="Rack C" ${rackC < rackCapacity ? '' : 'disabled'}>Rack C (${rackC} / ${rackCapacity})</option>
                                <option value="Rack D" ${rackD < rackCapacity ? '' : 'disabled'}>Rack D (${rackD} / ${rackCapacity})</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-pill-dark btn-sm">Accept into Stock</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL 2: RESTOCK REQUEST -->
    <div class="modal fade" id="requestModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-sm" style="max-width: 440px;">
            <div class="modal-content">
                <form action="/reorder/request" method="post">
                    <input type="hidden" name="source" value="inventory">
                    <input type="hidden" name="partId" id="reqPartId">
                    <input type="hidden" name="partName" id="reqPartName">
                    <input type="hidden" name="currentQuantity" id="reqCurrentQty">

                    <div class="modal-header">
                        <div class="d-flex align-items-center gap-2">
                            <span class="tag-pill">RESTOCK TRIGGER</span>
                            <h6 class="modal-title mb-0">Send Restock Request</h6>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3 info-panel">
                            <span class="fw-bold" id="reqPartDisplay" style="color:var(--txt);"></span>
                            <div class="small mt-1 text-muted" id="reqCurrentDisplay"></div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Requested Quantity *</label>
                            <input type="number" name="requestedQuantity" id="reqQuantityInput" class="form-control form-control-sm" min="1" required>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">Urgency Note / Message</label>
                            <input type="text" name="requestMessage" class="form-control form-control-sm" value="Stock running low in depot, please supply.">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-pill-dark btn-sm">
                            <i class="bi bi-send-fill me-1"></i> Transmit Request
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL 3: DISPATCH STOCK -->
    <div class="modal fade" id="stockModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-sm" style="max-width: 420px;">
            <div class="modal-content">
                <form action="/reorder/dispatch" method="post">
                    <input type="hidden" name="action" value="sub">
                    <input type="hidden" name="source" value="inventory">
                    <input type="hidden" name="partId" id="stockPartId">
                    <div class="modal-header">
                        <div class="d-flex align-items-center gap-2">
                            <span class="tag-pill">OUTBOUND</span>
                            <h6 class="modal-title mb-0">Dispatch Stock</h6>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3 info-panel">
                            <span class="fw-bold small" id="stockPartNameDisplay" style="color:var(--txt);"></span>
                            <div class="small mt-1 text-muted" id="stockPartCurrentDisplay"></div>
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Quantity to Dispatch *</label>
                            <input type="number" name="quantity" id="dispatchQtyInput" class="form-control form-control-sm" min="1" placeholder="e.g. 5" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-pill-dark btn-sm">
                            <i class="bi bi-box-arrow-up-right me-1"></i> Confirm Dispatch
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL 4: EDIT PART -->
    <div class="modal fade" id="editPartModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="/edit" method="post">
                    <input type="hidden" name="partId" id="editPartId">
                    <div class="modal-header">
                        <h6 class="modal-title mb-0">Edit Part Details</h6>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="mb-3">
                            <label class="form-label">Part SKU</label>
                            <input type="text" id="editPartIdDisplay" class="form-control form-control-sm font-monospace" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Part Description *</label>
                            <input type="text" name="partName" id="editPartName" class="form-control form-control-sm" required>
                        </div>
                        <div class="row g-2 mb-3">
                            <div class="col-6">
                                <label class="form-label">Reorder Level *</label>
                                <input type="number" name="reorderLevel" id="editReorderLevel" class="form-control form-control-sm" min="0" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label">Unit Price (Rs.) *</label>
                                <input type="number" step="0.01" name="unitPrice" id="editUnitPrice" class="form-control form-control-sm font-monospace" min="0" required>
                            </div>
                        </div>
                        <div class="mb-2">
                            <label class="form-label">Shelf / Rack Location *</label>
                            <select name="storageLocation" id="editStorageLocation" class="form-select form-select-sm" required>
                                <option value="Rack A">Rack A</option>
                                <option value="Rack B">Rack B</option>
                                <option value="Rack C">Rack C</option>
                                <option value="Rack D">Rack D</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-pill-dark btn-sm">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL 5: DELETE PART -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content">
                <form action="/delete" method="post">
                    <input type="hidden" name="partId" id="deletePartId">
                    <div class="modal-body text-center p-4">
                        <i class="bi bi-trash text-danger fs-1 d-block mb-2"></i>
                        <h6 class="fw-bold mb-1" style="color:var(--txt);">Delete Spare Part?</h6>
                        <p class="small text-muted mb-0">
                            Remove <strong id="deletePartDisplay"></strong> from repository?
                        </p>
                    </div>
                    <div class="modal-footer justify-content-center">
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-sm btn-danger px-3 rounded-pill">Confirm Delete</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL 6: LOCKED ALERT -->
    <div class="modal fade" id="lockedAddModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-sm">
            <div class="modal-content text-center p-3">
                <div class="modal-body">
                    <i class="bi bi-shield-lock-fill text-muted fs-1 d-block mb-2"></i>
                    <h6 class="fw-bold mb-1" style="color:var(--txt);">No QC-Approved Parts</h6>
                    <p class="small text-muted mb-0">
                        Intake requires shipments to first be verified and approved by Quality Control.
                    </p>
                </div>
                <div class="modal-footer justify-content-center border-0 pt-0">
                    <button type="button" class="btn-pill-dark btn-sm" data-bs-dismiss="modal">Understood</button>
                </div>
            </div>
        </div>
    </div>

    <!-- MY ACCOUNT MODAL -->
    <div class="modal fade" id="accountModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered" style="max-width:440px;">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="d-flex align-items-center gap-2">
                        <div style="width:36px;height:36px;border-radius:10px;background:var(--brand-dark);color:#ffffff;display:flex;align-items:center;justify-content:center;font-size:1.1rem;">
                            <i class="bi bi-person-circle"></i>
                        </div>
                        <h6 class="modal-title mb-0">My Account Profile</h6>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <form action="/account/update-profile" method="post" id="profileUpdateForm" autocomplete="off">
                        <input type="hidden" name="redirectUrl" value="/inventory">

                        <div class="mb-3">
                            <label class="form-label">Full Name</label>
                            <input type="text" name="fullName" class="form-control form-control-sm"
                                   value="${sessionScope.userFullName != null ? sessionScope.userFullName : 'Inventory Manager'}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Email Address</label>
                            <input type="email" name="email" class="form-control form-control-sm"
                                   value="${sessionScope.userEmail != null ? sessionScope.userEmail : 'inventory@parttrack.com'}" required>
                        </div>

                        <hr class="my-3" style="border-color:var(--border);">
                        <div class="small fw-bold text-muted mb-2">CHANGE PASSWORD (OPTIONAL)</div>

                        <div class="mb-2">
                            <label class="form-label">New Password</label>
                            <div class="input-group input-group-sm">
                                <input type="password" name="newPassword" id="profileNewPass" class="form-control" placeholder="Leave blank to keep current">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassVisibility('profileNewPass','eyeIcon1')">
                                    <i class="bi bi-eye" id="eyeIcon1"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">Confirm New Password</label>
                            <div class="input-group input-group-sm">
                                <input type="password" id="profileConfirmPass" class="form-control" placeholder="Repeat new password">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassVisibility('profileConfirmPass','eyeIcon2')">
                                    <i class="bi bi-eye" id="eyeIcon2"></i>
                                </button>
                            </div>
                            <div id="profilePassError" class="text-danger small mt-1" style="display:none;"></div>
                        </div>

                        <div class="d-flex gap-2 mt-4">
                            <button type="button" class="btn btn-sm btn-outline-secondary flex-fill" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn-pill-dark flex-fill justify-content-center" onclick="return validateProfileForm()">
                                Save Changes
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- SCRIPTS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function searchTable() {
            let filter = document.getElementById("searchInput").value.toLowerCase();
            let rows = document.querySelectorAll(".part-row");

            for (let i = 0; i < rows.length; i++) {
                let rowText = rows[i].innerText.toLowerCase();
                rows[i].style.display = rowText.includes(filter) ? "" : "none";
            }
        }

        function openRequestModal(partId, partName, currentQty, reorderLevel) {
            document.getElementById("reqPartId").value = partId;
            document.getElementById("reqPartName").value = partName;
            document.getElementById("reqCurrentQty").value = currentQty;

            document.getElementById("reqPartDisplay").textContent = partName + " (" + partId + ")";
            document.getElementById("reqCurrentDisplay").textContent = currentQty + " in stock";

            var recommended = Math.max(10, (reorderLevel * 2) - currentQty);
            document.getElementById("reqQuantityInput").value = recommended;

            new bootstrap.Modal(document.getElementById("requestModal")).show();
        }

        function openStockModal(partId, partName, currentQty) {
            if (currentQty === "add") {
                openRequestModal(partId, partName, 0, 5);
                return;
            }
            document.getElementById("stockPartId").value = partId;
            document.getElementById("stockPartNameDisplay").textContent = partName + " (" + partId + ")";
            let stockDisp = document.getElementById("stockPartCurrentDisplay");
            let qtyInput = document.getElementById("dispatchQtyInput");
            if (currentQty !== undefined && currentQty !== null && !isNaN(currentQty)) {
                if (stockDisp) stockDisp.textContent = "Current Depot Stock: " + currentQty + " Units";
                if (qtyInput) {
                    qtyInput.max = currentQty > 0 ? currentQty : 1;
                    qtyInput.value = "";
                }
            } else {
                if (stockDisp) stockDisp.textContent = "";
            }
            new bootstrap.Modal(document.getElementById("stockModal")).show();
        }

        function openEditModal(partId, partName, reorderLevel, unitPrice, storageLocation) {
            document.getElementById("editPartId").value = partId;
            document.getElementById("editPartIdDisplay").value = partId;
            document.getElementById("editPartName").value = partName;
            document.getElementById("editReorderLevel").value = reorderLevel;
            document.getElementById("editUnitPrice").value = unitPrice;
            
            var loc = storageLocation ? storageLocation.toUpperCase() : "RACK A";
            var normalizedLoc = "Rack A";
            if (loc.includes("B")) normalizedLoc = "Rack B";
            else if (loc.includes("C")) normalizedLoc = "Rack C";
            else if (loc.includes("D")) normalizedLoc = "Rack D";
            document.getElementById("editStorageLocation").value = normalizedLoc;

            new bootstrap.Modal(document.getElementById("editPartModal")).show();
        }

        function openDeleteModal(partId, partName) {
            document.getElementById("deletePartId").value = partId;
            document.getElementById("deletePartDisplay").textContent = partName + " (" + partId + ")";
            new bootstrap.Modal(document.getElementById("deleteModal")).show();
        }

        function onBatchSelected(selectEl) {
            let selectedOpt = selectEl.options[selectEl.selectedIndex];
            if (!selectedOpt || !selectedOpt.value) return;

            let partId = selectedOpt.getAttribute("data-partid");
            let partName = selectedOpt.getAttribute("data-partname");
            let available = selectedOpt.getAttribute("data-available");
            let cost = parseFloat(selectedOpt.getAttribute("data-cost")) || 0;

            document.getElementById("intakePartId").value = partId;
            document.getElementById("intakePartName").value = partName;
            document.getElementById("intakeAvailableBadge").textContent = available + " Units";
            document.getElementById("intakeQty").value = available;
            document.getElementById("intakeQty").max = available;

            let costEl = document.getElementById("intakeSupplierCost");
            if (costEl) costEl.value = "Rs. " + cost.toFixed(2);

            let suggestedPrice = cost > 0 ? (cost * 1.25).toFixed(2) : "1500.00";
            document.getElementById("intakePrice").value = suggestedPrice;

            let partRackMap = {
                <c:forEach var="item" items="${itemList}" varStatus="status">
                    "${item.partId}": "${item.storageLocation}"<c:if test="${!status.last}">,</c:if>
                </c:forEach>
            };
            if (partRackMap[partId]) {
                let existingRack = partRackMap[partId].toUpperCase();
                let rackSel = document.getElementById("intakeStorageLocation");
                if (rackSel) {
                    for (let i = 0; i < rackSel.options.length; i++) {
                        let optVal = rackSel.options[i].value.toUpperCase();
                        if (existingRack.indexOf(optVal) !== -1 || optVal.indexOf(existingRack) !== -1) {
                            rackSel.selectedIndex = i;
                            break;
                        }
                    }
                }
            }
        }

        function openIntakeForBatch(batchId, partId, partName, availableQty, cost) {
            let selectEl = document.getElementById("intakeBatchSelect");
            if (selectEl) {
                selectEl.value = batchId;
                onBatchSelected(selectEl);
            }
            let costEl = document.getElementById("intakeSupplierCost");
            if (costEl && cost) {
                let costVal = parseFloat(cost) || 0;
                costEl.value = "Rs. " + costVal.toFixed(2);
            }
            new bootstrap.Modal(document.getElementById("intakeModal")).show();
        }

        function showNoApprovedAlert() {
            new bootstrap.Modal(document.getElementById("lockedAddModal")).show();
        }

        function openAccountModal() {
            new bootstrap.Modal(document.getElementById("accountModal")).show();
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
            const html = document.documentElement;
            const isDark = html.getAttribute('data-theme') === 'dark';
            const next = isDark ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            const si = document.getElementById('themeSideIcon');
            if (si) si.className = next === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
            const heroImg = document.getElementById('inventoryHeroImg');
            if (heroImg) heroImg.src = next === 'dark' ? '/images/car_top_down_dark.jpg' : '/images/car_top_down.jpg';
        }

        (function() {
            const cur = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', cur);
            window.addEventListener('DOMContentLoaded', function() {
                const si = document.getElementById('themeSideIcon');
                if (si) si.className = cur === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
                const heroImg = document.getElementById('inventoryHeroImg');
                if (heroImg) heroImg.src = cur === 'dark' ? '/images/car_top_down_dark.jpg' : '/images/car_top_down.jpg';
            });
        })();
    </script>
</body>
</html>