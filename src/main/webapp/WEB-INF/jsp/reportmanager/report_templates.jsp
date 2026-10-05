<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Template Engine &amp; Schedulers | PartTrack</title>

    <!-- Dark mode init -->
    <script>
    (function(){var t=localStorage.getItem('theme')||'light';document.documentElement.setAttribute('data-theme',t);})();
    </script>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@500;600;700&display=swap" rel="stylesheet">
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

        .sidebar-rail {
            width: 72px; height: 100vh; position: fixed; top: 0; left: 0;
            background: var(--sidebar-bg); border-right: 1px solid var(--border);
            display: flex; flex-direction: column; align-items: center; padding: 1.25rem 0;
            z-index: 1030; box-shadow: 2px 0 8px rgba(0,0,0,.04);
            transition: background .2s, border-color .2s;
        }
        .brand-logo-icon {
            width: 44px; height: 44px; border-radius: 12px;
            background: linear-gradient(135deg, #7c3aed, #4f46e5);
            color: #fff; display: flex; align-items: center; justify-content: center;
            font-size: 1.3rem; box-shadow: 0 4px 12px rgba(124,58,237,.35);
            margin-bottom: 2rem; text-decoration: none;
        }
        .sidebar-nav {
            display: flex; flex-direction: column; align-items: center; gap: .85rem;
            width: 100%; list-style: none; padding: 0; margin: 0;
        }
        .sidebar-icon-link {
            width: 44px; height: 44px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: var(--txt2); text-decoration: none; font-size: 1.25rem;
            transition: all .15s; position: relative;
        }
        .sidebar-icon-link:hover { background: var(--table-hover); color: var(--txt); }
        .sidebar-icon-link.active { background: var(--purple-soft); color: var(--purple); font-weight: 700; }
        [data-theme="dark"] .sidebar-icon-link.active { background: #2e1065; color: #c084fc; }

        .sidebar-bottom { margin-top: auto; display: flex; flex-direction: column; align-items: center; }
        .logout-icon-link {
            width: 44px; height: 44px; border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            color: #ef4444; text-decoration: none; font-size: 1.25rem;
        }

        .main-content {
            margin-left: 72px; flex: 1; padding: 2rem;
            max-width: 1400px; width: calc(100% - 72px);
        }

        .white-card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 16px; box-shadow: 0 1px 4px rgba(0,0,0,.03);
            margin-bottom: 1.5rem; overflow: hidden;
            transition: background .2s, border-color .2s;
        }
        .card-header-clean { padding: 1.25rem 1.5rem; border-bottom: 1px solid var(--border); background: var(--card); }

        .photo-banner { position: relative; overflow: hidden; width: 100%; }
        .photo-banner img { width: 100%; height: 100%; object-fit: cover; display: block; }
        .photo-banner .overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(15,23,42,.88) 0%, rgba(15,23,42,.35) 60%, rgba(15,23,42,.1) 100%);
        }

        .tag-pill {
            background: var(--table-hover); border: 1px solid var(--border);
            border-radius: 20px; padding: .25rem .75rem; font-size: .8rem;
            font-weight: 600; color: var(--txt); display: inline-flex; align-items: center; gap: .35rem;
        }
        .btn-purple {
            background: var(--purple); color: #fff; border: none; border-radius: 10px;
            padding: .5rem 1.15rem; font-weight: 700; font-size: .88rem;
            display: inline-flex; align-items: center; gap: .45rem; text-decoration: none;
            transition: all .15s; cursor: pointer;
        }
        .btn-purple:hover { background: #6d28d9; color: #fff; transform: translateY(-1px); }

        .btn-navy {
            background: var(--navy); color: #fff; border: none; border-radius: 10px;
            padding: .5rem 1.15rem; font-weight: 700; font-size: .88rem;
            display: inline-flex; align-items: center; gap: .45rem; text-decoration: none;
            transition: all .15s; cursor: pointer;
        }
        .btn-navy:hover { background: var(--navy-dark); color: #fff; transform: translateY(-1px); }

        .btn-outline-clean {
            background: transparent; color: var(--txt); border: 1px solid var(--border);
            border-radius: 10px; padding: .45rem .95rem; font-weight: 600; font-size: .85rem;
            display: inline-flex; align-items: center; gap: .45rem; text-decoration: none;
            transition: all .15s; cursor: pointer;
        }
        .btn-outline-clean:hover { background: var(--table-hover); color: var(--txt); }

        .btn-icon {
            width: 34px; height: 34px; border-radius: 8px; display: inline-flex;
            align-items: center; justify-content: center; border: 1px solid var(--border);
            background: var(--card); color: var(--txt2); text-decoration: none;
            transition: all .15s; cursor: pointer;
        }
        .btn-icon-purple:hover { background: var(--purple-soft); color: var(--purple); border-color: var(--purple); }
        .btn-icon-danger:hover { background: #fee2e2; color: #dc2626; border-color: #fca5a5; }

        .table { color: var(--txt) !important; border-color: var(--border) !important; margin-bottom: 0; }
        .table > :not(caption) > * > * { background-color: transparent !important; border-bottom-color: var(--border) !important; padding: 1rem 1.25rem; }
        .table thead th {
            background: var(--table-head) !important; color: var(--txt2) !important;
            font-size: .78rem; font-weight: 700; text-transform: uppercase; letter-spacing: .05em;
            border-bottom: 2px solid var(--border) !important;
        }
        .table tbody tr:hover { background-color: var(--table-hover) !important; }

        .modal-content {
            background-color: var(--modal-bg) !important; border: 1px solid var(--border) !important;
            border-radius: 16px; color: var(--txt) !important;
        }
        .modal-header { background-color: var(--modal-header) !important; border-bottom: 1px solid var(--border) !important; }
        .modal-footer { border-top: 1px solid var(--border) !important; }
        .form-control, .form-select {
            background-color: var(--input-bg) !important; border-color: var(--border) !important;
            color: var(--txt) !important; border-radius: 8px;
        }
    </style>
</head>
<body>

    <!-- Sidebar Rail -->
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
                <a href="/reports/templates" class="sidebar-icon-link active" title="Template Engine & Automated Schedulers">
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

    <!-- Main Content -->
    <main class="main-content">
        <!-- Topbar -->
        <div class="d-flex justify-content-between align-items-center mb-4 gap-3 flex-wrap">
            <div>
                <h2 class="fw-extrabold mb-1" style="font-size:1.85rem; font-weight:800; letter-spacing:-0.03em; color:var(--txt);">
                    Template Engine &amp; Automated Schedulers
                </h2>
                <p class="mb-0" style="color:var(--txt2); font-size:1.02rem; font-weight:500; line-height:1.55;">
                    Configure reusable report templates specifying department modules, generate reports on-demand, and schedule automated email dispatches.
                </p>
            </div>
            <div class="d-flex align-items-center gap-2">
                <span class="badge bg-purple text-white px-3 py-2 fw-bold" style="background:var(--purple); cursor:pointer;" onclick="openAccountModal()" title="Click to edit account details">
                    <i class="bi bi-person-check-fill me-1"></i> <c:out value="${not empty sessionScope.fullName ? sessionScope.fullName : 'Report & Business Dashboard Manager'}"/>
                </span>
            </div>
        </div>

        <!-- Flash messages -->
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success alert-dismissible fade show d-flex align-items-center gap-2 rounded-3 mb-4 py-2 px-3 border" role="alert">
                <i class="bi bi-check-circle-fill text-success fs-5"></i>
                <div class="small fw-semibold text-success"><c:out value="${successMessage}"/></div>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show rounded-3 mb-4 py-2 px-3 border small fw-semibold" role="alert">
                <i class="bi bi-exclamation-triangle-fill text-danger me-1"></i> <c:out value="${errorMessage}"/>
                <button type="button" class="btn-close ms-auto py-2" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Photo Banner -->
        <div class="white-card mb-4" style="border-radius:16px;">
            <div class="photo-banner" style="height:140px;border-radius:16px;">
                <img src="https://images.unsplash.com/photo-1551836022-d5d88e9218df?auto=format&fit=crop&w=1200&q=85"
                     alt="Automation & Schedulers" loading="lazy">
                <div class="overlay"></div>
                <div style="position:absolute;bottom:1.25rem;left:1.75rem;right:1.75rem;" class="d-flex justify-content-between align-items-end flex-wrap gap-2">
                    <div>
                        <span class="badge mb-2" style="background:rgba(124,58,237,.9);color:#fff;font-size:.72rem;letter-spacing:.05em;padding:.35rem .75rem;border-radius:8px;">
                            <i class="bi bi-cpu-fill me-1"></i>AUTOMATION ARCHITECTURE
                        </span>
                        <h3 style="color:#fff;font-size:1.45rem;font-weight:800;margin:0;letter-spacing:-.02em;">
                            Reusable Report Presets &amp; Automated Delivery Schedulers
                        </h3>
                    </div>
                    <div class="d-flex gap-2">
                        <button type="button" class="btn btn-sm btn-purple" data-bs-toggle="modal" data-bs-target="#createTemplateModal">
                            <i class="bi bi-plus-lg me-1"></i> New Template
                        </button>
                        <button type="button" class="btn btn-sm btn-outline-clean text-white border-white" data-bs-toggle="modal" data-bs-target="#createScheduleModal">
                            <i class="bi bi-clock-history me-1"></i> New Email Schedule
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- 1. Report Templates Table Card -->
        <div class="white-card mb-4" id="templatesSection">
            <div class="card-header-clean d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div>
                    <h4 class="fw-bold mb-1" style="color:var(--txt); font-size:1.25rem; font-weight:800; letter-spacing:-0.02em;">
                        Configured Report Templates
                    </h4>
                    <p class="mb-0" style="color:var(--txt2); font-size:0.92rem; font-weight:500;">
                        Reusable templates combining specific operational departments (e.g. Weekly Inventory + Supplier). Generate certified PDF or TXT anytime with 1 click.
                    </p>
                </div>
                <button type="button" class="btn-purple" data-bs-toggle="modal" data-bs-target="#createTemplateModal">
                    <i class="bi bi-plus-lg"></i> Create New Template
                </button>
            </div>

            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th style="width:70px; text-align:center;">ID</th>
                            <th>Template Name</th>
                            <th>Combined Department Modules</th>
                            <th>Frequency</th>
                            <th style="text-align:center;">1-Click Report Generation</th>
                            <th style="text-align:center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty templates}">
                                <tr>
                                    <td colspan="6" class="text-center py-5 text-muted">
                                        <i class="bi bi-layers fs-1 d-block mb-2"></i>
                                        <h6 class="fw-bold">No Custom Templates Configured Yet</h6>
                                        <small>Create your first recurring template above to combine operational departments.</small>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="template" items="${templates}">
                                    <tr>
                                        <td class="text-center fw-bold" style="font-family:'JetBrains Mono',monospace; color:var(--purple);">
                                            #<c:out value="${template.id}"/>
                                        </td>
                                        <td>
                                            <div class="fw-bold" style="color:var(--txt); font-size:.95rem;"><c:out value="${template.templateName}"/></div>
                                            <small class="text-muted">PartTrack Official Engine Preset</small>
                                        </td>
                                        <td>
                                            <div class="d-flex flex-wrap gap-1">
                                                <c:forTokens items="${template.templateFilters}" delims="," var="moduleItem">
                                                    <span class="tag-pill" style="font-size:0.75rem;">
                                                        <i class="bi bi-check-circle-fill text-purple"></i> <c:out value="${moduleItem}"/>
                                                    </span>
                                                </c:forTokens>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="badge bg-purple-soft text-purple border border-purple px-2 py-1 fw-bold">
                                                <i class="bi bi-calendar-check me-1"></i><c:out value="${template.frequency}"/>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-inline-flex gap-2">
                                                <a href="/reports/templates/generate/${template.id}?format=pdf"
                                                   class="btn btn-sm btn-purple" title="Instant PDF Download">
                                                    <i class="bi bi-file-earmark-pdf-fill"></i> Instant PDF
                                                </a>
                                                <a href="/reports/templates/generate/${template.id}?format=txt"
                                                   class="btn btn-sm btn-navy" title="Instant TXT Download">
                                                    <i class="bi bi-file-text-fill"></i> Instant TXT
                                                </a>
                                            </div>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center justify-content-center gap-1">
                                                <button type="button" class="btn-icon btn-icon-purple edit-template-btn"
                                                        data-id="${template.id}"
                                                        data-name="<c:out value='${template.templateName}'/>"
                                                        data-filters="<c:out value='${template.templateFilters}'/>"
                                                        data-frequency="<c:out value='${template.frequency}'/>"
                                                        title="Edit Template">
                                                    <i class="bi bi-pencil-fill"></i>
                                                </button>
                                                <form action="/reports/templates/delete/${template.id}" method="post" style="margin:0;"
                                                      onsubmit="return confirm('Are you sure you want to delete this template?');">
                                                    <button type="submit" class="btn-icon btn-icon-danger" title="Delete Template">
                                                        <i class="bi bi-trash3-fill"></i>
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
        </div>

        <!-- 2. Automated Schedulers Table Card -->
        <div class="white-card mb-4" id="schedulesSection">
            <div class="card-header-clean d-flex justify-content-between align-items-center flex-wrap gap-2">
                <div>
                    <h4 class="fw-bold mb-1" style="color:var(--txt); font-size:1.25rem; font-weight:800; letter-spacing:-0.02em;">
                        Automated Recurring Report Dispatches
                    </h4>
                    <p class="mb-0" style="color:var(--txt2); font-size:0.92rem; font-weight:500;">
                        Active delivery schedules transmitting compiled operational reports automatically to designated recipient emails on a daily, weekly, or monthly cadence.
                    </p>
                </div>
                <button type="button" class="btn-purple" data-bs-toggle="modal" data-bs-target="#createScheduleModal">
                    <i class="bi bi-clock-history"></i> Add Schedule
                </button>
            </div>

            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th style="width:70px; text-align:center;">ID</th>
                            <th>Associated Template</th>
                            <th>Cadence</th>
                            <th>Recipient Email Address</th>
                            <th style="text-align:center;">Engine Status</th>
                            <th style="text-align:center;">Simulate Dispatch</th>
                            <th style="text-align:center;">Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty schedules}">
                                <tr>
                                    <td colspan="7" class="text-center py-5 text-muted">
                                        <i class="bi bi-envelope-exclamation fs-1 d-block mb-2"></i>
                                        <h6 class="fw-bold">No Automated Delivery Schedules Configured</h6>
                                        <small>Create an automated delivery schedule above to link a template with a target email address.</small>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="schedule" items="${schedules}">
                                    <tr>
                                        <td class="text-center fw-bold" style="font-family:'JetBrains Mono',monospace; color:var(--purple);">
                                            #<c:out value="${schedule.id}"/>
                                        </td>
                                        <td>
                                            <div class="fw-bold" style="color:var(--txt); font-size:.95rem;"><c:out value="${schedule.template != null ? schedule.template.templateName : 'Custom Blueprint'}"/></div>
                                            <small class="text-muted">Modules: <c:out value="${schedule.template != null ? schedule.template.templateFilters : 'All Modules'}"/></small>
                                        </td>
                                        <td>
                                            <span class="badge bg-purple-soft text-purple border border-purple px-2 py-1 fw-bold">
                                                <i class="bi bi-arrow-repeat me-1"></i><c:out value="${schedule.frequency}"/>
                                            </span>
                                        </td>
                                        <td>
                                            <span class="fw-semibold" style="font-family:'JetBrains Mono',monospace; color:var(--txt); font-size:0.85rem;">
                                                <i class="bi bi-envelope text-primary me-1"></i><c:out value="${schedule.deliveryEmail}"/>
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <span class="badge bg-success-subtle text-success border border-success px-2 py-1 fw-bold">
                                                <i class="bi bi-broadcast me-1"></i>ACTIVE SCHEDULER
                                            </span>
                                        </td>
                                        <td class="text-center">
                                            <form action="/reports/schedules/simulate-dispatch/${schedule.id}" method="post" style="margin:0;">
                                                <button type="submit" class="btn btn-sm btn-outline-clean" title="Test automated email transmission simulation">
                                                    <i class="bi bi-send-check text-purple me-1"></i> Simulate Dispatch
                                                </button>
                                            </form>
                                        </td>
                                        <td class="text-center">
                                            <div class="d-flex align-items-center justify-content-center gap-1">
                                                <button type="button" class="btn-icon btn-icon-purple edit-schedule-btn"
                                                        data-id="${schedule.id}"
                                                        data-template-id="${schedule.template != null ? schedule.template.id : ''}"
                                                        data-frequency="<c:out value='${schedule.frequency}'/>"
                                                        data-email="<c:out value='${schedule.deliveryEmail}'/>"
                                                        title="Edit Schedule">
                                                    <i class="bi bi-pencil-fill"></i>
                                                </button>
                                                <form action="/reports/schedules/cancel/${schedule.id}" method="post" style="margin:0;"
                                                      onsubmit="return confirm('Cancel automated delivery schedule #${schedule.id}?');">
                                                    <button type="submit" class="btn-icon btn-icon-danger" title="Cancel Schedule">
                                                        <i class="bi bi-x-circle-fill"></i>
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
        </div>

    </main>

    <!-- MODAL: CREATE TEMPLATE -->
    <div class="modal fade" id="createTemplateModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form id="createTemplateForm" action="/reports/templates/create" method="post" onsubmit="return validateTemplateForm('createTemplateForm')">
                    <div class="modal-header">
                        <div>
                            <span class="badge bg-purple-soft text-purple border border-purple mb-1">
                                <i class="bi bi-layers-fill me-1"></i>NEW REPORT BLUEPRINT
                            </span>
                            <h5 class="modal-title fw-bold mb-0" style="color:var(--txt);">Create Report Template</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Template Name</label>
                            <input type="text" name="templateName" class="form-control" placeholder="e.g. Weekly Warehouse &amp; Procurement Summary" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Default Frequency</label>
                            <select name="frequency" class="form-select">
                                <option value="Weekly" selected>Weekly</option>
                                <option value="Daily">Daily</option>
                                <option value="Monthly">Monthly</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <label class="form-label fw-bold small text-uppercase mb-0" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">
                                    Include Department Modules:
                                </label>
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-sm btn-link p-0 text-decoration-none" style="font-size:0.75rem;" onclick="toggleTplModalCheckboxes('create', true)">All</button>
                                    <span class="text-muted" style="font-size:0.75rem;">|</span>
                                    <button type="button" class="btn btn-sm btn-link p-0 text-decoration-none" style="font-size:0.75rem;" onclick="toggleTplModalCheckboxes('create', false)">Clear</button>
                                </div>
                            </div>

                            <div class="d-flex flex-column gap-2 p-3 rounded-3 border" style="background:var(--table-head); border-color:var(--border) !important;">
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Inventory" checked class="form-check-input create-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-boxes text-primary fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Warehouse Inventory</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">Stock quantities, valuations, depot reorder alerts</small>
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Supplier" checked class="form-check-input create-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-truck text-success fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Supplier Network</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">OEM vendor contracts &amp; procurement status</small>
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Spare Parts" checked class="form-check-input create-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-shield-check text-purple fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Spare Parts QA &amp; Inspection</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">Delivery inspection pass rates &amp; defect tracking</small>
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Sales" checked class="form-check-input create-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-graph-up-arrow text-info fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Sales &amp; Commercial Orders</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">Customer turnover, revenue metrics &amp; top parts</small>
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Customer Portal" checked class="form-check-input create-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-people-fill text-warning fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Customer Portal &amp; Accounts</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">Registered buyer directories &amp; shopper profiles</small>
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-outline-clean" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-purple">
                            <i class="bi bi-save2 me-1"></i> Save Blueprint Template
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL: EDIT TEMPLATE -->
    <div class="modal fade" id="editTemplateModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form id="editTemplateForm" method="post" onsubmit="return validateTemplateForm('editTemplateForm')">
                    <div class="modal-header">
                        <div>
                            <span class="badge bg-purple-soft text-purple border border-purple mb-1">
                                <i class="bi bi-pencil-fill me-1"></i>UPDATE BLUEPRINT
                            </span>
                            <h5 class="modal-title fw-bold mb-0" style="color:var(--txt);">Edit Report Template</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Template Name</label>
                            <input type="text" name="templateName" id="editTemplateName" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Default Frequency</label>
                            <select name="frequency" id="editTemplateFrequency" class="form-select">
                                <option value="Weekly">Weekly</option>
                                <option value="Daily">Daily</option>
                                <option value="Monthly">Monthly</option>
                            </select>
                        </div>
                        <div class="mb-2">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <label class="form-label fw-bold small text-uppercase mb-0" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">
                                    Include Department Modules:
                                </label>
                                <div class="d-flex gap-2">
                                    <button type="button" class="btn btn-sm btn-link p-0 text-decoration-none" style="font-size:0.75rem;" onclick="toggleTplModalCheckboxes('edit', true)">All</button>
                                    <span class="text-muted" style="font-size:0.75rem;">|</span>
                                    <button type="button" class="btn btn-sm btn-link p-0 text-decoration-none" style="font-size:0.75rem;" onclick="toggleTplModalCheckboxes('edit', false)">Clear</button>
                                </div>
                            </div>

                            <div class="d-flex flex-column gap-2 p-3 rounded-3 border" style="background:var(--table-head); border-color:var(--border) !important;">
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Inventory" id="edit-chk-inventory" class="form-check-input edit-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-boxes text-primary fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Warehouse Inventory</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">Stock quantities, valuations, depot reorder alerts</small>
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Supplier" id="edit-chk-supplier" class="form-check-input edit-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-truck text-success fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Supplier Network</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">OEM vendor contracts &amp; procurement status</small>
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Spare Parts" id="edit-chk-spareparts" class="form-check-input edit-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-shield-check text-purple fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Spare Parts QA &amp; Inspection</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">Delivery inspection pass rates &amp; defect tracking</small>
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Sales" id="edit-chk-sales" class="form-check-input edit-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-graph-up-arrow text-info fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Sales &amp; Commercial Orders</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">Customer turnover, revenue metrics &amp; top parts</small>
                                    </div>
                                </label>
                                <label class="d-flex align-items-center gap-2 p-2 rounded-2 border cursor-pointer" style="background:var(--card) !important; border-color:var(--border) !important;">
                                    <input type="checkbox" name="selectedModules" value="Customer Portal" id="edit-chk-customer" class="form-check-input edit-tpl-chk m-0" style="cursor:pointer;">
                                    <i class="bi bi-people-fill text-warning fs-5 ms-1"></i>
                                    <div>
                                        <span class="fw-bold d-block" style="font-size:0.88rem; color:var(--txt);">Customer Portal &amp; Accounts</span>
                                        <small class="text-muted d-block" style="font-size:0.72rem;">Registered buyer directories &amp; shopper profiles</small>
                                    </div>
                                </label>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-outline-clean" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-purple">
                            <i class="bi bi-check2-circle me-1"></i> Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL: CREATE SCHEDULE -->
    <div class="modal fade" id="createScheduleModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form action="/reports/schedules/create" method="post">
                    <div class="modal-header">
                        <div>
                            <span class="badge bg-purple-soft text-purple border border-purple mb-1">
                                <i class="bi bi-clock-history me-1"></i>NEW AUTOMATED CADENCE
                            </span>
                            <h5 class="modal-title fw-bold mb-0" style="color:var(--txt);">Create Automated Delivery Schedule</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Select Report Blueprint Template</label>
                            <select name="templateId" class="form-select" required>
                                <c:forEach var="tpl" items="${templates}">
                                    <option value="${tpl.id}"><c:out value="${tpl.templateName}"/> (<c:out value="${tpl.frequency}"/>)</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Dispatch Frequency Cadence</label>
                            <select name="frequency" class="form-select">
                                <option value="Weekly" selected>Weekly (Every Monday Morning)</option>
                                <option value="Daily">Daily (Every Evening at 18:00)</option>
                                <option value="Monthly">Monthly (1st Day of Each Month)</option>
                            </select>
                        </div>
                        <div class="mb-0">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Target Recipient Email Address</label>
                            <input type="email" name="deliveryEmail" class="form-control"
                                   placeholder="executive.board@parttrack.com" required>
                            <small class="text-muted d-block mt-1">An official certified PDF operations report will be dispatched on the configured recurring schedule.</small>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-outline-clean" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-purple">
                            <i class="bi bi-broadcast me-1"></i> Activate Recurring Schedule
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL: EDIT SCHEDULE -->
    <div class="modal fade" id="editScheduleModal" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <form id="editScheduleForm" method="post">
                    <input type="hidden" name="templateId" id="editScheduleTemplateId">
                    <div class="modal-header">
                        <div>
                            <span class="badge bg-purple-soft text-purple border border-purple mb-1">
                                <i class="bi bi-pencil-fill me-1"></i>UPDATE CADENCE
                            </span>
                            <h5 class="modal-title fw-bold mb-0" style="color:var(--txt);">Edit Delivery Schedule</h5>
                        </div>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Report Blueprint Template</label>
                            <select id="editScheduleTemplateSelect" class="form-select" disabled>
                                <c:forEach var="tpl" items="${templates}">
                                    <option value="${tpl.id}"><c:out value="${tpl.templateName}"/> (<c:out value="${tpl.frequency}"/>)</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Dispatch Frequency Cadence</label>
                            <select name="frequency" id="editScheduleFrequency" class="form-select">
                                <option value="Weekly">Weekly (Every Monday Morning)</option>
                                <option value="Daily">Daily (Every Evening at 18:00)</option>
                                <option value="Monthly">Monthly (1st Day of Each Month)</option>
                            </select>
                        </div>
                        <div class="mb-0">
                            <label class="form-label fw-bold small text-uppercase" style="color:var(--txt2); font-size:0.75rem; letter-spacing:0.05em;">Target Recipient Email Address</label>
                            <input type="email" name="deliveryEmail" id="editScheduleDeliveryEmail" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn-outline-clean" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn-purple">
                            <i class="bi bi-check2-circle me-1"></i> Update Schedule
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- MODAL: ACCOUNT & PROFILE EDIT -->
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
                        <input type="hidden" name="redirectUrl" value="/reports/templates">
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary">Full Name</label>
                            <input type="text" name="fullName" class="form-control"
                                   value="<c:out value='${not empty sessionScope.fullName ? sessionScope.fullName : sessionScope.currentUser}'/>"
                                   placeholder="Your full name" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label small fw-bold text-secondary">Email Address</label>
                            <input type="email" name="email" class="form-control"
                                   value="<c:out value='${not empty sessionScope.email ? sessionScope.email : \"admin@parttrack.com\"}'/>"
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
        /* Dark Mode Toggle */
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

        /* Template Edit Modal */
        function openTemplateEdit(id, name, filters, freq) {
            document.getElementById('editTemplateForm').action = '/reports/templates/update/' + id;
            document.getElementById('editTemplateName').value = name;
            var sel = document.getElementById('editTemplateFrequency');
            for (var i = 0; i < sel.options.length; i++) {
                if (sel.options[i].value === freq) { sel.selectedIndex = i; break; }
            }
            var f = (filters || '').toLowerCase();
            document.getElementById('edit-chk-inventory').checked = f.indexOf('inventory') !== -1;
            document.getElementById('edit-chk-supplier').checked = f.indexOf('supplier') !== -1;
            document.getElementById('edit-chk-spareparts').checked = f.indexOf('spare') !== -1 || f.indexOf('procurement') !== -1;
            document.getElementById('edit-chk-sales').checked = f.indexOf('sales') !== -1 || f.indexOf('order') !== -1;
            document.getElementById('edit-chk-customer').checked = f.indexOf('customer') !== -1 || f.indexOf('user') !== -1;
            new bootstrap.Modal(document.getElementById('editTemplateModal')).show();
        }

        /* Toggle All Checkboxes in Template Modals */
        function toggleTplModalCheckboxes(type, selectAll) {
            var className = type === 'create' ? '.create-tpl-chk' : '.edit-tpl-chk';
            var checkboxes = document.querySelectorAll(className);
            checkboxes.forEach(function(chk) {
                chk.checked = selectAll;
            });
        }

        /* Validate Template Form */
        function validateTemplateForm(formId) {
            var form = document.getElementById(formId);
            var chks = form.querySelectorAll('input[name="selectedModules"]:checked');
            if (chks.length === 0) {
                alert('Please select at least one department module (Inventory, Supplier, Spare Parts, Sales, or Customer).');
                return false;
            }
            return true;
        }

        /* Schedule Edit Modal */
        function openScheduleEdit(id, templateId, frequency, email) {
            document.getElementById('editScheduleForm').action = '/reports/schedules/update/' + id;
            var tplSel = document.getElementById('editScheduleTemplateSelect');
            for (var i = 0; i < tplSel.options.length; i++) {
                if (parseInt(tplSel.options[i].value) === templateId) {
                    tplSel.selectedIndex = i;
                    break;
                }
            }
            document.getElementById('editScheduleTemplateId').value = templateId;
            var freqSel = document.getElementById('editScheduleFrequency');
            for (var j = 0; j < freqSel.options.length; j++) {
                if (freqSel.options[j].value === frequency) { freqSel.selectedIndex = j; break; }
            }
            document.getElementById('editScheduleDeliveryEmail').value = email;
            new bootstrap.Modal(document.getElementById('editScheduleModal')).show();
        }

        /* Event Listener Wiring */
        document.addEventListener('DOMContentLoaded', function() {
            document.querySelectorAll('.edit-template-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    openTemplateEdit(this.dataset.id, this.dataset.name, this.dataset.filters, this.dataset.frequency);
                });
            });
            document.querySelectorAll('.edit-schedule-btn').forEach(function(btn) {
                btn.addEventListener('click', function() {
                    openScheduleEdit(this.dataset.id, parseInt(this.dataset.templateId) || null, this.dataset.frequency, this.dataset.email);
                });
            });
        });

        /* Open Account Modal */
        function openAccountModal() {
            new bootstrap.Modal(document.getElementById('accountModal')).show();
        }
    </script>
</body>
</html>
