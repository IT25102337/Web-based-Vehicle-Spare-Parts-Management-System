<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dispatched Deliveries &amp; QA | Supplier Portal</title>
    <script>
        (function(){
            var s = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', s);
        })();
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        /* ============ CSS VARIABLES ============ */
        :root {
            --navy:       #1e3a8a;
            --navy-dark:  #172554;
            --navy-soft:  #eff6ff;
            --navy-border:#bfdbfe;
            --bg:         #f0f4f8;
            --card:       #ffffff;
            --border:     #e2e8f0;
            --txt:        #0f172a;
            --txt2:       #64748b;
            --sidebar-bg: #ffffff;
            --table-head: #f8fafc;
            --table-hover:#f8fafc;
            --input-bg:   #ffffff;
            --modal-bg:   #ffffff;
            --modal-header:#f8fafc;
            --pill-bg:    #f1f5f9;
            --hero-grad:  linear-gradient(135deg, #0f172a 0%, #1e3a8a 55%, #0284c7 100%);
        }
        [data-theme='dark'] {
            --bg:         #0f172a;
            --card:       #1e293b;
            --border:     #334155;
            --txt:        #f1f5f9;
            --txt2:       #94a3b8;
            --sidebar-bg: #1e293b;
            --table-head: #273349;
            --table-hover:#1e2d45;
            --input-bg:   #273349;
            --modal-bg:   #1e293b;
            --modal-header:#273349;
            --pill-bg:    #1e293b;
            --navy-soft:  rgba(30,58,138,0.25);
            --navy-border:#1e3a8a;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg); color: var(--txt);
            display: flex; min-height: 100vh;
            transition: background .2s, color .2s;
        }

        /* ============ SIDEBAR ============ */
        .sidebar-rail {
            width: 72px; height: 100vh;
            position: fixed; top: 0; left: 0;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border);
            display: flex; flex-direction: column; align-items: center;
            padding: 1.25rem 0; z-index: 1040;
            box-shadow: 2px 0 8px rgba(0,0,0,0.04);
            transition: background .2s, border-color .2s;
        }

        .brand-logo-icon {
            width: 44px; height: 44px; border-radius: 12px;
            background: var(--navy); color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            box-shadow: 0 4px 12px rgba(30,58,138,0.35);
            margin-bottom: 2rem; text-decoration: none;
            transition: transform .15s ease;
        }
        .brand-logo-icon:hover { transform: scale(1.06); color: #fff; }

        .sidebar-nav {
            display: flex; flex-direction: column; align-items: center;
            gap: .85rem; width: 100%; list-style: none; padding: 0; margin: 0;
        }

        .sidebar-icon-link {
            width: 44px; height: 44px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: var(--txt2); text-decoration: none; font-size: 1.25rem;
            transition: all .15s ease; position: relative;
        }
        .sidebar-icon-link:hover { background: var(--navy-soft); color: var(--navy); }
        .sidebar-icon-link.active {
            background: var(--navy); color: #fff;
            box-shadow: 0 4px 12px rgba(30,58,138,0.3);
        }

        .sidebar-bottom { margin-top: auto; display: flex; flex-direction: column; align-items: center; gap: .5rem; }

        .logout-icon-link {
            width: 44px; height: 44px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: var(--txt2); text-decoration: none; font-size: 1.25rem;
            transition: all .15s ease;
        }
        .logout-icon-link:hover { background: #fef2f2; color: #ef4444; }

        .theme-btn {
            width: 44px; height: 44px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: var(--txt2); background: none; border: none; cursor: pointer;
            font-size: 1.15rem; transition: all .15s ease;
        }
        .theme-btn:hover { background: var(--navy-soft); color: var(--navy); }

        /* ============ MAIN CONTENT ============ */
        .main-content {
            margin-left: 72px; width: calc(100% - 72px);
            min-height: 100vh; display: flex; flex-direction: column;
        }

        /* ============ TOPBAR ============ */
        .topbar-clean {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.25rem 3rem 1rem;
            background: var(--card);
            border-bottom: 1px solid var(--border);
            transition: background .2s, border-color .2s;
        }
        .btn-pill-outline {
            background: var(--card);
            color: var(--txt);
            border: 1px solid var(--border);
            border-radius: 9999px;
            padding: 0.5rem 1.2rem;
            font-size: 0.82rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s ease;
        }
        .btn-pill-outline:hover {
            border-color: var(--navy);
            color: var(--navy);
            background: var(--navy-soft);
        }

        /* ============ HERO BANNER ============ */
        .hero {
            background: var(--hero-grad);
            color: #fff; padding: 2.5rem 3rem 2rem;
            position: relative; overflow: hidden;
        }
        .hero::before {
            content:''; position:absolute; top:-80px; right:-80px;
            width:320px; height:320px; border-radius:50%;
            background:rgba(255,255,255,0.04);
        }
        .hero-img {
            position:absolute; top:0; right:0;
            width:400px; height:100%; object-fit:cover;
            opacity:0.22; mix-blend-mode:luminosity;
        }
        .hero-badge {
            display:inline-flex; align-items:center; gap:.4rem;
            background:rgba(255,255,255,0.13); border:1px solid rgba(255,255,255,0.22);
            border-radius:99px; padding:.3rem .9rem;
            font-size:.78rem; font-weight:700; backdrop-filter:blur(8px);
            margin-bottom:1rem;
        }
        .hero-title { font-size:2.1rem; font-weight:800; letter-spacing:-.04em; line-height:1.1; margin-bottom:.4rem; }
        .hero-subtitle { font-size:1rem; opacity:.82; font-weight:500; margin-bottom:1.75rem; max-width:700px; }

        .hero-stats { display:flex; gap:2.25rem; flex-wrap:wrap; }
        .hstat { display:flex; flex-direction:column; }
        .hstat-num { font-size:1.6rem; font-weight:800; font-family:'JetBrains Mono',monospace; }
        .hstat-lbl { font-size:.7rem; opacity:.65; font-weight:700; text-transform:uppercase; letter-spacing:.07em; }

        /* ============ KPI CARDS ============ */
        .kpi-grid {
            display:grid; grid-template-columns:repeat(4,1fr); gap:1rem;
            padding:1.75rem 3rem 0;
        }
        @media(max-width:1200px){ .kpi-grid{ grid-template-columns:repeat(2,1fr); } }
        @media(max-width:768px){ .kpi-grid{ grid-template-columns:1fr; padding:1rem; } }

        .kpi-card {
            background:var(--card); border:1px solid var(--border);
            border-radius:16px; padding:1.25rem 1.3rem;
            box-shadow:0 2px 8px rgba(0,0,0,0.03);
            transition:transform .2s, box-shadow .2s;
            cursor:pointer;
        }
        .kpi-card:hover { transform:translateY(-3px); box-shadow:0 8px 20px rgba(0,0,0,0.07); }
        .kpi-card-top { display:flex; align-items:center; justify-content:space-between; margin-bottom:.75rem; }
        .kpi-icon {
            width:40px; height:40px; border-radius:10px;
            display:flex; align-items:center; justify-content:center; font-size:1.15rem;
        }
        .kpi-chip { font-size:.7rem; font-weight:700; border-radius:99px; padding:.2rem .65rem; }
        .kpi-lbl { font-size:.75rem; font-weight:600; color:var(--txt2); margin-bottom:.25rem; text-transform:uppercase; letter-spacing:.05em; }
        .kpi-num { font-size:2rem; font-weight:800; letter-spacing:-.03em; color:var(--txt); line-height:1; }
        .kpi-sub { font-size:.78rem; color:var(--txt2); margin-top:.5rem; display:flex; align-items:center; gap:.3rem; }

        /* ============ SECTION TABS ============ */
        .portal-tabs {
            padding:1.5rem 3rem .75rem;
            display:flex; gap:.5rem; flex-wrap:wrap; align-items:center;
        }
        .portal-tab-btn {
            padding:.5rem 1.25rem; border-radius:99px; font-size:.85rem; font-weight:700;
            border:1.5px solid var(--border); background:var(--card); color:var(--txt2);
            cursor:pointer; transition:all .15s ease; display:inline-flex; align-items:center; gap:.4rem;
        }
        .portal-tab-btn:hover { border-color:var(--navy); color:var(--navy); }
        .portal-tab-btn.active { background:var(--navy); color:#fff; border-color:var(--navy); }

        /* ============ PANELS & TABLES ============ */
        .table-card {
            margin:0 3rem 2.5rem; background:var(--card);
            border:1px solid var(--border); border-radius:18px; overflow:hidden;
            box-shadow:0 4px 16px rgba(0,0,0,0.04);
            transition:background .2s, border-color .2s;
        }
        .table-card-header {
            padding:1.25rem 1.75rem; border-bottom:1px solid var(--border);
            display:flex; align-items:center; justify-content:space-between;
            background:var(--table-head);
        }
        .table-card-title { font-size:1rem; font-weight:800; color:var(--txt); display:flex; align-items:center; gap:.5rem; }

        .portal-table { width:100%; border-collapse:collapse; }
        .portal-table thead th {
            padding:.9rem 1.2rem; font-size:.72rem; font-weight:700;
            text-transform:uppercase; letter-spacing:.06em; color:var(--txt2);
            background:var(--table-head); border-bottom:1px solid var(--border);
            white-space:nowrap;
        }
        .portal-table tbody td {
            padding:.9rem 1.2rem; border-bottom:1px solid var(--border);
            font-size:.88rem; color:var(--txt); vertical-align:middle;
        }
        .portal-table tbody tr:last-child td { border-bottom:none; }
        .portal-table tbody tr:hover td { background:var(--table-hover); }

        /* Badges */
        .status-badge {
            display:inline-flex; align-items:center; gap:.3rem;
            font-size:.72rem; font-weight:700; padding:.25rem .7rem;
            border-radius:99px; white-space:nowrap;
        }
        .badge-pending    { background:#fef3c7; color:#b45309; border:1px solid #fde68a; }
        .badge-dispatched { background:#dbeafe; color:#1d4ed8; border:1px solid #bfdbfe; }
        .badge-approved   { background:#dcfce7; color:#15803d; border:1px solid #bbf7d0; }
        .badge-rejected   { background:#fee2e2; color:#dc2626; border:1px solid #fecaca; }
        [data-theme='dark'] .badge-pending    { background:rgba(180,83,9,.2);  color:#fbbf24; border-color:rgba(180,83,9,.4);  }
        [data-theme='dark'] .badge-dispatched { background:rgba(29,78,216,.2); color:#60a5fa; border-color:rgba(29,78,216,.4); }
        [data-theme='dark'] .badge-approved   { background:rgba(21,128,61,.2); color:#4ade80; border-color:rgba(21,128,61,.4); }
        [data-theme='dark'] .badge-rejected   { background:rgba(220,38,38,.2); color:#f87171; border-color:rgba(220,38,38,.4); }

        .sku-tag {
            font-family:'JetBrains Mono',monospace; font-size:.82rem; font-weight:700;
            color:var(--navy); background:var(--navy-soft); border:1px solid var(--navy-border);
            border-radius:7px; padding:.2rem .55rem;
        }
        [data-theme='dark'] .sku-tag { color:#93c5fd; }

        .btn-dispatch {
            background:var(--navy); color:#fff; border:none;
            padding:.4rem 1rem; border-radius:8px; font-size:.8rem; font-weight:700;
            display:inline-flex; align-items:center; gap:.35rem; cursor:pointer;
            transition:all .15s ease;
        }
        .btn-dispatch:hover { background:var(--navy-dark); transform:translateY(-1px); }

        .btn-clean-sm {
            background:var(--pill-bg); color:var(--txt2); border:1px solid var(--border);
            padding:.35rem .75rem; border-radius:7px; font-size:.78rem; font-weight:600;
            cursor:pointer; transition:all .15s;
        }
        .btn-clean-sm:hover { background:var(--navy-soft); color:var(--navy); border-color:var(--navy-border); }

        /* Empty state */
        .empty-state { text-align:center; padding:3.5rem 1rem; color:var(--txt2); }
        .empty-state i { font-size:3.5rem; opacity:.25; display:block; margin-bottom:1rem; }

        /* Modals */
        .modal-content {
            background:var(--modal-bg); border:1px solid var(--border);
            border-radius:18px; color:var(--txt);
        }
        .modal-header {
            background:var(--modal-header); border-bottom:1px solid var(--border);
            border-radius:18px 18px 0 0; padding:1.1rem 1.5rem;
        }
        .modal-footer {
            background:var(--modal-header); border-top:1px solid var(--border);
            border-radius:0 0 18px 18px;
        }
        .form-control, .form-select {
            background:var(--input-bg) !important; border-color:var(--border) !important;
            color:var(--txt) !important; border-radius:8px;
        }
        .form-label { color:var(--txt2); font-size:.82rem; font-weight:700; }
        [data-theme='dark'] .btn-close { filter:invert(1) brightness(1.5); }

        @media(max-width:768px){
            .main-content { margin-left:0; width:100%; }
            .sidebar-rail { display:none; }
            .hero { padding:1.5rem; }
            .kpi-grid, .portal-tabs, .table-card { padding-left:1rem; padding-right:1rem; margin-left:0; margin-right:0; }
            .hero-img { display:none; }
        }
    </style>
</head>
<body>

    <!-- ============================= -->
    <!-- LEFT SIDEBAR                  -->
    <!-- ============================= -->
    <aside class="sidebar-rail">
        <a href="javascript:void(0)" onclick="openAccountModal()" class="brand-logo-icon" title="My Account & Profile Details">
            <i class="bi bi-person-circle"></i>
        </a>

        <ul class="sidebar-nav">
            <li>
                <a href="/supplier" class="sidebar-icon-link" title="Incoming Purchase Orders">
                    <i class="bi bi-inbox-fill"></i>
                </a>
            </li>
            <li>
                <a href="/supplier/deliveries" class="sidebar-icon-link active" title="Dispatched Deliveries & QA">
                    <i class="bi bi-clipboard2-check-fill"></i>
                </a>
            </li>
            <li>
                <a href="/supplier/network" class="sidebar-icon-link" title="Supplier Network Directory">
                    <i class="bi bi-buildings-fill"></i>
                </a>
            </li>
        </ul>

        <div class="sidebar-bottom">
            <button class="theme-btn" onclick="toggleTheme()" title="Toggle Dark/Light Mode">
                <i id="themeIcon" class="bi bi-moon-stars-fill"></i>
            </button>
            <a href="/logout" class="logout-icon-link" title="Logout">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </aside>

    <!-- ============================= -->
    <!-- MAIN CONTENT                  -->
    <!-- ============================= -->
    <div class="main-content">

        <!-- TOPBAR: ACCOUNT DETAILS UPPER RIGHT CORNER -->
        <header class="topbar-clean">
            <div class="d-flex align-items-center gap-2">
                <span class="badge" style="background:var(--navy-soft);color:var(--navy);font-weight:700;font-size:0.75rem;border:1px solid var(--navy-border);padding:0.4rem 0.8rem;border-radius:99px;">
                    <i class="bi bi-clipboard2-check me-1"></i> DELIVERIES &amp; QA
                </span>
                <span class="text-muted small fw-semibold d-none d-md-inline">&middot; Dispatched Shipments Clearance Log</span>
            </div>
            <div class="d-flex align-items-center gap-2">
                <button type="button" class="btn-pill-outline" onclick="openAccountModal()" title="My Account Profile">
                    <i class="bi bi-person-circle" style="color:var(--navy);font-size:1.1rem;"></i>
                    <span>${not empty sessionScope.fullName ? sessionScope.fullName : (not empty sessionScope.currentUser ? sessionScope.currentUser : 'Supplier Partner')}</span>
                </button>
                <button type="button" class="btn-pill-outline" onclick="toggleTheme()" title="Toggle Dark/Light Mode" style="padding:0.5rem 0.8rem;">
                    <i id="topbarThemeIcon" class="bi bi-moon-stars-fill"></i>
                </button>
            </div>
        </header>

        <!-- HERO BANNER -->
        <div class="hero">
            <img class="hero-img"
                 src="https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=900&q=85&fit=crop"
                 alt="Supplier Logistics">
            <div style="position:relative;z-index:2;">
                <div class="hero-badge">
                    <i class="bi bi-clipboard2-check" style="color:#67e8f9;"></i>
                    Deliveries &amp; QA Inspection Tracking
                </div>
                <h1 class="hero-title">Dispatched Deliveries &amp; QA Clearance</h1>
                <p class="hero-subtitle">
                    Monitor all dispatched shipments delivered to Spare Part Management and track real-time quality approval verdicts.
                    <c:if test="${not empty sessionScope.fullName}">
                        &nbsp;&middot;&nbsp;
                        <span style="background:rgba(255,255,255,.14);border:1px solid rgba(255,255,255,.24);border-radius:99px;padding:.2rem .75rem;font-size:.8rem;">
                            <i class="bi bi-building-check me-1" style="color:#67e8f9;"></i>${sessionScope.fullName}
                        </span>
                    </c:if>
                </p>

                <div class="hero-stats">
                    <div class="hstat">
                        <span class="hstat-num" style="color:#60a5fa;">${dispatchedOrdersCount}</span>
                        <span class="hstat-lbl">Dispatched Batches</span>
                    </div>
                    <div class="hstat">
                        <span class="hstat-num" style="color:#4ade80;">${approvedCount}</span>
                        <span class="hstat-lbl">QA Approved</span>
                    </div>
                    <div class="hstat">
                        <span class="hstat-num" style="color:#fbbf24;">${pendingQACount}</span>
                        <span class="hstat-lbl">Awaiting QA</span>
                    </div>
                    <div class="hstat">
                        <span class="hstat-num">${totalDispatchedUnits}</span>
                        <span class="hstat-lbl">Total Units Shipped</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- FLASH MESSAGES -->
        <div style="padding:1rem 3rem 0;">
            <c:if test="${not empty successMessage}">
                <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 py-3 px-4 border" role="alert">
                    <i class="bi bi-check-circle-fill text-success fs-5"></i>
                    <div class="fw-semibold text-success">${successMessage}</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show d-flex align-items-center gap-2 py-3 px-4 border" role="alert">
                    <i class="bi bi-exclamation-triangle-fill text-danger fs-5"></i>
                    <div class="fw-semibold text-danger">${errorMessage}</div>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
        </div>

        <!-- KPI CARDS -->
        <div class="kpi-grid">
            <!-- 1: Pending Orders -->
            <div class="kpi-card" onclick="window.location.href='/supplier'">
                <div class="kpi-card-top">
                    <div class="kpi-icon" style="background:#fef3c7;color:#b45309;"><i class="bi bi-inbox-fill"></i></div>
                    <span class="kpi-chip" style="background:#fef3c7;color:#b45309;">Orders</span>
                </div>
                <div class="kpi-lbl">Pending Part Requests</div>
                <div class="kpi-num" style="color:#b45309;">${pendingOrdersCount}</div>
                <div class="kpi-sub"><i class="bi bi-clock-history text-warning"></i> Ready to dispatch</div>
            </div>

            <!-- 2: Dispatched Batches -->
            <div class="kpi-card" onclick="window.location.href='/supplier/deliveries'">
                <div class="kpi-card-top">
                    <div class="kpi-icon" style="background:#dbeafe;color:#1d4ed8;"><i class="bi bi-truck"></i></div>
                    <span class="kpi-chip" style="background:#dbeafe;color:#1d4ed8;">Active</span>
                </div>
                <div class="kpi-lbl">Dispatched Batches</div>
                <div class="kpi-num" style="color:#1d4ed8;">${dispatchedOrdersCount}</div>
                <div class="kpi-sub"><i class="bi bi-box-arrow-up-right text-primary"></i> Delivered to warehouse</div>
            </div>

            <!-- 3: Quality Approved -->
            <div class="kpi-card" onclick="window.location.href='/supplier/deliveries'">
                <div class="kpi-card-top">
                    <div class="kpi-icon" style="background:#dcfce7;color:#15803d;"><i class="bi bi-shield-check"></i></div>
                    <span class="kpi-chip" style="background:#dcfce7;color:#15803d;">Passed QA</span>
                </div>
                <div class="kpi-lbl">QA Approved Batches</div>
                <div class="kpi-num" style="color:#15803d;">${approvedCount}</div>
                <div class="kpi-sub"><i class="bi bi-check-all text-success"></i> Cleared for inventory</div>
            </div>

            <!-- 4: Supplier Directory -->
            <div class="kpi-card" onclick="window.location.href='/supplier/network'">
                <div class="kpi-card-top">
                    <div class="kpi-icon" style="background:#eff6ff;color:var(--navy);"><i class="bi bi-buildings"></i></div>
                    <span class="kpi-chip" style="background:#eff6ff;color:var(--navy);">Network</span>
                </div>
                <div class="kpi-lbl">Authorized Suppliers</div>
                <div class="kpi-num">${totalSuppliers}</div>
                <div class="kpi-sub"><i class="bi bi-people-fill text-primary"></i> Active vendor partners</div>
            </div>
        </div>

        <!-- PORTAL NAVIGATION PILLS -->
        <div class="portal-tabs">
            <a href="/supplier" class="portal-tab-btn" id="tabBtnOrders" style="text-decoration:none;">
                <i class="bi bi-bell-fill"></i> Incoming Requests from Spare Part Manager
                <c:if test="${pendingOrdersCount > 0}">
                    <span style="background:#ef4444;color:#fff;border-radius:99px;font-size:.68rem;padding:.12rem .5rem;">${pendingOrdersCount}</span>
                </c:if>
            </a>
            <a href="/supplier/deliveries" class="portal-tab-btn active" id="tabBtnDeliveries" style="text-decoration:none;">
                <i class="bi bi-clipboard2-check"></i> Dispatched Deliveries &amp; QA Results
            </a>
            <a href="/supplier/network" class="portal-tab-btn" id="tabBtnSuppliers" style="text-decoration:none;">
                <i class="bi bi-buildings"></i> Suppliers Network Directory (CRUD)
            </a>
        </div>

        <!-- =========================================================
             DISPATCHED DELIVERIES & QA RESULTS TABLE
        ========================================================= -->
        <div class="table-card mt-1">
            <div class="table-card-header">
                <div class="table-card-title">
                    <i class="bi bi-truck text-primary"></i>
                    Dispatched Shipments &amp; Live QA Inspection Status
                </div>
                <span class="small" style="color:var(--txt2);font-weight:600;">${deliveries.size()} total delivery batch(es)</span>
            </div>

            <c:choose>
                <c:when test="${empty deliveries}">
                    <div class="empty-state">
                        <i class="bi bi-box-seam"></i>
                        <h6 style="color:var(--txt);font-weight:700;">No Shipments Yet</h6>
                        <p style="font-size:.88rem;">Dispatched part batches will appear here alongside Spare Part Manager inspection verdicts.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="overflow-x:auto;">
                        <table class="portal-table">
                            <thead>
                                <tr>
                                    <th>Batch #</th>
                                    <th>Supplier</th>
                                    <th>Part SKU</th>
                                    <th>Part Name</th>
                                    <th>Shipped Qty</th>
                                    <th>Unit Cost</th>
                                    <th>Dispatch Date</th>
                                    <th>QA Verdict</th>
                                    <th>Inspection Notes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="deliv" items="${deliveries}">
                                    <tr id="delivery-row-${deliv.batchId}">
                                        <td><span class="sku-tag">#B-${deliv.batchId}</span></td>
                                        <td class="fw-semibold" style="color:var(--txt);">${deliv.supplierName}</td>
                                        <td><span class="sku-tag">${deliv.partId}</span></td>
                                        <td class="fw-bold" style="color:var(--txt);">${deliv.partName}</td>
                                        <td><span class="badge bg-secondary px-2 py-1">${deliv.receivedQty} Units</span></td>
                                        <td style="font-family:'JetBrains Mono',monospace;color:var(--navy);font-weight:700;">
                                            Rs.&nbsp;<fmt:formatNumber value="${deliv.supplierPrice}" pattern="#,##0.00"/>
                                        </td>
                                        <td style="color:var(--txt2);font-size:.82rem;">${deliv.arrivalDate}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${deliv.approved}">
                                                    <span class="status-badge badge-approved"><i class="bi bi-check-circle-fill"></i>APPROVED (In Stock)</span>
                                                </c:when>
                                                <c:when test="${deliv.rejected}">
                                                    <span class="status-badge badge-rejected"><i class="bi bi-x-circle-fill"></i>REJECTED</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge badge-pending"><i class="bi bi-hourglass-split"></i>Awaiting QA</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="small" style="color:var(--txt2);max-width:260px;">
                                            ${deliv.qualityNotes}
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div><!-- /main-content -->

    <!-- ============================================ -->
    <!-- ACCOUNT MODAL                                -->
    <!-- ============================================ -->
    <div class="modal fade" id="accountModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered" style="max-width:420px;">
            <div class="modal-content">
                <div class="modal-header" style="background:linear-gradient(135deg, #1e3a8a, #0284c7);color:#fff;border-radius:18px 18px 0 0;">
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-person-circle fs-5"></i>
                        <h6 class="modal-title fw-bold mb-0">Supplier Account Profile</h6>
                    </div>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="/account/update-profile" method="post" autocomplete="off">
                        <input type="hidden" name="redirectUrl" value="/supplier/deliveries">
                        <div class="mb-3">
                            <label class="form-label">Full Partner Name</label>
                            <input type="text" name="fullName" class="form-control"
                                   value="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.currentUser}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control"
                                   value="${not empty sessionScope.email ? sessionScope.email : ''}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">New Password (leave blank to keep)</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="Min 4 characters">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Confirm Password</label>
                            <input type="password" name="confirmNewPassword" class="form-control">
                        </div>
                        <button type="submit" class="btn-dispatch w-100 justify-content-center mt-3">
                            <i class="bi bi-check-circle-fill"></i> Save Profile
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        /* ── DARK MODE ── */
        function toggleTheme() {
            var h = document.documentElement;
            var dark = h.getAttribute('data-theme') === 'dark';
            var next = dark ? 'light' : 'dark';
            h.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            var iconClass = dark ? 'bi bi-moon-stars-fill' : 'bi bi-sun-fill';
            var i1 = document.getElementById('themeIcon');
            var i2 = document.getElementById('topbarThemeIcon');
            if (i1) i1.className = iconClass;
            if (i2) i2.className = iconClass;
        }
        (function(){
            var s = localStorage.getItem('theme') || 'light';
            var iconClass = s === 'dark' ? 'bi bi-sun-fill' : 'bi bi-moon-stars-fill';
            var i1 = document.getElementById('themeIcon');
            var i2 = document.getElementById('topbarThemeIcon');
            if (i1) i1.className = iconClass;
            if (i2) i2.className = iconClass;
        })();

        /* ── ACCOUNT MODAL ── */
        function openAccountModal() {
            new bootstrap.Modal(document.getElementById('accountModal')).show();
        }
    </script>
</body>
</html>
