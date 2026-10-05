<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Role &amp; Access Control Matrix | System Administrator | PartTrack</title>

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
            width: 5px;
        }
        .sys-sidebar::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.2);
            border-radius: 4px;
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
            padding-top: 1.25rem;
            border-top: 1px solid rgba(255,255,255,0.08);
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
            margin-top: auto;
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
            background: linear-gradient(135deg, #1e3a8a 0%, #0f172a 100%);
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
        }
        .sys-hero-card::after {
            content: '';
            position: absolute;
            top: -40px;
            right: -40px;
            width: 240px;
            height: 240px;
            background: radial-gradient(circle, rgba(59, 130, 246, 0.25) 0%, transparent 70%);
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
            color: #93c5fd;
            font-size: 0.92rem;
            max-width: 650px;
            line-height: 1.5;
        }

        /* ── MATRIX TABLE ── */
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
            text-align: center;
        }
        .sys-table th:first-child, .sys-table th:nth-child(2) {
            text-align: left;
        }
        .sys-table td {
            padding: 1rem 1.25rem;
            border-bottom: 1px solid var(--border);
            font-size: 0.86rem;
            color: var(--txt);
            vertical-align: middle;
            text-align: center;
        }
        .sys-table td:first-child, .sys-table td:nth-child(2) {
            text-align: left;
        }
        .sys-table tr:last-child td { border-bottom: none; }
        .sys-table tr:hover td { background: var(--accent-soft); }

        .perm-check {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.95rem;
            background: rgba(16, 185, 129, 0.15);
            color: #10b981;
        }
        .perm-cross {
            width: 28px;
            height: 28px;
            border-radius: 8px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.85rem;
            background: var(--card-subtle);
            color: var(--txt3);
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
            <a href="/admin/suspensions" class="sys-nav-link">
                <i class="bi bi-person-x-fill text-warning"></i>
                <span>Suspended History</span>
                <c:if test="${stats.suspendedUsers > 0}">
                    <span class="badge bg-danger rounded-pill ms-auto px-2 py-1" style="font-size:0.68rem;">
                        ${stats.suspendedUsers}
                    </span>
                </c:if>
            </a>
            <a href="/admin/roles" class="sys-nav-link active">
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
                <span class="text-primary fw-bold">Role-Based Access Control (RBAC) Matrix</span>
                <span class="sys-badge-admin ms-2">
                    <i class="bi bi-check-circle-fill"></i> Security Policies Active
                </span>
            </div>

            <div class="d-flex align-items-center gap-2">
                <a href="/admin/users" class="btn btn-outline-primary rounded-3 fw-bold px-3 py-2 d-inline-flex align-items-center gap-2">
                    <i class="bi bi-people-fill"></i> Provision &amp; Manage Accounts
                </a>
                <a href="/logout" class="btn btn-outline-danger rounded-pill fw-bold px-3 py-2 d-inline-flex align-items-center gap-2 shadow-sm" style="font-size:0.86rem; text-decoration:none;" title="Sign out of System Administrator">
                    <i class="bi bi-box-arrow-right"></i>
                    <span>Logout</span>
                </a>
            </div>
        </div>

        <!-- Hero Card -->
        <div class="sys-hero-card">
            <div>
                <h1 class="sys-hero-title">Role &amp; Module Access Control Matrix</h1>
                <p class="sys-hero-sub">
                    Enforces strict principle of least privilege (PoLP) and segregation of duties. Interceptors actively block unauthorized endpoints across the 7 distinct system functional domains.
                </p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill fw-bold">
                    <i class="bi bi-shield-check me-1"></i> Interceptor Guard Active
                </span>
            </div>
        </div>

        <!-- Access Matrix Table -->
        <div class="sys-table-card">
            <div class="sys-table-header">
                <div>
                    <h5 class="fw-bold mb-0">System Privilege Delegation Grid</h5>
                    <small class="text-muted">Module access rights mapped across authenticated roles</small>
                </div>
            </div>

            <div class="table-responsive">
                <table class="sys-table">
                    <thead>
                        <tr>
                            <th style="width:220px;">Role &amp; Title</th>
                            <th style="width:280px;">Scope of Responsibility</th>
                            <th>Customer Store</th>
                            <th>Inventory Hub</th>
                            <th>QA &amp; Receiving</th>
                            <th>Commercial Sales</th>
                            <th>Supplier Partner</th>
                            <th>Report &amp; Analytics</th>
                            <th>System Admin Console</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="row" items="${matrix}">
                            <tr>
                                <td>
                                    <div class="fw-bold text-dark-title">${row.roleTitle}</div>
                                    <span class="badge bg-secondary-subtle text-secondary mt-1" style="font-size:0.72rem;">${row.roleCode}</span>
                                </td>
                                <td>
                                    <div class="text-muted" style="font-size:0.82rem; line-height:1.4;">${row.description}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${row.permCustomerStore}"><span class="perm-check"><i class="bi bi-check-lg"></i></span></c:when>
                                        <c:otherwise><span class="perm-cross"><i class="bi bi-dash"></i></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${row.permInventory}"><span class="perm-check"><i class="bi bi-check-lg"></i></span></c:when>
                                        <c:otherwise><span class="perm-cross"><i class="bi bi-dash"></i></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${row.permQualityQa}"><span class="perm-check"><i class="bi bi-check-lg"></i></span></c:when>
                                        <c:otherwise><span class="perm-cross"><i class="bi bi-dash"></i></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${row.permSales}"><span class="perm-check"><i class="bi bi-check-lg"></i></span></c:when>
                                        <c:otherwise><span class="perm-cross"><i class="bi bi-dash"></i></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${row.permSupplier}"><span class="perm-check"><i class="bi bi-check-lg"></i></span></c:when>
                                        <c:otherwise><span class="perm-cross"><i class="bi bi-dash"></i></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${row.permReports}"><span class="perm-check"><i class="bi bi-check-lg"></i></span></c:when>
                                        <c:otherwise><span class="perm-cross"><i class="bi bi-dash"></i></span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${row.permSysAdmin}"><span class="perm-check" style="background:rgba(37,99,235,0.18); color:#2563eb;"><i class="bi bi-check-lg"></i></span></c:when>
                                        <c:otherwise><span class="perm-cross"><i class="bi bi-dash"></i></span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <script>
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
