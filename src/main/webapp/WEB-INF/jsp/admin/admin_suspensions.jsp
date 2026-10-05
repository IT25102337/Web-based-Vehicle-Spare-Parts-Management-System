<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Suspended History &amp; Account Recovery Console | PartTrack</title>

    <!-- Theme Initialization BEFORE Render -->
    <script>
        (function(){
            var s = localStorage.getItem('theme') || 'light';
            document.documentElement.setAttribute('data-theme', s);
        })();
    </script>

    <!-- Google Fonts & Bootstrap 5 -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        :root {
            --bg: #f8fafc;
            --card: #ffffff;
            --card-subtle: #f1f5f9;
            --border: #e2e8f0;
            --txt: #0f172a;
            --txt2: #475569;
            --txt3: #94a3b8;
            --sidebar-bg: #0f172a;
            --sidebar-border: #1e293b;
            --accent: #2563eb;
            --accent-soft: #eff6ff;
            --accent-hover: #1d4ed8;
            --danger: #ef4444;
            --danger-soft: #fef2f2;
            --success: #10b981;
            --success-soft: #ecfdf5;
            --warning: #f59e0b;
            --warning-soft: #fffbeb;
        }

        [data-theme='dark'] {
            --bg: #090d16;
            --card: #111827;
            --card-subtle: #1e293b;
            --border: #1f293d;
            --txt: #f8fafc;
            --txt2: #94a3b8;
            --txt3: #64748b;
            --sidebar-bg: #0b1120;
            --sidebar-border: #1e293b;
            --accent: #3b82f6;
            --accent-soft: rgba(59, 130, 246, 0.12);
            --accent-hover: #60a5fa;
            --danger: #f87171;
            --danger-soft: rgba(239, 68, 68, 0.12);
            --success: #34d399;
            --success-soft: rgba(16, 185, 129, 0.12);
            --warning: #fbbf24;
            --warning-soft: rgba(245, 158, 11, 0.12);
        }

        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: var(--bg);
            color: var(--txt);
            min-height: 100vh;
            display: flex;
            overflow-x: hidden;
            transition: background-color 0.25s ease, color 0.25s ease;
        }

        /* ── SYSTEM ADMIN SIDEBAR ── */
        .sys-sidebar {
            width: 260px;
            background: var(--sidebar-bg);
            border-right: 1px solid var(--sidebar-border);
            display: flex;
            flex-direction: column;
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            z-index: 100;
            padding: 1.25rem 1rem;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: rgba(255,255,255,0.2) transparent;
        }
        .sys-sidebar::-webkit-scrollbar {
            width: 4px;
        }
        .sys-sidebar::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.2);
            border-radius: 99px;
        }
        .sys-brand {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.5rem 0.75rem 1.75rem;
            border-bottom: 1px solid rgba(255,255,255,0.08);
            text-decoration: none;
        }
        .sys-brand-icon {
            width: 42px;
            height: 42px;
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            color: #fff;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.35);
        }
        .sys-brand-title {
            color: #fff;
            font-size: 1.05rem;
            font-weight: 800;
            letter-spacing: -0.02em;
            line-height: 1.1;
        }
        .sys-brand-sub {
            color: #94a3b8;
            font-size: 0.72rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .sys-nav {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
            margin-top: 1.5rem;
            flex: 1;
        }
        .sys-nav-label {
            color: #64748b;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            padding: 0.5rem 0.75rem 0.25rem;
        }
        .sys-nav-link {
            display: flex;
            align-items: center;
            gap: 0.85rem;
            padding: 0.75rem 0.9rem;
            border-radius: 10px;
            color: #94a3b8;
            font-size: 0.9rem;
            font-weight: 600;
            text-decoration: none;
            transition: all 0.2s ease;
            position: relative;
        }
        .sys-nav-link i { font-size: 1.15rem; }
        .sys-nav-link:hover {
            color: #fff;
            background: rgba(255,255,255,0.06);
            transform: translateX(3px);
        }
        .sys-nav-link.active {
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.9), rgba(29, 78, 216, 0.95));
            color: #ffffff;
            font-weight: 700;
            box-shadow: 0 4px 14px rgba(37, 99, 235, 0.35);
        }
        .sys-sidebar-footer {
            margin-top: auto;
            padding-top: 1.25rem;
            border-top: 1px solid rgba(255,255,255,0.08);
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            flex-shrink: 0;
        }

        /* ── MAIN WORKSPACE ── */
        .sys-main {
            margin-left: 260px;
            flex: 1;
            padding: 2rem 2.5rem 3rem;
            max-width: 1440px;
        }
        .sys-topbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 2rem;
            gap: 1.5rem;
        }
        .sys-breadcrumb {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-size: 0.84rem;
            color: var(--txt2);
            font-weight: 600;
        }
        .sys-badge-admin {
            background: rgba(37, 99, 235, 0.12);
            color: var(--accent);
            border: 1px solid rgba(37, 99, 235, 0.25);
            padding: 0.3rem 0.8rem;
            border-radius: 99px;
            font-size: 0.78rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }

        /* ── HERO BANNER ── */
        .sys-hero-card {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            color: #fff;
            border-radius: 20px;
            padding: 2.25rem 2.5rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 2rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.18);
            border-left: 5px solid #f59e0b;
        }
        .sys-hero-card::after {
            content: '';
            position: absolute;
            top: -50px;
            right: -50px;
            width: 240px;
            height: 240px;
            background: radial-gradient(circle, rgba(245, 158, 11, 0.2) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .sys-hero-title {
            font-size: 1.75rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin-bottom: 0.4rem;
        }
        .sys-hero-sub {
            color: #cbd5e1;
            font-size: 0.92rem;
            max-width: 650px;
            line-height: 1.5;
        }

        /* ── RECOVERY CARD TILES ── */
        .recovery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(360px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2.5rem;
        }
        .recovery-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-left: 4px solid var(--warning);
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            transition: all 0.2s ease;
        }
        .recovery-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.07);
        }
        .recovery-card-head {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 1rem;
            margin-bottom: 1rem;
        }
        .user-avatar-lg {
            width: 46px;
            height: 46px;
            border-radius: 12px;
            background: rgba(245, 158, 11, 0.15);
            color: #d97706;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 1.1rem;
            border: 1px solid rgba(245, 158, 11, 0.3);
        }
        .reason-box {
            background: var(--card-subtle);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-size: 0.84rem;
            color: var(--txt);
            margin-bottom: 1.25rem;
        }

        /* ── BUTTONS ── */
        .btn-recover {
            background: linear-gradient(135deg, #10b981, #059669);
            color: #ffffff;
            border: none;
            border-radius: 10px;
            padding: 0.65rem 1.25rem;
            font-size: 0.88rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
            width: 100%;
        }
        .btn-recover:hover {
            background: linear-gradient(135deg, #059669, #047857);
            color: #fff;
            transform: translateY(-1px);
        }
        .btn-ghost-dark {
            background: rgba(255, 255, 255, 0.06);
            color: #cbd5e1;
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 10px;
            padding: 0.65rem 1rem;
            font-size: 0.85rem;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-ghost-dark:hover {
            background: rgba(255, 255, 255, 0.12);
            color: #fff;
        }

        /* ── AUDIT HISTORY TABLE ── */
        .sys-table-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 18px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0,0,0,0.03);
            margin-bottom: 2rem;
        }
        .sys-table-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
            flex-wrap: wrap;
        }
        .sys-table {
            width: 100%;
            border-collapse: collapse;
        }
        .sys-table th {
            background: var(--card-subtle);
            font-size: 0.74rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--txt2);
            padding: 0.9rem 1.25rem;
            border-bottom: 1px solid var(--border);
        }
        .sys-table td {
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.86rem;
            color: var(--txt);
            vertical-align: middle;
        }
        .sys-table tr:last-child td { border-bottom: none; }
        .sys-table tr:hover td { background: var(--accent-soft); }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.3rem 0.75rem;
            border-radius: 99px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .status-active {
            background: var(--success-soft);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.3);
        }
        .status-suspended {
            background: var(--danger-soft);
            color: var(--danger);
            border: 1px solid rgba(239, 68, 68, 0.3);
        }
        .status-recovered {
            background: var(--success-soft);
            color: var(--success);
            border: 1px solid rgba(16, 185, 129, 0.3);
        }

        .search-input-wrap {
            position: relative;
            min-width: 280px;
        }
        .search-input-wrap i {
            position: absolute;
            left: 1rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--txt3);
            font-size: 0.95rem;
        }
        .search-input-wrap input {
            width: 100%;
            background: var(--card-subtle);
            border: 1px solid var(--border);
            border-radius: 99px;
            padding: 0.55rem 1rem 0.55rem 2.5rem;
            font-size: 0.86rem;
            color: var(--txt);
            outline: none;
            transition: all 0.2s ease;
        }
        .search-input-wrap input:focus {
            border-color: var(--accent);
            box-shadow: 0 0 0 3px var(--accent-soft);
        }
    </style>
</head>
<body>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  SYSTEM ADMINISTRATOR SIDEBAR                     -->
    <!-- ═════════════════════════════════════════════════ -->
    <aside class="sys-sidebar">
        <a href="/admin/dashboard" class="sys-brand">
            <div class="sys-brand-icon">
                <i class="bi bi-shield-lock-fill"></i>
            </div>
            <div>
                <div class="sys-brand-title">PartTrack Master</div>
                <div class="sys-brand-sub">System Administrator</div>
            </div>
        </a>

        <nav class="sys-nav">
            <div class="sys-nav-label">Core Governance</div>
            <a href="/admin/dashboard" class="sys-nav-link">
                <i class="bi bi-speedometer2"></i>
                <span>Command Center</span>
            </a>
            <a href="/admin/users" class="sys-nav-link">
                <i class="bi bi-people-fill"></i>
                <span>User Directory</span>
            </a>
            <a href="/admin/suspensions" class="sys-nav-link active">
                <i class="bi bi-person-x-fill text-warning"></i>
                <span>Suspended History</span>
                <c:if test="${stats.suspendedUsers > 0}">
                    <span class="badge bg-danger rounded-pill ms-auto px-2 py-1" style="font-size:0.68rem;">
                        ${stats.suspendedUsers}
                    </span>
                </c:if>
            </a>
            <a href="/admin/roles" class="sys-nav-link">
                <i class="bi bi-shield-check"></i>
                <span>Access Matrix</span>
            </a>

            <div class="sys-nav-label mt-3">Operational Portals</div>
            <a href="/reports/dashboard" class="sys-nav-link" target="_blank" title="Report & Business Dashboard">
                <i class="bi bi-bar-chart-line-fill text-info"></i>
                <span>Report &amp; Analytics</span>
            </a>
            <a href="/sales" class="sys-nav-link" target="_blank" title="Commercial Sales Management">
                <i class="bi bi-graph-up-arrow text-warning"></i>
                <span>Sales Management</span>
            </a>
            <a href="/inventory/dashboard" class="sys-nav-link" target="_blank" title="Inventory Warehouse Hub">
                <i class="bi bi-boxes text-success"></i>
                <span>Warehouse Hub</span>
            </a>
            <a href="/spareparts" class="sys-nav-link" target="_blank" title="Quality Control & Inspection">
                <i class="bi bi-tools text-purple" style="color:#8b5cf6;"></i>
                <span>Quality Control</span>
            </a>
            <a href="/supplier" class="sys-nav-link" target="_blank" title="Supplier Portal">
                <i class="bi bi-truck text-info"></i>
                <span>Supplier Portal</span>
            </a>
            <a href="/customer" class="sys-nav-link" target="_blank" title="Customer Catalog View">
                <i class="bi bi-shop text-primary"></i>
                <span>Customer Store</span>
            </a>
        </nav>

        <div class="sys-sidebar-footer">
            <button onclick="toggleTheme()" class="btn-ghost-dark w-100 justify-content-center" id="themeToggleBtn">
                <i class="bi bi-sun-fill" id="themeIcon"></i>
                <span id="themeLabel">Light / Dark</span>
            </button>
            <a href="/logout" class="btn-ghost-dark w-100 justify-content-center text-danger border-0">
                <i class="bi bi-box-arrow-right"></i>
                <span>Sign Out</span>
            </a>
        </div>
    </aside>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MAIN SYSTEM WORKSPACE                            -->
    <!-- ═════════════════════════════════════════════════ -->
    <main class="sys-main">

        <!-- Topbar -->
        <div class="sys-topbar">
            <div class="sys-breadcrumb">
                <i class="bi bi-shield-lock-fill text-primary"></i>
                <span>System Administrator</span>
                <i class="bi bi-chevron-right text-muted" style="font-size:0.75rem;"></i>
                <span class="text-warning fw-bold">Suspended History &amp; Recovery</span>
                <span class="sys-badge-admin ms-2">
                    <i class="bi bi-check-circle-fill"></i> Security Governance
                </span>
            </div>

            <div class="d-flex align-items-center gap-2">
                <a href="/admin/users" class="btn btn-outline-primary rounded-3 fw-bold px-3 py-2 d-inline-flex align-items-center gap-2">
                    <i class="bi bi-people-fill"></i> View User Directory
                </a>
                <a href="/logout" class="btn btn-outline-danger rounded-pill fw-bold px-3 py-2 d-inline-flex align-items-center gap-2 shadow-sm" style="font-size:0.86rem; text-decoration:none;" title="Sign out of System Administrator">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>

        <!-- System Alert Messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show rounded-3 border-0 shadow-sm mb-4" role="alert">
                <i class="bi bi-check-circle-fill me-2 fs-5 align-middle"></i>
                <strong>Action Executed:</strong> ${successMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 border-0 shadow-sm mb-4" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2 fs-5 align-middle"></i>
                <strong>Security Alert:</strong> ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Hero Card -->
        <div class="sys-hero-card">
            <div>
                <h1 class="sys-hero-title">Suspended History &amp; Account Recovery</h1>
                <p class="sys-hero-sub">
                    Audit log of all account suspension events across PartTrack. Review stated incident reasons, administrator audit trails, and instantly restore suspended accounts to active operational status with one click.
                </p>
            </div>
            <div class="d-flex align-items-center gap-3">
                <div class="text-end">
                    <div class="fs-2 fw-bold text-warning">${activeSuspensions.size()}</div>
                    <div class="text-white-50" style="font-size:0.78rem; text-transform:uppercase; letter-spacing:0.05em;">Currently Held</div>
                </div>
            </div>
        </div>

        <!-- ═════════════════════════════════════════════════ -->
        <!--  SECTION 1: ACTIVE SUSPENSIONS QUEUE             -->
        <!-- ═════════════════════════════════════════════════ -->
        <div class="d-flex align-items-center justify-content-between mb-3">
            <div>
                <h5 class="fw-bold mb-0 text-dark-title">
                    <i class="bi bi-exclamation-octagon-fill text-warning me-2"></i>
                    Active Account Suspensions (${activeSuspensions.size()})
                </h5>
                <small class="text-muted">Accounts currently blocked from signing in or executing transactions</small>
            </div>
        </div>

        <c:choose>
            <c:when test="${not empty activeSuspensions}">
                <div class="recovery-grid">
                    <c:forEach var="item" items="${activeSuspensions}">
                        <div class="recovery-card">
                            <div>
                                <div class="recovery-card-head">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="user-avatar-lg">
                                            ${item.username.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div>
                                            <div class="fw-bold text-dark-title fs-6">${item.fullName}</div>
                                            <div class="text-muted" style="font-size:0.8rem;">
                                                @${item.username} &bull; <span class="badge bg-secondary-subtle text-secondary">${item.role}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <span class="status-badge status-suspended">
                                        <i class="bi bi-slash-circle-fill"></i> Suspended
                                    </span>
                                </div>

                                <div class="reason-box">
                                    <div class="fw-bold text-muted mb-1" style="font-size:0.74rem; text-transform:uppercase; letter-spacing:0.04em;">
                                        Suspension Justification:
                                    </div>
                                    <div class="text-dark fw-medium">"${item.reason}"</div>
                                </div>

                                <div class="mb-3" style="font-size:0.8rem; color:var(--txt2);">
                                    <div><i class="bi bi-clock me-1 text-muted"></i> Suspended On: <strong>${item.suspendedAt}</strong></div>
                                    <div><i class="bi bi-person-fill-lock me-1 text-muted"></i> Initiated By: <strong>@${item.suspendedBy}</strong></div>
                                </div>
                            </div>

                            <!-- One-Click Account Recovery Action -->
                            <form action="/admin/users/recover" method="post" class="mt-2">
                                <input type="hidden" name="userId" value="${item.userId}">
                                <button type="submit" class="btn-recover">
                                    <i class="bi bi-arrow-counterclockwise fs-5"></i>
                                    <span>Recover Account Access</span>
                                </button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="card border-0 rounded-4 p-4 text-center mb-4 shadow-sm" style="background:var(--card);">
                    <div class="text-success my-2" style="font-size:2.5rem;">
                        <i class="bi bi-shield-check"></i>
                    </div>
                    <h5 class="fw-bold text-success mb-1">No Active Suspensions</h5>
                    <p class="text-muted mb-0" style="font-size:0.9rem;">
                        All customer and staff accounts are currently in good standing and operating normally.
                    </p>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- ═════════════════════════════════════════════════ -->
        <!--  SECTION 2: COMPLETE AUDIT LOG                   -->
        <!-- ═════════════════════════════════════════════════ -->
        <div class="sys-table-card">
            <div class="sys-table-header">
                <div>
                    <h5 class="fw-bold mb-0">Suspension &amp; Recovery Audit History</h5>
                    <small class="text-muted">Chronological timeline of all historical security enforcement actions</small>
                </div>

                <div class="search-input-wrap">
                    <i class="bi bi-search"></i>
                    <input type="text" id="suspensionHistorySearch" placeholder="Search audit history..." onkeyup="filterSuspensionHistory()">
                </div>
            </div>

            <div class="table-responsive">
                <table class="sys-table" id="historyTable">
                    <thead>
                        <tr>
                            <th style="width:70px;">Log ID</th>
                            <th>Target User Account</th>
                            <th>Incident Reason</th>
                            <th>Suspension Timestamp</th>
                            <th>Enforced By</th>
                            <th>Lifecycle Status</th>
                            <th>Recovery Audit</th>
                            <th class="text-end" style="width:130px;">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="h" items="${history}">
                            <tr class="history-row-item">
                                <td class="fw-bold text-muted">#${h.historyId}</td>
                                <td>
                                    <div class="fw-bold text-dark-title">${h.fullName}</div>
                                    <div class="text-muted" style="font-size:0.78rem;">
                                        @${h.username} &bull; <span class="badge bg-secondary-subtle text-secondary">${h.role}</span>
                                    </div>
                                </td>
                                <td>
                                    <span class="text-dark fw-medium" title="${h.reason}">
                                        ${h.reason}
                                    </span>
                                </td>
                                <td class="text-muted" style="font-size:0.8rem;">
                                    ${h.suspendedAt}
                                </td>
                                <td>
                                    <span class="badge bg-dark text-white rounded-pill px-2 py-1" style="font-size:0.75rem;">
                                        @${h.suspendedBy}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${h.status == 'RECOVERED'}">
                                            <span class="status-badge status-recovered">
                                                <i class="bi bi-check-circle-fill"></i> Recovered
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-suspended">
                                                <i class="bi bi-slash-circle-fill"></i> Suspended
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty h.recoveredAt}">
                                            <div style="font-size:0.78rem;">
                                                <div class="text-success fw-bold"><i class="bi bi-check2 me-1"></i>${h.recoveredAt}</div>
                                                <div class="text-muted">by @${h.recoveredBy}</div>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted fst-italic" style="font-size:0.78rem;">Pending Recovery</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${h.status == 'SUSPENDED'}">
                                            <form action="/admin/users/recover" method="post" style="display:inline;">
                                                <input type="hidden" name="userId" value="${h.userId}">
                                                <button type="submit" class="btn btn-sm btn-success rounded-pill px-3 fw-bold" style="font-size:0.78rem;">
                                                    <i class="bi bi-arrow-counterclockwise"></i> Recover
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-success-subtle text-success rounded-pill px-2 py-1" style="font-size:0.72rem;">
                                                Restored
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty history}">
                            <tr>
                                <td colspan="8" class="text-center py-5">
                                    <i class="bi bi-shield-check text-muted" style="font-size:2.5rem;"></i>
                                    <div class="fw-bold mt-2 text-muted">No historical suspension records recorded</div>
                                    <small class="text-muted">Suspensions triggered by the administrator will be recorded here permanently.</small>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Live Audit History Filter
        function filterSuspensionHistory() {
            var q = document.getElementById('suspensionHistorySearch').value.toLowerCase();
            var rows = document.querySelectorAll('.history-row-item');
            rows.forEach(function(row) {
                var text = row.textContent.toLowerCase();
                row.style.display = text.indexOf(q) !== -1 ? '' : 'none';
            });
        }

        // Theme Toggle Logic
        function toggleTheme() {
            var h = document.documentElement;
            var isDark = h.getAttribute('data-theme') === 'dark';
            var next = isDark ? 'light' : 'dark';
            h.setAttribute('data-theme', next);
            localStorage.setItem('theme', next);
            updateThemeIcon(next);
        }

        function updateThemeIcon(t) {
            var icon = document.getElementById('themeIcon');
            var label = document.getElementById('themeLabel');
            if (icon) {
                icon.className = (t === 'dark') ? 'bi bi-sun-fill text-warning' : 'bi bi-moon-stars-fill';
            }
            if (label) {
                label.textContent = (t === 'dark') ? 'Light Mode' : 'Dark Mode';
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            var cur = localStorage.getItem('theme') || 'light';
            updateThemeIcon(cur);
        });
    </script>
</body>
</html>
