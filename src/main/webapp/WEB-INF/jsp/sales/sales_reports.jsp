<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Commercial Reports & Executive Transmissions | PartTrack Atelier</title>
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

        /* ── PHOTO BANNER (Brand new image: sales_reports_analytics.jpg) ── */
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
            object-position: center 40%;
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
        .status-pill-glow.approved { background: rgba(16, 185, 129, 0.16); color: #10b981; border: 1px solid rgba(16, 185, 129, 0.35); }
        .status-pill-glow.reviewed { background: rgba(6, 182, 212, 0.16); color: #06b6d4; border: 1px solid rgba(6, 182, 212, 0.35); }
        .status-pill-glow.pending { background: rgba(245, 158, 11, 0.16); color: #f59e0b; border: 1px solid rgba(245, 158, 11, 0.35); }
        .status-pill-glow.rejected { background: rgba(244, 63, 94, 0.16); color: #f43f5e; border: 1px solid rgba(244, 63, 94, 0.35); }

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
                <a href="/sales/orders" class="sales-nav-item" title="Customer Orders Queue & Fulfillment">
                    <i class="bi bi-bag-check"></i>
                    <c:if test="${pendingOrders > 0}">
                        <span class="badge-pulse-dot"></span>
                    </c:if>
                </a>
            </li>
            <li>
                <!-- UI 3: Commercial Audit Reports -->
                <a href="/sales/reports" class="sales-nav-item active" title="Commercial Audit Reports & Transmissions">
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
                    <i class="bi bi-file-earmark-bar-graph text-info"></i> Commercial Audit Reports &amp; Transmissions
                </h1>
                <p class="sales-tagline">Executive commercial oversight &bull; Financial revenue certification &bull; PDF document vault</p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <a href="/sales/orders" class="btn-outline-glass">
                    <i class="bi bi-bag-check"></i> Orders Queue
                </a>
                <button class="btn-emerald-pill" data-bs-toggle="modal" data-bs-target="#generateSalesReportModal">
                    <i class="bi bi-plus-lg"></i> Transmit New Report
                </button>
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

        <!-- BANNER STRIP (Brand new image: sales_reports_analytics.jpg) -->
        <section class="sales-banner-strip">
            <img src="/images/sales/sales_reports_analytics.jpg" alt="Executive Financial Analytics" class="sales-banner-bg">
            <div class="sales-banner-overlay"></div>
            <div class="sales-banner-content">
                <div class="d-flex align-items-center gap-2 mb-1">
                    <span class="badge rounded-pill px-3 py-1 fw-bold text-uppercase" style="background:rgba(6,182,212,0.2);color:#06b6d4;border:1px solid rgba(6,182,212,0.4);font-size:0.7rem;letter-spacing:0.06em;">
                        Executive Governance
                    </span>
                    <span class="text-white-50 small">&bull; Realized Cash Rs.&nbsp;<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></span>
                </div>
                <h3 class="fw-bold mb-1 text-white">Commercial Income &amp; Revenue Telemetry</h3>
                <p class="small text-white-50 mb-0">Generate official commercial audits, transmit them directly to Executive Management, and export PDF archives.</p>
            </div>
            <div class="position-relative z-2 text-end d-none d-md-block">
                <button class="btn-emerald-pill" data-bs-toggle="modal" data-bs-target="#generateSalesReportModal">
                    <i class="bi bi-file-earmark-plus"></i> Generate Audit Report
                </button>
            </div>
        </section>

        <!-- TRANSMITTED REPORTS ATELIER TABLE -->
        <div class="atelier-card">
            <div class="atelier-head">
                <div class="atelier-title">
                    <i class="bi bi-journal-check text-info"></i> Transmitted Executive Sales Reports
                </div>
                <span class="small text-muted">${salesReports != null ? salesReports.size() : 0} report(s) on file</span>
            </div>

            <c:choose>
                <c:when test="${empty salesReports}">
                    <div class="p-5 text-center text-muted">
                        <i class="bi bi-journal-text fs-2 d-block mb-2"></i>
                        <div class="fw-semibold">No Sales Reports Transmitted Yet</div>
                        <small class="mb-3 d-block">Generate a verified commercial sales report to transmit to the Executive Administrator.</small>
                        <button class="btn-emerald-pill" data-bs-toggle="modal" data-bs-target="#generateSalesReportModal">
                            <i class="bi bi-plus-lg"></i> Create First Report
                        </button>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="table-responsive">
                        <table class="atelier-table">
                            <thead>
                                <tr>
                                    <th>Report Ref</th>
                                    <th>Audit Title</th>
                                    <th>Classification</th>
                                    <th>Audit Timeframe</th>
                                    <th>Transmission Date</th>
                                    <th>Admin Status</th>
                                    <th class="text-end">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="rep" items="${salesReports}">
                                    <tr>
                                        <td><span class="order-badge-token">#REP-${rep.report_id}</span></td>
                                        <td>
                                            <div class="fw-bold">${rep.report_title}</div>
                                            <c:if test="${not empty rep.notes}">
                                                <div class="small text-muted"><i class="bi bi-chat-left-dots me-1"></i>${rep.notes}</div>
                                            </c:if>
                                        </td>
                                        <td><span class="badge rounded-pill px-3 py-1" style="background:var(--card-subtle);color:var(--txt2);border:1px solid var(--border);">${rep.report_type}</span></td>
                                        <td class="small text-muted font-monospace">${rep.from_date} &rarr; ${rep.to_date}</td>
                                        <td class="small text-muted"><i class="bi bi-clock me-1"></i>${rep.generated_date}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${rep.status == 'Approved' || rep.status == 'Approved (Audit Passed)'}">
                                                    <span class="status-pill-glow approved"><i class="bi bi-check-circle-fill"></i> Approved</span>
                                                </c:when>
                                                <c:when test="${rep.status == 'Reviewed' || rep.status == 'Reviewed & Analyzed'}">
                                                    <span class="status-pill-glow reviewed"><i class="bi bi-eye-fill"></i> Reviewed</span>
                                                </c:when>
                                                <c:when test="${rep.status == 'Needs Revision' || rep.status == 'Rejected'}">
                                                    <span class="status-pill-glow rejected"><i class="bi bi-exclamation-triangle-fill"></i> Revision Needed</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-pill-glow pending"><i class="bi bi-hourglass-split"></i> Pending Admin</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-end text-nowrap">
                                            <div class="d-inline-flex gap-1">
                                                <button class="btn-outline-glass" onclick="viewReportDetails('${rep.report_id}', '${rep.report_title}', '${rep.status}')">
                                                    <i class="bi bi-eye"></i> View
                                                </button>
                                                <a href="/sales/reports/download/${rep.report_id}" class="btn-outline-glass text-info">
                                                    <i class="bi bi-file-earmark-pdf-fill"></i> PDF
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                    <!-- Store raw content for viewer modal -->
                                    <div id="sales-report-content-${rep.report_id}" style="display:none;"><c:out value="${rep.report_content}"/></div>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </main>

    <!-- GENERATE REPORT MODAL -->
    <div class="modal fade" id="generateSalesReportModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <form action="/sales/reports/generate" method="post">
                    <div class="modal-header">
                        <div class="d-flex align-items-center gap-2">
                            <div style="width:36px;height:36px;border-radius:10px;background:var(--sales-cyan-soft);color:#06b6d4;display:flex;align-items:center;justify-content:center;">
                                <i class="bi bi-file-earmark-bar-graph"></i>
                            </div>
                            <div>
                                <h6 class="modal-title fw-bold mb-0">Generate Commercial Revenue Audit</h6>
                                <small class="text-muted">Transmit verified performance telemetry to Administrator</small>
                            </div>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>

                    <div class="modal-body p-4">
                        <div class="row g-2 mb-4">
                            <div class="col-4">
                                <div class="p-3 rounded-3 text-center" style="background:var(--card-subtle);border:1px solid var(--border);">
                                    <div class="small text-muted text-uppercase fw-bold">Settled Cash</div>
                                    <div class="fw-bold font-monospace text-success">Rs.&nbsp;<fmt:formatNumber value="${totalRevenue}" pattern="#,##0"/></div>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="p-3 rounded-3 text-center" style="background:var(--card-subtle);border:1px solid var(--border);">
                                    <div class="small text-muted text-uppercase fw-bold">Processing Value</div>
                                    <div class="fw-bold font-monospace text-info">Rs.&nbsp;<fmt:formatNumber value="${processingRevenue}" pattern="#,##0"/></div>
                                </div>
                            </div>
                            <div class="col-4">
                                <div class="p-3 rounded-3 text-center" style="background:var(--card-subtle);border:1px solid var(--border);">
                                    <div class="small text-muted text-uppercase fw-bold">Fulfilled Orders</div>
                                    <div class="fw-bold font-monospace">${completedOrders} Orders</div>
                                </div>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small text-muted text-uppercase fw-bold">Report Title</label>
                            <input type="text" name="reportTitle" class="form-control" value="Commercial Sales &amp; Income Performance Audit" required>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small text-muted text-uppercase fw-bold">From Date</label>
                                <input type="date" name="fromDate" id="reportFromDate" class="form-control">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small text-muted text-uppercase fw-bold">To Date</label>
                                <input type="date" name="toDate" id="reportToDate" class="form-control">
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small text-muted text-uppercase fw-bold">Sales Executive Certification Remarks</label>
                            <textarea name="managerNotes" class="form-control" rows="3" placeholder="Add specific commercial findings, sales pipeline highlights, or executive notes..."></textarea>
                        </div>
                    </div>

                    <div class="modal-footer gap-2">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-emerald-pill">
                            <i class="bi bi-send-check"></i> Transmit to Administrator
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- VIEW REPORT DETAILS MODAL -->
    <div class="modal fade" id="viewReportModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <div>
                        <h6 class="modal-title fw-bold mb-0" id="viewReportModalTitle">Report Content</h6>
                        <small class="text-muted" id="viewReportModalStatus"></small>
                    </div>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <pre id="viewReportModalContent" style="white-space: pre-wrap; font-family: 'Space Grotesk', monospace; font-size: 0.82rem; background: var(--card-subtle); padding: 1.25rem; border-radius: 12px; border: 1px solid var(--border); color: var(--txt); max-height: 400px; overflow-y: auto;"></pre>
                </div>
                <div class="modal-footer justify-content-between">
                    <a href="#" id="viewReportModalDownloadPdf" class="btn-emerald-pill">
                        <i class="bi bi-file-earmark-pdf"></i> Download Official PDF
                    </a>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
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

        function viewReportDetails(id, title, status) {
            document.getElementById('viewReportModalTitle').innerText = title;
            document.getElementById('viewReportModalStatus').innerText = 'Status: ' + status;
            var el = document.getElementById('sales-report-content-' + id);
            document.getElementById('viewReportModalContent').innerText = el ? el.innerText : 'No content available';
            document.getElementById('viewReportModalDownloadPdf').href = '/sales/reports/download/' + id;
            new bootstrap.Modal(document.getElementById('viewReportModal')).show();
        }

        (function(){
            try {
                var now = new Date();
                var endStr = now.toISOString().split('T')[0];
                now.setDate(now.getDate() - 30);
                var startStr = now.toISOString().split('T')[0];
                var f = document.getElementById('reportFromDate');
                var t = document.getElementById('reportToDate');
                if (f && !f.value) f.value = startStr;
                if (t && !t.value) t.value = endStr;
            } catch(e) {}
        })();
    </script>
</body>
</html>
