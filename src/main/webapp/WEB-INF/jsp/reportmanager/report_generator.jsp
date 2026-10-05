<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Multi-Department Report Generator | PartTrack</title>

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

        /* ── MODULE SELECTOR CARDS ── */
        .module-check-card {
            border: 2px solid var(--border);
            border-radius: 12px;
            padding: 1.15rem;
            background: var(--card);
            cursor: pointer;
            transition: all .18s;
            position: relative;
            display: flex;
            align-items: flex-start;
            gap: .95rem;
            height: 100%;
        }
        .module-check-card:hover {
            border-color: #a855f7;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,.05);
        }
        .module-check-card.selected {
            border-color: var(--purple);
            background: rgba(124,58,237,.04);
        }
        [data-theme="dark"] .module-check-card.selected {
            background: rgba(124,58,237,.12);
        }
        .module-icon-box {
            width: 44px; height: 44px;
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem;
            flex-shrink: 0;
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
            padding: .55rem 1.25rem;
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
            padding: .55rem 1.25rem;
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
            padding: .55rem 1rem;
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
                <a href="/reports/dashboard" class="sidebar-icon-link" title="Executive Business Dashboard">
                    <i class="bi bi-speedometer2"></i>
                </a>
            </li>
            <li>
                <a href="/reports/generator" class="sidebar-icon-link active" title="Multi-Department Report Generator">
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
                    Multi-Department Report Generator
                </h2>
                <p class="mb-0" style="color:var(--txt2); font-size:1.02rem; font-weight:500; line-height:1.55;">
                    Generate unified analytical reports combining data across Warehouse Stock, QA Inspection, Commercial Sales, Suppliers, and Customer Portal.
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

        <!-- ── PHOTO BANNER ────────────────────────── -->
        <div class="white-card mb-4" style="border-radius:16px;">
            <div class="photo-banner" style="height:140px;border-radius:16px;">
                <img src="https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&w=1200&q=85"
                     alt="Multi-Department Audit Generator" loading="lazy">
                <div class="overlay"></div>
                <div style="position:absolute;bottom:1.25rem;left:1.75rem;right:1.75rem;" class="d-flex justify-content-between align-items-end flex-wrap gap-2">
                    <div>
                        <span class="badge mb-2" style="background:rgba(124,58,237,.9);color:#fff;font-size:.72rem;letter-spacing:.05em;padding:.35rem .75rem;border-radius:8px;">
                            <i class="bi bi-sliders me-1"></i>CROSS-FUNCTIONAL REPORT ENGINE
                        </span>
                        <h3 style="color:#fff;font-size:1.45rem;font-weight:800;margin:0;letter-spacing:-.02em;">
                            Compile Combined Multi-Department Audit Report
                        </h3>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-sm btn-purple" onclick="toggleAllModules(true)">
                            <i class="bi bi-check-all me-1"></i> Select All 5 Modules
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-clean text-white border-white" onclick="toggleAllModules(false)">
                            <i class="bi bi-dash-square me-1"></i> Clear
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── REPORT GENERATOR CARD ───────────────── -->
        <div class="white-card mb-4">
            <div class="card-header-clean d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div>
                    <h4 class="fw-bold mb-1" style="color:var(--txt); font-size:1.25rem; font-weight:800; letter-spacing:-0.02em;">
                        Choose Department Scope &amp; Audit Parameters
                    </h4>
                    <p class="mb-0" style="color:var(--txt2); font-size:0.92rem; font-weight:500;">
                        Select any combination of functions below to generate a comprehensive unified report in PDF or TXT format, or store directly in the official audit queue.
                    </p>
                </div>
                <span class="badge bg-success-subtle text-success border border-success px-3 py-2 fw-bold">
                    <i class="bi bi-shield-check me-1"></i>Executive Inspection Ready
                </span>
            </div>

            <div class="p-4">
                <form action="/reports/generate-combined" method="post" id="multiReportForm">
                    
                    <!-- 1. Interactive Module Checkboxes -->
                    <div class="mb-4">
                        <label class="form-label fw-bold mb-3" style="color:var(--txt); font-size:1rem;">
                            <i class="bi bi-grid-fill text-purple me-1"></i> Choose Operational Departments to Include:
                        </label>
                        <div class="row g-3">
                            
                            <!-- Module 1: Inventory -->
                            <div class="col-md-6 col-lg-4">
                                <div class="module-check-card selected" id="card-inventory" onclick="toggleModuleCard('inventory', event)">
                                    <input type="checkbox" name="selectedModules" value="inventory" id="chk-inventory" checked class="form-check-input mt-1">
                                    <div class="module-icon-box bg-primary-subtle text-primary">
                                        <i class="bi bi-boxes"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold" style="color:var(--txt);">Warehouse Inventory</div>
                                        <small class="d-block" style="color:var(--txt2);">Stock balances, depot capacity, unit valuation &amp; reorder level alerts.</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Module 2: Supplier -->
                            <div class="col-md-6 col-lg-4">
                                <div class="module-check-card selected" id="card-supplier" onclick="toggleModuleCard('supplier', event)">
                                    <input type="checkbox" name="selectedModules" value="supplier" id="chk-supplier" checked class="form-check-input mt-1">
                                    <div class="module-icon-box bg-success-subtle text-success">
                                        <i class="bi bi-truck"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold" style="color:var(--txt);">Supplier Partner Network</div>
                                        <small class="d-block" style="color:var(--txt2);">Authorized OEM suppliers, active vendors &amp; purchase order dispatches.</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Module 3: Spare Part Manager -->
                            <div class="col-md-6 col-lg-4">
                                <div class="module-check-card selected" id="card-spareparts" onclick="toggleModuleCard('spareparts', event)">
                                    <input type="checkbox" name="selectedModules" value="spareparts" id="chk-spareparts" checked class="form-check-input mt-1">
                                    <div class="module-icon-box bg-purple-soft text-purple">
                                        <i class="bi bi-shield-check"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold" style="color:var(--txt);">Spare Part QA &amp; Inspection</div>
                                        <small class="d-block" style="color:var(--txt2);">Incoming batch quality checks, acceptance pass rates &amp; defect rejections.</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Module 4: Sales Manager -->
                            <div class="col-md-6 col-lg-4">
                                <div class="module-check-card selected" id="card-sales" onclick="toggleModuleCard('sales', event)">
                                    <input type="checkbox" name="selectedModules" value="sales" id="chk-sales" checked class="form-check-input mt-1">
                                    <div class="module-icon-box bg-info-subtle text-info">
                                        <i class="bi bi-graph-up-arrow"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold" style="color:var(--txt);">Sales &amp; Commercial Orders</div>
                                        <small class="d-block" style="color:var(--txt2);">Customer orders queue, completed cash revenue &amp; top-demand parts.</small>
                                    </div>
                                </div>
                            </div>

                            <!-- Module 5: Customer Portal -->
                            <div class="col-md-6 col-lg-4">
                                <div class="module-check-card selected" id="card-customer" onclick="toggleModuleCard('customer', event)">
                                    <input type="checkbox" name="selectedModules" value="customer" id="chk-customer" checked class="form-check-input mt-1">
                                    <div class="module-icon-box bg-warning-subtle text-warning-emphasis">
                                        <i class="bi bi-people-fill"></i>
                                    </div>
                                    <div>
                                        <div class="fw-bold" style="color:var(--txt);">Customer Portal &amp; Users</div>
                                        <small class="d-block" style="color:var(--txt2);">Registered shopper accounts, retail orders &amp; user credentials.</small>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- 2. Parameters: Custom Title, Timeframe, Frequency -->
                    <div class="row g-3 mb-4">
                        <div class="col-md-4">
                            <label class="form-label fw-bold">Report Title</label>
                            <input type="text" name="reportTitle" class="form-control" value="Executive Cross-Functional Operations Audit" required>
                        </div>
                        <div class="col-md-2">
                            <label class="form-label fw-bold">Audit Recurrence</label>
                            <select name="frequency" class="form-select">
                                <option value="Weekly" selected>Weekly</option>
                                <option value="Daily">Daily</option>
                                <option value="Monthly">Monthly</option>
                                <option value="On-Demand">On-Demand</option>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold">From Date</label>
                            <input type="date" name="fromDate" id="combFromDate" class="form-control">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label fw-bold">To Date</label>
                            <input type="date" name="toDate" id="combToDate" class="form-control">
                        </div>
                    </div>

                    <!-- 3. Export Buttons: PDF, TXT, Save -->
                    <div class="d-flex align-items-center justify-content-between flex-wrap gap-2 pt-3 border-top" style="border-color:var(--border) !important;">
                        <div class="small fw-semibold" style="color:var(--txt2);">
                            <i class="bi bi-info-circle text-primary me-1"></i> Choose export format or save report directly to the official inspection audit queue.
                        </div>
                        <div class="d-flex align-items-center gap-2">
                            <button type="submit" name="outputFormat" value="pdf" class="btn-purple">
                                <i class="bi bi-file-earmark-pdf-fill text-white"></i> Generate &amp; Download PDF
                            </button>
                            <button type="submit" name="outputFormat" value="txt" class="btn-navy">
                                <i class="bi bi-file-text-fill text-white"></i> Generate &amp; Download TXT
                            </button>
                            <button type="submit" name="outputFormat" value="save" class="btn-outline-clean">
                                <i class="bi bi-save2 text-success"></i> Save to Audit Queue
                            </button>
                        </div>
                    </div>

                </form>
            </div>
        </div>

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
                        <input type="hidden" name="redirectUrl" value="/reports/generator">
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

        /* ── Toggle Module Cards ── */
        function toggleModuleCard(modName, event) {
            var chk = document.getElementById('chk-' + modName);
            var card = document.getElementById('card-' + modName);
            if (!event || event.target !== chk) {
                chk.checked = !chk.checked;
            }
            if (chk.checked) {
                card.classList.add('selected');
            } else {
                card.classList.remove('selected');
            }
        }

        /* ── Select All / Deselect All Modules ── */
        function toggleAllModules(selectAll) {
            var modules = ['inventory', 'supplier', 'spareparts', 'sales', 'customer'];
            modules.forEach(function(m) {
                var chk = document.getElementById('chk-' + m);
                var card = document.getElementById('card-' + m);
                if (chk) chk.checked = selectAll;
                if (card) {
                    if (selectAll) card.classList.add('selected');
                    else card.classList.remove('selected');
                }
            });
        }

        /* ── Open Account Modal ── */
        function openAccountModal() {
            new bootstrap.Modal(document.getElementById('accountModal')).show();
        }

        // Initialize default dates
        window.addEventListener('DOMContentLoaded', function() {
            var now = new Date();
            var past = new Date();
            past.setDate(now.getDate() - 7);
            var toIso = now.toISOString().split('T')[0];
            var fromIso = past.toISOString().split('T')[0];
            var f = document.getElementById('combFromDate');
            var t = document.getElementById('combToDate');
            if (f && !f.value) f.value = fromIso;
            if (t && !t.value) t.value = toIso;
        });
    </script>
</body>
</html>
