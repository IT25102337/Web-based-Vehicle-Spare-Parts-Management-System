<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Executive Business Dashboard | PartTrack</title>

    <!-- Dark mode init: must run BEFORE styles to prevent flash -->
    <script>
    (function(){var t=localStorage.getItem('theme')||'light';document.documentElement.setAttribute('data-theme',t);})();
    </script>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --navy: #1e3a8a; --navy-dark: #172554; --navy-soft: #eff6ff; --navy-border: #bfdbfe;
            --purple: #7c3aed; --purple-soft: #f5f3ff;
            --bg: #f0f4f8; --card: #ffffff; --border: #e2e8f0;
            --txt: #0f172a; --txt2: #64748b; --sidebar-bg: #ffffff;
            --table-head: #f8fafc; --table-hover: #f8fafc; --input-bg: #ffffff;
            --modal-bg: #ffffff; --modal-header: #f8fafc;
        }
        [data-theme="dark"] {
            --bg: #0f172a; --card: #1e293b; --border: #334155;
            --txt: #f1f5f9; --txt2: #94a3b8; --sidebar-bg: #1e293b;
            --table-head: #273349; --table-hover: #1e2d45; --input-bg: #273349;
            --modal-bg: #1e293b; --modal-header: #273349;
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--bg);
            color: var(--txt);
            min-height: 100vh;
            margin: 0;
            display: flex;
            transition: background .2s, color .2s;
        }

        /* ── SIDEBAR ── */
        .sidebar-rail {
            width: 72px;
            height: 100vh;
            position: fixed;
            top: 0; left: 0;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--border);
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 1.25rem 0;
            z-index: 1030;
            box-shadow: 2px 0 8px rgba(0,0,0,.04);
            transition: background .2s, border-color .2s;
        }

        .brand-logo-icon {
            width: 44px; height: 44px;
            border-radius: 12px;
            background: linear-gradient(135deg, #7c3aed, #4f46e5);
            color: #fff;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            box-shadow: 0 4px 12px rgba(124,58,237,.35);
            margin-bottom: 2rem;
            text-decoration: none;
            transition: transform .15s;
        }
        .brand-logo-icon:hover { transform: scale(1.06); color: #fff; }

        .sidebar-nav {
            display: flex; flex-direction: column;
            align-items: center; gap: .85rem;
            width: 100%; list-style: none;
            padding: 0; margin: 0;
        }

        .sidebar-icon-link {
            width: 44px; height: 44px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: var(--txt2);
            text-decoration: none;
            font-size: 1.25rem;
            transition: all .15s;
            position: relative;
        }
        .sidebar-icon-link:hover { background: var(--table-hover); color: var(--txt); }
        .sidebar-icon-link.active {
            background: var(--purple-soft);
            color: var(--purple);
            font-weight: 700;
        }
        [data-theme="dark"] .sidebar-icon-link.active {
            background: #2e1065;
            color: #c084fc;
        }

        .sidebar-bottom {
            margin-top: auto;
            display: flex; flex-direction: column;
            align-items: center;
        }

        .logout-icon-link {
            width: 44px; height: 44px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: #ef4444;
            text-decoration: none;
            font-size: 1.25rem;
            transition: background .15s;
        }
        .logout-icon-link:hover { background: #fee2e2; }
        [data-theme="dark"] .logout-icon-link:hover { background: #450a0a; }

        /* ── MAIN CONTENT ── */
        .main-content {
            margin-left: 72px;
            flex: 1;
            padding: 2rem;
            max-width: 1400px;
            width: calc(100% - 72px);
        }

        /* ── WHITE CARDS ── */
        .white-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            box-shadow: 0 1px 4px rgba(0,0,0,.03);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: background .2s, border-color .2s;
        }

        .card-header-clean {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border);
            background: var(--card);
        }

        /* ── PHOTO BANNERS ── */
        .photo-banner {
            position: relative;
            overflow: hidden;
            width: 100%;
        }
        .photo-banner img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        .photo-banner .overlay {
            position: absolute;
            inset: 0;
            background: linear-gradient(to top, rgba(15,23,42,.88) 0%, rgba(15,23,42,.35) 60%, rgba(15,23,42,.1) 100%);
        }

        /* ── BADGES & BUTTONS ── */
        .tag-pill {
            background: var(--table-hover);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: .25rem .75rem;
            font-size: .8rem;
            font-weight: 600;
            color: var(--txt);
            display: inline-flex;
            align-items: center;
            gap: .35rem;
        }

        .btn-purple {
            background: var(--purple);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: .5rem 1.15rem;
            font-weight: 700;
            font-size: .88rem;
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            text-decoration: none;
            transition: all .15s;
            cursor: pointer;
        }
        .btn-purple:hover { background: #6d28d9; color: #fff; transform: translateY(-1px); }

        .btn-navy {
            background: var(--navy);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: .5rem 1.15rem;
            font-weight: 700;
            font-size: .88rem;
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            text-decoration: none;
            transition: all .15s;
            cursor: pointer;
        }
        .btn-navy:hover { background: var(--navy-dark); color: #fff; transform: translateY(-1px); }

        .btn-outline-clean {
            background: transparent;
            color: var(--txt);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: .5rem 1rem;
            font-weight: 600;
            font-size: .88rem;
            display: inline-flex;
            align-items: center;
            gap: .45rem;
            text-decoration: none;
            transition: all .15s;
            cursor: pointer;
        }
        .btn-outline-clean:hover { background: var(--table-hover); color: var(--txt); }

        .module-icon-box {
            width: 42px; height: 42px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        /* ── TABLES ── */
        .table {
            color: var(--txt) !important;
            border-color: var(--border) !important;
            margin-bottom: 0;
        }
        .table > :not(caption) > * > * {
            background-color: transparent !important;
            border-bottom-color: var(--border) !important;
            padding: 1rem 1.25rem;
        }
        .table thead th {
            background: var(--table-head) !important;
            color: var(--txt2) !important;
            font-size: .78rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: .05em;
            border-bottom: 2px solid var(--border) !important;
        }
        .table tbody tr:hover {
            background-color: var(--table-hover) !important;
        }

        /* ── MODALS ── */
        .modal-content {
            background-color: var(--modal-bg) !important;
            border: 1px solid var(--border) !important;
            border-radius: 16px;
            color: var(--txt) !important;
        }
        .modal-header {
            background-color: var(--modal-header) !important;
            border-bottom: 1px solid var(--border) !important;
        }
        .modal-footer {
            border-top: 1px solid var(--border) !important;
        }
        .form-control, .form-select {
            background-color: var(--input-bg) !important;
            border-color: var(--border) !important;
            color: var(--txt) !important;
            border-radius: 8px;
        }
    </style>
</head>
<body>

    <!-- ═══════════════════════════════════════════ -->
    <!--  SIDEBAR NAVIGATION                         -->
    <!-- ═══════════════════════════════════════════ -->
    <aside class="sidebar-rail">
        <a href="javascript:void(0)" onclick="openAccountModal()" class="brand-logo-icon" title="My Account & Profile Details">
            <i class="bi bi-person-circle"></i>
        </a>

        <ul class="sidebar-nav">
            <li>
                <a href="/reports/dashboard" class="sidebar-icon-link active" title="Executive Business Dashboard">
                    <i class="bi bi-speedometer2"></i>
                </a>
            </li>
            <li>
                <a href="/reports/generator" class="sidebar-icon-link" title="Multi-Department Report Generator">
                    <i class="bi bi-sliders"></i>
                </a>
            </li>
            <li>
                <a href="/reports/audits" class="sidebar-icon-link" title="Manager Audit & Inspection Inbox">
                    <i class="bi bi-journal-check"></i>
                    <c:if test="${not empty inventoryReports && inventoryReports.size() > 0}">
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size:0.6rem; transform: translate(-30%, 30%) !important;">
                            ${inventoryReports.size()}
                        </span>
                    </c:if>
                </a>
            </li>
            <li>
                <a href="/reports/templates" class="sidebar-icon-link" title="Template Engine & Automated Schedulers">
                    <i class="bi bi-layers-fill"></i>
                </a>
            </li>
        </ul>

        <div class="sidebar-bottom">
            <button onclick="toggleTheme()" id="themeSideBtn" title="Toggle Dark / Light Mode"
                    style="width:44px;height:44px;border-radius:10px;border:1px solid var(--border);
                           background:transparent;color:var(--txt2);cursor:pointer;font-size:1.15rem;
                           display:flex;align-items:center;justify-content:center;
                           transition:all .15s;margin-bottom:.65rem;">
                <i class="bi bi-moon-stars-fill" id="themeSideIcon"></i>
            </button>
            <a href="/logout" class="logout-icon-link" title="Logout">
                <i class="bi bi-box-arrow-right"></i>
            </a>
        </div>
    </aside>

    <!-- ═══════════════════════════════════════════ -->
    <!--  MAIN CONTENT                               -->
    <!-- ═══════════════════════════════════════════ -->
    <main class="main-content">

        <!-- Topbar -->
        <div class="d-flex justify-content-between align-items-center mb-4 gap-3 flex-wrap">
            <div>
                <h2 class="fw-extrabold mb-1" style="font-size:1.85rem; font-weight:800; letter-spacing:-0.03em; color:var(--txt);">
                    Executive Business Dashboard
                </h2>
                <p class="mb-0" style="color:var(--txt2); font-size:1.02rem; font-weight:500; line-height:1.55;">
                    Live 360° operational control tower monitoring Inventory, Quality Control, Commercial Sales, OEM Suppliers, and Customer Accounts.
                </p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-purple text-white px-3 py-2 fw-bold" style="background:var(--purple); cursor:pointer;" onclick="openAccountModal()" title="Click to edit account details">
                    <i class="bi bi-person-check-fill me-1"></i> ${not empty sessionScope.fullName ? sessionScope.fullName : 'Report & Business Dashboard Manager'}
                </span>
            </div>
        </div>

        <!-- Flash messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 rounded-3 mb-4 py-2 px-3 border" role="alert">
                <i class="bi bi-check-circle-fill text-success fs-5"></i>
                <div class="small fw-semibold text-success">${successMessage}</div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty reportMessage}">
            <div class="alert ${reportSuccess ? 'alert-success' : 'alert-info'} alert-dismissible fade show rounded-3 mb-4 py-2 px-3 border small fw-semibold" role="alert">
                <i class="bi bi-info-circle-fill me-1"></i> ${reportMessage}
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- ── HERO PHOTO BANNER ────────────────────── -->
        <div class="white-card mb-4" style="border-radius:16px;">
            <div class="photo-banner" style="height:150px;border-radius:16px;">
                <img src="https://images.unsplash.com/photo-1551288049-bebda4e38f71?auto=format&fit=crop&w=1200&q=85"
                     alt="Admin Analytics" loading="lazy">
                <div class="overlay"></div>
                <div style="position:absolute;bottom:1.25rem;left:1.75rem;right:1.75rem;" class="d-flex justify-content-between align-items-end flex-wrap gap-2">
                    <div>
                        <span class="badge mb-2" style="background:rgba(124,58,237,.9);color:#fff;font-size:.72rem;letter-spacing:.05em;padding:.35rem .75rem;border-radius:8px;">
                            <i class="bi bi-speedometer2 me-1"></i>360° ENTERPRISE CONTROL TOWER
                        </span>
                        <h3 style="color:#fff;font-size:1.45rem;font-weight:800;margin:0;letter-spacing:-.02em;">
                            Cross-Functional Operations &amp; Performance Intelligence
                        </h3>
                    </div>
                    <div class="d-flex gap-2">
                        <a href="/reports/generator" class="btn btn-sm btn-purple">
                            <i class="bi bi-file-earmark-bar-graph-fill me-1"></i> Compile Audit Report
                        </a>
                        <a href="/reports/audits" class="btn btn-sm btn-outline-clean text-white border-white">
                            <i class="bi bi-inbox-fill me-1"></i> Review Manager Reports
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── 4 KPI STAT CARDS ─────────────────────── -->
        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="white-card p-3 mb-0" style="border-top:4px solid #7c3aed;">
                    <div class="text-secondary small fw-bold text-uppercase" style="font-size:.78rem; font-weight:800; letter-spacing:.06em;">Physical Stock Inventory</div>
                    <div class="fw-bold mt-1" style="font-size:2rem; font-weight:800; letter-spacing:-0.02em; color:var(--purple);">${summary.activeSKUs} SKUs</div>
                    <div class="small text-secondary mt-1"><i class="bi bi-boxes text-purple me-1"></i>Warehouse catalog items</div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="white-card p-3 mb-0" style="border-top:4px solid #1e3a8a;">
                    <div class="text-secondary small fw-bold text-uppercase" style="font-size:.78rem; font-weight:800; letter-spacing:.06em;">Units in Warehouse Stock</div>
                    <div class="fw-bold mt-1" style="font-size:2rem; font-weight:800; letter-spacing:-0.02em; color:var(--navy);">${summary.stockItems} Units</div>
                    <div class="small text-secondary mt-1"><i class="bi bi-check2-circle text-primary me-1"></i>Physical parts on depot shelves</div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="white-card p-3 mb-0" style="border-top:4px solid #10b981;">
                    <div class="text-secondary small fw-bold text-uppercase" style="font-size:.78rem; font-weight:800; letter-spacing:.06em;">Sales Revenue Realized</div>
                    <div class="fw-bold mt-1 text-success" style="font-size:2rem; font-weight:800; letter-spacing:-0.02em;">Rs. <fmt:formatNumber value="${summary.totalValuation}" type="number" maxFractionDigits="2"/></div>
                    <div class="small text-secondary mt-1"><i class="bi bi-graph-up-arrow text-success me-1"></i>Completed customer orders</div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="white-card p-3 mb-0" style="border-top:4px solid #059669;">
                    <div class="text-secondary small fw-bold text-uppercase" style="font-size:.78rem; font-weight:800; letter-spacing:.06em;">Supplier Batches Received</div>
                    <div class="fw-bold mt-1" style="font-size:2rem; font-weight:800; letter-spacing:-0.02em; color:#059669;">${summary.supplierDeliveries} Batches</div>
                    <div class="small text-secondary mt-1"><i class="bi bi-truck text-success me-1"></i>Quality inspection gate</div>
                </div>
            </div>
        </div>

        <!-- ═══════════════════════════════════════════════════════════ -->
        <!--  360° BUSINESS OVERSIGHT PANELS                             -->
        <!-- ═══════════════════════════════════════════════════════════ -->
        <section id="overview-content">
            
            <!-- Quick Department Jump Nav Bar -->
            <div class="d-flex align-items-center justify-content-between p-3 white-card mb-4 flex-wrap gap-2">
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-purple text-white px-2 py-1"><i class="bi bi-speedometer2 me-1"></i>LIVE 360° OVERVIEW</span>
                    <span class="fw-bold" style="color:var(--txt); font-size:0.95rem;">Cross-Functional Department Intelligence Tower</span>
                </div>
                <div class="d-flex align-items-center gap-2 flex-wrap">
                    <a href="#dash-inventory" class="btn btn-sm btn-outline-clean" style="font-size:0.8rem;">
                        <i class="bi bi-boxes text-primary me-1"></i> Warehouse Stock (${invData.totalParts})
                    </a>
                    <a href="#dash-qa" class="btn btn-sm btn-outline-clean" style="font-size:0.8rem;">
                        <i class="bi bi-shield-check text-purple me-1"></i> QA Inspection (${qaData.totalBatches})
                    </a>
                    <a href="#dash-sales" class="btn btn-sm btn-outline-clean" style="font-size:0.8rem;">
                        <i class="bi bi-graph-up-arrow text-info me-1"></i> Sales &amp; Revenue
                    </a>
                    <a href="#dash-supplier" class="btn btn-sm btn-outline-clean" style="font-size:0.8rem;">
                        <i class="bi bi-truck text-success me-1"></i> Suppliers (${supplierData.activeSuppliers})
                    </a>
                    <a href="#dash-customer" class="btn btn-sm btn-outline-clean" style="font-size:0.8rem;">
                        <i class="bi bi-people-fill text-warning me-1"></i> Customers (${custData.totalCustomers})
                    </a>
                </div>
            </div>

            <!-- ROW 1: DEPARTMENT 1 (INVENTORY) & DEPARTMENT 2 (SPARE PARTS QA) -->
            <div class="row g-4 mb-4">
                
                <!-- DEPARTMENT 1: WAREHOUSE INVENTORY -->
                <div class="col-xl-6" id="dash-inventory">
                    <div class="white-card h-100 mb-0">
                        <div class="card-header-clean d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-2">
                                <div class="module-icon-box bg-primary-subtle text-primary">
                                    <i class="bi bi-boxes"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-0" style="color:var(--txt);">Warehouse Stock &amp; Inventory</h5>
                                    <small style="color:var(--txt2);">Read-only physical inventory &amp; asset valuation oversight</small>
                                </div>
                            </div>
                            <span class="badge bg-primary-subtle text-primary border border-primary px-2 py-1 fw-bold">
                                ${invData.totalParts} Unique SKUs
                            </span>
                        </div>
                        <div class="p-3">
                            <div class="row g-2 mb-3">
                                <div class="col-sm-4">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.75rem;">UNIQUE SKUS</div>
                                        <div class="fw-extrabold" style="font-size:1.4rem; color:var(--txt);">${invData.totalParts}</div>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.75rem;">PHYSICAL UNITS</div>
                                        <div class="fw-extrabold" style="font-size:1.4rem; color:var(--navy);">${invData.totalUnits}</div>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.75rem;">TOTAL VALUATION</div>
                                        <div class="fw-extrabold text-success" style="font-size:1.15rem;">Rs. <fmt:formatNumber value="${invData.totalValue}" type="number" maxFractionDigits="2"/></div>
                                    </div>
                                </div>
                            </div>

                            <h6 class="fw-bold mb-2 small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">
                                <i class="bi bi-shield-exclamation text-danger me-1"></i> Priority Low-Stock &amp; Depleted Parts:
                            </h6>
                            <div class="table-responsive">
                                <table class="table table-sm align-middle" style="font-size:0.83rem;">
                                    <thead>
                                        <tr>
                                            <th>Part ID &amp; Name</th>
                                            <th class="text-center">On-Hand</th>
                                            <th class="text-center">Safety Level</th>
                                            <th>Shelf Location</th>
                                            <th class="text-end">Unit Price</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty invData.lowStockList}">
                                                <tr>
                                                    <td colspan="5" class="text-center py-3 text-muted">All warehouse parts exceed minimum safety threshold.</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="item" items="${invData.lowStockList}">
                                                    <tr>
                                                        <td>
                                                            <strong style="color:var(--txt);">${item.part_name}</strong>
                                                            <small class="d-block text-muted">SKU: ${item.part_id}</small>
                                                        </td>
                                                        <td class="text-center">
                                                            <span class="badge ${item.quantity == 0 ? 'bg-danger' : 'bg-warning text-dark'} fw-bold">
                                                                ${item.quantity}
                                                            </span>
                                                        </td>
                                                        <td class="text-center text-muted">${item.reorder_level}</td>
                                                        <td><span class="tag-pill" style="font-size:0.75rem;">${item.storage_location}</span></td>
                                                        <td class="text-end fw-semibold">Rs. ${item.unit_price}</td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- DEPARTMENT 2: SPARE PARTS QA & RECEIVING -->
                <div class="col-xl-6" id="dash-qa">
                    <div class="white-card h-100 mb-0">
                        <div class="card-header-clean d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-2">
                                <div class="module-icon-box bg-purple-soft text-purple">
                                    <i class="bi bi-shield-check"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-0" style="color:var(--txt);">Spare Part QA &amp; Receiving Gate</h5>
                                    <small style="color:var(--txt2);">Read-only incoming supplier deliveries &amp; defect inspection</small>
                                </div>
                            </div>
                            <span class="badge bg-success-subtle text-success border border-success px-2 py-1 fw-bold">
                                <i class="bi bi-award-fill me-1"></i>${qaData.passRate}% Pass Rate
                            </span>
                        </div>
                        <div class="p-3">
                            <div class="row g-2 mb-3">
                                <div class="col-sm-3 col-6">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.72rem;">TOTAL BATCHES</div>
                                        <div class="fw-extrabold" style="font-size:1.3rem; color:var(--txt);">${qaData.totalBatches}</div>
                                    </div>
                                </div>
                                <div class="col-sm-3 col-6">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.72rem;">QA APPROVED</div>
                                        <div class="fw-extrabold text-success" style="font-size:1.3rem;">${qaData.approvedBatches}</div>
                                    </div>
                                </div>
                                <div class="col-sm-3 col-6">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.72rem;">DEFECT REJECTS</div>
                                        <div class="fw-extrabold text-danger" style="font-size:1.3rem;">${qaData.rejectedBatches}</div>
                                    </div>
                                </div>
                                <div class="col-sm-3 col-6">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.72rem;">PENDING QA</div>
                                        <div class="fw-extrabold text-warning-emphasis" style="font-size:1.3rem;">${qaData.pendingBatches}</div>
                                    </div>
                                </div>
                            </div>

                            <h6 class="fw-bold mb-2 small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">
                                <i class="bi bi-truck-flatbed text-purple me-1"></i> Recent Supplier Delivery QA Batches:
                            </h6>
                            <div class="table-responsive">
                                <table class="table table-sm align-middle" style="font-size:0.83rem;">
                                    <thead>
                                        <tr>
                                            <th>Batch ID &amp; Part</th>
                                            <th>Supplier</th>
                                            <th class="text-center">Intake Qty</th>
                                            <th class="text-center">QA Result</th>
                                            <th class="text-end">Arrival Date</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty qaData.recentBatches}">
                                                <tr>
                                                    <td colspan="5" class="text-center py-3 text-muted">No delivery batches registered yet.</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="batch" items="${qaData.recentBatches}">
                                                    <tr>
                                                        <td>
                                                            <strong style="color:var(--txt);">${batch.part_name}</strong>
                                                            <small class="d-block text-muted">#${batch.batch_id} [${batch.part_id}]</small>
                                                        </td>
                                                        <td><small style="color:var(--txt);">${batch.supplier_name}</small></td>
                                                        <td class="text-center fw-bold">${batch.received_qty}</td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${batch.quality_status == 'APPROVED'}">
                                                                    <span class="badge bg-success-subtle text-success border border-success px-2 py-0">Approved</span>
                                                                </c:when>
                                                                <c:when test="${batch.quality_status == 'REJECTED'}">
                                                                    <span class="badge bg-danger-subtle text-danger border border-danger px-2 py-0">Rejected</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning px-2 py-0">Pending</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-end text-muted small">${batch.arrival_date}</td>
                                                    </tr>
                                                </c:forEach>
                                            </c:otherwise>
                                        </c:choose>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <!-- ROW 2: DEPARTMENT 3 (SALES), DEPARTMENT 4 (SUPPLIER), DEPARTMENT 5 (CUSTOMER) -->
            <div class="row g-4 mb-4">
                
                <!-- DEPARTMENT 3: COMMERCIAL SALES & ORDERS -->
                <div class="col-xl-6" id="dash-sales">
                    <div class="white-card h-100 mb-0">
                        <div class="card-header-clean d-flex justify-content-between align-items-center">
                            <div class="d-flex align-items-center gap-2">
                                <div class="module-icon-box bg-info-subtle text-info">
                                    <i class="bi bi-graph-up-arrow"></i>
                                </div>
                                <div>
                                    <h5 class="fw-bold mb-0" style="color:var(--txt);">Commercial Sales &amp; Revenue Pipeline</h5>
                                    <small style="color:var(--txt2);">Read-only customer retail orders &amp; turnover reconciliation</small>
                                </div>
                            </div>
                            <span class="badge bg-primary-subtle text-primary border border-primary px-2 py-1 fw-bold">
                                Rs. <fmt:formatNumber value="${salesData.completedRevenue}" type="number" maxFractionDigits="2"/> Realized
                            </span>
                        </div>
                        <div class="p-3">
                            <div class="row g-2 mb-3">
                                <div class="col-sm-4">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.75rem;">TOTAL ORDERS</div>
                                        <div class="fw-extrabold" style="font-size:1.4rem; color:var(--txt);">${salesData.totalOrders}</div>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.75rem;">COMPLETED ORDERS</div>
                                        <div class="fw-extrabold text-success" style="font-size:1.4rem;">${salesData.completedOrders}</div>
                                    </div>
                                </div>
                                <div class="col-sm-4">
                                    <div class="p-2 rounded-2 border text-center" style="background:var(--table-head); border-color:var(--border) !important;">
                                        <div class="text-secondary small fw-bold" style="font-size:0.75rem;">OPEN PIPELINE</div>
                                        <div class="fw-extrabold text-info" style="font-size:1.15rem;">Rs. <fmt:formatNumber value="${salesData.pipelineRevenue}" type="number" maxFractionDigits="2"/></div>
                                    </div>
                                </div>
                            </div>

                            <h6 class="fw-bold mb-2 small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">
                                <i class="bi bi-cart-check text-info me-1"></i> Recent Customer Order Transactions:
                            </h6>
                            <div class="table-responsive mb-3">
                                <table class="table table-sm align-middle" style="font-size:0.83rem;">
                                    <thead>
                                        <tr>
                                            <th>Order Ref &amp; Customer</th>
                                            <th>Date</th>
                                            <th class="text-end">Amount</th>
                                            <th class="text-center">Order Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:choose>
                                            <c:when test="${empty salesData.recentOrders}">
                                                <tr>
                                                    <td colspan="4" class="text-center py-3 text-muted">No sales orders recorded yet.</td>
                                                </tr>
                                            </c:when>
                                            <c:otherwise>
                                                <c:forEach var="ord" items="${salesData.recentOrders}">
                                                    <tr>
                                                        <td>
                                                            <strong style="color:var(--txt);">Order #${ord.order_id}</strong>
                                                            <small class="d-block text-muted">${ord.customer_name}</small>
                                                        </td>
                                                        <td class="text-muted small">${ord.order_date}</td>
                                                        <td class="text-end fw-bold">Rs. ${ord.total_amount}</td>
                                                        <td class="text-center">
                                                            <c:choose>
                                                                <c:when test="${ord.status == 'COMPLETED'}">
                                                                    <span class="badge bg-success-subtle text-success border border-success px-2 py-0">Completed</span>
                                                                </c:when>
                                                                <c:when test="${ord.status == 'PROCESSING'}">
                                                                    <span class="badge bg-info-subtle text-info border border-info px-2 py-0">Processing</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning px-2 py-0">Pending</span>
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

                            <h6 class="fw-bold mb-2 small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">
                                <i class="bi bi-star-fill text-warning me-1"></i> Top-Demand Spare Parts Leaderboard:
                            </h6>
                            <div class="d-flex flex-column gap-1">
                                <c:forEach var="top" items="${salesData.topSelling}" varStatus="loop">
                                    <div class="d-flex align-items-center justify-content-between p-2 rounded-2 border" style="background:var(--card); border-color:var(--border) !important; font-size:0.83rem;">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="tag-pill fw-bold" style="font-size:0.75rem;">#${loop.index + 1}</span>
                                            <div>
                                                <strong style="color:var(--txt);">${top.part_name}</strong>
                                                <small class="d-block text-muted">Part SKU: ${top.part_id}</small>
                                            </div>
                                        </div>
                                        <div class="text-end">
                                            <span class="fw-bold text-success">Rs. <fmt:formatNumber value="${top.total_sales}" type="number" maxFractionDigits="2"/></span>
                                            <small class="d-block text-muted">${top.total_qty} units sold</small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- DEPARTMENT 4 & 5: SUPPLIER NETWORK & CUSTOMER PORTAL -->
                <div class="col-xl-6">
                    <div class="d-flex flex-column gap-4 h-100">
                        
                        <!-- SUPPLIER NETWORK -->
                        <div class="white-card mb-0" id="dash-supplier">
                            <div class="card-header-clean d-flex justify-content-between align-items-center">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="module-icon-box bg-success-subtle text-success">
                                        <i class="bi bi-truck"></i>
                                    </div>
                                    <div>
                                        <h5 class="fw-bold mb-0" style="color:var(--txt);">Authorized OEM Suppliers</h5>
                                        <small style="color:var(--txt2);">Read-only certified automotive vendor partnerships</small>
                                    </div>
                                </div>
                                <span class="badge bg-success px-2 py-1">${supplierData.activeSuppliers} Active Vendors</span>
                            </div>
                            <div class="p-3">
                                <div class="table-responsive">
                                    <table class="table table-sm align-middle" style="font-size:0.83rem;">
                                        <thead>
                                            <tr>
                                                <th>Supplier Name</th>
                                                <th>Contact Person</th>
                                                <th>Category</th>
                                                <th class="text-center">Status</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="sup" items="${supplierData.supplierList}">
                                                <tr>
                                                    <td>
                                                        <strong style="color:var(--txt);">${sup.supplier_name}</strong>
                                                        <small class="d-block text-muted">ID: #${sup.supplier_id}</small>
                                                    </td>
                                                    <td>${sup.contact_person}</td>
                                                    <td><span class="tag-pill" style="font-size:0.75rem;">${sup.category}</span></td>
                                                    <td class="text-center">
                                                        <span class="badge bg-success-subtle text-success border border-success px-2 py-0">${sup.status}</span>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- CUSTOMER PORTAL -->
                        <div class="white-card mb-0" id="dash-customer">
                            <div class="card-header-clean d-flex justify-content-between align-items-center">
                                <div class="d-flex align-items-center gap-2">
                                    <div class="module-icon-box bg-warning-subtle text-warning-emphasis">
                                        <i class="bi bi-people-fill"></i>
                                    </div>
                                    <div>
                                        <h5 class="fw-bold mb-0" style="color:var(--txt);">Registered Customer Accounts</h5>
                                        <small style="color:var(--txt2);">Read-only retail shopper credentials &amp; customer profiles</small>
                                    </div>
                                </div>
                                <span class="badge bg-purple-soft text-purple border border-purple px-2 py-1 fw-bold">${custData.totalCustomers} Shoppers</span>
                            </div>
                            <div class="p-3">
                                <div class="table-responsive">
                                    <table class="table table-sm align-middle" style="font-size:0.83rem;">
                                        <thead>
                                            <tr>
                                                <th>Customer &amp; Username</th>
                                                <th>Email Address</th>
                                                <th class="text-end">Registered Date</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="c" items="${custData.customerList}">
                                                <tr>
                                                    <td>
                                                        <strong style="color:var(--txt);">${c.full_name}</strong>
                                                        <small class="d-block text-muted">@${c.username} [ID: #${c.user_id}]</small>
                                                    </td>
                                                    <td class="small fw-semibold" style="font-family:'JetBrains Mono',monospace;">${c.email}</td>
                                                    <td class="text-end text-muted small">${c.created_at}</td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>

        </section>

    </main>

    <!-- ═══════════════════════════════════════════ -->
    <!--  MODAL: ACCOUNT & PROFILE EDIT              -->
    <!-- ═══════════════════════════════════════════ -->
    <div class="modal fade" id="accountModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" style="color:var(--txt); font-size:1.15rem;">
                        <i class="bi bi-person-circle text-purple me-2"></i>My Profile &amp; Account Settings
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <form action="/account/update-profile" method="post" id="profileUpdateForm" autocomplete="off">
                        <input type="hidden" name="redirectUrl" value="/reports/dashboard">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary">Full Name</label>
                            <input type="text" name="fullName" class="form-control"
                                   value="${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.currentUser}"
                                   placeholder="Your full name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary">Email Address</label>
                            <input type="email" name="email" class="form-control"
                                   value="${not empty sessionScope.email ? sessionScope.email : 'admin@parttrack.com'}"
                                   placeholder="your@email.com" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary">New Password (leave blank to keep current)</label>
                            <input type="password" name="newPassword" class="form-control" placeholder="At least 4 characters">
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary">Confirm New Password</label>
                            <input type="password" name="confirmNewPassword" class="form-control" placeholder="Re-enter password">
                        </div>
                        <div class="d-grid mt-4">
                            <button type="submit" class="btn-purple py-2 justify-content-center">Save Profile Changes</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        /* ── Dark Mode Toggle ── */
        function toggleTheme() {
            var current = document.documentElement.getAttribute('data-theme') || 'light';
            var next = current === 'dark' ? 'light' : 'dark';
            document.documentElement.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            var icon = document.getElementById('themeSideIcon');
            if (icon) {
                icon.className = next === 'dark' ? 'bi bi-sun-fill text-warning' : 'bi bi-moon-stars-fill';
            }
        }
        (function(){
            var t = localStorage.getItem('theme') || 'light';
            var icon = document.getElementById('themeSideIcon');
            if (icon) {
                icon.className = t === 'dark' ? 'bi bi-sun-fill text-warning' : 'bi bi-moon-stars-fill';
            }
        })();

        /* ── Open Account Modal ── */
        function openAccountModal() {
            new bootstrap.Modal(document.getElementById('accountModal')).show();
        }
    </script>
</body>
</html>
