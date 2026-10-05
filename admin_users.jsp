<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Master User Directory | System Administrator | PartTrack</title>

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

        /* ── HEADER BANNER ── */
        .sys-header-card {
            background: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%);
            color: #fff;
            border-radius: 20px;
            padding: 2rem 2.25rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 2rem;
            position: relative;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(15, 23, 42, 0.16);
        }
        .sys-header-card::after {
            content: '';
            position: absolute;
            top: -40px;
            right: -40px;
            width: 220px;
            height: 220px;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.25) 0%, transparent 70%);
            border-radius: 50%;
            pointer-events: none;
        }
        .sys-header-title {
            font-size: 1.65rem;
            font-weight: 800;
            letter-spacing: -0.03em;
            margin-bottom: 0.35rem;
        }
        .sys-header-sub {
            color: #93c5fd;
            font-size: 0.9rem;
            max-width: 600px;
            line-height: 1.5;
        }

        /* ── BUTTONS ── */
        .btn-brand-accent {
            background: var(--accent);
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 0.65rem 1.25rem;
            font-size: 0.88rem;
            font-weight: 700;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            cursor: pointer;
            transition: all 0.2s ease;
            box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
        }
        .btn-brand-accent:hover {
            background: var(--accent-hover);
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

        /* ── QUICK STATS ── */
        .stats-strip {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.25rem;
            margin-bottom: 2rem;
        }
        .stat-box {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1.25rem 1.4rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            box-shadow: 0 2px 6px rgba(0,0,0,0.02);
            transition: transform 0.2s ease;
        }
        .stat-box:hover {
            transform: translateY(-2px);
            border-color: var(--accent);
        }
        .stat-val {
            font-size: 1.75rem;
            font-weight: 800;
            line-height: 1.1;
            color: var(--txt);
        }
        .stat-lbl {
            font-size: 0.78rem;
            font-weight: 600;
            color: var(--txt2);
            margin-top: 0.25rem;
        }
        .stat-icon {
            width: 44px;
            height: 44px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
        }

        /* ── FILTER & CONTROLS BAR ── */
        .controls-card {
            background: var(--card);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 1.25rem 1.5rem;
            margin-bottom: 1.5rem;
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            justify-content: space-between;
            gap: 1rem;
        }
        .filter-pills {
            display: flex;
            flex-wrap: wrap;
            gap: 0.5rem;
            align-items: center;
        }
        .filter-pill {
            padding: 0.45rem 0.9rem;
            border-radius: 99px;
            font-size: 0.8rem;
            font-weight: 700;
            text-decoration: none;
            border: 1px solid var(--border);
            color: var(--txt2);
            background: var(--card-subtle);
            transition: all 0.18s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
        }
        .filter-pill:hover {
            color: var(--accent);
            border-color: var(--accent);
            background: var(--accent-soft);
        }
        .filter-pill.active {
            background: var(--accent);
            color: #fff;
            border-color: var(--accent);
            box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
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

        /* ── TABLE CARD ── */
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

        .user-avatar {
            width: 38px;
            height: 38px;
            border-radius: 10px;
            background: linear-gradient(135deg, rgba(37, 99, 235, 0.15), rgba(29, 78, 216, 0.25));
            border: 1px solid var(--border);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 0.85rem;
            color: var(--accent);
        }

        /* Status & Role Badges */
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

        .role-pill {
            display: inline-flex;
            align-items: center;
            gap: 0.35rem;
            padding: 0.3rem 0.75rem;
            border-radius: 8px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .role-customer { background: rgba(59, 130, 246, 0.12); color: #2563eb; }
        .role-inventory { background: rgba(16, 185, 129, 0.12); color: #059669; }
        .role-spareparts { background: rgba(139, 92, 246, 0.12); color: #7c3aed; }
        .role-sales { background: rgba(245, 158, 11, 0.12); color: #d97706; }
        .role-supplier { background: rgba(14, 165, 233, 0.12); color: #0284c7; }
        .role-report { background: rgba(236, 72, 153, 0.12); color: #db2777; }
        .role-admin { background: rgba(99, 102, 241, 0.15); color: #4f46e5; border: 1px solid rgba(99, 102, 241, 0.3); }

        /* Action Buttons */
        .btn-action-sm {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            border: 1px solid var(--border);
            background: var(--card-subtle);
            color: var(--txt2);
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            cursor: pointer;
            transition: all 0.15s ease;
            text-decoration: none;
        }
        .btn-action-sm:hover {
            color: var(--accent);
            border-color: var(--accent);
            background: var(--card);
        }
        .btn-action-danger:hover {
            color: var(--danger);
            border-color: var(--danger);
            background: var(--danger-soft);
        }
        .btn-action-recover:hover {
            color: var(--success);
            border-color: var(--success);
            background: var(--success-soft);
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
            <a href="/admin/dashboard" class="sys-nav-link">
                <i class="bi bi-speedometer2"></i>
                <span>Command Center</span>
            </a>
            <a href="/admin/users" class="sys-nav-link active">
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
    <!--  MAIN SYSTEM WORKSPACE                            -->
    <!-- ═════════════════════════════════════════════════ -->
    <main class="sys-main">

        <!-- Topbar -->
        <div class="sys-topbar">
            <div class="sys-breadcrumb">
                <i class="bi bi-shield-lock-fill text-primary"></i>
                <span>System Administrator</span>
                <i class="bi bi-chevron-right text-muted" style="font-size:0.75rem;"></i>
                <span class="text-primary fw-bold">Master User Directory</span>
                <span class="sys-badge-admin ms-2">
                    <i class="bi bi-check-circle-fill"></i> Super Admin Mode
                </span>
            </div>

            <div class="d-flex align-items-center gap-2">
                <button type="button" class="btn-brand-accent" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                    <i class="bi bi-person-plus-fill"></i> Add Customer
                </button>
                <button type="button" class="btn btn-outline-primary rounded-3 fw-bold px-3 py-2 d-inline-flex align-items-center gap-2" data-bs-toggle="modal" data-bs-target="#addStaffModal">
                    <i class="bi bi-person-badge-fill"></i> Provision Staff
                </button>
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
                <strong>Success:</strong> ${successMessage}
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

        <!-- Header Card -->
        <div class="sys-header-card">
            <div>
                <h1 class="sys-header-title">Master User &amp; Customer Directory</h1>
                <p class="sys-header-sub">
                    Manage all customer registrations, departmental staff credentials, role-based assignments, and account governance with instant suspension or permanent removal capabilities.
                </p>
            </div>
            <div class="d-flex align-items-center gap-3">
                <a href="/admin/suspensions" class="btn btn-light rounded-pill px-4 py-2 fw-bold text-dark d-inline-flex align-items-center gap-2 shadow-sm">
                    <i class="bi bi-clock-history text-warning"></i> Suspended History
                </a>
            </div>
        </div>

        <!-- Quick Telemetry Stats Strip -->
        <div class="stats-strip">
            <div class="stat-box">
                <div>
                    <div class="stat-val">${stats.totalUsers}</div>
                    <div class="stat-lbl">Total Registered Accounts</div>
                </div>
                <div class="stat-icon" style="background:rgba(37,99,235,0.12); color:#2563eb;">
                    <i class="bi bi-people-fill"></i>
                </div>
            </div>
            <div class="stat-box">
                <div>
                    <div class="stat-val">${stats.totalCustomers}</div>
                    <div class="stat-lbl">Active Retail Customers</div>
                </div>
                <div class="stat-icon" style="background:rgba(16,185,129,0.12); color:#10b981;">
                    <i class="bi bi-cart-check-fill"></i>
                </div>
            </div>
            <div class="stat-box">
                <div>
                    <div class="stat-val">${stats.activeStaff}</div>
                    <div class="stat-lbl">Operational Staff Members</div>
                </div>
                <div class="stat-icon" style="background:rgba(139,92,246,0.12); color:#8b5cf6;">
                    <i class="bi bi-person-badge-fill"></i>
                </div>
            </div>
            <div class="stat-box">
                <div>
                    <div class="stat-val text-danger">${stats.suspendedUsers}</div>
                    <div class="stat-lbl">Suspended Accounts</div>
                </div>
                <div class="stat-icon" style="background:rgba(239,68,68,0.12); color:#ef4444;">
                    <i class="bi bi-person-x-fill"></i>
                </div>
            </div>
        </div>

        <!-- Controls, Role Filters, and Live Search Bar -->
        <div class="controls-card">
            <div class="filter-pills">
                <span class="text-muted fw-bold me-2" style="font-size:0.75rem; text-transform:uppercase;">Role Filter:</span>
                <a href="/admin/users?role=ALL" class="filter-pill ${currentFilter == 'ALL' ? 'active' : ''}">
                    All Accounts
                </a>
                <a href="/admin/users?role=CUSTOMER" class="filter-pill ${currentFilter == 'CUSTOMER' ? 'active' : ''}">
                    <i class="bi bi-person text-primary"></i> Customers
                </a>
                <a href="/admin/users?role=INVENTORY" class="filter-pill ${currentFilter == 'INVENTORY' ? 'active' : ''}">
                    <i class="bi bi-boxes text-success"></i> Inventory
                </a>
                <a href="/admin/users?role=SPAREPARTS" class="filter-pill ${currentFilter == 'SPAREPARTS' ? 'active' : ''}">
                    <i class="bi bi-tools text-purple" style="color:#8b5cf6;"></i> Spare Parts
                </a>
                <a href="/admin/users?role=SALES" class="filter-pill ${currentFilter == 'SALES' ? 'active' : ''}">
                    <i class="bi bi-graph-up-arrow text-warning"></i> Sales
                </a>
                <a href="/admin/users?role=SUPPLIER" class="filter-pill ${currentFilter == 'SUPPLIER' ? 'active' : ''}">
                    <i class="bi bi-truck text-info"></i> Suppliers
                </a>
                <a href="/admin/users?role=REPORT_MANAGER" class="filter-pill ${currentFilter == 'REPORT_MANAGER' ? 'active' : ''}">
                    <i class="bi bi-file-earmark-bar-graph text-pink" style="color:#db2777;"></i> Report Manager
                </a>
                <a href="/admin/users?role=SYSADMIN" class="filter-pill ${currentFilter == 'SYSADMIN' ? 'active' : ''}">
                    <i class="bi bi-shield-lock text-indigo" style="color:#4f46e5;"></i> Administrators
                </a>
            </div>

            <div class="search-input-wrap">
                <i class="bi bi-search"></i>
                <input type="text" id="userDirectorySearch" placeholder="Search name, username, email, phone..." onkeyup="filterUserDirectory()">
            </div>
        </div>

        <!-- Master Directory Table Card -->
        <div class="sys-table-card">
            <div class="sys-table-header">
                <div>
                    <h5 class="fw-bold mb-0">System User Accounts</h5>
                    <small class="text-muted">Showing ${users.size()} accounts matching filter '${currentFilter}'</small>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-secondary-subtle text-secondary rounded-pill px-3 py-2 fw-semibold">
                        Filter: ${currentFilter}
                    </span>
                </div>
            </div>

            <div class="table-responsive">
                <table class="sys-table" id="usersMasterTable">
                    <thead>
                        <tr>
                            <th style="width:70px;">ID</th>
                            <th>User Account</th>
                            <th>Contact Info</th>
                            <th>Assigned Role</th>
                            <th style="width:130px;">Password</th>
                            <th>Status</th>
                            <th>Registered On</th>
                            <th class="text-end" style="width:160px;">Governance</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr class="user-row-item">
                                <td class="fw-bold text-muted">#${u.userId}</td>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="user-avatar">
                                            ${u.username.substring(0, 1).toUpperCase()}
                                        </div>
                                        <div>
                                            <div class="fw-bold text-dark-title">${u.fullName}</div>
                                            <div class="text-muted" style="font-size:0.78rem;">@${u.username}</div>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div class="fw-medium">${u.email}</div>
                                    <div class="text-muted" style="font-size:0.78rem;">
                                        <i class="bi bi-telephone me-1"></i>${u.phone}
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role == 'CUSTOMER'}">
                                            <span class="role-pill role-customer"><i class="bi bi-person"></i> Customer</span>
                                        </c:when>
                                        <c:when test="${u.role == 'INVENTORY'}">
                                            <span class="role-pill role-inventory"><i class="bi bi-boxes"></i> Inventory Manager</span>
                                        </c:when>
                                        <c:when test="${u.role == 'SPAREPARTS'}">
                                            <span class="role-pill role-spareparts"><i class="bi bi-tools"></i> Spare Part Manager</span>
                                        </c:when>
                                        <c:when test="${u.role == 'SALES'}">
                                            <span class="role-pill role-sales"><i class="bi bi-graph-up"></i> Sales Manager</span>
                                        </c:when>
                                        <c:when test="${u.role == 'SUPPLIER'}">
                                            <span class="role-pill role-supplier"><i class="bi bi-truck"></i> Supplier Partner</span>
                                        </c:when>
                                        <c:when test="${u.role == 'REPORT_MANAGER'}">
                                            <span class="role-pill role-report"><i class="bi bi-file-earmark-bar-graph"></i> Report Manager</span>
                                        </c:when>
                                        <c:when test="${u.role == 'SYSADMIN' || u.role == 'ADMIN'}">
                                            <span class="role-pill role-admin"><i class="bi bi-shield-lock-fill"></i> System Admin</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="role-pill bg-secondary-subtle text-secondary">${u.role}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <span class="font-monospace fw-bold" id="pwd-text-${u.userId}" style="font-size:0.86rem; letter-spacing:0.1em; color:var(--txt);">••••••••</span>
                                        <button type="button" class="btn btn-sm btn-link p-0 text-muted" 
                                                onclick="toggleUserPasswordVisibility('${u.userId}', '${u.password}')" 
                                                title="View / Hide Password" 
                                                id="pwd-btn-${u.userId}" 
                                                style="text-decoration:none;">
                                            <i class="bi bi-eye-fill" id="pwd-icon-${u.userId}"></i>
                                        </button>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.status == 'ACTIVE'}">
                                            <span class="status-badge status-active">
                                                <i class="bi bi-check-circle-fill"></i> Active
                                            </span>
                                        </c:when>
                                        <c:when test="${u.status == 'SUSPENDED'}">
                                            <span class="status-badge status-suspended">
                                                <i class="bi bi-slash-circle-fill"></i> Suspended
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge bg-secondary-subtle text-secondary">${u.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-muted" style="font-size:0.8rem;">
                                    ${u.createdAt}
                                </td>
                                <td class="text-end">
                                    <div class="d-flex align-items-center justify-content-end gap-1">
                                        <!-- Edit User Button -->
                                        <button type="button" class="btn-action-sm" title="Edit Profile Details"
                                                onclick="openEditUserModal('${u.userId}', '${u.username}', '${fn:escapeXml(u.fullName)}', '${u.email}', '${u.phone}', '${u.role}', '${u.status}', '${fn:escapeXml(u.password)}')">
                                            <i class="bi bi-pencil-fill"></i>
                                        </button>

                                        <!-- Suspend or Recover -->
                                        <c:choose>
                                            <c:when test="${u.status == 'SUSPENDED'}">
                                                <form action="/admin/users/recover" method="post" style="display:inline;">
                                                    <input type="hidden" name="userId" value="${u.userId}">
                                                    <button type="submit" class="btn-action-sm btn-action-recover text-success" title="Instant Account Recovery">
                                                        <i class="bi bi-arrow-counterclockwise"></i>
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <c:if test="${u.username != 'admin'}">
                                                    <button type="button" class="btn-action-sm btn-action-danger text-warning" title="Suspend Account Access"
                                                            onclick="openSuspendModal('${u.userId}', '${u.username}', '${u.fullName}', '${u.role}')">
                                                        <i class="bi bi-slash-circle"></i>
                                                    </button>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>

                                        <!-- Delete Account (Disabled for root admin) -->
                                        <c:choose>
                                            <c:when test="${u.username == 'admin'}">
                                                <button type="button" class="btn-action-sm opacity-50" title="System Administrator account cannot be deleted" disabled>
                                                    <i class="bi bi-lock-fill"></i>
                                                </button>
                                            </c:when>
                                            <c:otherwise>
                                                <button type="button" class="btn-action-sm btn-action-danger" title="Permanently Delete Account"
                                                        onclick="openDeleteModal('${u.userId}', '${u.username}', '${u.fullName}')">
                                                    <i class="bi bi-trash-fill text-danger"></i>
                                                </button>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty users}">
                            <tr>
                                <td colspan="8" class="text-center py-5">
                                    <i class="bi bi-people text-muted" style="font-size:2.5rem;"></i>
                                    <div class="fw-bold mt-2 text-muted">No accounts found matching filter '${currentFilter}'</div>
                                    <a href="/admin/users?role=ALL" class="btn btn-sm btn-outline-primary mt-2">Reset Filter</a>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MODAL 1: ADD VERIFIED CUSTOMER                   -->
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
                                <input type="text" name="fullName" class="sys-form-input" placeholder="e.g. Kasun Fernando" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Username <span class="text-danger">*</span></label>
                                <input type="text" name="username" class="sys-form-input" placeholder="e.g. kasunf" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Email Address <span class="text-danger">*</span></label>
                                <input type="email" name="email" class="sys-form-input" placeholder="e.g. kasun@example.com" required>
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
                                    <input type="password" name="password" id="userCustPassword" class="sys-form-input pe-5" placeholder="Minimum 4 characters" required minlength="4">
                                    <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted pe-3" 
                                            onclick="toggleInputVisibility('userCustPassword', 'userCustEyeIcon')" style="text-decoration:none;">
                                        <i class="bi bi-eye-fill" id="userCustEyeIcon"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Confirm Password <span class="text-danger">*</span></label>
                                <div class="position-relative">
                                    <input type="password" name="confirmPassword" id="userCustConfirmPassword" class="sys-form-input pe-5" placeholder="Re-enter password" required minlength="4">
                                    <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted pe-3" 
                                            onclick="toggleInputVisibility('userCustConfirmPassword', 'userCustConfirmEyeIcon')" style="text-decoration:none;">
                                        <i class="bi bi-eye-fill" id="userCustConfirmEyeIcon"></i>
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
                                    <input type="password" name="password" id="userStaffPassword" class="sys-form-input pe-5" placeholder="Minimum 4 characters" required minlength="4">
                                    <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted pe-3" 
                                            onclick="toggleInputVisibility('userStaffPassword', 'userStaffEyeIcon')" style="text-decoration:none;">
                                        <i class="bi bi-eye-fill" id="userStaffEyeIcon"></i>
                                    </button>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Confirm Password <span class="text-danger">*</span></label>
                                <div class="position-relative">
                                    <input type="password" name="confirmPassword" id="userStaffConfirmPassword" class="sys-form-input pe-5" placeholder="Re-enter password" required minlength="4">
                                    <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted pe-3" 
                                            onclick="toggleInputVisibility('userStaffConfirmPassword', 'userStaffConfirmEyeIcon')" style="text-decoration:none;">
                                        <i class="bi bi-eye-fill" id="userStaffConfirmEyeIcon"></i>
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

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MODAL 3: EDIT USER DETAILS                       -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="modal fade" id="editUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <form action="/admin/users/update" method="post">
                    <input type="hidden" name="userId" id="editUserId">
                    <div class="modal-header">
                        <div>
                            <h5 class="modal-title fw-bold mb-0">
                                <i class="bi bi-pencil-square text-primary me-2"></i>
                                Edit User Account: <span id="editUserTitleUsername" class="text-primary"></span>
                            </h5>
                            <small class="text-muted">Modify account identity, login credentials, and permission assignments</small>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="sys-form-label">Full Name <span class="text-danger">*</span></label>
                                <input type="text" name="fullName" id="editFullName" class="sys-form-input" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Username (Login ID) <span class="text-danger">*</span></label>
                                <div class="position-relative">
                                    <input type="text" name="username" id="editUsername" class="sys-form-input" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Email Address <span class="text-danger">*</span></label>
                                <input type="email" name="email" id="editEmail" class="sys-form-input" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Contact Phone <span class="text-danger">*</span></label>
                                <input type="text" name="phone" id="editPhone" class="sys-form-input" required>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">System Role <span class="text-danger">*</span></label>
                                <select name="role" id="editRole" class="sys-form-select" required>
                                    <option value="CUSTOMER">CUSTOMER (Customer Store)</option>
                                    <option value="INVENTORY">INVENTORY (Warehouse Hub)</option>
                                    <option value="SPAREPARTS">SPAREPARTS (Quality Control)</option>
                                    <option value="SALES">SALES (Sales Management)</option>
                                    <option value="SUPPLIER">SUPPLIER (Supplier Portal)</option>
                                    <option value="REPORT_MANAGER">REPORT_MANAGER (Report &amp; Analytics)</option>
                                    <option value="SYSADMIN">SYSADMIN (System Administrator)</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="sys-form-label">Account Status <span class="text-danger">*</span></label>
                                <select name="status" id="editStatus" class="sys-form-select" required>
                                    <option value="ACTIVE">ACTIVE</option>
                                    <option value="SUSPENDED">SUSPENDED</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label class="sys-form-label">
                                    Login Password <span class="text-danger">*</span>
                                </label>
                                <div class="position-relative">
                                    <input type="password" name="password" id="editPassword" class="sys-form-input pe-5" required minlength="4">
                                    <button type="button" class="btn btn-link position-absolute end-0 top-50 translate-middle-y text-muted pe-3" 
                                            onclick="toggleInputVisibility('editPassword', 'editPasswordEyeIcon')" 
                                            title="View / Hide Password" style="text-decoration:none;">
                                        <i class="bi bi-eye-fill text-muted" id="editPasswordEyeIcon"></i>
                                    </button>
                                </div>
                                <small class="text-muted" style="font-size:0.75rem;">
                                    <i class="bi bi-shield-lock-fill text-primary me-1"></i>Current password is shown above. Click the eye icon to view or type a new password to change it.
                                </small>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-brand-accent">
                            <i class="bi bi-save2-fill"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MODAL 4: SUSPEND USER ACCOUNT                    -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="modal fade" id="suspendUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="/admin/users/suspend" method="post">
                    <input type="hidden" name="userId" id="suspendUserId">
                    <div class="modal-header border-warning">
                        <h5 class="modal-title fw-bold text-warning">
                            <i class="bi bi-slash-circle-fill me-2"></i>
                            Suspend Account Access
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p class="text-muted mb-3">
                            You are placing a security hold on <strong id="suspendTargetName" class="text-dark"></strong> (<span id="suspendTargetUsername" class="text-muted"></span>).
                            Suspended users cannot log in or perform system transactions until recovered.
                        </p>
                        <div class="mb-3">
                            <label class="sys-form-label">Suspension Audit Reason <span class="text-danger">*</span></label>
                            <select name="reason" class="sys-form-select mb-2" onchange="checkCustomReason(this)">
                                <option value="Policy review / administrative hold">Policy review / administrative hold</option>
                                <option value="Multiple unauthorized access attempts">Multiple unauthorized access attempts</option>
                                <option value="Suspected fraudulent activity">Suspected fraudulent activity</option>
                                <option value="Incomplete compliance documentation">Incomplete compliance documentation</option>
                                <option value="Temporary operational hold">Temporary operational hold</option>
                                <option value="CUSTOM">Custom justification...</option>
                            </select>
                            <input type="text" id="customReasonInput" class="sys-form-input d-none" placeholder="Provide specific justification...">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-warning rounded-pill px-4 fw-bold">
                            <i class="bi bi-slash-circle-fill"></i> Confirm Suspension
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- ═════════════════════════════════════════════════ -->
    <!--  MODAL 5: PERMANENTLY REMOVE ACCOUNT              -->
    <!-- ═════════════════════════════════════════════════ -->
    <div class="modal fade" id="deleteUserModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="/admin/users/delete" method="post">
                    <input type="hidden" name="userId" id="deleteUserId">
                    <div class="modal-header border-danger">
                        <h5 class="modal-title fw-bold text-danger">
                            <i class="bi bi-trash3-fill me-2"></i>
                            Permanently Delete User Account
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="alert alert-danger border-0 d-flex align-items-center gap-3 mb-3">
                            <i class="bi bi-exclamation-octagon-fill fs-3 text-danger"></i>
                            <div style="font-size:0.86rem;">
                                <strong>Warning:</strong> This action cannot be reversed! All associated account profile data will be permanently removed from the master database.
                            </div>
                        </div>
                        <p class="mb-0">
                            Are you certain you want to purge user <strong id="deleteTargetName"></strong> (<span id="deleteTargetUsername" class="text-danger"></span>)?
                        </p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-danger rounded-pill px-4 fw-bold">
                            <i class="bi bi-trash-fill"></i> Delete Account
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        // Password Visibility Toggle for Table Rows
        function toggleUserPasswordVisibility(userId, plainPassword) {
            var span = document.getElementById('pwd-text-' + userId);
            var icon = document.getElementById('pwd-icon-' + userId);
            if (!span || !icon) return;
            if (span.textContent === '••••••••') {
                span.textContent = plainPassword;
                span.classList.add('text-primary');
                icon.className = 'bi bi-eye-slash-fill text-primary';
            } else {
                span.textContent = '••••••••';
                span.classList.remove('text-primary');
                icon.className = 'bi bi-eye-fill text-muted';
            }
        }

        // Password Visibility Toggle for Form Inputs
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

        // Modal helper functions
        function openEditUserModal(id, username, fullName, email, phone, role, status, password) {
            document.getElementById('editUserId').value = id;
            document.getElementById('editUserTitleUsername').textContent = '@' + username;
            document.getElementById('editFullName').value = fullName;
            document.getElementById('editUsername').value = username;
            document.getElementById('editEmail').value = email;
            document.getElementById('editPhone').value = phone;
            document.getElementById('editRole').value = role;
            document.getElementById('editStatus').value = status;
            var pwdInput = document.getElementById('editPassword');
            if (pwdInput) {
                pwdInput.value = password || '';
                pwdInput.type = 'password';
            }
            var eyeIcon = document.getElementById('editPasswordEyeIcon');
            if (eyeIcon) {
                eyeIcon.className = 'bi bi-eye-fill text-muted';
            }
            var m = new bootstrap.Modal(document.getElementById('editUserModal'));
            m.show();
        }

        function openSuspendModal(id, username, fullName, role) {
            document.getElementById('suspendUserId').value = id;
            document.getElementById('suspendTargetName').textContent = fullName;
            document.getElementById('suspendTargetUsername').textContent = '@' + username + ' (' + role + ')';
            var m = new bootstrap.Modal(document.getElementById('suspendUserModal'));
            m.show();
        }

        function openDeleteModal(id, username, fullName) {
            document.getElementById('deleteUserId').value = id;
            document.getElementById('deleteTargetName').textContent = fullName;
            document.getElementById('deleteTargetUsername').textContent = '@' + username;
            var m = new bootstrap.Modal(document.getElementById('deleteUserModal'));
            m.show();
        }

        function checkCustomReason(sel) {
            var custom = document.getElementById('customReasonInput');
            if (sel.value === 'CUSTOM') {
                custom.classList.remove('d-none');
                custom.required = true;
                sel.name = '';
                custom.name = 'reason';
            } else {
                custom.classList.add('d-none');
                custom.required = false;
                sel.name = 'reason';
                custom.name = '';
            }
        }

        // Live Directory Search Filtering
        function filterUserDirectory() {
            var q = document.getElementById('userDirectorySearch').value.toLowerCase();
            var rows = document.querySelectorAll('.user-row-item');
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
