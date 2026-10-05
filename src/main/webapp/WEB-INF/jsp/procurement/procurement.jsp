<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quality Control &amp; Inspection Board | AutoParts Depot</title>

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
            --bg: #f5f4ef;
            --card: #ffffff;
            --card-subtle: #eeece2;
            --border: #dfdbce;
            --border-hover: #c8c2b0;
            --txt: #1c1917;
            --txt2: #57534e;
            --txt-muted: #78716c;
            --brand-red: #d97706;
            --brand-red-hover: #b45309;
            --brand-dark: #1c1917;
            --pill-bg: #eeece2;
            --sidebar-bg: #ffffff;
            --table-head: #faf9f5;
            --table-hover: #f5f3ec;
            --radius-lg: 16px;
            --radius-md: 12px;
            --radius-sm: 6px;
            --shadow-subtle: 0 1px 3px rgba(0,0,0,0.06), 0 8px 24px -4px rgba(0,0,0,0.06);
            --shadow-modal: 0 20px 40px -10px rgba(0,0,0,0.2);
            --amber-glow: rgba(217, 119, 6, 0.25);
            --sku-txt: #b45309;
        }

        [data-theme="dark"] {
            --bg: #14171d;
            --card: #1c2028;
            --card-subtle: #242934;
            --border: #2e3544;
            --border-hover: #454f64;
            --txt: #f8fafc;
            --txt2: #94a3b8;
            --txt-muted: #64748b;
            --brand-red: #f59e0b;
            --brand-red-hover: #d97706;
            --brand-dark: #f8fafc;
            --pill-bg: #242934;
            --sidebar-bg: #101318;
            --table-head: #181c24;
            --table-hover: #222732;
            --shadow-subtle: 0 1px 3px rgba(0,0,0,0.5), 0 8px 24px -4px rgba(0,0,0,0.4);
            --shadow-modal: 0 20px 40px -10px rgba(0,0,0,0.8);
            --amber-glow: rgba(245, 158, 11, 0.22);
            --sku-txt: #fbbf24;
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
            background-color: var(--brand-red);
            color: #090a0d !important;
            box-shadow: 0 0 16px var(--amber-glow);
        }
        [data-theme="dark"] .sidebar-icon-link.active {
            background-color: var(--brand-red);
            color: #090a0d !important;
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
            border-color: var(--brand-red);
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
            color: var(--brand-red);
            margin: 0;
            font-weight: 600;
            letter-spacing: 0.05em;
        }

        /* BUTTONS */
        .btn-pill-dark {
            background: var(--card-subtle);
            color: var(--txt) !important;
            border: 1px solid var(--border);
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
        .btn-pill-dark:hover {
            border-color: var(--brand-red);
            color: var(--brand-red) !important;
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
            color: #090a0d !important;
            border: 1px solid var(--brand-red);
            border-radius: 9999px;
            padding: 0.45rem 1.15rem;
            font-size: 0.8rem;
            font-weight: 800;
            letter-spacing: 0.03em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            cursor: pointer;
            box-shadow: 0 4px 14px var(--amber-glow);
            transition: all 0.2s ease;
        }
        .btn-pill-red:hover {
            background: var(--brand-red-hover);
            border-color: var(--brand-red-hover);
            transform: translateY(-1px);
        }

        /* HERO BANNER */
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

        /* BENTO KPI CARDS */
        .kpi-minimal-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            box-shadow: var(--shadow-subtle);
            transition: all 0.2s ease;
        }
        .kpi-minimal-card:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }
        .kpi-metric-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.25rem;
        }
        .kpi-tag {
            font-size: 0.72rem;
            font-weight: 800;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            color: var(--txt-muted);
        }
        .kpi-icon-pill {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: var(--card-subtle);
            color: var(--txt);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.05rem;
        }
        .kpi-val {
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            line-height: 1.1;
            margin: 0 0 0.4rem 0;
            color: var(--txt);
        }
        .kpi-subnote {
            font-size: 0.8rem;
            color: var(--txt2);
            margin: 0;
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
            font-weight: 700;
            font-size: 0.82rem;
            color: var(--sku-txt);
            letter-spacing: 0.04em;
        }

        .tag-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: var(--radius-sm);
            font-size: 0.75rem;
            font-weight: 600;
            background: var(--pill-bg);
            color: var(--txt);
            border: 1px solid var(--border);
        }

        .badge-status-approved {
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

        .badge-status-pending {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(245, 158, 11, 0.1);
            color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.25);
        }

        .badge-status-rejected {
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
            text-decoration: none;
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

        /* FORM CONTROLS */
        .form-label-clean {
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            color: var(--txt-muted);
            margin-bottom: 0.45rem;
            display: block;
        }
        .form-control-clean, .form-select-clean {
            background-color: var(--card);
            border: 1px solid var(--border);
            color: var(--txt);
            border-radius: 10px;
            padding: 0.6rem 0.95rem;
            font-size: 0.88rem;
            width: 100%;
            transition: all 0.2s ease;
        }
        .form-control-clean:focus, .form-select-clean:focus {
            outline: none;
            border-color: var(--txt);
            box-shadow: 0 0 0 1px var(--txt);
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
            padding: 1.5rem 1.75rem;
            border-bottom: 1px solid var(--border);
            background: var(--card);
        }
        .modal-title {
            font-weight: 800;
            font-size: 1.15rem;
            letter-spacing: -0.02em;
            text-transform: uppercase;
            color: var(--txt);
        }
        .modal-body {
            padding: 1.75rem;
        }
        .modal-footer {
            padding: 1.25rem 1.75rem;
            border-top: 1px solid var(--border);
            background: var(--card);
        }

        @media (max-width: 992px) {
            .sidebar-rail { display: none; }
            .main-content { margin-left: 0; width: 100%; padding: 1.5rem; }
            .hero-ev { height: auto; padding: 2rem; }
            .hero-ev-title { font-size: 1.8rem; }
        }
    </style>
</head>
<body>

    <!-- 1. SIDEBAR RAIL -->
    <aside class="sidebar-rail">
        <a href="javascript:void(0)" onclick="openAccountModal()" class="brand-logo-icon" title="My Account Profile">
            <i class="bi bi-person-circle"></i>
        </a>

        <ul class="sidebar-nav">
            <!-- 1. Supply Procurement & Orders -->
            <li>
                <a href="/spareparts" class="sidebar-icon-link" title="Supply Procurement &amp; Orders">
                    <i class="bi bi-speedometer2"></i>
                    <c:if test="${pendingRestockCount > 0}">
                        <span class="badge-dot"></span>
                    </c:if>
                </a>
            </li>
            <!-- 2. Quality Control & Inspection Board (Active) -->
            <li>
                <a href="/procurement" class="sidebar-icon-link active" title="Quality Inspection Board">
                    <i class="bi bi-patch-check"></i>
                    <c:if test="${pendingCount > 0}">
                        <span class="badge-dot" style="background:#f59e0b;"></span>
                    </c:if>
                </a>
            </li>
            <!-- 3. Authorized OEM Suppliers Directory -->
            <li>
                <a href="/spareparts/suppliers" class="sidebar-icon-link" title="Authorized OEM Suppliers Directory">
                    <i class="bi bi-buildings"></i>
                </a>
            </li>
        </ul>

        <div class="sidebar-bottom">
            <button class="theme-toggle-sidebar" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
                <i id="themeSideIcon" class="bi bi-moon-stars-fill"></i>
            </button>
            <a href="/logout" class="logout-icon-link" title="Logout">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </aside>

    <!-- 2. MAIN CONTENT -->
    <main class="main-content">

        <!-- Topbar -->
        <header class="topbar-clean">
            <div>
                <h1 class="topbar-title">QUALITY CONTROL &amp; INSPECTION</h1>
                <p class="topbar-sub">PHYSICAL VERIFICATION &amp; WAREHOUSE INTAKE ELIGIBILITY</p>
            </div>

            <div class="d-flex align-items-center gap-3">
                <button type="button" class="btn-pill-outline" onclick="openAccountModal()" title="Account Profile">
                    <i class="bi bi-person-circle"></i>
                    <span>${not empty sessionScope.fullName ? sessionScope.fullName : 'Spare Part Manager'}</span>
                </button>
                <button type="button" class="btn-pill-outline" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
                    <i id="themeIcon" class="bi bi-moon-stars-fill"></i>
                </button>
                <button type="button" class="btn-pill-red" onclick="openAddNewSparePartModal()">
                    <i class="bi bi-plus-circle-fill"></i> Add New Spare Part
                </button>
                <a href="/spareparts" class="btn-pill-dark">
                    <i class="bi bi-arrow-left-short"></i> Procurement Orders
                </a>
            </div>
        </header>

        <!-- Flash Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 rounded-4 mb-4 py-3 px-4 border" role="alert">
                <i class="bi bi-check-circle-fill text-success fs-5"></i>
                <div class="small fw-semibold text-success">${successMessage}</div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 rounded-4 mb-4 py-3 px-4 border" role="alert">
                <i class="bi bi-exclamation-triangle-fill text-danger fs-5"></i>
                <div class="small fw-semibold text-danger">${errorMessage}</div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Hero Banner -->
        <section class="hero-ev">
            <img src="https://images.unsplash.com/photo-1616432043562-3671ea2e5242?w=1600&q=80" alt="Quality Inspection" class="hero-ev-bg">
            <div class="hero-ev-overlay"></div>
            
            <div class="hero-ev-content">
                <div class="hero-metrics-strip">
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${totalDeliveries}</span>
                        <span class="hero-metric-lbl">Delivered Batches</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${pendingCount}</span>
                        <span class="hero-metric-lbl">Pending Check</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${approvedCount}</span>
                        <span class="hero-metric-lbl">Approved Ready</span>
                    </div>
                    <div class="hero-metric-item">
                        <span class="hero-metric-num">${rejectedCount}</span>
                        <span class="hero-metric-lbl">Defective / Return</span>
                    </div>
                </div>

                <h2 class="hero-ev-title">PHYSICAL INSPECTION &amp; BATCH VERIFICATION</h2>
                <p class="hero-ev-sub">
                    Inspect arriving supplier deliveries for OEM specification compliance. Approve certified batches to unlock warehouse inventory intake, or reject damaged shipments to issue return notices.
                </p>

                <div class="d-flex align-items-center gap-3 flex-wrap">
                    <div class="btn-pill-white">
                        <i class="bi bi-patch-check-fill text-success"></i> ${passRatePct}% Overall QA Pass Rate
                    </div>
                    <a href="#inspectionQueueSection" class="btn-pill-ghost">
                        <i class="bi bi-hourglass-split"></i> Awaiting Inspection (${pendingCount})
                    </a>
                    <a href="/spareparts" class="btn-pill-ghost">
                        <i class="bi bi-truck"></i> Procurement Pipeline
                    </a>
                </div>
            </div>
        </section>

        <!-- 4 Bento KPI Cards -->
        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="kpi-minimal-card">
                    <div class="kpi-metric-header">
                        <span class="kpi-tag">DELIVERED BATCHES</span>
                        <div class="kpi-icon-pill">
                            <i class="bi bi-truck"></i>
                        </div>
                    </div>
                    <div>
                        <div class="kpi-val">${totalDeliveries}</div>
                        <p class="kpi-subnote">${totalReceivedUnits} total units delivered</p>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="kpi-minimal-card" style="border-color:${pendingCount > 0 ? '#f59e0b' : 'var(--border)'};">
                    <div class="kpi-metric-header">
                        <span class="kpi-tag" style="color:${pendingCount > 0 ? '#f59e0b' : 'var(--txt-muted)'};">PENDING PHYSICAL QA</span>
                        <div class="kpi-icon-pill" style="color:${pendingCount > 0 ? '#f59e0b' : 'inherit'};">
                            <i class="bi bi-hourglass-split"></i>
                        </div>
                    </div>
                    <div>
                        <div class="kpi-val" style="color:${pendingCount > 0 ? '#f59e0b' : 'var(--txt)'};">${pendingCount}</div>
                        <p class="kpi-subnote">${pendingCount > 0 ? 'Batches awaiting physical verification' : 'All shipments inspected'}</p>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="kpi-minimal-card">
                    <div class="kpi-metric-header">
                        <span class="kpi-tag">APPROVED FOR INTAKE</span>
                        <div class="kpi-icon-pill" style="color:#10b981;">
                            <i class="bi bi-check-circle-fill"></i>
                        </div>
                    </div>
                    <div>
                        <div class="kpi-val text-success">${approvedCount}</div>
                        <p class="kpi-subnote">${totalAvailableUnits} units unlocked for warehouse intake</p>
                    </div>
                </div>
            </div>

            <div class="col-sm-6 col-xl-3">
                <div class="kpi-minimal-card" style="border-color:${rejectedCount > 0 ? 'var(--brand-red)' : 'var(--border)'};">
                    <div class="kpi-metric-header">
                        <span class="kpi-tag" style="color:${rejectedCount > 0 ? 'var(--brand-red)' : 'var(--txt-muted)'};">REJECTED / DEFECTS</span>
                        <div class="kpi-icon-pill" style="color:${rejectedCount > 0 ? 'var(--brand-red)' : 'inherit'};">
                            <i class="bi bi-x-circle-fill"></i>
                        </div>
                    </div>
                    <div>
                        <div class="kpi-val" style="color:${rejectedCount > 0 ? 'var(--brand-red)' : 'var(--txt)'};">${rejectedCount}</div>
                        <p class="kpi-subnote">${rejectedCount > 0 ? 'Supplier flagged for return / credit' : 'Zero defective batches recorded'}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- MAIN QUALITY INSPECTION TABLE -->
        <section id="inspectionQueueSection" class="table-card">
            <div class="table-card-header">
                <div>
                    <h3 class="table-card-title">
                        <i class="bi bi-patch-check"></i> INCOMING SUPPLIER DELIVERIES &amp; PHYSICAL INSPECTION
                    </h3>
                    <p class="table-card-sub">Review delivered batches, perform physical inspection, and certify parts for warehouse intake.</p>
                </div>
                <span class="tag-pill">
                    Logged Batches: <strong>${productList != null ? productList.size() : 0}</strong>
                </span>
            </div>

            <div class="table-responsive">
                <table class="table-minimal">
                    <thead>
                        <tr>
                            <th style="width:90px;">Batch #</th>
                            <th style="width:130px;">Part SKU</th>
                            <th>Part Description</th>
                            <th>Supplier Partner</th>
                            <th class="text-center" style="width:110px;">Delivered</th>
                            <th class="text-center" style="width:110px;">Intake Ready</th>
                            <th class="text-end" style="width:130px;">Unit Cost</th>
                            <th style="width:120px;">Arrival Date</th>
                            <th class="text-center" style="width:150px;">QA Verdict</th>
                            <th>Inspector Notes</th>
                            <th class="text-center" style="width:140px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty productList}">
                                <tr>
                                    <td colspan="11" class="text-center py-5" style="color:var(--txt2);">
                                        <i class="bi bi-truck fs-1 d-block mb-2" style="color:var(--txt-muted);"></i>
                                        <h6 class="fw-bold" style="color:var(--txt);">No Supplier Deliveries Recorded</h6>
                                        <small style="color:var(--txt2);">Shipments dispatched by suppliers will appear here for physical quality verification.</small>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${productList}">
                                    <tr>
                                        <td><span class="tag-pill">#${item.batchId}</span></td>
                                        <td><span class="sku-code">${item.partId}</span></td>
                                        <td><div class="fw-bold" style="color:var(--txt);">${item.partName}</div></td>
                                        <td>
                                            <span style="color:var(--txt); font-weight:500;">
                                                <i class="bi bi-building me-1" style="color:var(--txt-muted);"></i>${item.supplierName}
                                            </span>
                                        </td>
                                        <td class="text-center fw-bold" style="color:var(--txt);">${item.receivedQty}</td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.availableQty > 0}">
                                                    <span class="tag-pill" style="font-weight:700; color:#10b981;">${item.availableQty} Units</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="small" style="color:var(--txt-muted);">0 Units</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end sku-code">
                                            Rs. <fmt:formatNumber value="${item.supplierPrice}" pattern="#,##0.00"/>
                                        </td>
                                        <td><small class="sku-code" style="color:var(--txt2);">${item.arrivalDate}</small></td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.isApproved()}">
                                                    <span class="badge-status-approved">
                                                        <i class="bi bi-check-circle-fill"></i> APPROVED
                                                    </span>
                                                </c:when>
                                                <c:when test="${item.isRejected()}">
                                                    <span class="badge-status-rejected">
                                                        <i class="bi bi-x-circle-fill"></i> REJECTED
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-status-pending">
                                                        <i class="bi bi-hourglass-split"></i> PENDING QA
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="small" style="color:var(--txt2);">${item.qualityNotes}</td>
                                        <td class="text-center">
                                            <div class="d-inline-flex gap-1">
                                                <button type="button" class="btn-pill-dark" style="padding:0.35rem 0.85rem; font-size:0.78rem;"
                                                        onclick="openInspectModal('${item.batchId}', '${item.partId}', '${item.partName}', '${item.qualityStatus}', '${item.qualityNotes}')">
                                                    <i class="bi bi-patch-check"></i> Inspect
                                                </button>
                                                <form action="/procurement/delete" method="post" style="margin:0;" onsubmit="return confirm('Delete batch record #${item.batchId}?');">
                                                    <input type="hidden" name="batchId" value="${item.batchId}">
                                                    <button type="submit" class="btn-icon-action danger" title="Delete Delivery Record">
                                                        <i class="bi bi-trash3"></i>
                                                    </button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <!-- Modal 0: Add New Spare Part to System & Send Supplier Request -->
    <div class="modal fade" id="addNewSparePartModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg" style="max-width: 820px;">
            <div class="modal-content" style="border-radius: 4px; border: 1px solid var(--border); box-shadow: 0 20px 40px rgba(0,0,0,0.3);">
                <form action="/procurement/request-new-part" method="post">
                    <input type="hidden" name="redirectUrl" value="/procurement">
                    <div class="modal-header" style="border-radius: 4px 4px 0 0; padding: 1.4rem 2rem; border-bottom: 1px solid var(--border); background: var(--card);">
                        <div class="d-flex align-items-center gap-3">
                            <div style="width:42px;height:42px;border-radius:4px;background:var(--brand-red);color:#090a0d;display:flex;align-items:center;justify-content:center;font-size:1.25rem;">
                                <i class="bi bi-plus-square-fill"></i>
                            </div>
                            <div>
                                <h5 class="modal-title mb-0" style="font-size: 1.15rem; font-weight: 800; letter-spacing: -0.01em; text-transform: uppercase;">Add New Spare Part to System</h5>
                                <small style="color:var(--txt-muted); font-size: 0.8rem;">Register new spare part SKU &amp; send requisition to OEM supplier</small>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" style="filter: var(--btn-close-filter, none);"></button>
                    </div>

                    <div class="modal-body" style="padding: 2rem;">
                        <div class="row g-3 mb-3">
                            <div class="col-md-7">
                                <label class="form-label-clean" style="font-size:0.75rem; font-weight:700; text-transform:uppercase; letter-spacing:0.04em;">Spare Part SKU / Code *</label>
                                <input type="text" name="partId" id="newPartId" class="form-control-clean sku-code" placeholder="e.g. SP-5040 or PRT-9100" style="border-radius:4px; height: 44px;" required>
                            </div>
                            <div class="col-md-5 d-flex align-items-end">
                                <button type="button" class="btn-pill-outline w-100" onclick="generateNewPartSku()" title="Generate Random Part ID" style="border-radius:4px; height: 44px; font-size:0.8rem; font-weight:700; text-transform:uppercase; letter-spacing:0.03em;">
                                    <i class="bi bi-magic me-1"></i> Auto SKU
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-clean" style="font-size:0.75rem; font-weight:700; text-transform:uppercase; letter-spacing:0.04em;">Spare Part Name / Description *</label>
                            <input type="text" name="partName" id="newPartName" class="form-control-clean" placeholder="e.g. Ceramic Front Brake Rotor 350mm" style="border-radius:4px; height: 44px;" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-clean" style="font-size:0.75rem; font-weight:700; text-transform:uppercase; letter-spacing:0.04em;">Select Authorized OEM Supplier *</label>
                            <select name="supplierName" id="newPartSupplierSelect" class="form-select-clean" style="border-radius:4px; height: 44px;" required>
                                <c:forEach var="sup" items="${suppliers}">
                                    <option value="${sup.supplierName}">${sup.supplierName} &bull; ${sup.category}</option>
                                </c:forEach>
                                <c:if test="${empty suppliers}">
                                    <option value="Apex Auto Components Ltd">Apex Auto Components Ltd &bull; Engine &amp; Transmission</option>
                                    <option value="Brembo Brake Systems Global">Brembo Brake Systems Global &bull; Braking Systems</option>
                                    <option value="Denso OEM Genuine Parts">Denso OEM Genuine Parts &bull; OEM Electrical</option>
                                    <option value="Titan Heavy Wheels & Tyres">Titan Heavy Wheels & Tyres &bull; Wheels &amp; Suspension</option>
                                </c:if>
                            </select>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label-clean" style="font-size:0.75rem; font-weight:700; text-transform:uppercase; letter-spacing:0.04em;">Initial Request Quantity *</label>
                                <input type="number" name="requestedQty" id="newPartQty" class="form-control-clean" min="1" value="20" style="border-radius:4px; height: 44px;" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label-clean" style="font-size:0.75rem; font-weight:700; text-transform:uppercase; letter-spacing:0.04em;">Target Unit Price (Rs.) *</label>
                                <input type="number" step="0.01" name="expectedPrice" id="newPartPrice" class="form-control-clean sku-code" value="6500.00" style="border-radius:4px; height: 44px;" required>
                            </div>
                        </div>

                        <div class="mb-1">
                            <label class="form-label-clean" style="font-size:0.75rem; font-weight:700; text-transform:uppercase; letter-spacing:0.04em;">Requisition Notes &amp; Specifications for Supplier</label>
                            <textarea name="deliveryNotes" class="form-control-clean" rows="3" placeholder="e.g. New part catalog introduction. OEM certified standard packaging required." style="border-radius:4px;"></textarea>
                        </div>
                    </div>

                    <div class="modal-footer" style="border-radius: 0 0 4px 4px; padding: 1.25rem 2rem; border-top: 1px solid var(--border); background: var(--card);">
                        <button type="button" class="btn-pill-outline" data-bs-dismiss="modal" style="border-radius:4px; padding: 0.65rem 1.4rem; font-weight: 600;">Cancel</button>
                        <button type="submit" class="btn-pill-red" style="border-radius:4px; padding: 0.65rem 1.75rem; font-weight: 700; text-transform: uppercase; letter-spacing: 0.03em;">
                            <i class="bi bi-send-check-fill me-1"></i> Register &amp; Send Req to Supplier
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal 1: Perform Quality Inspection -->
    <div class="modal fade" id="inspectModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="/procurement/inspect" method="post">
                    <input type="hidden" name="batchId" id="inspectBatchId">
                    <div class="modal-header">
                        <div>
                            <h6 class="modal-title mb-0">Quality Inspection Verdict</h6>
                            <small style="color:var(--txt-muted);">Physical check certification &amp; intake eligibility</small>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body p-4">
                        <div class="p-3 rounded-3 mb-3" style="background:var(--card-subtle); border:1px solid var(--border);">
                            <div class="small" style="color:var(--txt-muted); font-weight:700; text-transform:uppercase; font-size:0.7rem;">Batch Under Inspection</div>
                            <div class="fw-bold fs-6 mt-1" id="inspectBatchDisplay" style="color:var(--txt);"></div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-clean">Physical Quality Verdict *</label>
                            <div class="d-flex gap-3 mt-1">
                                <label class="d-flex align-items-center gap-2 p-2 rounded-3 border flex-fill" style="cursor:pointer; background:var(--card);">
                                    <input type="radio" name="qualityStatus" id="statusApproved" value="APPROVED" checked>
                                    <div>
                                        <div class="fw-bold text-success" style="font-size:0.85rem;"><i class="bi bi-check-circle-fill me-1"></i> Approve Batch</div>
                                        <small class="text-secondary" style="font-size:0.72rem;">Meets OEM standards; eligible for intake</small>
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2 p-2 rounded-3 border flex-fill" style="cursor:pointer; background:var(--card);">
                                    <input type="radio" name="qualityStatus" id="statusRejected" value="REJECTED">
                                    <div>
                                        <div class="fw-bold text-danger" style="font-size:0.85rem;"><i class="bi bi-x-circle-fill me-1"></i> Reject Batch</div>
                                        <small class="text-secondary" style="font-size:0.72rem;">Defective parts; initiate vendor return</small>
                                    </div>
                                </label>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-clean">Inspector Remarks / QA Observations *</label>
                            <textarea name="qualityNotes" id="inspectNotes" class="form-control-clean" rows="3" placeholder="e.g. Visual check passed, OEM seal verified, zero micro-fractures detected." required></textarea>
                        </div>
                    </div>

                    <div class="modal-footer">
                        <button type="button" class="btn-pill-outline" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-pill-dark">
                            <i class="bi bi-patch-check-fill"></i> Save QA Verdict
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal 2: My Account Modal -->
    <div class="modal fade" id="accountModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered" style="max-width:440px;">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="d-flex align-items-center gap-2">
                        <div style="width:38px;height:38px;border-radius:10px;background:var(--card-subtle);display:flex;align-items:center;justify-content:center;font-size:1.2rem;color:var(--txt);">
                            <i class="bi bi-person-circle"></i>
                        </div>
                        <div>
                            <h6 class="modal-title mb-0">My Account Profile</h6>
                            <small style="color:var(--txt-muted);">Spare Part Manager credentials</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <div class="text-center mb-4">
                        <div style="width:64px;height:64px;border-radius:50%;background:var(--card-subtle);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;font-size:2rem;color:var(--txt);margin:0 auto .75rem;">
                            <i class="bi bi-person-fill"></i>
                        </div>
                        <div class="fw-bold" style="color:var(--txt);">${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.currentUser}</div>
                        <div class="small text-secondary">${sessionScope.currentUser} &middot; <span class="tag-pill">Spare Part Manager</span></div>
                    </div>

                    <form action="/account/update-profile" method="post" id="profileUpdateForm" autocomplete="off">
                        <input type="hidden" name="redirectUrl" value="/procurement">

                        <div class="mb-3">
                            <label class="form-label-clean">Full Name</label>
                            <input type="text" name="fullName" class="form-control-clean"
                                   value="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.currentUser}"
                                   placeholder="Your full name" autocomplete="off">
                        </div>

                        <div class="mb-3">
                            <label class="form-label-clean">Email Address</label>
                            <input type="email" name="email" class="form-control-clean"
                                   value="${not empty sessionScope.email ? sessionScope.email : 'spareparts@parttrack.com'}"
                                   placeholder="your@email.com" autocomplete="off">
                        </div>

                        <hr class="my-3" style="border-color:var(--border);">
                        <p class="small text-secondary mb-3"><i class="bi bi-lock me-1"></i>Change Password <span class="text-muted">(leave blank to keep current)</span></p>

                        <div class="mb-3">
                            <label class="form-label-clean">New Password</label>
                            <div class="input-group">
                                <input type="password" name="newPassword" id="profileNewPass" class="form-control-clean" style="border-top-right-radius:0; border-bottom-right-radius:0;"
                                       placeholder="Min 4 characters" minlength="4" autocomplete="new-password">
                                <button class="btn btn-outline-secondary border-start-0" type="button" style="border-color:var(--border); background:var(--card-subtle);"
                                        onclick="togglePassVisibility('profileNewPass','profilePassIcon')">
                                    <i class="bi bi-eye" id="profilePassIcon"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-clean">Confirm New Password</label>
                            <input type="password" name="confirmNewPassword" id="profileConfirmPass" class="form-control-clean"
                                   placeholder="Re-enter new password" autocomplete="new-password">
                            <span id="profilePassError" class="text-danger small fw-bold mt-1" style="display:none;"></span>
                        </div>

                        <div class="d-flex gap-2 mt-4">
                            <button type="button" class="btn-pill-outline flex-fill justify-content-center" data-bs-dismiss="modal">Cancel</button>
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
        function openAccountModal() {
            new bootstrap.Modal(document.getElementById('accountModal')).show();
        }

        function openAddNewSparePartModal() {
            generateNewPartSku();
            document.getElementById('newPartName').value = '';
            document.getElementById('newPartQty').value = '20';
            document.getElementById('newPartPrice').value = '6500.00';
            new bootstrap.Modal(document.getElementById('addNewSparePartModal')).show();
        }

        function generateNewPartSku() {
            var randomNum = Math.floor(1000 + Math.random() * 9000);
            document.getElementById('newPartId').value = 'PRT-' + randomNum;
        }

        function openInspectModal(batchId, partId, partName, currentStatus, currentNotes) {
            document.getElementById('inspectBatchId').value = batchId;
            document.getElementById('inspectBatchDisplay').textContent = '#' + batchId + ' - ' + partName + ' (' + partId + ')';
            document.getElementById('inspectNotes').value = currentNotes || '';
            if (currentStatus === 'APPROVED') {
                document.getElementById('statusApproved').checked = true;
            } else if (currentStatus === 'REJECTED') {
                document.getElementById('statusRejected').checked = true;
            } else {
                document.getElementById('statusApproved').checked = true;
            }
            new bootstrap.Modal(document.getElementById('inspectModal')).show();
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
            const moonClass = 'bi bi-moon-stars-fill';
            const sunClass  = 'bi bi-sun-fill';
            const si = document.getElementById('themeSideIcon');
            const ti = document.getElementById('themeIcon');
            if (si) si.className = next === 'dark' ? sunClass : moonClass;
            if (ti) ti.className = next === 'dark' ? sunClass : moonClass;
        }

        (function() {
            const saved = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', saved);
            window.addEventListener('DOMContentLoaded', function() {
                const si = document.getElementById('themeSideIcon');
                const ti = document.getElementById('themeIcon');
                if (si) si.className = saved === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
                if (ti) ti.className = saved === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
            });
        })();
    </script>
</body>
</html>
