<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Commercial Sales Command | PartTrack Atelier</title>
    <script>
        (function(){
            var s = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', s);
        })();
    </script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700;800;900&family=Space+Grotesk:wght@500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --bg: #090d16;
            --sidebar-bg: #0d1322;
            --card: #111827;
            --card-subtle: #172134;
            --border: #1f2d45;
            --border-hover: #334a6e;
            --txt: #f8fafc;
            --txt2: #94a3b8;
            --txt-muted: #64748b;
            
            /* Emerald & Amber Commercial Palette */
            --sales-gold: #f59e0b;
            --sales-gold-soft: rgba(245, 158, 11, 0.14);
            --sales-emerald: #10b981;
            --sales-emerald-soft: rgba(16, 185, 129, 0.14);
            --sales-cyan: #06b6d4;
            --sales-cyan-soft: rgba(6, 182, 212, 0.14);
            --sales-crimson: #f43f5e;
            
            --table-head: #0e1626;
            --table-hover: #162238;
            --pill-bg: #152033;
            --shadow-glow: 0 10px 30px -10px rgba(16, 185, 129, 0.2);
            --radius-lg: 22px;
            --radius-md: 14px;
        }

        [data-theme="light"] {
            --bg: #f4f6fa;
            --sidebar-bg: #ffffff;
            --card: #ffffff;
            --card-subtle: #f1f4f9;
            --border: #e2e8f0;
            --border-hover: #cbd5e1;
            --txt: #0f172a;
            --txt2: #475569;
            --txt-muted: #94a3b8;
            
            --sales-gold: #d97706;
            --sales-gold-soft: rgba(217, 119, 6, 0.1);
            --sales-emerald: #059669;
            --sales-emerald-soft: rgba(5, 150, 105, 0.1);
            --sales-cyan: #0891b2;
            --sales-cyan-soft: rgba(8, 145, 178, 0.1);
            --sales-crimson: #e11d48;
            
            --table-head: #f8fafc;
            --table-hover: #f1f5f9;
            --pill-bg: #e2e8f0;
            --shadow-glow: 0 10px 25px -8px rgba(0, 0, 0, 0.08);
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Outfit', sans-serif;
            background-color: var(--bg);
            color: var(--txt);
            min-height: 100vh;
            margin: 0;
            display: flex;
            transition: background-color 0.25s ease, color 0.25s ease;
            -webkit-font-smoothing: antialiased;
        }

        /* ── LUXURY SLIM RAIL (COMMERCIAL THEME) ── */
        .sales-rail {
            width: 80px;
            height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1.6rem 0;
            z-index: 1040;
            box-shadow: 4px 0 24px rgba(0,0,0,0.15);
        }

        .sales-brand-avatar {
            width: 46px;
            height: 46px;
            border-radius: 14px;
            background: linear-gradient(135deg, #10b981 0%, #047857 100%);
            color: #ffffff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
            margin-bottom: 2.2rem;
            cursor: pointer;
            box-shadow: 0 6px 18px rgba(16, 185, 129, 0.35);
            transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
        }
        .sales-brand-avatar:hover { transform: scale(1.08) rotate(2deg); }

        .sales-nav-list {
            list-style: none;
            padding: 0;
            margin: 0;
            display: flex;
            flex-direction: column;
            gap: 0.9rem;
            width: 100%;
            align-items: center;
        }

        .sales-nav-item {
            width: 48px;
            height: 48px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--txt2);
            font-size: 1.28rem;
            text-decoration: none;
            position: relative;
            transition: all 0.2s ease;
        }
        .sales-nav-item:hover {
            color: #10b981;
            background: var(--sales-emerald-soft);
        }
        .sales-nav-item.active {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #ffffff;
            box-shadow: 0 4px 16px rgba(16, 185, 129, 0.4);
        }

        .badge-pulse-dot {
            width: 9px;
            height: 9px;
            background-color: var(--sales-gold);
            border: 2px solid var(--sidebar-bg);
            border-radius: 50%;
            position: absolute;
            top: 8px;
            right: 8px;
            box-shadow: 0 0 8px var(--sales-gold);
        }

        .sales-rail-footer {
            margin-top: auto;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 0.75rem;
        }

        .sales-btn-ctrl {
            width: 44px;
            height: 44px;
            border-radius: 13px;
            border: 1px solid var(--border);
            background: var(--card-subtle);
            color: var(--txt2);
            font-size: 1.15rem;
            display: flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .sales-btn-ctrl:hover {
            color: var(--txt);
            border-color: var(--border-hover);
            transform: translateY(-2px);
        }
        .sales-btn-ctrl.logout:hover {
            color: #f43f5e;
            border-color: rgba(244, 63, 94, 0.4);
            background: rgba(244, 63, 94, 0.12);
        }

        /* ── MAIN VIEWPORT ── */
        .sales-viewport {
            margin-left: 80px;
            padding: 2.25rem 3.5rem;
            width: calc(100% - 80px);
            min-height: 100vh;
            max-width: 1640px;
        }

        /* ── LUXURY HEADER ── */
        .sales-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .sales-headline {
            font-size: 1.6rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin: 0;
            color: var(--txt);
            display: flex;
            align-items: center;
            gap: 0.6rem;
        }

        .sales-tagline {
            font-size: 0.85rem;
            color: var(--txt-muted);
            margin: 0;
            font-weight: 400;
        }

        /* ── PILL BUTTONS ── */
        .btn-emerald-pill {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #ffffff !important;
            border: none;
            border-radius: 9999px;
            padding: 0.6rem 1.45rem;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.03em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.3);
            transition: all 0.2s ease;
        }
        .btn-emerald-pill:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(16, 185, 129, 0.45);
        }

        .btn-gold-pill {
            background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
            color: #ffffff !important;
            border: none;
            border-radius: 9999px;
            padding: 0.6rem 1.45rem;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.03em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            box-shadow: 0 4px 14px rgba(245, 158, 11, 0.3);
            transition: all 0.2s ease;
        }
        .btn-gold-pill:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 22px rgba(245, 158, 11, 0.45);
        }

        .btn-glass-pill {
            background: rgba(255, 255, 255, 0.08);
            color: #ffffff !important;
            border: 1px solid rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border-radius: 9999px;
            padding: 0.6rem 1.45rem;
            font-size: 0.82rem;
            font-weight: 700;
            letter-spacing: 0.03em;
            text-transform: uppercase;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-glass-pill:hover {
            background: rgba(255, 255, 255, 0.18);
            transform: translateY(-2px);
        }

        /* ── BRAND SHOWROOM HERO BANNER ── */
        .sales-hero-banner {
            position: relative;
            height: 350px;
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 2.25rem;
            display: flex;
            flex-direction: column;
            justify-content: flex-end;
            padding: 2.8rem 3.2rem;
            background: #080d19;
            box-shadow: var(--shadow-glow);
            border: 1px solid var(--border);
        }
        .sales-hero-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center 42%;
            opacity: 0.65;
            transition: transform 0.6s ease;
        }
        .sales-hero-banner:hover .sales-hero-bg { transform: scale(1.025); }
        .sales-hero-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(180deg, rgba(8,13,25,0.2) 0%, rgba(8,13,25,0.7) 45%, rgba(8,13,25,0.96) 100%);
        }
        .sales-hero-content {
            position: relative;
            z-index: 2;
            color: #ffffff;
            max-width: 960px;
        }

        .sales-stat-bar {
            display: flex;
            gap: 2.5rem;
            margin-bottom: 1.25rem;
            flex-wrap: wrap;
        }
        .sales-stat-cell { display: flex; flex-direction: column; }
        .sales-stat-val {
            font-size: 1.55rem;
            font-weight: 800;
            color: #ffffff;
            font-family: 'Space Grotesk', sans-serif;
            letter-spacing: -0.02em;
            line-height: 1;
        }
        .sales-stat-label {
            font-size: 0.72rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: rgba(255, 255, 255, 0.7);
            font-weight: 600;
            margin-top: 0.35rem;
        }

        .sales-hero-title {
            font-size: 2.35rem;
            font-weight: 900;
            letter-spacing: -0.04em;
            line-height: 1.1;
            margin: 0 0 0.6rem 0;
            background: linear-gradient(135deg, #ffffff 30%, #a7f3d0 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }
        .sales-hero-sub {
            font-size: 0.95rem;
            color: rgba(255, 255, 255, 0.85);
            margin: 0 0 1.6rem 0;
            max-width: 720px;
            font-weight: 400;
            line-height: 1.5;
        }

        /* ── 5 COMMERCIAL GLOW CARDS ── */
        .commercial-grid {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 1.25rem;
            margin-bottom: 2.25rem;
        }
        @media(max-width: 1350px) { .commercial-grid { grid-template-columns: repeat(3, 1fr); } }
        @media(max-width: 768px) { .commercial-grid { grid-template-columns: repeat(1, 1fr); } }

        .commercial-card {
            background-color: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 1.4rem;
            position: relative;
            overflow: hidden;
            transition: all 0.25s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .commercial-card:hover {
            transform: translateY(-3px);
            border-color: var(--border-hover);
            box-shadow: 0 12px 28px rgba(0,0,0,0.18);
        }

        .commercial-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 3px;
            background: transparent;
            transition: background 0.25s;
        }
        .commercial-card.green::before { background: var(--sales-emerald); }
        .commercial-card.amber::before { background: var(--sales-gold); }
        .commercial-card.cyan::before { background: var(--sales-cyan); }
        .commercial-card.purple::before { background: #8b5cf6; }

        .comm-card-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.1rem;
        }
        .comm-icon-sphere {
            width: 42px;
            height: 42px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }
        .comm-pill-tag {
            font-size: 0.68rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            padding: 0.25rem 0.65rem;
            border-radius: 9999px;
        }

        .comm-num {
            font-size: 1.9rem;
            font-weight: 800;
            font-family: 'Space Grotesk', sans-serif;
            letter-spacing: -0.03em;
            color: var(--txt);
            line-height: 1;
            margin-bottom: 0.35rem;
        }
        .comm-lbl {
            font-size: 0.75rem;
            color: var(--txt-muted);
            text-transform: uppercase;
            letter-spacing: 0.06em;
            font-weight: 600;
            margin: 0;
        }

        /* ── SECTION BENTO CARDS ── */
        .atelier-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 2rem;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
        }
        .atelier-head {
            padding: 1.25rem 1.8rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            background: var(--table-head);
        }
        .atelier-title {
            font-size: 1.05rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            color: var(--txt);
            display: flex;
            align-items: center;
            gap: 0.6rem;
            margin: 0;
        }

        /* ── ATELIER LUXURY TABLE ── */
        .atelier-table {
            width: 100%;
            border-collapse: collapse;
        }
        .atelier-table thead th {
            padding: 0.9rem 1.5rem;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--txt-muted);
            background: var(--table-head);
            border-bottom: 1px solid var(--border);
            white-space: nowrap;
        }
        .atelier-table tbody td {
            padding: 1.05rem 1.5rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.88rem;
            color: var(--txt);
            vertical-align: middle;
            transition: background 0.15s;
        }
        .atelier-table tbody tr:last-child td { border-bottom: none; }
        .atelier-table tbody tr:hover td { background: var(--table-hover); }

        .order-badge-token {
            font-family: 'Space Grotesk', monospace;
            font-weight: 700;
            font-size: 0.82rem;
            background: var(--card-subtle);
            border: 1px solid var(--border);
            padding: 0.25rem 0.6rem;
            border-radius: 8px;
            color: #10b981;
        }

        .status-pill-glow {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            font-size: 0.72rem;
            font-weight: 700;
            padding: 0.35rem 0.85rem;
            border-radius: 9999px;
            white-space: nowrap;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .status-pill-glow.pending { background: rgba(245, 158, 11, 0.16); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.35); }
        .status-pill-glow.processing { background: rgba(6, 182, 212, 0.16); color: #06b6d4; border: 1px solid rgba(6, 182, 212, 0.35); }
        .status-pill-glow.completed { background: rgba(16, 185, 129, 0.16); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.35); }
        .status-pill-glow.cancelled { background: rgba(244, 63, 94, 0.16); color: #f43f5e; border: 1px solid rgba(244, 63, 94, 0.35); }

        .btn-outline-glass {
            padding: 0.4rem 0.85rem;
            border-radius: 10px;
            font-size: 0.78rem;
            font-weight: 700;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            border: 1px solid var(--border);
            background: var(--card-subtle);
            color: var(--txt);
            cursor: pointer;
            transition: all 0.15s ease;
        }
        .btn-outline-glass:hover {
            border-color: #10b981;
            color: #10b981;
            background: var(--sales-emerald-soft);
        }

        /* ── MODALS ── */
        .modal-content {
            background-color: var(--card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: 0 25px 60px rgba(0,0,0,0.5);
            color: var(--txt);
        }
        .modal-header {
            border-bottom: 1px solid var(--border);
            padding: 1.35rem 1.75rem;
        }
        .modal-footer {
            border-top: 1px solid var(--border);
            padding: 1.35rem 1.75rem;
        }
        .form-control, .form-select {
            background-color: var(--bg);
            border: 1px solid var(--border);
            color: var(--txt);
            border-radius: 10px;
        }
        .form-control:focus, .form-select:focus {
            background-color: var(--card);
            border-color: #10b981;
            color: var(--txt);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.25);
        }
    </style>
</head>
<body>

    <!-- SIDEBAR RAIL (3 UIs: Dashboard / Orders / Reports) -->
    <aside class="sales-rail">
        <div class="sales-brand-avatar" onclick="openAccountModal()" title="Sales Profile & Account">
            <i class="bi bi-shield-shaded"></i>
        </div>

        <ul class="sales-nav-list">
            <li>
                <!-- UI 1: Sales Operations Dashboard -->
                <a href="/sales" class="sales-nav-item active" title="Commercial Sales Dashboard">
                    <i class="bi bi-speedometer"></i>
                </a>
            </li>
            <li>
                <!-- UI 2: Customer Orders Queue -->
                <a href="/sales/orders" class="sales-nav-item" title="Customer Orders Queue & Fulfillment">
                    <i class="bi bi-bag-check"></i>
                    <c:if test="${pendingOrders > 0}">
                        <span class="badge-pulse-dot"></span>
                    </c:if>
                </a>
            </li>
            <li>
                <!-- UI 3: Commercial Audit Reports -->
                <a href="/sales/reports" class="sales-nav-item" title="Commercial Audit Reports & Transmissions">
                    <i class="bi bi-file-earmark-bar-graph"></i>
                </a>
            </li>
        </ul>

        <div class="sales-rail-footer">
            <button class="sales-btn-ctrl" onclick="toggleTheme()" title="Toggle Theme">
                <i class="bi bi-moon-stars" id="themeIcon"></i>
            </button>
            <a href="/logout" class="sales-btn-ctrl logout" title="Logout">
                <i class="bi bi-power"></i>
            </a>
        </div>
    </aside>

    <!-- MAIN VIEWPORT -->
    <main class="sales-viewport">

        <!-- TOPBAR -->
        <header class="sales-header">
            <div>
                <h1 class="sales-headline">
                    <i class="bi bi-gem text-warning"></i> Commercial Sales Command
                </h1>
                <p class="sales-tagline">Atelier showroom analytics &bull; Realized income telemetry &bull; Demand velocity</p>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div class="d-none d-md-flex align-items-center gap-2 px-3 py-2 rounded-pill" style="background:var(--card);border:1px solid var(--border);">
                    <span style="width:8px;height:8px;border-radius:50%;background:#10b981;box-shadow:0 0 8px #10b981;"></span>
                    <span class="small fw-semibold text-muted">Settled Cash:</span>
                    <span class="small fw-bold text-success font-monospace">Rs.&nbsp;<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></span>
                </div>
                <a href="/sales/orders" class="btn-emerald-pill">
                    <i class="bi bi-bag-check-fill"></i> Customer Orders Queue
                </a>
            </div>
        </header>

        <!-- FLASH NOTIFICATIONS -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show border-0 rounded-4 py-3 px-4 mb-4 shadow-sm" role="alert" style="background:rgba(16,185,129,0.15);color:#10b981;border:1px solid rgba(16,185,129,0.3)!important;">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <span class="fw-semibold">${successMessage}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show border-0 rounded-4 py-3 px-4 mb-4 shadow-sm" role="alert" style="background:rgba(244,63,94,0.15);color:#f43f5e;border:1px solid rgba(244,63,94,0.3)!important;">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <span class="fw-semibold">${errorMessage}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <!-- COMMERCIAL SALES DEAL HERO BANNER -->
        <section class="sales-hero-banner">
            <img src="/images/sales/commercial_sales_deal.jpg?v=2" alt="Commercial Automotive Sales Deal & Agreement" class="sales-hero-bg">
            <div class="sales-hero-overlay"></div>
            <div class="sales-hero-content">
                <div class="sales-stat-bar">
                    <div class="sales-stat-cell">
                        <span class="sales-stat-val text-success">Rs.&nbsp;<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></span>
                        <span class="sales-stat-label">Realized Cash Revenue</span>
                    </div>
                    <div class="sales-stat-cell">
                        <span class="sales-stat-val text-warning">Rs.&nbsp;<fmt:formatNumber value="${pipelineRevenue}" pattern="#,##0"/></span>
                        <span class="sales-stat-label">In-Flight Order Value</span>
                    </div>
                    <div class="sales-stat-cell">
                        <span class="sales-stat-val">${totalOrders}</span>
                        <span class="sales-stat-label">Total Store Orders</span>
                    </div>
                    <div class="sales-stat-cell">
                        <span class="sales-stat-val text-info">${pendingOrders}</span>
                        <span class="sales-stat-label">Fulfillment Queue</span>
                    </div>
                </div>
                <h2 class="sales-hero-title">PartTrack Commercial Atelier</h2>
                <p class="sales-hero-sub">Direct control room for customer purchases, live order fulfillment status, parts market demand analysis, and executive audit certification reporting.</p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="/sales/orders" class="btn-gold-pill">
                        <i class="bi bi-lightning-charge-fill"></i> Orders Fulfillment Queue (${pendingOrders} Pending)
                    </a>
                    <a href="/sales/reports" class="btn-glass-pill">
                        <i class="bi bi-file-earmark-bar-graph"></i> Executive Audit Board
                    </a>
                </div>
            </div>
        </section>

        <!-- 5 COMMERCIAL KPI CARDS -->
        <section class="commercial-grid">
            <!-- 1. Realized Cash -->
            <div class="commercial-card green">
                <div class="comm-card-head">
                    <div class="comm-icon-sphere" style="background:var(--sales-emerald-soft);color:var(--sales-emerald);">
                        <i class="bi bi-cash-stack"></i>
                    </div>
                    <span class="comm-pill-tag" style="background:var(--sales-emerald-soft);color:var(--sales-emerald);">Settled</span>
                </div>
                <div>
                    <div class="comm-num" style="color:var(--sales-emerald);">
                        Rs.&nbsp;<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/>
                    </div>
                    <p class="comm-lbl">Realized Cash (Completed)</p>
                </div>
            </div>

            <!-- 2. Processing Pipeline -->
            <div class="commercial-card cyan">
                <div class="comm-card-head">
                    <div class="comm-icon-sphere" style="background:var(--sales-cyan-soft);color:var(--sales-cyan);">
                        <i class="bi bi-boxes"></i>
                    </div>
                    <span class="comm-pill-tag" style="background:var(--sales-cyan-soft);color:var(--sales-cyan);">Packing</span>
                </div>
                <div>
                    <div class="comm-num" style="color:var(--sales-cyan);">${processingOrders}</div>
                    <p class="comm-lbl">In Warehouse Prep</p>
                </div>
            </div>

            <!-- 3. Pending Review -->
            <div class="commercial-card amber">
                <div class="comm-card-head">
                    <div class="comm-icon-sphere" style="background:var(--sales-gold-soft);color:var(--sales-gold);">
                        <i class="bi bi-hourglass-split"></i>
                    </div>
                    <span class="comm-pill-tag" style="background:var(--sales-gold-soft);color:var(--sales-gold);">Awaiting</span>
                </div>
                <div>
                    <div class="comm-num" style="color:var(--sales-gold);">${pendingOrders}</div>
                    <p class="comm-lbl">Pending Review</p>
                </div>
            </div>

            <!-- 4. Fulfilled -->
            <div class="commercial-card green">
                <div class="comm-card-head">
                    <div class="comm-icon-sphere" style="background:rgba(16,185,129,0.1);color:#10b981;">
                        <i class="bi bi-check2-circle"></i>
                    </div>
                    <span class="comm-pill-tag" style="background:rgba(16,185,129,0.1);color:#10b981;">Delivered</span>
                </div>
                <div>
                    <div class="comm-num">${completedOrders}</div>
                    <p class="comm-lbl">Completed Orders</p>
                </div>
            </div>

            <!-- 5. Gross Demand -->
            <div class="commercial-card purple">
                <div class="comm-card-head">
                    <div class="comm-icon-sphere" style="background:rgba(139,92,246,0.12);color:#8b5cf6;">
                        <i class="bi bi-graph-up-arrow"></i>
                    </div>
                    <span class="comm-pill-tag" style="background:rgba(139,92,246,0.12);color:#8b5cf6;">Scope</span>
                </div>
                <div>
                    <div class="comm-num" style="color:#a78bfa;">
                        Rs.&nbsp;<fmt:formatNumber value="${grossCommercialValue}" pattern="#,##0"/>
                    </div>
                    <p class="comm-lbl">Gross Store Demand</p>
                </div>
            </div>
        </section>

        <!-- TWO COLUMN ATELIER: TOP PARTS & TRANSMISSION SHORTCUT -->
        <div class="row g-4 mb-4">
            
            <!-- Left: Top Selling Spare Parts -->
            <div class="col-lg-6">
                <div class="atelier-card h-100">
                    <div class="atelier-head">
                        <div class="atelier-title">
                            <i class="bi bi-trophy-fill text-warning"></i> Top Selling Parts Demand
                        </div>
                        <span class="badge rounded-pill px-3 py-1" style="background:var(--sales-gold-soft);color:var(--sales-gold);border:1px solid rgba(245,158,11,0.3);font-size:0.75rem;">
                            Market Velocity
                        </span>
                    </div>

                    <c:choose>
                        <c:when test="${empty topSellingParts}">
                            <div class="p-5 text-center text-muted">
                                <i class="bi bi-box-seam fs-2 d-block mb-2"></i>
                                <div class="fw-semibold">No Sales History Yet</div>
                                <small>Rankings update automatically as customer orders are fulfilled.</small>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="table-responsive">
                                <table class="atelier-table">
                                    <thead>
                                        <tr>
                                            <th>Part Name</th>
                                            <th>SKU ID</th>
                                            <th class="text-center">Units Sold</th>
                                            <th class="text-end">Gross Sales</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="part" items="${topSellingParts}">
                                            <tr>
                                                <td class="fw-bold text-nowrap">${part.part_name}</td>
                                                <td><span class="order-badge-token">#${part.part_id}</span></td>
                                                <td class="text-center font-monospace fw-bold">${part.total_qty}</td>
                                                <td class="text-end font-monospace fw-bold text-success">
                                                    Rs.&nbsp;<fmt:formatNumber value="${part.total_sales}" pattern="#,##0.00"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Right: Executive Transmissions Snapshot -->
            <div class="col-lg-6">
                <div class="atelier-card h-100">
                    <div class="atelier-head">
                        <div class="atelier-title">
                            <i class="bi bi-file-earmark-check text-info"></i> Executive Transmissions Overview
                        </div>
                        <a href="/sales/reports" class="btn-outline-glass">
                            View All <i class="bi bi-arrow-right"></i>
                        </a>
                    </div>

                    <div class="p-4">
                        <div class="d-flex align-items-center justify-content-between p-3 rounded-4 mb-3" style="background:var(--card-subtle);border:1px solid var(--border);">
                            <div>
                                <div class="fw-bold mb-1">Administrative Audit Pipeline</div>
                                <div class="small text-muted">Verified sales audit records transmitted directly to Executive Administration.</div>
                            </div>
                            <span class="fs-3 font-monospace fw-bold text-info">${salesReports != null ? salesReports.size() : 0}</span>
                        </div>

                        <div class="d-flex align-items-center justify-content-between p-3 rounded-4 mb-4" style="background:var(--card-subtle);border:1px solid var(--border);">
                            <div>
                                <div class="fw-bold mb-1">Fulfillment Backlog</div>
                                <div class="small text-muted">Customer orders currently waiting in queue or inside warehouse packing.</div>
                            </div>
                            <span class="fs-3 font-monospace fw-bold text-warning">${pendingOrders + processingOrders}</span>
                        </div>

                        <div class="d-flex gap-3">
                            <a href="/sales/orders" class="btn-emerald-pill flex-fill justify-content-center">
                                <i class="bi bi-bag-check-fill"></i> Manage Orders Queue
                            </a>
                            <a href="/sales/reports" class="btn-outline-glass px-4">
                                <i class="bi bi-file-earmark-bar-graph"></i> Reports Board
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- RECENT CUSTOMER ORDERS OVERVIEW -->
        <div class="atelier-card">
            <div class="atelier-head">
                <div class="atelier-title">
                    <i class="bi bi-clock-history text-secondary"></i> Recent Customer Orders
                </div>
                <div class="d-flex align-items-center gap-3">
                    <span class="small text-muted">${totalOrders} total order(s)</span>
                    <a href="/sales/orders" class="btn-outline-glass">
                        Full Orders Queue <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="p-5 text-center text-muted">
                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                        <div class="fw-semibold">No Customer Orders Yet</div>
                        <small>Customer store purchases will appear here live.</small>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="atelier-table">
                            <thead>
                                <tr>
                                    <th>Order Ref</th>
                                    <th>Customer</th>
                                    <th>Timestamp</th>
                                    <th>Items Ordered</th>
                                    <th>Total Value</th>
                                    <th>Fulfillment Status</th>
                                    <th class="text-end">Quick Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}" end="5">
                                    <tr>
                                        <td><span class="order-badge-token">#${order.order_id}</span></td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div style="width:34px;height:34px;border-radius:10px;background:var(--card-subtle);display:flex;align-items:center;justify-content:center;font-size:0.9rem;font-weight:700;">
                                                    <i class="bi bi-person text-muted"></i>
                                                </div>
                                                <div class="fw-bold">${order.customer_name}</div>
                                            </div>
                                        </td>
                                        <td class="small text-muted font-monospace">${order.order_date}</td>
                                        <td>
                                            <c:set var="itemCount" value="${orderItemsMap[order.order_id].size()}"/>
                                            <span class="badge rounded-pill px-3 py-1" style="background:var(--card-subtle);color:var(--txt2);border:1px solid var(--border);">
                                                <i class="bi bi-box-seam me-1 text-primary"></i>${itemCount != null ? itemCount : 0} items
                                            </span>
                                        </td>
                                        <td class="font-monospace fw-bold">
                                            Rs.&nbsp;<fmt:formatNumber value="${order.total_amount}" pattern="#,##0.00"/>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${order.status == 'PENDING'}">
                                                    <span class="status-pill-glow pending"><i class="bi bi-hourglass-split"></i> Pending</span>
                                                </c:when>
                                                <c:when test="${order.status == 'PROCESSING'}">
                                                    <span class="status-pill-glow processing"><i class="bi bi-gear-fill"></i> Processing</span>
                                                </c:when>
                                                <c:when test="${order.status == 'COMPLETED'}">
                                                    <span class="status-pill-glow completed"><i class="bi bi-check-circle-fill"></i> Completed</span>
                                                </c:when>
                                                <c:when test="${order.status == 'CANCELLED'}">
                                                    <span class="status-pill-glow cancelled"><i class="bi bi-x-circle-fill"></i> Cancelled</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pill-glow">${order.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end">
                                            <a href="/sales/orders" class="btn-outline-glass">
                                                <i class="bi bi-sliders"></i> Manage in Queue
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>

    <!-- ACCOUNT PROFILE MODAL -->
    <div class="modal fade" id="accountModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 440px;">
            <div class="modal-content">
                <div class="modal-header">
                    <h6 class="modal-title fw-bold">Sales Executive Profile</h6>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="/update-profile" method="post">
                        <div class="mb-3">
                            <label class="form-label small text-muted text-uppercase fw-bold">Full Name</label>
                            <input type="text" name="fullName" class="form-control" value="${sessionScope.fullName != null ? sessionScope.fullName : 'Sales Manager'}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small text-muted text-uppercase fw-bold">Email Address</label>
                            <input type="email" name="email" class="form-control" value="${sessionScope.userEmail != null ? sessionScope.userEmail : 'sales@parttrack.com'}" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small text-muted text-uppercase fw-bold">New Password</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="Leave blank to keep unchanged">
                        </div>
                        <div class="d-flex gap-2 mt-4">
                            <button type="button" class="btn btn-secondary flex-fill" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn-emerald-pill flex-fill justify-content-center">Save Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function toggleTheme() {
            var h = document.documentElement;
            var dark = h.getAttribute('data-theme') === 'dark';
            var next = dark ? 'light' : 'dark';
            h.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            document.getElementById('themeIcon').className = dark ? 'bi bi-moon-stars-fill' : 'bi bi-sun-fill text-warning';
        }
        (function(){
            var s = localStorage.getItem('theme') || 'light';
            var icon = document.getElementById('themeIcon');
            if (icon) icon.className = s === 'dark' ? 'bi bi-sun-fill text-warning' : 'bi bi-moon-stars-fill';
        })();

        function openAccountModal() {
            new bootstrap.Modal(document.getElementById('accountModal')).show();
        }
    </script>
</body>
</html>
