<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Orders Fulfillment Queue | PartTrack Atelier</title>
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

        /* ── HEADER ── */
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

        /* ── BUTTONS ── */
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

        /* ── PHOTO BANNER (Brand new image: sales_orders_porsche.jpg) ── */
        .sales-banner-strip {
            position: relative;
            height: 170px;
            border-radius: var(--radius-lg);
            overflow: hidden;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 2.8rem;
            background: #080d19;
            border: 1px solid var(--border);
            box-shadow: var(--shadow-glow);
        }
        .sales-banner-bg {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            object-fit: cover;
            object-position: center 50%;
            opacity: 0.52;
        }
        .sales-banner-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, rgba(8,13,25,0.96) 0%, rgba(8,13,25,0.7) 45%, rgba(8,13,25,0.92) 100%);
        }
        .sales-banner-content {
            position: relative;
            z-index: 2;
            color: #ffffff;
        }

        /* ── STATUS TABS ── */
        .sales-filter-strip {
            display: flex;
            gap: 0.6rem;
            margin-bottom: 1.5rem;
            flex-wrap: wrap;
        }
        .sales-filter-pill {
            padding: 0.45rem 1.2rem;
            border-radius: 9999px;
            font-size: 0.82rem;
            font-weight: 700;
            border: 1px solid var(--border);
            background: var(--card);
            color: var(--txt2);
            cursor: pointer;
            transition: all 0.15s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
        }
        .sales-filter-pill:hover {
            border-color: #10b981;
            color: #10b981;
            background: var(--card-subtle);
        }
        .sales-filter-pill.active {
            background: linear-gradient(135deg, #10b981 0%, #059669 100%);
            color: #ffffff;
            border-color: #10b981;
            box-shadow: 0 4px 14px rgba(16, 185, 129, 0.35);
        }

        /* ── ATELIER CARD & TABLE ── */
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

        /* Delete button */
        .btn-purge-order {
            padding: 0.4rem 0.85rem;
            border-radius: 10px;
            font-size: 0.78rem;
            font-weight: 700;
            border: 1px solid rgba(244, 63, 94, 0.35);
            background: rgba(244, 63, 94, 0.08);
            color: #f43f5e;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            transition: all 0.15s ease;
        }
        .btn-purge-order:hover {
            background: #f43f5e;
            color: #ffffff;
            border-color: #f43f5e;
            box-shadow: 0 4px 12px rgba(244, 63, 94, 0.35);
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
                <a href="/sales" class="sales-nav-item" title="Commercial Sales Dashboard">
                    <i class="bi bi-speedometer"></i>
                </a>
            </li>
            <li>
                <!-- UI 2: Customer Orders Queue -->
                <a href="/sales/orders" class="sales-nav-item active" title="Customer Orders Queue & Fulfillment">
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
                    <i class="bi bi-bag-check text-success"></i> Customer Orders Fulfillment Queue
                </h1>
                <p class="sales-tagline">Real-time order processing &bull; Line item dispatch &bull; Customer portal synchronization</p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <a href="/sales" class="btn-outline-glass">
                    <i class="bi bi-arrow-left"></i> Commercial Overview
                </a>
                <a href="/sales/reports" class="btn-outline-glass">
                    <i class="bi bi-file-earmark-bar-graph"></i> Executive Reports
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

        <!-- BANNER STRIP (Commercial Sales Checkout image) -->
        <section class="sales-banner-strip">
            <img src="/images/sales/commercial_sales_checkout.jpg" alt="Order Processing Telemetry" class="sales-banner-bg">
            <div class="sales-banner-overlay"></div>
            <div class="sales-banner-content">
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="badge rounded-pill px-3 py-1 fw-bold text-uppercase" style="background:rgba(16,185,129,0.2);color:#10b981;border:1px solid rgba(16,185,129,0.4);font-size:0.7rem;letter-spacing:0.06em;">
                        Live Customer Store Pipeline
                    </span>
                    <span class="text-white-50 small">&bull; Synchronized Live</span>
                </div>
                <h3 class="fw-bold mb-1 text-white">Order Processing &amp; Line Audit Queue</h3>
                <p class="small text-white-50 mb-0">Orders deleted here are completely and permanently removed from both this queue and the customer's portal.</p>
            </div>
            <div class="position-relative z-2 text-end d-none d-md-block">
                <div class="fs-2 fw-bold text-white font-monospace">${totalOrders}</div>
                <div class="text-white-50 small text-uppercase fw-bold" style="letter-spacing:0.06em;">Orders Total</div>
            </div>
        </section>

        <!-- FILTER TABS -->
        <div class="sales-filter-strip">
            <button class="sales-filter-pill active" onclick="filterOrders('all', this)">
                <i class="bi bi-grid-fill"></i> All Orders (${totalOrders})
            </button>
            <button class="sales-filter-pill" onclick="filterOrders('PENDING', this)">
                <i class="bi bi-hourglass-split text-warning"></i> Pending Verification (${pendingOrders})
            </button>
            <button class="sales-filter-pill" onclick="filterOrders('PROCESSING', this)">
                <i class="bi bi-gear-fill text-info"></i> In Processing (${processingOrders})
            </button>
            <button class="sales-filter-pill" onclick="filterOrders('COMPLETED', this)">
                <i class="bi bi-check-circle-fill text-success"></i> Completed (${completedOrders})
            </button>
            <button class="sales-filter-pill" onclick="filterOrders('CANCELLED', this)">
                <i class="bi bi-x-circle-fill text-danger"></i> Cancelled (${cancelledOrders})
            </button>
        </div>

        <!-- ORDERS ATELIER TABLE -->
        <div class="atelier-card">
            <div class="atelier-head">
                <div class="atelier-title">
                    <i class="bi bi-receipt-cutoff text-success"></i> Customer Store Order Registry
                </div>
                <span class="small text-muted">${totalOrders} order(s) listed</span>
            </div>

            <c:choose>
                <c:when test="${empty orders}">
                    <div class="p-5 text-center text-muted">
                        <i class="bi bi-inbox fs-2 d-block mb-2"></i>
                        <div class="fw-semibold">No Customer Orders in Queue</div>
                        <small>Customer purchases placed through the store checkout will appear here.</small>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="atelier-table" id="ordersTable">
                            <thead>
                                <tr>
                                    <th>Order Ref</th>
                                    <th>Customer Name</th>
                                    <th>Timestamp</th>
                                    <th>Items Ordered</th>
                                    <th>Total Payable</th>
                                    <th>Status</th>
                                    <th>Order Notes</th>
                                    <th class="text-end">Fulfillment Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${orders}">
                                    <tr class="order-row" data-status="${order.status}">
                                        <td>
                                            <span class="order-badge-token">#${order.order_id}</span>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center gap-2">
                                                <div style="width:34px;height:34px;border-radius:10px;background:var(--card-subtle);display:flex;align-items:center;justify-content:center;font-size:0.9rem;font-weight:700;">
                                                    <i class="bi bi-person-fill text-muted"></i>
                                                </div>
                                                <div>
                                                    <div class="fw-bold">${order.customer_name}</div>
                                                    <div class="small text-muted" style="font-size:0.75rem;">Verified Customer</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="small text-muted font-monospace">
                                            <i class="bi bi-calendar3 me-1"></i>${order.order_date}
                                        </td>
                                        <td>
                                            <c:set var="itemCount" value="${orderItemsMap[order.order_id].size()}"/>
                                            <button class="btn-outline-glass" onclick="openOrderItems(${order.order_id})">
                                                <i class="bi bi-box-seam text-info"></i> ${itemCount != null ? itemCount : 0} item(s)
                                            </button>
                                        </td>
                                        <td>
                                            <span class="font-monospace fw-bold" style="font-size:0.92rem;color:var(--txt);">
                                                Rs.&nbsp;<fmt:formatNumber value="${order.total_amount}" pattern="#,##0.00"/>
                                            </span>
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
                                        <td class="small text-muted" style="max-width:180px;">
                                            <c:out value="${order.notes != null && !order.notes.isBlank() ? order.notes : '—'}" />
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <div class="d-inline-flex gap-1 align-items-center">
                                                <!-- Process Action (if Pending) -->
                                                <c:if test="${order.status == 'PENDING'}">
                                                    <button class="btn-outline-glass text-info"
                                                            onclick="openProcessModal(${order.order_id}, '${order.customer_name}')">
                                                        <i class="bi bi-gear-fill"></i> Process
                                                    </button>
                                                </c:if>

                                                <!-- Complete Action -->
                                                <c:if test="${order.status == 'PENDING' || order.status == 'PROCESSING'}">
                                                    <form action="/sales/order/complete" method="post" style="display:inline;" onsubmit="return confirm('Mark Order #${order.order_id} as COMPLETED and realize cash revenue?')">
                                                        <input type="hidden" name="orderId" value="${order.order_id}">
                                                        <input type="hidden" name="redirectUrl" value="/sales/orders">
                                                        <button type="submit" class="btn-outline-glass text-success" title="Mark Completed">
                                                            <i class="bi bi-check2-circle"></i> Complete
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <!-- Cancel Action -->
                                                <c:if test="${order.status == 'PENDING' || order.status == 'PROCESSING'}">
                                                    <form action="/sales/order/cancel" method="post" style="display:inline;" onsubmit="return confirm('Cancel Order #${order.order_id}?')">
                                                        <input type="hidden" name="orderId" value="${order.order_id}">
                                                        <input type="hidden" name="redirectUrl" value="/sales/orders">
                                                        <button type="submit" class="btn-outline-glass text-warning" title="Cancel Order">
                                                            <i class="bi bi-x-circle"></i> Cancel
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <!-- PERMANENT DELETE ORDER (removes from both Sales Queue and Customer Store) -->
                                                <form action="/sales/order/delete" method="post" style="display:inline;"
                                                      onsubmit="return confirm('PERMANENTLY DELETE Order #${order.order_id}?\n\nThis will completely erase the order from this queue AND from the customer\'s logged-in order tracking history. This action cannot be undone.')">
                                                    <input type="hidden" name="orderId" value="${order.order_id}">
                                                    <input type="hidden" name="redirectUrl" value="/sales/orders">
                                                    <button type="submit" class="btn-purge-order" title="Permanently Delete Order">
                                                        <i class="bi bi-trash3-fill"></i> Delete
                                                    </button>
                                                </form>
                                            </div>
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

    <!-- ORDER ITEMS BREAKDOWN MODAL -->
    <div class="modal fade" id="orderItemsModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="d-flex align-items-center gap-2">
                        <div style="width:36px;height:36px;border-radius:10px;background:var(--sales-emerald-soft);color:#10b981;display:flex;align-items:center;justify-content:center;">
                            <i class="bi bi-receipt"></i>
                        </div>
                        <div>
                            <h6 class="modal-title fw-bold mb-0" id="orderItemsTitle">Order Item Breakdown</h6>
                            <small class="text-muted" id="orderItemsSubtitle">Customer items</small>
                        </div>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div id="orderItemsList" class="d-flex flex-column gap-2">
                        <!-- JS Populated -->
                    </div>
                    <div class="d-flex justify-content-between align-items-center p-3 rounded-3 mt-4" style="background:var(--card-subtle);border:1px solid var(--border);">
                        <span class="fw-bold">Total Order Value:</span>
                        <span class="fw-bold fs-5 font-monospace text-success" id="orderItemsTotal">Rs. 0.00</span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- PROCESS ORDER MODAL -->
    <div class="modal fade" id="processModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered" style="max-width: 440px;">
            <div class="modal-content">
                <div class="modal-header">
                    <div class="d-flex align-items-center gap-2">
                        <div style="width:34px;height:34px;border-radius:9px;background:var(--sales-cyan-soft);color:#06b6d4;display:flex;align-items:center;justify-content:center;">
                            <i class="bi bi-gear-fill"></i>
                        </div>
                        <h6 class="modal-title fw-bold mb-0">Advance Order to Processing</h6>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <form action="/sales/order/process" method="post">
                    <input type="hidden" name="orderId" id="processOrderId">
                    <input type="hidden" name="redirectUrl" value="/sales/orders">
                    <div class="modal-body p-4">
                        <div class="p-3 rounded-3 mb-3" style="background:var(--card-subtle);border:1px solid var(--border);">
                            <div class="small text-muted">Customer &amp; Order:</div>
                            <div class="fw-bold text-success" id="processCustomerName"></div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small text-muted text-uppercase fw-bold">Processing Note (Optional)</label>
                            <textarea name="notes" class="form-control" rows="2" placeholder="e.g. Packing dispatched from bay 4, invoice generated..."></textarea>
                        </div>
                        <small class="text-muted">The customer will immediately see their order status change to <strong>Processing</strong> in their order dashboard.</small>
                    </div>
                    <div class="modal-footer gap-2">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-emerald-pill">
                            <i class="bi bi-gear-fill"></i> Confirm Processing
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

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

        /* ── INJECTED ORDER ITEMS MAP ── */
        var ORDER_ITEMS = {};
        <c:forEach var="entry" items="${orderItemsMap}">
            ORDER_ITEMS["${entry.key}"] = [
                <c:forEach var="item" items="${entry.value}" varStatus="st">
                {
                    partId:    "${item.part_id}",
                    partName:  "${item.part_name}",
                    quantity:  ${item.quantity},
                    unitPrice: ${item.unit_price},
                    lineTotal: ${item.line_total}
                }${not st.last ? ',' : ''}
                </c:forEach>
            ];
        </c:forEach>

        function openOrderItems(orderId) {
            var items = ORDER_ITEMS[orderId] || [];
            document.getElementById('orderItemsTitle').textContent = 'Order #' + orderId + ' — Line Items';
            document.getElementById('orderItemsSubtitle').textContent = items.length + ' item type(s) ordered';
            var list = document.getElementById('orderItemsList');
            var totalEl = document.getElementById('orderItemsTotal');

            if (items.length === 0) {
                list.innerHTML = '<div class="text-center py-4 text-muted">No line items found for this order.</div>';
                totalEl.textContent = 'Rs. 0.00';
            } else {
                var html = '';
                var grandTotal = 0;
                items.forEach(function(item) {
                    grandTotal += item.lineTotal;
                    html += '<div class="d-flex align-items-center justify-content-between p-3 rounded-3" style="background:var(--card-subtle);border:1px solid var(--border);">' +
                        '<div>' +
                            '<div class="fw-bold">' + (item.partName || item.partId) + '</div>' +
                            '<div class="small text-muted">SKU: #' + item.partId + ' &bull; Rs. ' + item.unitPrice.toFixed(2) + ' / unit</div>' +
                        '</div>' +
                        '<div class="text-end">' +
                            '<div class="fw-bold">× ' + item.quantity + '</div>' +
                            '<div class="font-monospace fw-bold text-success">Rs. ' + item.lineTotal.toFixed(2) + '</div>' +
                        '</div>' +
                    '</div>';
                });
                list.innerHTML = html;
                totalEl.textContent = 'Rs. ' + grandTotal.toFixed(2);
            }

            new bootstrap.Modal(document.getElementById('orderItemsModal')).show();
        }

        function openProcessModal(orderId, customerName) {
            document.getElementById('processOrderId').value = orderId;
            document.getElementById('processCustomerName').textContent = customerName + ' (Order #' + orderId + ')';
            new bootstrap.Modal(document.getElementById('processModal')).show();
        }

        function filterOrders(status, btnEl) {
            document.querySelectorAll('.sales-filter-pill').forEach(function(b){ b.classList.remove('active'); });
            if (btnEl) btnEl.classList.add('active');

            document.querySelectorAll('.order-row').forEach(function(row) {
                if (status === 'all') {
                    row.style.display = '';
                } else {
                    row.style.display = row.getAttribute('data-status') === status ? '' : 'none';
                }
            });
        }
    </script>
</body>
</html>
