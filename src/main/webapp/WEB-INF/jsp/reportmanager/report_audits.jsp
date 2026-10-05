<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Audit &amp; Inspection Inbox | PartTrack</title>

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
            --table-head: #f8fafc; --table-hover: #f1f5f9; --input-bg: #ffffff;
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

        /* ── BADGES & BUTTONS ── */
        .border-purple { border-color: #a855f7 !important; }
        .text-purple { color: #7c3aed !important; }
        .bg-purple-soft { background: #f5f3ff !important; color: #7c3aed !important; }
        [data-theme="dark"] .bg-purple-soft { background: #2e1065 !important; color: #c084fc !important; }
        .bg-purple { background: #7c3aed !important; color: #fff !important; }

        .btn-purple {
            background: var(--purple);
            color: #fff;
            border: none;
            border-radius: 9px;
            padding: .45rem 1rem;
            font-weight: 700;
            font-size: .86rem;
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            text-decoration: none;
            transition: all .15s;
            cursor: pointer;
        }
        .btn-purple:hover { background: #6d28d9; color: #fff; transform: translateY(-1px); }

        .btn-outline-clean {
            background: transparent;
            color: var(--txt);
            border: 1px solid var(--border);
            border-radius: 9px;
            padding: .45rem .85rem;
            font-weight: 600;
            font-size: .85rem;
            display: inline-flex;
            align-items: center;
            gap: .4rem;
            text-decoration: none;
            transition: all .15s;
            cursor: pointer;
        }
        .btn-outline-clean:hover { background: var(--table-hover); color: var(--txt); }
        .btn-outline-clean.active {
            background: var(--purple) !important;
            color: #fff !important;
            border-color: var(--purple) !important;
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
            padding: 1.15rem 1.25rem;
            vertical-align: middle;
        }
        .table thead th {
            background: var(--table-head) !important;
            color: var(--txt2) !important;
            font-size: .76rem;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: .06em;
            border-bottom: 2px solid var(--border) !important;
        }
        .table tbody tr {
            transition: background-color .15s ease;
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
        .report-box {
            background: var(--table-head);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1.25rem;
            color: var(--txt);
            font-family: 'JetBrains Mono', monospace;
            font-size: .85rem;
            white-space: pre-wrap;
            line-height: 1.6;
            max-height: 340px;
            overflow-y: auto;
        }

        /* ── AUDIT INBOX TABLE POLISH ── */
        .badge-ref-id {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.82rem;
            font-weight: 700;
            padding: 0.35rem 0.65rem;
            border-radius: 8px;
            background: var(--table-hover);
            color: var(--txt);
            border: 1px solid var(--border);
            display: inline-block;
        }

        .status-badge-clean {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.4rem 0.85rem;
            border-radius: 20px;
            font-size: 0.82rem;
            font-weight: 700;
            white-space: nowrap;
        }
        .status-badge-clean.approved {
            background: #ecfdf5;
            color: #059669;
            border: 1px solid #a7f3d0;
        }
        [data-theme="dark"] .status-badge-clean.approved {
            background: rgba(16, 185, 129, 0.15);
            color: #34d399;
            border-color: rgba(16, 185, 129, 0.3);
        }

        .status-badge-clean.pending {
            background: #fffbeb;
            color: #d97706;
            border: 1px solid #fde68a;
        }
        [data-theme="dark"] .status-badge-clean.pending {
            background: rgba(245, 158, 11, 0.15);
            color: #fbbf24;
            border-color: rgba(245, 158, 11, 0.3);
        }

        .status-badge-clean.rejected {
            background: #fff1f2;
            color: #e11d48;
            border: 1px solid #fecdd3;
        }
        [data-theme="dark"] .status-badge-clean.rejected {
            background: rgba(239, 68, 68, 0.15);
            color: #f87171;
            border-color: rgba(239, 68, 68, 0.3);
        }

        .btn-action-approve {
            background: #10b981;
            color: #ffffff;
            border: none;
            padding: 0.42rem 0.85rem;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.82rem;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            transition: all 0.15s ease;
            box-shadow: 0 1px 3px rgba(16, 185, 129, 0.2);
            white-space: nowrap;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-action-approve:hover {
            background: #059669;
            color: #ffffff;
            transform: translateY(-1px);
        }

        .btn-action-reject {
            background: #ef4444;
            color: #ffffff;
            border: none;
            padding: 0.42rem 0.85rem;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.82rem;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            transition: all 0.15s ease;
            box-shadow: 0 1px 3px rgba(239, 68, 68, 0.2);
            white-space: nowrap;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-action-reject:hover {
            background: #dc2626;
            color: #ffffff;
            transform: translateY(-1px);
        }

        .btn-action-inspect {
            background: var(--purple);
            color: #ffffff;
            border: none;
            padding: 0.42rem 0.85rem;
            border-radius: 8px;
            font-weight: 700;
            font-size: 0.82rem;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            transition: all 0.15s ease;
            box-shadow: 0 1px 3px rgba(124, 58, 237, 0.2);
            white-space: nowrap;
            cursor: pointer;
        }
        .btn-action-inspect:hover {
            background: #6d28d9;
            color: #ffffff;
            transform: translateY(-1px);
        }

        .btn-action-doc {
            background: var(--card);
            color: var(--txt);
            border: 1px solid var(--border);
            padding: 0.38rem 0.65rem;
            border-radius: 8px;
            font-weight: 600;
            font-size: 0.8rem;
            display: inline-flex;
            align-items: center;
            gap: 0.3rem;
            text-decoration: none;
            transition: all 0.15s ease;
            white-space: nowrap;
        }
        .btn-action-doc:hover {
            background: var(--table-hover);
            color: var(--txt);
            border-color: #cbd5e1;
        }

        .btn-action-delete {
            background: transparent;
            color: #ef4444;
            border: 1px solid var(--border);
            padding: 0.38rem 0.6rem;
            border-radius: 8px;
            font-size: 0.85rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            transition: all 0.15s ease;
            cursor: pointer;
        }
        .btn-action-delete:hover {
            background: #fee2e2;
            color: #dc2626;
            border-color: #fca5a5;
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
                <a href="/reports/generator" class="sidebar-icon-link" title="Multi-Department Report Generator">
                    <i class="bi bi-sliders"></i>
                </a>
            </li>
            <li>
                <a href="/reports/audits" class="sidebar-icon-link active" title="Manager Audit & Inspection Inbox">
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
                    Manager Audit &amp; Inspection Inbox
                </h2>
                <p class="mb-0" style="color:var(--txt2); font-size:1.02rem; font-weight:500; line-height:1.55;">
                    Review transmitted management reports, inspect operational audits, and record official executive approval decisions.
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

        <!-- ── STATS CALCULATION ───────────────────── -->
        <c:set var="totalReports" value="${not empty inventoryReports ? inventoryReports.size() : 0}"/>
        <c:set var="pendingCount" value="0"/>
        <c:set var="approvedCount" value="0"/>
        <c:set var="rejectedCount" value="0"/>

        <c:forEach var="r" items="${inventoryReports}">
            <c:set var="st" value="${r.status != null ? r.status.toLowerCase() : ''}"/>
            <c:choose>
                <c:when test="${st.contains('approv')}">
                    <c:set var="approvedCount" value="${approvedCount + 1}"/>
                </c:when>
                <c:when test="${st.contains('reject') || st.contains('revis')}">
                    <c:set var="rejectedCount" value="${rejectedCount + 1}"/>
                </c:when>
                <c:otherwise>
                    <c:set var="pendingCount" value="${pendingCount + 1}"/>
                </c:otherwise>
            </c:choose>
        </c:forEach>

        <!-- ── 4 CLEAR KPI SUMMARY CARDS ───────────── -->
        <div class="row g-3 mb-4">
            <div class="col-sm-6 col-xl-3">
                <div class="white-card p-3 mb-0" style="border-top:4px solid #7c3aed;">
                    <div class="text-secondary small fw-bold text-uppercase" style="font-size:.78rem; font-weight:800; letter-spacing:.06em;">All Transmitted Filings</div>
                    <div class="fw-bold mt-1" style="font-size:2rem; font-weight:800; letter-spacing:-0.02em; color:var(--purple);">${totalReports} Reports</div>
                    <div class="small text-secondary mt-1"><i class="bi bi-folder2-open text-purple me-1"></i>Official audit archive</div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="white-card p-3 mb-0" style="border-top:4px solid #f59e0b;">
                    <div class="text-secondary small fw-bold text-uppercase" style="font-size:.78rem; font-weight:800; letter-spacing:.06em;">Pending Review</div>
                    <div class="fw-bold mt-1 text-warning-emphasis" style="font-size:2rem; font-weight:800; letter-spacing:-0.02em;">${pendingCount} Filings</div>
                    <div class="small text-secondary mt-1"><i class="bi bi-hourglass-split text-warning me-1"></i>Awaiting executive decision</div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="white-card p-3 mb-0" style="border-top:4px solid #10b981;">
                    <div class="text-secondary small fw-bold text-uppercase" style="font-size:.78rem; font-weight:800; letter-spacing:.06em;">Approved &amp; Certified</div>
                    <div class="fw-bold mt-1 text-success" style="font-size:2rem; font-weight:800; letter-spacing:-0.02em;">${approvedCount} Endorsed</div>
                    <div class="small text-secondary mt-1"><i class="bi bi-check-circle-fill text-success me-1"></i>Passed operational inspection</div>
                </div>
            </div>
            <div class="col-sm-6 col-xl-3">
                <div class="white-card p-3 mb-0" style="border-top:4px solid #ef4444;">
                    <div class="text-secondary small fw-bold text-uppercase" style="font-size:.78rem; font-weight:800; letter-spacing:.06em;">Rejected / Revisions</div>
                    <div class="fw-bold mt-1 text-danger" style="font-size:2rem; font-weight:800; letter-spacing:-0.02em;">${rejectedCount} Rejected</div>
                    <div class="small text-secondary mt-1"><i class="bi bi-x-circle-fill text-danger me-1"></i>Deficiencies flagged</div>
                </div>
            </div>
        </div>

        <!-- ── MAIN AUDIT INBOX CONTAINER ─────────── -->
        <div class="white-card mb-4" id="incomingReportsSection">
            
            <!-- Clean Header + Search & Filter Toolbar -->
            <div class="p-4 border-bottom" style="border-color:var(--border) !important;">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3 mb-3">
                    <div>
                        <h4 class="fw-bold mb-1" style="color:var(--txt); font-size:1.3rem; font-weight:800; letter-spacing:-0.02em;">
                            Transmitted Management Reports Registry
                        </h4>
                        <p class="mb-0" style="color:var(--txt2); font-size:0.92rem; font-weight:500;">
                            Inspect full audit documents, examine manager submissions, and apply certified executive decisions.
                        </p>
                    </div>
                </div>

                <!-- Instant Search & Filter Pills Row -->
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-3">
                    <!-- Realtime Search Input -->
                    <div class="input-group" style="max-width:380px;">
                        <span class="input-group-text border-end-0" style="background:var(--table-head); border-color:var(--border); color:var(--txt2);">
                            <i class="bi bi-search"></i>
                        </span>
                        <input type="text" id="reportSearchInput" class="form-control border-start-0"
                               placeholder="Search by Title, Manager, or Ref #..."
                               onkeyup="filterReports()">
                    </div>

                    <!-- Clean Status Filter Buttons -->
                    <div class="d-flex align-items-center gap-2 flex-wrap">
                        <button type="button" class="btn btn-sm btn-purple report-filter-btn" id="filter-all" onclick="filterAuditReports('all')">
                            All Reports (${totalReports})
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-clean report-filter-btn" id="filter-pending" onclick="filterAuditReports('pending')">
                            <i class="bi bi-hourglass-split text-warning me-1"></i> Pending (${pendingCount})
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-clean report-filter-btn" id="filter-approved" onclick="filterAuditReports('approved')">
                            <i class="bi bi-check-circle-fill text-success me-1"></i> Approved (${approvedCount})
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-clean report-filter-btn" id="filter-rejected" onclick="filterAuditReports('rejected')">
                            <i class="bi bi-x-circle-fill text-danger me-1"></i> Rejected (${rejectedCount})
                        </button>
                    </div>
                </div>
            </div>

            <!-- ── DATA TABLE ──────────────────────────── -->
            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th style="width:75px; text-align:center;">Ref #</th>
                            <th style="min-width:320px;">Report Information &amp; Scope</th>
                            <th style="width:190px;">Transmitted By</th>
                            <th style="width:170px; text-align:center;">Executive Status</th>
                            <th style="min-width:370px; text-align:end;">Actions &amp; Decisions</th>
                        </tr>
                    </thead>
                    <tbody id="reportTableBody">
                        <c:choose>
                            <c:when test="${empty inventoryReports}">
                                <tr>
                                    <td colspan="5" class="text-center py-5" style="color:var(--txt2);">
                                        <i class="bi bi-inbox fs-1 d-block mb-2 text-muted"></i>
                                        <h6 class="fw-bold">No Management Reports Transmitted Yet</h6>
                                        <small>When department managers generate and send audit filings, they will appear here for executive analysis.</small>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="rep" items="${inventoryReports}">
                                    
                                    <!-- Status key detection -->
                                    <c:set var="rawStatus" value="${not empty rep.status ? rep.status : 'Pending Review'}"/>
                                    <c:set var="statusKey" value="pending"/>
                                    <c:choose>
                                        <c:when test="${rawStatus.toLowerCase().contains('approv')}">
                                            <c:set var="statusKey" value="approved"/>
                                        </c:when>
                                        <c:when test="${rawStatus.toLowerCase().contains('reject') || rawStatus.toLowerCase().contains('revis')}">
                                            <c:set var="statusKey" value="rejected"/>
                                        </c:when>
                                        <c:otherwise>
                                            <c:set var="statusKey" value="pending"/>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- Department badge determination -->
                                    <c:set var="typeInfo" value="${(not empty rep.reportType ? rep.reportType : '')} ${(not empty rep.reportTitle ? rep.reportTitle : '')} ${(not empty rep.generatedBy ? rep.generatedBy : '')}"/>

                                    <tr class="report-audit-row" data-status="${statusKey}">
                                        
                                        <!-- 1. Ref ID -->
                                        <td class="text-center">
                                            <span class="badge-ref-id">
                                                #${rep.reportId}
                                            </span>
                                        </td>

                                        <!-- 2. Report Details & Department Tag -->
                                        <td>
                                            <div class="fw-bold mb-1" style="color:var(--txt); font-size:1.02rem;">
                                                ${rep.reportTitle}
                                            </div>
                                            <div class="d-flex align-items-center gap-2 flex-wrap mb-1">
                                                <c:choose>
                                                    <c:when test="${typeInfo.toLowerCase().contains('sales')}">
                                                        <span class="badge bg-info-subtle text-info border border-info px-2 py-1 fw-bold">
                                                            <i class="bi bi-graph-up-arrow me-1"></i>Sales Order Reconciliation
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${typeInfo.toLowerCase().contains('inventory') || typeInfo.toLowerCase().contains('warehouse') || typeInfo.toLowerCase().contains('stock')}">
                                                        <span class="badge bg-warning-subtle text-warning-emphasis border border-warning px-2 py-1 fw-bold">
                                                            <i class="bi bi-boxes me-1"></i>Warehouse Inventory
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${typeInfo.toLowerCase().contains('supplier')}">
                                                        <span class="badge bg-success-subtle text-success border border-success px-2 py-1 fw-bold">
                                                            <i class="bi bi-truck me-1"></i>Supplier Network
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${typeInfo.toLowerCase().contains('spare') || typeInfo.toLowerCase().contains('qa') || typeInfo.toLowerCase().contains('procurement')}">
                                                        <span class="badge bg-purple-soft text-purple border border-purple px-2 py-1 fw-bold">
                                                            <i class="bi bi-shield-check me-1"></i>Spare Parts QA
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-primary-subtle text-primary border border-primary px-2 py-1 fw-bold">
                                                            <i class="bi bi-layers-fill me-1"></i>Cross-Functional Audit
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>

                                                <c:if test="${not empty rep.fromDate && not empty rep.toDate}">
                                                    <span class="badge bg-light text-secondary border px-2 py-1 small">
                                                        <i class="bi bi-calendar3 me-1"></i>${rep.fromDate} → ${rep.toDate}
                                                    </span>
                                                </c:if>
                                            </div>
                                            
                                            <!-- Short summary note if available -->
                                            <c:if test="${not empty rep.notes}">
                                                <div class="text-secondary small fst-italic" style="font-size:0.8rem; line-height:1.4;">
                                                    <i class="bi bi-info-circle me-1"></i>${rep.notes}
                                                </div>
                                            </c:if>

                                            <!-- Hidden full content storage for modal preview -->
                                            <div id="admin-report-content-${rep.reportId}" style="display:none;">${rep.reportContent}</div>
                                        </td>

                                        <!-- 3. Transmitted By -->
                                        <td>
                                            <div class="fw-bold" style="color:var(--txt); font-size:.92rem;">
                                                <i class="bi bi-person-fill text-secondary me-1"></i>${rep.generatedBy}
                                            </div>
                                            <div class="text-muted small mt-1" style="font-size:.8rem;">
                                                <i class="bi bi-clock me-1"></i>
                                                <c:choose>
                                                    <c:when test="${not empty rep.generatedDate}">
                                                        ${rep.generatedDate}
                                                    </c:when>
                                                    <c:otherwise>Recent</c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>

                                        <!-- 4. Executive Status -->
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${statusKey == 'approved'}">
                                                    <span class="status-badge-clean approved">
                                                        <i class="bi bi-check-circle-fill"></i> Approved
                                                    </span>
                                                </c:when>
                                                <c:when test="${statusKey == 'rejected'}">
                                                    <span class="status-badge-clean rejected">
                                                        <i class="bi bi-x-circle-fill"></i> Rejected
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge-clean pending">
                                                        <i class="bi bi-hourglass-split"></i> Pending Review
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- 5. Actions & Decisions -->
                                        <td class="text-end" style="min-width:370px;">
                                            <div class="d-inline-flex align-items-center justify-content-end gap-1 flex-nowrap">
                                                
                                                <!-- Quick Approve Button (if not already approved) -->
                                                <c:if test="${statusKey != 'approved'}">
                                                    <form action="/reports/review" method="post" style="margin:0;">
                                                        <input type="hidden" name="reportId" value="${rep.reportId}">
                                                        <input type="hidden" name="status" value="Approved">
                                                        <input type="hidden" name="decision" value="APPROVE">
                                                        <input type="hidden" name="notes" value="Quick approved by Executive Administrator.">
                                                        <button type="submit" class="btn-action-approve" title="1-Click Fast Approval">
                                                            <i class="bi bi-check-lg"></i> Approve
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <!-- Quick Reject Button (if not already rejected) -->
                                                <c:if test="${statusKey != 'rejected'}">
                                                    <form action="/reports/review" method="post" style="margin:0;" onsubmit="return confirm('Are you sure you want to REJECT report #${rep.reportId}?');">
                                                        <input type="hidden" name="reportId" value="${rep.reportId}">
                                                        <input type="hidden" name="status" value="Rejected">
                                                        <input type="hidden" name="decision" value="REJECT">
                                                        <input type="hidden" name="notes" value="Quick rejected upon executive review.">
                                                        <button type="submit" class="btn-action-reject" title="1-Click Fast Rejection">
                                                            <i class="bi bi-x-lg"></i> Reject
                                                        </button>
                                                    </form>
                                                </c:if>

                                                <!-- Full Inspect & Decide Modal Button (Select Mode) -->
                                                <button type="button" class="btn-action-inspect inspect-report-btn"
                                                        data-id="${rep.reportId}"
                                                        data-title="<c:out value='${rep.reportTitle}'/>"
                                                        data-status="<c:out value='${rawStatus}'/>"
                                                        data-notes="<c:out value='${rep.notes != null ? rep.notes : \"\"}'/>"
                                                        title="Inspect full report viewer & select custom decision mode">
                                                    <i class="bi bi-eye-fill"></i> Inspect
                                                </button>

                                                <!-- Download PDF -->
                                                <a href="/reports/download/${rep.reportId}"
                                                   class="btn-action-doc" title="Download Official PDF">
                                                    <i class="bi bi-file-earmark-pdf-fill text-danger"></i> PDF
                                                </a>

                                                <!-- Download TXT -->
                                                <a href="/reports/download-txt/${rep.reportId}"
                                                   class="btn-action-doc" title="Download Raw TXT">
                                                    <i class="bi bi-file-text-fill text-primary"></i> TXT
                                                </a>

                                                <!-- Delete Filing -->
                                                <form action="/reports/delete" method="post" style="margin:0;" onsubmit="return confirm('Permanently delete report #${rep.reportId}?');">
                                                    <input type="hidden" name="reportId" value="${rep.reportId}">
                                                    <button type="submit" class="btn-action-delete" title="Delete filing permanently">
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

            <!-- No search matches placeholder -->
            <div id="noReportsMatchMsg" class="text-center py-5" style="display:none; color:var(--txt2);">
                <i class="bi bi-search fs-1 d-block mb-2 text-muted"></i>
                <h6 class="fw-bold">No Matching Reports Found</h6>
                <small>Try adjusting your search keywords or clear the status filter.</small>
            </div>

        </div>

    </main>

    <!-- ═══════════════════════════════════════════ -->
    <!--  MODAL: ANALYZE & REVIEW INVENTORY REPORT   -->
    <!-- ═══════════════════════════════════════════ -->
    <div class="modal fade" id="analyzeReportModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <form action="/reports/review" method="post">
                    <div class="modal-header">
                        <div>
                            <span class="badge bg-purple-soft text-purple border border-purple mb-1">
                                <i class="bi bi-shield-check me-1"></i>EXECUTIVE AUDIT INSPECTION
                            </span>
                            <h5 class="modal-title fw-bold mb-0" id="analyzeModalTitle" style="color:var(--txt);">
                                Inspect Management Report
                            </h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="reportId" id="analyzeModalReportId">
                        <input type="hidden" name="decision" value="APPROVE">
                        
                        <div class="d-flex align-items-center justify-content-between mb-2">
                            <span class="small fw-bold text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">
                                Transmitted Document Contents:
                            </span>
                            <div class="d-flex align-items-center gap-2">
                                <span class="badge" id="analyzeModalStatusBadge">Pending</span>
                                <a href="javascript:void(0)" id="analyzeModalDownloadBtn" class="btn btn-sm btn-outline-clean py-0" style="font-size:0.75rem;">
                                    <i class="bi bi-download text-danger me-1"></i>PDF
                                </a>
                                <a href="javascript:void(0)" id="analyzeModalDownloadTxtBtn" class="btn btn-sm btn-outline-clean py-0" style="font-size:0.75rem;">
                                    <i class="bi bi-file-text text-primary me-1"></i>TXT
                                </a>
                            </div>
                        </div>
                        
                        <div class="report-box mb-4" id="analyzeModalContent">
                            Loading report content...
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">
                                Executive Decision Status:
                            </label>
                            <select name="status" class="form-select" id="analyzeModalStatusSelect" required>
                                <option value="Approved">Approved (Certified &amp; Endorsed)</option>
                                <option value="Pending Review">Pending Review (Awaiting Clarification)</option>
                                <option value="Revision Needed">Revision Needed (Send Back to Manager)</option>
                                <option value="Rejected">Rejected (Deficiencies Identified)</option>
                            </select>
                        </div>

                        <div class="mb-0">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">
                                Executive Directives &amp; Inspection Notes:
                            </label>
                            <textarea name="notes" class="form-control" id="analyzeModalNotes" rows="3"
                                      placeholder="Add executive inspection findings or directives for the department manager..."></textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-outline-clean" data-bs-dismiss="modal">Close</button>
                        <button type="submit" class="btn-purple">
                            <i class="bi bi-check2-circle me-1"></i> Commit Executive Decision
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

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
                        <input type="hidden" name="redirectUrl" value="/reports/audits">
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

        /* ── Realtime Search & Filter ── */
        window.activeStatusFilter = 'all';

        function filterReports() {
            var searchInput = document.getElementById('reportSearchInput');
            var search = searchInput ? (searchInput.value || '').toLowerCase().trim() : '';
            var currentFilter = window.activeStatusFilter || 'all';
            var rows = document.querySelectorAll('.report-audit-row');
            var visibleCount = 0;

            rows.forEach(function(row) {
                var status = row.getAttribute('data-status');
                var text = (row.textContent || '').toLowerCase();
                var matchesStatus = (currentFilter === 'all' || status === currentFilter);
                var matchesSearch = (!search || text.indexOf(search) !== -1);

                if (matchesStatus && matchesSearch) {
                    row.style.display = '';
                    visibleCount++;
                } else {
                    row.style.display = 'none';
                }
            });

            var emptyMsg = document.getElementById('noReportsMatchMsg');
            if (emptyMsg) {
                emptyMsg.style.display = (visibleCount === 0 && rows.length > 0) ? '' : 'none';
            }
        }

        function filterAuditReports(type) {
            window.activeStatusFilter = type;
            document.querySelectorAll('.report-filter-btn').forEach(function(btn) {
                btn.classList.remove('active', 'btn-purple');
                btn.classList.add('btn-outline-clean');
            });
            var activeBtn = document.getElementById('filter-' + type);
            if (activeBtn) {
                activeBtn.classList.remove('btn-outline-clean');
                activeBtn.classList.add('btn-purple', 'active');
            }
            filterReports();
        }

        /* ── Analyze Modal ── */
        function openAnalyzeModal(id, title, status, notes) {
            document.getElementById('analyzeModalReportId').value = id;
            document.getElementById('analyzeModalTitle').textContent = title + " (Ref #" + id + ")";
            var badge = document.getElementById('analyzeModalStatusBadge');
            badge.textContent = status;
            if (status && status.toLowerCase().indexOf('approv') !== -1) {
                badge.className = 'badge bg-success text-white px-2 py-1 fw-bold';
            } else if (status && (status.toLowerCase().indexOf('reject') !== -1 || status.toLowerCase().indexOf('revis') !== -1)) {
                badge.className = 'badge bg-danger text-white px-2 py-1 fw-bold';
            } else {
                badge.className = 'badge bg-warning text-dark px-2 py-1 fw-bold';
            }
            var contentEl = document.getElementById('admin-report-content-' + id);
            document.getElementById('analyzeModalContent').textContent = contentEl ? contentEl.textContent : "No content available.";
            document.getElementById('analyzeModalNotes').value = notes || '';
            
            var sel = document.getElementById('analyzeModalStatusSelect');
            if (sel) {
                var sLower = (status || '').toLowerCase();
                if (sLower.indexOf('approv') !== -1) sel.value = 'Approved';
                else if (sLower.indexOf('revis') !== -1) sel.value = 'Revision Needed';
                else if (sLower.indexOf('reject') !== -1) sel.value = 'Rejected';
                else sel.value = 'Pending Review';
            }

            var dlBtn = document.getElementById('analyzeModalDownloadBtn');
            if (dlBtn) dlBtn.href = '/reports/download/' + id;
            var dlTxtBtn = document.getElementById('analyzeModalDownloadTxtBtn');
            if (dlTxtBtn) dlTxtBtn.href = '/reports/download-txt/' + id;
            new bootstrap.Modal(document.getElementById('analyzeReportModal')).show();
        }

        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.inspect-report-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    openAnalyzeModal(this.dataset.id, this.dataset.title, this.dataset.status, this.dataset.notes);
                });
            });
        });

        /* ── Open Account Modal ── */
        function openAccountModal() {
            new bootstrap.Modal(document.getElementById('accountModal')).show();
        }
    </script>
</body>
</html>
