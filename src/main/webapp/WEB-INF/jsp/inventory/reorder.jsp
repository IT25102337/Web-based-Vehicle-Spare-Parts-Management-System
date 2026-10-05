<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reorder Center | AutoParts Depot</title>

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
            object-position: center 35%;
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
        }
        .bento-card-clean:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }
        .bento-card-media {
            height: 180px;
            position: relative;
            overflow: hidden;
            background: #09090b;
        }
        .bento-card-media img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.4s ease;
        }
        .bento-card-clean:hover .bento-card-media img {
            transform: scale(1.04);
        }
        .bento-card-body {
            padding: 1.5rem;
            display: flex;
            flex-direction: column;
            flex: 1;
        }
        .bento-tag {
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--txt-muted);
            margin-bottom: 0.35rem;
        }
        .bento-card-title {
            font-size: 1.1rem;
            font-weight: 700;
            margin: 0 0 0.5rem 0;
            color: var(--txt);
        }
        .bento-card-desc {
            font-size: 0.85rem;
            color: var(--txt2);
            margin: 0 0 1.25rem 0;
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

        .badge-stock-danger {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(225, 29, 72, 0.12);
            color: var(--brand-red);
            border: 1px solid rgba(225, 29, 72, 0.25);
        }

        .badge-stock-warning {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(245, 158, 11, 0.12);
            color: #d97706;
            border: 1px solid rgba(245, 158, 11, 0.25);
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
            <!-- 2. Stock Repository -->
            <li>
                <a href="/inventory" class="sidebar-icon-link" title="Stock Repository">
                    <i class="bi bi-layers-fill"></i>
                </a>
            </li>
            <!-- 3. Reorder Alerts (Active) -->
            <li>
                <a href="/reorder" class="sidebar-icon-link active" title="Reorder Center">
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
                <h1 class="topbar-title">REORDER &amp; REPLENISHMENT PIPELINE</h1>
                <p class="topbar-sub">Safety stock threshold detection &amp; procurement triggers</p>
            </div>

            <div class="d-flex align-items-center gap-2">
                <a href="/inventory" class="btn-pill-dark">
                    <i class="bi bi-layers-fill"></i> Stock Repository
                </a>
            </div>
        </div>

        <!-- HERO BANNER: EV AUTOMOTIVE MINIMALIST STYLE -->
        <div class="hero-ev">
            <img src="/images/industrial_gears.jpg" alt="Replenishment Pipeline" class="hero-ev-bg">
            <div class="hero-ev-overlay"></div>
            <div class="hero-ev-content">
                <div class="hero-metrics-strip">
                    <div class="hero-metric-item">
                        <span class="hero-metric-num" style="color:${not empty reorderList && reorderList.size() > 0 ? '#f87171' : '#4ade80'};">
                            ${reorderList != null ? reorderList.size() : 0}
                        </span>
                        <span class="hero-metric-lbl">Low Stock Alerts</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${pendingRequests != null ? pendingRequests.size() : 0}</span>
                        <span class="hero-metric-lbl">In Procurement Queue</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">DIRECT</span>
                        <span class="hero-metric-lbl">QA Inspection Link</span>
                    </div>
                </div>

                <h1 class="hero-ev-title">SAFETY THRESHOLDS. AUTOMATED REPLENISHMENT.</h1>
                <p class="hero-ev-sub">Deficit alerts transmit directly into the Spare Part Department queue for verified supplier fulfillment.</p>

                <div class="d-flex align-items-center gap-2 flex-wrap">
                    <a href="/inventory" class="btn-pill-white">
                        <i class="bi bi-arrow-left"></i> Back to Repository
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


        <!-- TABLE 1: LOW STOCK ALERTS -->
        <div class="table-card">
            <div class="table-card-header">
                <div>
                    <h3 class="table-card-title">
                        <i class="bi bi-shield-exclamation text-danger"></i> SAFETY THRESHOLD ALERTS
                    </h3>
                    <p class="table-card-sub">Spare parts below threshold requiring replenishment</p>
                </div>
                <span class="tag-pill">
                    Active: <strong class="${reorderList != null && reorderList.size() > 0 ? 'text-danger' : 'text-success'}" style="margin-left:4px;">${reorderList != null ? reorderList.size() : 0}</strong>
                </span>
            </div>

            <div class="table-responsive">
                <table class="table-minimal">
                    <thead>
                        <tr>
                            <th style="width:140px;">Part SKU</th>
                            <th>Part Description</th>
                            <th style="width:150px;">Location</th>
                            <th class="text-center" style="width:140px;">Current Stock</th>
                            <th class="text-center" style="width:140px;">Reorder Level</th>
                            <th class="text-end" style="width:140px;">Unit Price</th>
                            <th class="text-center" style="width:140px;">Severity</th>
                            <th class="text-center" style="width:170px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty reorderList}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-check2-circle text-success fs-1 d-block mb-2"></i>
                                        <div class="fw-bold" style="color:var(--txt);">All Stock Levels Are Healthy</div>
                                        <small>No spare parts currently require replenishment dispatch.</small>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${reorderList}">
                                    <tr>
                                        <td><span class="sku-code">${item.partId}</span></td>
                                        <td><div class="fw-bold">${item.partName}</div></td>
                                        <td>
                                            <span class="tag-pill">
                                                <i class="bi bi-geo-alt text-danger"></i> ${item.storageLocation}
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.quantity == 0}">
                                                    <span class="badge-stock-danger">0 Units (Depleted)</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-stock-warning">${item.quantity} Units Left</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center text-muted">
                                            Min ${item.reorderLevel} Units
                                        </td>
                                        <td class="text-end font-monospace">
                                            Rs. <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.quantity == 0}">
                                                    <span class="tag-pill" style="color:#ef4444; border-color:rgba(239,68,68,0.3); background:rgba(239,68,68,0.1);">CRITICAL</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="tag-pill" style="color:#f59e0b; border-color:rgba(245,158,11,0.3); background:rgba(245,158,11,0.1);">WARNING</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <button class="btn-pill-red btn-sm"
                                                    onclick="openRequestModal('${item.partId}', '${item.partName}', ${item.quantity}, ${item.reorderLevel})">
                                                <i class="bi bi-send-fill"></i> Request Restock
                                            </button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- TABLE 2: TRANSMITTED RESTOCK REQUESTS (PROCESSING) -->
        <div class="table-card">
            <div class="table-card-header">
                <div>
                    <h3 class="table-card-title">
                        <i class="bi bi-hourglass-split text-warning"></i> TRANSMITTED RESTOCK REQUESTS
                    </h3>
                    <p class="table-card-sub">Active requisitions awaiting Spare Part supplier delivery &amp; QA</p>
                </div>
                <span class="tag-pill">
                    In Pipeline: <strong style="color:var(--txt); margin-left:4px;">${pendingRequests != null ? pendingRequests.size() : 0}</strong>
                </span>
            </div>

            <div class="table-responsive">
                <table class="table-minimal">
                    <thead>
                        <tr>
                            <th style="width:110px;">Req ID</th>
                            <th style="width:140px;">Part SKU</th>
                            <th>Part Description</th>
                            <th class="text-center" style="width:130px;">Stock</th>
                            <th class="text-center" style="width:150px;">Requested</th>
                            <th>Remarks</th>
                            <th style="width:140px;">Date</th>
                            <th class="text-center" style="width:170px;">Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty pendingRequests}">
                                <tr>
                                    <td colspan="8" class="text-center py-5 text-muted">
                                        <i class="bi bi-inbox fs-1 d-block mb-2"></i>
                                        <div class="fw-bold" style="color:var(--txt);">No Active Restock Requests</div>
                                        <small>Submitted restock requests will appear here for processing.</small>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="req" items="${pendingRequests}">
                                    <tr>
                                        <td><span class="tag-pill">#${req.requestId}</span></td>
                                        <td><span class="sku-code">${req.partId}</span></td>
                                        <td><div class="fw-bold">${req.partName}</div></td>
                                        <td class="text-center">
                                            <span class="${req.currentQuantity == 0 ? 'badge-stock-danger' : 'badge-stock-warning'}">
                                                ${req.currentQuantity} Units
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <span class="tag-pill" style="font-weight:700;">+${req.requestedQuantity} Units</span>
                                        </td>
                                        <td class="small text-muted">
                                            <c:choose>
                                                <c:when test="${not empty req.requestMessage}">
                                                    <i class="bi bi-chat-left-text me-1 text-primary"></i>${req.requestMessage}
                                                </c:when>
                                                <c:otherwise>Standard replenishment request</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td><span class="small font-monospace text-muted">${req.requestDate}</span></td>
                                        <td class="text-center">
                                            <span class="tag-pill" style="background:rgba(245,158,11,0.12); color:#d97706; border-color:rgba(245,158,11,0.25);">
                                                <i class="bi bi-hourglass-split me-1"></i> Awaiting Delivery
                                            </span>
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

    <!-- RESTOCK REQUEST MODAL -->
    <div class="modal fade" id="requestModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-sm" style="max-width:430px;">
            <div class="modal-content">
                <form action="/reorder/request" method="post">
                    <input type="hidden" name="source" value="reorder">
                    <input type="hidden" name="partId" id="reqPartId">
                    <input type="hidden" name="partName" id="reqPartName">
                    <input type="hidden" name="currentQuantity" id="reqCurrentQty">

                    <div class="modal-header">
                        <div class="d-flex align-items-center gap-2">
                            <span class="tag-pill">DISPATCH</span>
                            <h6 class="modal-title mb-0">Restock Request</h6>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body">
                        <div class="info-panel d-flex justify-content-between align-items-center mb-3">
                            <span class="fw-bold small" id="reqPartDisplay" style="color:var(--txt);"></span>
                            <span class="badge-stock-danger" id="reqCurrentDisplay"></span>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Needed Restock Quantity *</label>
                            <input type="number" name="requestedQuantity" id="reqQuantityInput" class="form-control form-control-sm" min="1" required autofocus>
                        </div>

                        <div class="mb-2">
                            <label class="form-label">Message for Spare Part Dept</label>
                            <textarea name="requestMessage" rows="2" class="form-control form-control-sm" placeholder="Message for Spare Part Dept...">Please supply needed stock.</textarea>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn btn-sm btn-outline-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-pill-dark btn-sm">
                            <i class="bi bi-send-fill me-1"></i> Send Request
                        </button>
                    </div>
                </form>
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
                        <input type="hidden" name="redirectUrl" value="/reorder">

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

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
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
            const html = document.documentElement;
            const isDark = html.getAttribute('data-theme') === 'dark';
            const next = isDark ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            const si = document.getElementById('themeSideIcon');
            if (si) si.className = next === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
        }

        (function() {
            const cur = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', cur);
            window.addEventListener('DOMContentLoaded', function() {
                const si = document.getElementById('themeSideIcon');
                if (si) si.className = cur === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
            });
        })();
    </script>
</body>
</html>
