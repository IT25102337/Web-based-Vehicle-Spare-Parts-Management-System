<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Administrator Command Center | PartTrack</title>

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
            --success: #10b981;
            --warning: #f59e0b;
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
            --success: #34d399;
            --warning: #fbbf24;
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
        .sys-hero {
            background: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%);
            color: #fff;
            border-radius: 20px;
            padding: 2.25rem 2.5rem;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 12px 36px rgba(15, 23, 42, 0.18);
        }
        .sys-hero::after {
            content: '';
            position: absolute;
            top: -60px;
            right: -60px;
            width: 280px;
            height: 280px;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.25) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .sys-hero-title {
            font-size: 1.85rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin-bottom: 0.4rem;
        }
        .sys-hero-sub {
            color: #93c5fd;
            font-size: 0.95rem;
            max-width: 680px;
            line-height: 1.5;
            margin-bottom: 1.5rem;
        }

        /* ── KPI METRICS ── */
        .kpi-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2rem;
        }
        .kpi-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1.25rem 1.4rem;
            transition: all 0.2s ease;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 0.75rem;
            min-width: 0;
        }
        .kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(0,0,0,0.06);
            border-color: var(--accent);
        }
        .kpi-info {
            min-width: 0;
            flex: 1;
        }
        .kpi-val {
            font-size: 1.85rem;
            font-weight: 800;
            color: var(--txt);
            line-height: 1.1;
        }
        .kpi-val-status {
            font-size: 0.8rem;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.25rem 0.65rem;
            border-radius: 99px;
            background: rgba(14, 165, 233, 0.12);
            color: #0ea5e9;
            border: 1px solid rgba(14, 165, 233, 0.25);
            white-space: nowrap;
        }
        .kpi-label {
            font-size: 0.8rem;
            font-weight: 600;
            color: var(--txt2);
            margin-top: 0.35rem;
        }
        .kpi-icon-box {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
            flex-shrink: 0;
        }

        /* ── ROLES OPERATIONS GRID ── */
        .roles-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(320px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2rem;
        }
        .role-dept-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1.5rem;
            transition: all 0.2s ease;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .role-dept-card:hover {
            border-color: var(--accent);
            box-shadow: 0 8px 24px rgba(0,0,0,0.05);
            transform: translateY(-2px);
        }
        .role-dept-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        .role-badge {
            font-size: 0.72rem;
            font-weight: 700;
            padding: 0.25rem 0.65rem;
            border-radius: 99px;
            text-transform: uppercase;
            letter-spacing: 0.04em;
        }
        .badge-cust { background: rgba(59, 130, 246, 0.12); color: #3b82f6; }
        .badge-inv  { background: rgba(16, 185, 129, 0.12); color: #10b981; }
        .badge-qa   { background: rgba(168, 85, 247, 0.12); color: #a855f7; }
        .badge-sale { background: rgba(245, 158, 11, 0.12); color: #f59e0b; }
        .badge-supp { background: rgba(14, 165, 233, 0.12); color: #0ea5e9; }
        .badge-rep  { background: rgba(99, 102, 241, 0.12); color: #6366f1; }
        .badge-sys  { background: rgba(239, 68, 68, 0.12);  color: #ef4444; }

        .role-count-pill {
            font-size: 1.15rem;
            font-weight: 800;
            color: var(--txt);
        }

        /* ── BUTTONS ── */
        .btn-brand-accent {
            background: var(--accent);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 0.6rem 1.25rem;
            font-weight: 700;
            font-size: 0.88rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        .btn-brand-accent:hover {
            background: var(--accent-hover);
            color: #fff;
            transform: translateY(-1px);
        }
        .btn-ghost-dark {
            background: rgba(255,255,255,0.12);
            color: #fff;
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 10px;
            padding: 0.6rem 1.2rem;
            font-weight: 600;
            font-size: 0.88rem;
            display: inline-flex;
            align-items: center;
            gap: 0.45rem;
            transition: all 0.2s ease;
            text-decoration: none;
        }
        .btn-ghost-dark:hover {
            background: rgba(255,255,255,0.22);
            color: #fff;
        }
        .btn-outline-action {
            background: transparent;
            color: var(--txt);
            border: 1px solid var(--border);
            border-radius: 8px;
            padding: 0.45rem 0.9rem;
            font-size: 0.8rem;
            font-weight: 600;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            transition: all 0.2s ease;
        }
        .btn-outline-action:hover {
            border-color: var(--accent);
            color: var(--accent);
            background: var(--accent-soft);
        }

        /* ── TABLE CARD ── */
        .sys-table-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            overflow: hidden;
            box-shadow: 0 2px 8px rgba(0,0,0,0.03);
        }
        .sys-table-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .sys-table {
            width: 100%;
            border-collapse: collapse;
        }
        .sys-table th {
            background: var(--card-subtle);
            font-size: 0.75rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--txt2);
            padding: 0.85rem 1.25rem;
            border-bottom: 1px solid var(--border);
        }
        .sys-table td {
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.86rem;
            color: var(--txt);
        }
        .sys-table tr:last-child td { border-bottom: none; }
        .sys-table tr:hover td { background: var(--accent-soft); }

        .user-avatar-sm {
            width: 34px;
            height: 34px;
            border-radius: 8px;
            background: var(--card-subtle);
            border: 1px solid var(--border);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 0.82rem;
            color: var(--accent);
        }

        /* ── MODALS ── */
        .modal-content {
            background: var(--card);
            color: var(--txt);
            border: 1px solid var(--border);
            border-radius: 18px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.25);
        }
        .modal-header {
            border-bottom: 1px solid var(--border);
            padding: 1.25rem 1.5rem;
        }
        .modal-body { padding: 1.5rem; }
        .modal-footer {
            border-top: 1px solid var(--border);
            padding: 1rem 1.5rem;
        }
        .sys-form-label {
            font-size: 0.82rem;
            font-weight: 700;
            color: var(--txt2);
            margin-bottom: 0.4rem;
        }
        .sys-form-input, .sys-form-select {
            width: 100%;
            background: var(--card-subtle);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 0.65rem 0.9rem;
            font-size: 0.88rem;
            font-weight: 500;
            color: var(--txt);
            outline: none;
            transition: border-color 0.2s ease;
        }
        .sys-form-input:focus, .sys-form-select:focus {
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
            <a href="/admin/dashboard" class="sys-nav-link active">
                <i class="bi bi-speedometer2"></i>
                <span>Command Center</span>
            </a>
            <a href="/admin/users" class="sys-nav-link">
                <i class="bi bi-people-fill"></i>
                <span>User Directory</span>
            </a>
            <a href="/admin/suspensions" class="sys-nav-link">
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
    <!--  MAIN WORKSPACE                                   -->
    <!-- ═════════════════════════════════════════════════ -->
    <main class="sys-main">

        <!-- Topbar -->
        <header class="sys-topbar">
            <div class="sys-breadcrumb">
                <i class="bi bi-house-door"></i>
                <span>/</span>
                <span>System Administration</span>
                <span>/</span>
                <span class="text-primary fw-bold">Command Center</span>
            </div>
            <div class="d-flex align-items-center gap-3">
                <span class="sys-badge-admin">
                    <i class="bi bi-shield-fill-check"></i>
                    Super Admin Console
                </span>
                <div class="d-flex align-items-center gap-2">
                    <div class="user-avatar-sm">SA</div>
                    <div>
                        <div class="fw-bold small" style="line-height:1.2;">${sessionScope.fullName != null ? sessionScope.fullName : 'System Administrator'}</div>
                        <div class="small" style="font-size:0.72rem;color:var(--txt2);">@${sessionScope.currentUser != null ? sessionScope.currentUser : 'admin'}</div>
                    </div>
                </div>
                <a href="/logout" class="btn btn-outline-danger rounded-pill fw-bold px-3 py-1 d-inline-flex align-items-center gap-2 shadow-sm" style="font-size:0.84rem; text-decoration:none;" title="Sign out of System Administrator">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </header>

        <!-- Flash Notifications -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show border-0 rounded-4 py-3 px-4 mb-4 shadow-sm" role="alert" style="background:rgba(16,185,129,0.15);color:#10b981;">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-check-circle-fill fs-5"></i>
                    <span class="fw-semibold">${successMessage}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show border-0 rounded-4 py-3 px-4 mb-4 shadow-sm" role="alert" style="background:rgba(239,68,68,0.15);color:#ef4444;">
                <div class="d-flex align-items-center gap-2">
                    <i class="bi bi-exclamation-triangle-fill fs-5"></i>
                    <span class="fw-semibold">${errorMessage}</span>
                    <button type="button" class="btn-close ms-auto" data-bs-dismiss="alert"></button>
                </div>
            </div>
        </c:if>

        <!-- Executive Command Banner -->
        <section class="sys-hero">
            <h1 class="sys-hero-title">System Administrator Command Center</h1>
            <p class="sys-hero-sub">Master directory governance, active staff & customer provisioning, role-based access control (RBAC), account suspension recovery, and security policy management.</p>
            <div class="d-flex gap-3 flex-wrap">
                <button type="button" class="btn-brand-accent" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                    <i class="bi bi-person-plus-fill"></i>
                    + Add New Customer
                </button>
                <button type="button" class="btn-ghost-dark" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                    <i class="bi bi-person-badge"></i>
                    + Provision Staff Account
                </button>
                <a href="/admin/users" class="btn-ghost-dark">
                    <i class="bi bi-people"></i>
                    User Directory (${stats.totalUsers})
                </a>
                <a href="/admin/suspensions" class="btn-ghost-dark">
                    <i class="bi bi-person-x-fill text-warning"></i>
                    Suspended History (${stats.suspendedUsers})
                </a>
            </div>
        </section>

        <!-- KPI Metric Cards -->
        <section class="kpi-grid">
            <div class="kpi-card">
                <div>
                    <div class="kpi-val">${stats.totalUsers}</div>
                    <div class="kpi-label">Total Accounts</div>
                </div>
                <div class="kpi-icon-box" style="background:rgba(37,99,235,0.12);color:#2563eb;">
                    <i class="bi bi-people-fill"></i>
                </div>
            </div>
            <div class="kpi-card">
                <div>
                    <div class="kpi-val text-primary">${stats.totalCustomers}</div>
                    <div class="kpi-label">Active Customers</div>
                </div>
                <div class="kpi-icon-box" style="background:rgba(59,130,246,0.12);color:#3b82f6;">
                    <i class="bi bi-person-check-fill"></i>
                </div>
            </div>
            <div class="kpi-card">
                <div>
                    <div class="kpi-val text-success">${stats.totalStaff}</div>
                    <div class="kpi-label">Operations Staff</div>
                </div>
                <div class="kpi-icon-box" style="background:rgba(16,185,129,0.12);color:#10b981;">
                    <i class="bi bi-briefcase-fill"></i>
                </div>
            </div>
            <div class="kpi-card">
                <div>
                    <div class="kpi-val text-warning">${stats.suspendedUsers}</div>
                    <div class="kpi-label">Suspended Accounts</div>
                </div>
                <div class="kpi-icon-box" style="background:rgba(245,158,11,0.12);color:#f59e0b;">
                    <i class="bi bi-person-slash"></i>
                </div>
            </div>
        </section>

        <!-- Department Role Oversight Cards -->
        <h4 class="fw-bold mb-3 d-flex align-items-center gap-2">
            <i class="bi bi-grid-fill text-primary"></i>
            Operational Roles &amp; Department Accounts
        </h4>
        <section class="roles-grid">
            
            <!-- 1. Customer Accounts -->
            <div class="role-dept-card">
                <div>
                    <div class="role-dept-header">
                        <span class="role-badge badge-cust">Customer Access</span>
                        <span class="role-count-pill">${stats.totalCustomers} Users</span>
                    </div>
                    <h5 class="fw-bold mb-1">Customer Accounts</h5>
                    <p class="small text-muted mb-3">Self-service storefront ordering, checkout cart, purchase order history, and personal customer profiles.</p>
                </div>
                <div class="d-flex justify-content-between align-items-center pt-3 border-top" style="border-color:var(--border)!important;">
                    <a href="/admin/users?role=CUSTOMER" class="btn-outline-action">
                        <i class="bi bi-eye"></i> Manage Customers
                    </a>
                    <button class="btn-outline-action text-primary" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                        <i class="bi bi-plus-lg"></i> Add
                    </button>
                </div>
            </div>

            <!-- 2. Inventory Managers -->
            <div class="role-dept-card">
                <div>
                    <div class="role-dept-header">
                        <span class="role-badge badge-inv">Warehouse Hub</span>
                        <span class="role-count-pill">${stats.totalInventory} Managers</span>
                    </div>
                    <h5 class="fw-bold mb-1">Inventory Managers</h5>
                    <p class="small text-muted mb-3">Warehouse stock management, parts catalog CRUD, reorder threshold triggers, and restock requests.</p>
                </div>
                <div class="d-flex justify-content-between align-items-center pt-3 border-top" style="border-color:var(--border)!important;">
                    <a href="/admin/users?role=INVENTORY" class="btn-outline-action">
                        <i class="bi bi-eye"></i> Manage Inventory
                    </a>
                    <span class="small text-success fw-bold"><i class="bi bi-check-circle-fill"></i> Active</span>
                </div>
            </div>

            <!-- 3. Spare Part Quality Managers -->
            <div class="role-dept-card">
                <div>
                    <div class="role-dept-header">
                        <span class="role-badge badge-qa">Quality Control</span>
                        <span class="role-count-pill">${stats.totalSpareparts} Managers</span>
                    </div>
                    <h5 class="fw-bold mb-1">Spare Part Managers</h5>
                    <p class="small text-muted mb-3">Receiving supplier parts, quality assurance inspection (QA), restock fulfillment, and warranty checks.</p>
                </div>
                <div class="d-flex justify-content-between align-items-center pt-3 border-top" style="border-color:var(--border)!important;">
                    <a href="/admin/users?role=SPAREPARTS" class="btn-outline-action">
                        <i class="bi bi-eye"></i> Manage Spareparts
                    </a>
                    <span class="small text-success fw-bold"><i class="bi bi-check-circle-fill"></i> Active</span>
                </div>
            </div>

            <!-- 4. Commercial Sales Managers -->
            <div class="role-dept-card">
                <div>
                    <div class="role-dept-header">
                        <span class="role-badge badge-sale">Commercial Sales</span>
                        <span class="role-count-pill">${stats.totalSales} Managers</span>
                    </div>
                    <h5 class="fw-bold mb-1">Sales Managers</h5>
                    <p class="small text-muted mb-3">Commercial orders, order fulfillment processing, realized cashflow analytics, and dispatch tracking.</p>
                </div>
                <div class="d-flex justify-content-between align-items-center pt-3 border-top" style="border-color:var(--border)!important;">
                    <a href="/admin/users?role=SALES" class="btn-outline-action">
                        <i class="bi bi-eye"></i> Manage Sales
                    </a>
                    <span class="small text-success fw-bold"><i class="bi bi-check-circle-fill"></i> Active</span>
                </div>
            </div>

            <!-- 5. Supplier Partners -->
            <div class="role-dept-card">
                <div>
                    <div class="role-dept-header">
                        <span class="role-badge badge-supp">Supplier Logistics</span>
                        <span class="role-count-pill">${stats.totalSuppliers} Partners</span>
                    </div>
                    <h5 class="fw-bold mb-1">Supplier Partners</h5>
                    <p class="small text-muted mb-3">Supplier parts catalog pricing, intake deliveries, stock tracking, and supplier agreement communications.</p>
                </div>
                <div class="d-flex justify-content-between align-items-center pt-3 border-top" style="border-color:var(--border)!important;">
                    <a href="/admin/users?role=SUPPLIER" class="btn-outline-action">
                        <i class="bi bi-eye"></i> Manage Suppliers
                    </a>
                    <span class="small text-success fw-bold"><i class="bi bi-check-circle-fill"></i> Active</span>
                </div>
            </div>

            <!-- 6. Report & Business Dashboard Managers -->
            <div class="role-dept-card">
                <div>
                    <div class="role-dept-header">
                        <span class="role-badge badge-rep">Report &amp; Analytics</span>
                        <span class="role-count-pill">${stats.totalReportManagers} Managers</span>
                    </div>
                    <h5 class="fw-bold mb-1">Report &amp; Business Dashboard</h5>
                    <p class="small text-muted mb-3">Executive 360° metrics, multi-department PDF/TXT report engine, manager audit approvals, and automated schedulers.</p>
                </div>
                <div class="d-flex justify-content-between align-items-center pt-3 border-top" style="border-color:var(--border)!important;">
                    <a href="/admin/users?role=REPORT_MANAGER" class="btn-outline-action">
                        <i class="bi bi-eye"></i> Manage Reports
                    </a>
                    <a href="/reports/dashboard" target="_blank" class="btn-outline-action text-primary">
                        <i class="bi bi-box-arrow-up-right"></i> Open Portal
                    </a>
                </div>
            </div>
        </section>

        <!-- Master User Directory Preview Table -->
        <section class="sys-table-card mt-4">
            <div class="sys-table-header">
                <div>
                    <h5 class="fw-bold mb-0">Recent User Registrations &amp; Security Audit</h5>
                    <div class="small text-muted">Latest accounts provisioned across the platform</div>
                </div>
                <a href="/admin/users" class="btn-outline-action">
                    <i class="bi bi-list-ul"></i> View Full Directory (${stats.totalUsers})
                </a>
            </div>
            <div class="table-responsive">
                <table class="sys-table">
                    <thead>
                        <tr>
                            <th>User ID</th>
                            <th>User Profile</th>
                            <th>Role Assignment</th>
                            <th>Contact Email</th>
                            <th>Status</th>
                            <th>Created Timestamp</th>
                            <th class="text-end">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${securityLogs}">
                            <tr>
                                <td class="fw-bold text-muted">#${u.user_id}</td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="user-avatar-sm">
                                            ${u.username.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div>
                                            <div class="fw-bold">${u.full_name}</div>
                                            <div class="small text-muted">@${u.username}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="role-badge 
                                        ${u.role == 'CUSTOMER' ? 'badge-cust' : 
                                          u.role == 'INVENTORY' ? 'badge-inv' : 
                                          u.role == 'SPAREPARTS' ? 'badge-qa' : 
                                          u.role == 'SALES' ? 'badge-sale' : 
                                          u.role == 'SUPPLIER' ? 'badge-supp' : 
                                          u.role == 'REPORT_MANAGER' ? 'badge-rep' : 'badge-sys'}">
                                        ${u.role}
                                    </span>
                                </td>
                                <td>${u.email}</td>
                                <td>
                                    <span class="badge ${u.status == 'ACTIVE' ? 'bg-success' : 'bg-warning'} rounded-pill px-2 py-1">
                                        ${u.status != null ? u.status : 'ACTIVE'}
                                    </span>
                                </td>
                                <td class="small text-muted">${u.created_at}</td>
                                <td class="text-end">
                                    <a href="/admin/users?role=${u.role}" class="btn-outline-action btn-sm">
                                        <i class="bi bi-pencil-square"></i> Inspect
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </section>

    </main>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MODAL 1: ADD NEW CUSTOMER                        -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <form action="/admin/users/add-customer" method="post">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title fw-bold mb-0">
                                <i class="bi bi-person-plus-fill text-primary me-2"></i>
                                Provision New Customer Account
                            </h5>
                            <small class="text-muted">Enter full customer registration details and credentials</small>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="sys-form-label">Full Customer Name <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" class="sys-form-input" placeholder="e.g. Johnathan Smith" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Username <span class="text-danger">*</span></label>
                                <input type="text" name="username" class="sys-form-input" placeholder="e.g. jsmith2026" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Email Address <span class="text-danger">*</span></label>
                                <input type="email" name="email" class="sys-form-input" placeholder="e.g. jsmith@example.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Contact Phone</label>
                                <input type="text" name="phone" class="sys-form-input" placeholder="e.g. +94 77 123 4567" value="+94 77 123 4567">
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Delivery Street Address</label>
                                <input type="text" name="address" class="sys-form-input" placeholder="e.g. 142 Galle Road, Bambalapitiya">
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">City / Region</label>
                                <input type="text" name="city" class="sys-form-input" placeholder="e.g. Colombo 04">
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Account Password <span class="text-danger">*</span></label>
                                <div class="position-relative">
                                    <input type="password" name="password" id="dashCustPassword" class="sys-form-input pe-5" placeholder="Minimum 4 characters" required minlength="4">
                                    <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted pe-3" 
                                            onclick="toggleInputVisibility('dashCustPassword', 'dashCustEyeIcon')" style="text-decoration:none;">
                                        <i class="bi bi-eye-fill" id="dashCustEyeIcon"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Confirm Password <span class="text-danger">*</span></label>
                                <div class="position-relative">
                                    <input type="password" name="confirmPassword" id="dashCustConfirmPassword" class="sys-form-input pe-5" placeholder="Re-enter password" required minlength="4">
                                    <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted pe-3" 
                                            onclick="toggleInputVisibility('dashCustConfirmPassword', 'dashCustConfirmEyeIcon')" style="text-decoration:none;">
                                        <i class="bi bi-eye-fill" id="dashCustConfirmEyeIcon"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-brand-accent">
                            <i class="bi bi-check-lg"></i> Create Customer Account
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MODAL 2: PROVISION STAFF ACCOUNT                 -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="modal fade" id="addStaffModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <form action="/admin/users/add-staff" method="post">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title fw-bold mb-0">
                                <i class="bi bi-person-badge-fill text-success me-2"></i>
                                Provision Operational Staff Account
                            </h5>
                            <small class="text-muted">Grant departmental privileges and system role access</small>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="sys-form-label">Role Assignment <span class="text-danger">*</span></label>
                                <select name="role" class="sys-form-select" required>
                                    <option value="INVENTORY">Inventory Manager (Warehouse Stock Hub)</option>
                                    <option value="SPAREPARTS">Spare Part Manager (Quality Control &amp; QA)</option>
                                    <option value="SALES">Sales Manager (Commercial Sales Orders)</option>
                                    <option value="SUPPLIER">Supplier Partner (Logistics &amp; Catalog)</option>
                                    <option value="REPORT_MANAGER">Report &amp; Business Dashboard Manager</option>
                                    <option value="SYSADMIN">System Administrator (Super Admin)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Staff Full Name <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" class="sys-form-input" placeholder="e.g. David Vance" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Username <span class="text-danger">*</span></label>
                                <input type="text" name="username" class="sys-form-input" placeholder="e.g. dvance_mgr" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Corporate Email <span class="text-danger">*</span></label>
                                <input type="email" name="email" class="sys-form-input" placeholder="e.g. dvance@parttrack.com" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Contact Phone</label>
                                <input type="text" name="phone" class="sys-form-input" placeholder="e.g. +94 77 987 6543" value="+94 77 987 6543">
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Department / Branch Location</label>
                                <input type="text" name="department" class="sys-form-input" placeholder="e.g. Central Depot Hub, Colombo">
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Initial Password <span class="text-danger">*</span></label>
                                <div class="position-relative">
                                    <input type="password" name="password" id="dashStaffPassword" class="sys-form-input pe-5" placeholder="Minimum 4 characters" required minlength="4">
                                    <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted pe-3" 
                                            onclick="toggleInputVisibility('dashStaffPassword', 'dashStaffEyeIcon')" style="text-decoration:none;">
                                        <i class="bi bi-eye-fill" id="dashStaffEyeIcon"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Confirm Password <span class="text-danger">*</span></label>
                                <div class="position-relative">
                                    <input type="password" name="confirmPassword" id="dashStaffConfirmPassword" class="sys-form-input pe-5" placeholder="Re-enter password" required minlength="4">
                                    <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted pe-3" 
                                            onclick="toggleInputVisibility('dashStaffConfirmPassword', 'dashStaffConfirmEyeIcon')" style="text-decoration:none;">
                                        <i class="bi bi-eye-fill" id="dashStaffConfirmEyeIcon"></i>
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-brand-accent" style="background:#10b981;">
                            <i class="bi bi-shield-lock-fill"></i> Provision Account
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Password Visibility Toggle
        function toggleInputVisibility(inputId, iconId) {
            var input = document.getElementById(inputId);
            var icon = document.getElementById(iconId);
            if (!input || !icon) return;
            if (input.type === 'password') {
                input.type = 'text';
                icon.className = 'bi bi-eye-slash-fill text-primary';
            } else {
                input.type = 'password';
                icon.className = 'bi bi-eye-fill text-muted';
            }
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
