<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Authorized OEM Suppliers | Spare Part Management</title>
    
    <!-- Fonts & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=JetBrains+Mono:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Dark Mode Init Script (Prevents FOUC) -->
    <script>
        (function() {
            var savedTheme = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', savedTheme);
        })();
    </script>

    <style>
        :root {
            --bg-page: #f5f4ef;
            --card: #ffffff;
            --card-subtle: #eeece2;
            --border: #dfdbce;
            --border-hover: #c8c2b0;
            --txt: #1c1917;
            --txt2: #57534e;
            --txt-muted: #78716c;
            --sidebar-bg: #ffffff;
            --table-head: #faf9f5;
            --table-hover: #f5f3ec;
            --brand-dark: #1c1917;
            --brand-red: #d97706;
            --brand-red-hover: #b45309;
            --pill-bg: #eeece2;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.06);
            --shadow-card: 0 4px 20px -2px rgba(0, 0, 0, 0.06);
            --shadow-modal: 0 25px 50px -12px rgba(0, 0, 0, 0.2);
            --radius-sm: 6px;
            --radius-md: 12px;
            --radius-lg: 16px;
            --radius-xl: 20px;
            --amber-glow: rgba(217, 119, 6, 0.25);
            --sku-txt: #b45309;
        }

        [data-theme="dark"] {
            --bg-page: #14171d;
            --card: #1c2028;
            --card-subtle: #242934;
            --border: #2e3544;
            --border-hover: #454f64;
            --txt: #f8fafc;
            --txt2: #94a3b8;
            --txt-muted: #64748b;
            --sidebar-bg: #101318;
            --table-head: #181c24;
            --table-hover: #222732;
            --brand-dark: #f8fafc;
            --brand-red: #f59e0b;
            --brand-red-hover: #d97706;
            --pill-bg: #242934;
            --shadow-sm: 0 1px 3px rgba(0,0,0,0.5);
            --shadow-card: 0 4px 20px -2px rgba(0, 0, 0, 0.4);
            --shadow-modal: 0 25px 50px -12px rgba(0, 0, 0, 0.8);
            --amber-glow: rgba(245, 158, 11, 0.22);
            --sku-txt: #fbbf24;
        }

        * { box-sizing: border-box; }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg-page);
            color: var(--txt);
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
            transition: background-color 0.2s ease, color 0.2s ease;
        }

        /* SIDEBAR RAIL */
        .sidebar-rail {
            width: 76px;
            background-color: var(--sidebar-bg);
            border-right: 1px solid var(--border);
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1.5rem 0;
            z-index: 1030;
            transition: all 0.2s ease;
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
            transition: transform 0.2s ease;
            cursor: pointer;
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
            padding: 0.55rem 1.25rem;
            font-size: 0.84rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-pill-dark:hover {
            border-color: var(--brand-red);
            color: var(--brand-red) !important;
            transform: translateY(-1px);
        }

        .btn-pill-red {
            background: var(--brand-red);
            color: #090a0d !important;
            border: 1px solid var(--brand-red);
            border-radius: 9999px;
            padding: 0.55rem 1.25rem;
            font-size: 0.84rem;
            font-weight: 800;
            letter-spacing: 0.03em;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            box-shadow: 0 4px 14px var(--amber-glow);
            transition: all 0.2s ease;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-pill-red:hover {
            background: var(--brand-red-hover);
            border-color: var(--brand-red-hover);
            transform: translateY(-1px);
        }

        .btn-pill-outline {
            background: var(--card);
            color: var(--txt);
            border: 1px solid var(--border);
            border-radius: 9999px;
            padding: 0.55rem 1.1rem;
            font-size: 0.84rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            transition: all 0.2s ease;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-pill-outline:hover {
            border-color: var(--txt);
            background: var(--card-subtle);
        }

        .btn-pill-white {
            background: #ffffff;
            color: #09090b !important;
            border: 1px solid #ffffff;
            border-radius: 9999px;
            padding: 0.6rem 1.35rem;
            font-size: 0.85rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-pill-white:hover {
            background: #f1f5f9;
            transform: translateY(-1px);
        }

        .btn-pill-ghost {
            background: rgba(255, 255, 255, 0.12);
            color: #ffffff !important;
            border: 1px solid rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(8px);
            border-radius: 9999px;
            padding: 0.6rem 1.35rem;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-pill-ghost:hover {
            background: rgba(255, 255, 255, 0.22);
            transform: translateY(-1px);
        }

        /* HERO EV BANNER */
        .hero-ev {
            position: relative;
            border-radius: var(--radius-xl);
            overflow: hidden;
            margin-bottom: 2.25rem;
            min-height: 240px;
            background: #09090b;
            display: flex;
            align-items: center;
            padding: 2.5rem 3rem;
            box-shadow: var(--shadow-card);
        }
        .hero-ev-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center;
            opacity: 0.38;
            filter: brightness(0.85);
            transition: transform 0.6s ease;
        }
        .hero-ev:hover .hero-ev-bg {
            transform: scale(1.02);
        }
        .hero-ev-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, rgba(9, 9, 11, 0.94) 0%, rgba(9, 9, 11, 0.65) 60%, rgba(9, 9, 11, 0.3) 100%);
        }
        .hero-ev-content {
            position: relative;
            z-index: 2;
            max-width: 820px;
        }
        .hero-metrics-strip {
            display: flex;
            align-items: center;
            gap: 1.75rem;
            margin-bottom: 1.25rem;
        }
        .hero-metric-item {
            display: flex;
            flex-direction: column;
        }
        .hero-metric-num {
            font-family: 'JetBrains Mono', monospace;
            font-size: 1.55rem;
            font-weight: 700;
            color: #ffffff;
            line-height: 1;
        }
        .hero-metric-lbl {
            font-size: 0.72rem;
            font-weight: 600;
            color: #94a3b8;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-top: 0.3rem;
        }
        .hero-ev-title {
            font-size: 2.1rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            text-transform: uppercase;
            color: #ffffff;
            margin: 0 0 0.65rem 0;
            line-height: 1.15;
        }
        .hero-ev-sub {
            font-size: 0.92rem;
            color: #cbd5e1;
            margin: 0 0 1.5rem 0;
            line-height: 1.55;
            max-width: 680px;
        }

        /* KPI BENTO CARDS */
        .kpi-minimal-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 1.5rem;
            box-shadow: var(--shadow-sm);
            transition: all 0.2s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            height: 100%;
        }
        .kpi-minimal-card:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
            box-shadow: var(--shadow-card);
        }
        .kpi-metric-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        .kpi-tag {
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--txt-muted);
        }
        .kpi-icon-pill {
            width: 36px;
            height: 36px;
            border-radius: 10px;
            background: var(--card-subtle);
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            color: var(--txt);
        }
        .kpi-val {
            font-family: 'JetBrains Mono', monospace;
            font-size: 2rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            color: var(--txt);
            line-height: 1;
            margin-bottom: 0.35rem;
        }
        .kpi-subnote {
            font-size: 0.78rem;
            color: var(--txt2);
            margin: 0;
        }

        /* TABLE CARD */
        .table-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 1.75rem 2rem;
            box-shadow: var(--shadow-card);
            margin-bottom: 2rem;
        }
        .table-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }
        .table-card-title {
            font-size: 1.05rem;
            font-weight: 800;
            letter-spacing: -0.01em;
            text-transform: uppercase;
            margin: 0 0 0.25rem 0;
            color: var(--txt);
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }
        .table-card-sub {
            font-size: 0.8rem;
            color: var(--txt-muted);
            margin: 0;
        }

        /* TABLE */
        .table-minimal {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }
        .table-minimal th {
            background-color: var(--table-head);
            color: var(--txt2);
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            padding: 0.95rem 1.25rem;
            border-bottom: 1px solid var(--border);
            border-top: none;
            white-space: nowrap;
        }
        .table-minimal td {
            padding: 1.1rem 1.25rem;
            color: var(--txt);
            font-size: 0.88rem;
            border-bottom: 1px solid var(--border);
            vertical-align: middle;
            background: transparent;
            transition: background 0.15s ease;
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

        /* STATUS BADGES */
        .badge-status-active {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.85rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(16, 185, 129, 0.12);
            color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.3);
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        .badge-status-inactive {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.28rem 0.85rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            background: rgba(100, 116, 139, 0.12);
            color: #64748b;
            border: 1px solid rgba(100, 116, 139, 0.25);
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        /* SEARCH BAR */
        .search-pill-box {
            display: flex;
            align-items: center;
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 9999px;
            padding: 0.45rem 1rem;
            width: 320px;
            transition: all 0.2s ease;
        }
        .search-pill-box:focus-within {
            border-color: var(--txt);
            box-shadow: 0 0 0 1px var(--txt);
        }
        .search-pill-box input {
            border: none;
            outline: none;
            background: transparent;
            font-size: 0.85rem;
            color: var(--txt);
            margin-left: 0.5rem;
            width: 100%;
        }

        /* FORM CONTROLS FOR MODALS */
        .form-label-clean {
            font-size: 0.76rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            color: var(--txt2);
            margin-bottom: 0.4rem;
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
        .modal-body { padding: 1.75rem; }
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
            <!-- 2. Quality Control & Inspection Board -->
            <li>
                <a href="/procurement" class="sidebar-icon-link" title="Quality Inspection Board">
                    <i class="bi bi-patch-check"></i>
                    <c:if test="${pendingCount > 0}">
                        <span class="badge-dot" style="background:#f59e0b;"></span>
                    </c:if>
                </a>
            </li>
            <!-- 3. Authorized OEM Suppliers Directory (Active) -->
            <li>
                <a href="/spareparts/suppliers" class="sidebar-icon-link active" title="Authorized OEM Suppliers Directory">
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
                <h1 class="topbar-title">AUTHORIZED OEM SUPPLIERS</h1>
                <p class="topbar-sub">CERTIFIED VENDOR DIRECTORY &amp; PARTNER CONTACT REGISTRY</p>
            </div>

            <div class="d-flex align-items-center gap-2 flex-wrap">
                <button type="button" class="btn-pill-dark" onclick="openAddNewSparePartModal()">
                    <i class="bi bi-plus-circle-fill"></i> Add New Spare Part
                </button>
                <a href="/spareparts" class="btn-pill-outline">
                    <i class="bi bi-arrow-left-short"></i> Back to Procurement
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

        <!-- MAIN TABLE: SUPPLIERS DIRECTORY (READ-ONLY FOR SPARE PART MANAGER) -->
        <section class="table-card">
            <div class="table-card-header">
                <div>
                    <h3 class="table-card-title">
                        <i class="bi bi-buildings"></i> AUTHORIZED OEM SUPPLIERS NETWORK
                    </h3>
                    <p class="table-card-sub">Manage and inspect corporate supplier partners, categories, and direct contact details.</p>
                </div>

                <div class="d-flex align-items-center gap-3">
                    <span class="tag-pill" title="Spare Part Manager Directory View Mode">
                        <i class="bi bi-shield-lock-fill text-primary"></i> Directory Read-Only
                    </span>
                    <div class="search-pill-box">
                        <i class="bi bi-search" style="color:var(--txt-muted);"></i>
                        <input type="text" id="supplierSearchInput" placeholder="Filter company, category, contact..." onkeyup="filterSuppliersTable()">
                    </div>
                </div>
            </div>

            <div class="table-responsive">
                <table class="table-minimal" id="suppliersTable">
                    <thead>
                        <tr>
                            <th style="width:70px;">ID</th>
                            <th>Supplier Company</th>
                            <th>Category</th>
                            <th>Contact Person</th>
                            <th>Email Address</th>
                            <th>Phone</th>
                            <th class="text-center" style="width:130px;">Status</th>
                            <th class="text-center" style="width:160px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty suppliers}">
                                <tr>
                                    <td colspan="8" class="text-center py-5" style="color:var(--txt2);">
                                        <i class="bi bi-buildings fs-1 d-block mb-2" style="color:var(--txt-muted);"></i>
                                        <h6 class="fw-bold" style="color:var(--txt);">No Suppliers Registered</h6>
                                        <small style="color:var(--txt2);">Corporate supplier records will appear here.</small>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="sup" items="${suppliers}">
                                    <tr class="supplier-row" data-search="${sup.supplierName.toLowerCase()} ${sup.category.toLowerCase()} ${sup.contactPerson.toLowerCase()} ${sup.status.toLowerCase()}">
                                        <td><span class="tag-pill">#${sup.supplierId}</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div style="width:34px;height:34px;border-radius:8px;background:var(--card-subtle);border:1px solid var(--border);display:flex;align-items:center;justify-content:center;color:var(--txt);font-size:0.95rem;">
                                                    <i class="bi bi-building"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold" style="color:var(--txt);">${sup.supplierName}</div>
                                                    <small style="color:var(--txt-muted);font-size:0.75rem;">${sup.address}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td><span class="tag-pill" style="font-weight:600;">${sup.category}</span></td>
                                        <td><span style="color:var(--txt); font-weight:500;">${sup.contactPerson}</span></td>
                                        <td>
                                            <a href="mailto:${sup.email}" style="color:var(--txt); text-decoration:none; display:inline-flex; align-items:center; gap:0.35rem;">
                                                <i class="bi bi-envelope text-primary"></i> ${sup.email}
                                            </a>
                                        </td>
                                        <td><small class="sku-code" style="color:var(--txt2);">${sup.phone}</small></td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${sup.status.equalsIgnoreCase('ACTIVE')}">
                                                    <span class="badge-status-active">
                                                        <i class="bi bi-check-circle-fill"></i> ACTIVE
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge-status-inactive">
                                                        <i class="bi bi-dash-circle"></i> INACTIVE
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${sup.status.equalsIgnoreCase('ACTIVE')}">
                                                    <button type="button" class="btn-pill-dark btn-sm py-1 px-3"
                                                            onclick="openOrderFromThisSupplier('${sup.supplierName}')"
                                                            title="Request parts or add new spare part from this supplier">
                                                        <i class="bi bi-send-fill" style="font-size:0.75rem;"></i> Request Parts
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn-pill-outline btn-sm py-1 px-3" disabled style="opacity:0.6;cursor:not-allowed;" title="Supplier is inactive">
                                                        <i class="bi bi-slash-circle"></i> On Hold
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
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
                    <input type="hidden" name="redirectUrl" value="/spareparts/suppliers">
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

    <!-- Modal: My Account Profile -->
    <div class="modal fade" id="accountModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered" style="max-width:440px;">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="d-flex align-items-center gap-2">
                        <div style="width:36px;height:36px;border-radius:10px;background:var(--brand-dark);color:#ffffff;display:flex;align-items:center;justify-content:center;font-size:1.1rem;">
                            <i class="bi bi-person-circle"></i>
                        </div>
                        <div>
                            <h6 class="modal-title mb-0">My Account Profile</h6>
                            <small style="color:var(--txt-muted);">Update credentials &amp; password</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">
                    <form action="/account/update-profile" method="post" id="profileUpdateForm" autocomplete="off">
                        <input type="hidden" name="redirectUrl" value="/spareparts/suppliers">

                        <div class="mb-3">
                            <label class="form-label-clean">Full Name</label>
                            <input type="text" name="fullName" class="form-control-clean"
                                   value="${not empty sessionScope.fullName ? sessionScope.fullName : 'Spare Part Manager'}" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label-clean">Email Address</label>
                            <input type="email" name="email" class="form-control-clean"
                                   value="${not empty sessionScope.email ? sessionScope.email : 'spareparts@parttrack.com'}" required>
                        </div>

                        <hr class="my-3" style="border-color:var(--border);">
                        <div class="small fw-bold text-muted mb-2">CHANGE PASSWORD (OPTIONAL)</div>

                        <div class="mb-2">
                            <label class="form-label-clean">New Password</label>
                            <div class="input-group">
                                <input type="password" name="newPassword" id="profileNewPass" class="form-control-clean" placeholder="Leave blank to keep current">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassVisibility('profileNewPass','eyeIcon1')">
                                    <i class="bi bi-eye" id="eyeIcon1"></i>
                                </button>
                            </div>
                        </div>

                        <div class="mb-2">
                            <label class="form-label-clean">Confirm New Password</label>
                            <div class="input-group">
                                <input type="password" id="profileConfirmPass" class="form-control-clean" placeholder="Repeat new password">
                                <button class="btn btn-outline-secondary" type="button" onclick="togglePassVisibility('profileConfirmPass','eyeIcon2')">
                                    <i class="bi bi-eye" id="eyeIcon2"></i>
                                </button>
                            </div>
                            <div id="profilePassError" class="text-danger small mt-1" style="display:none;"></div>
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

        function openOrderFromThisSupplier(supplierName) {
            generateNewPartSku();
            document.getElementById('newPartName').value = '';
            var select = document.getElementById('newPartSupplierSelect');
            if (select) {
                for (var i = 0; i < select.options.length; i++) {
                    if (select.options[i].value === supplierName) {
                        select.selectedIndex = i;
                        break;
                    }
                }
            }
            new bootstrap.Modal(document.getElementById('addNewSparePartModal')).show();
        }

        function filterSuppliersTable() {
            var input = document.getElementById('supplierSearchInput').value.toLowerCase().trim();
            var rows = document.querySelectorAll('.supplier-row');
            rows.forEach(function(row) {
                var searchData = row.getAttribute('data-search') || '';
                if (searchData.indexOf(input) > -1) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
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
            var current = html.getAttribute('data-theme') || 'light';
            var next = current === 'dark' ? 'light' : 'dark';
            html.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            updateThemeIcons(next);
        }

        function updateThemeIcons(theme) {
            var sideIcon = document.getElementById('themeSideIcon');
            var topIcon = document.getElementById('themeIcon');
            var isDark = theme === 'dark';
            if (sideIcon) sideIcon.className = isDark ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
            if (topIcon) topIcon.className = isDark ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
        }

        document.addEventListener('DOMContentLoaded', function() {
            var saved = localStorage.getItem('theme') || 'light';
            updateThemeIcons(saved);
        });
    </script>
</body>
</html>
