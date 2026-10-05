<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | PartTrack</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@500&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f8fafc;
            color: #1e293b;
            min-height: 100vh;
        }

        /* Top Navigation Bar */
        .navbar-custom {
            background-color: #ffffff;
            border-bottom: 1px solid #e2e8f0;
        }

        .nav-link {
            color: #64748b;
            font-weight: 500;
            padding: 0.5rem 1rem;
            border-radius: 6px;
            transition: all 0.15s ease-in-out;
        }

        .nav-link:hover {
            color: #0f172a;
            background-color: #f1f5f9;
        }

        .nav-link.active {
            color: #2563eb;
            background-color: #eff6ff;
            font-weight: 600;
        }

        /* Box Type Card Container */
        .box-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .box-header {
            padding: 1rem 1.25rem;
            border-bottom: 1px solid #e2e8f0;
            background-color: #ffffff;
            border-radius: 8px 8px 0 0;
        }

        /* Metric Stat Box */
        .stat-box {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1.25rem;
            height: 100%;
            transition: border-color 0.15s ease;
        }

        .stat-box:hover {
            border-color: #cbd5e1;
        }

        .stat-icon {
            width: 42px;
            height: 42px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }

        /* Clean Table */
        .table {
            margin-bottom: 0;
            color: #1e293b;
        }

        .table thead th {
            background-color: #f8fafc;
            color: #475569;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            font-weight: 600;
            padding: 0.85rem 1.25rem;
            border-bottom: 1px solid #e2e8f0;
        }

        .table tbody td {
            padding: 0.9rem 1.25rem;
            vertical-align: middle;
            border-bottom: 1px solid #f1f5f9;
        }

        .table tbody tr:hover td {
            background-color: #f8fafc;
        }

        .sku-code {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.85rem;
            font-weight: 600;
            color: #0f172a;
            background: #f1f5f9;
            padding: 0.2rem 0.5rem;
            border-radius: 4px;
            border: 1px solid #e2e8f0;
        }
    </style>
</head>
<body>

    <!-- ========================================== -->
    <!-- 1. NAVIGATION BAR                          -->
    <!-- ========================================== -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top py-2 mb-4">
        <div class="container-xl">
            <!-- Brand -->
            <a class="navbar-brand fw-bold text-dark d-flex align-items-center gap-2" href="/">
                <span class="p-2 bg-primary text-white rounded"><i class="bi bi-box-seam"></i></span>
                <span>PartTrack</span>
                <span class="badge bg-light text-secondary border fw-normal" style="font-size: 0.75rem;">Inventory System</span>
            </a>

            <!-- Navigation Links -->
            <div class="collapse navbar-collapse show" id="navbarNav">
                <ul class="navbar-nav ms-auto gap-1">
                    <li class="nav-item">
                        <a class="nav-link active" href="/"><i class="bi bi-speedometer2 me-1"></i> Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/inventory"><i class="bi bi-table me-1"></i> Stock Repository</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/reorder">
                            <i class="bi bi-bell me-1"></i> Reorder Alerts
                            <c:if test="${lowStockCount > 0}">
                                <span class="badge bg-danger rounded-pill ms-1">${lowStockCount}</span>
                            </c:if>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/procurement">
                            <i class="bi bi-patch-check me-1"></i> Supplier Quality
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content Area -->
    <div class="container-xl pb-5">

        <!-- Header Box -->
        <div class="box-card p-4 mb-4 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
            <div>
                <h4 class="fw-bold mb-1 text-dark">Spare Parts Overview</h4>
                <p class="text-secondary small mb-0">Summary of inventory status, safety thresholds, and valuation.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="/inventory" class="btn btn-primary btn-sm rounded px-3 py-2 fw-medium">
                    <i class="bi bi-arrow-right-circle me-1"></i> View All Parts
                </a>
                <a href="/reorder" class="btn btn-outline-secondary btn-sm rounded px-3 py-2 fw-medium">
                    <i class="bi bi-bell me-1"></i> Reorder Items (${lowStockCount})
                </a>
            </div>
        </div>

        <!-- 4 Stat Metric Boxes -->
        <div class="row g-3 mb-4">
            <!-- Box 1: Total Models -->
            <div class="col-sm-6 col-lg-3">
                <div class="stat-box">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary small fw-semibold text-uppercase">Part Models</span>
                        <div class="stat-icon bg-light text-primary border">
                            <i class="bi bi-box"></i>
                        </div>
                    </div>
                    <div class="fs-3 fw-bold text-dark">${totalItems}</div>
                    <div class="text-muted small mt-1">Unique catalog entries</div>
                </div>
            </div>

            <!-- Box 2: Total Units In Stock -->
            <div class="col-sm-6 col-lg-3">
                <div class="stat-box">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary small fw-semibold text-uppercase">Total Quantity</span>
                        <div class="stat-icon bg-light text-info border">
                            <i class="bi bi-layers"></i>
                        </div>
                    </div>
                    <div class="fs-3 fw-bold text-dark">${totalStock}</div>
                    <div class="text-muted small mt-1">Total physical stock in depot</div>
                </div>
            </div>

            <!-- Box 3: Low Stock Alerts -->
            <div class="col-sm-6 col-lg-3">
                <div class="stat-box">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary small fw-semibold text-uppercase">Reorder Alerts</span>
                        <div class="stat-icon ${lowStockCount > 0 ? 'bg-danger-subtle text-danger' : 'bg-success-subtle text-success'} border">
                            <i class="bi bi-exclamation-circle"></i>
                        </div>
                    </div>
                    <div class="fs-3 fw-bold ${lowStockCount > 0 ? 'text-danger' : 'text-success'}">${lowStockCount}</div>
                    <div class="small mt-1 ${lowStockCount > 0 ? 'text-danger' : 'text-muted'}">
                        <c:choose>
                            <c:when test="${lowStockCount > 0}">Items need replenishment</c:when>
                            <c:otherwise>Stock levels normal</c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>

            <!-- Box 4: Total Inventory Valuation -->
            <div class="col-sm-6 col-lg-3">
                <div class="stat-box">
                    <div class="d-flex align-items-center justify-content-between mb-2">
                        <span class="text-secondary small fw-semibold text-uppercase">Total Value</span>
                        <div class="stat-icon bg-light text-success border">
                            <i class="bi bi-currency-dollar"></i>
                        </div>
                    </div>
                    <div class="fs-3 fw-bold text-dark">
                        Rs. <fmt:formatNumber value="${totalValue}" pattern="#,##0.00"/>
                    </div>
                    <div class="text-muted small mt-1">Total inventory net worth</div>
                </div>
            </div>
        </div>

        <!-- Low Stock Attention Box -->
        <div class="box-card">
            <div class="box-header d-flex justify-content-between align-items-center">
                <div>
                    <h6 class="fw-bold mb-0 text-dark">
                        <i class="bi bi-exclamation-triangle text-warning me-1"></i> Low Stock Warning List
                    </h6>
                    <small class="text-muted">Spare parts currently at or below the reorder safety limit.</small>
                </div>
                <a href="/reorder" class="btn btn-sm btn-outline-primary rounded px-3">
                    Open Reorder Center <i class="bi bi-arrow-right"></i>
                </a>
            </div>

            <div class="table-responsive">
                <table class="table align-middle">
                    <thead>
                        <tr>
                            <th>Part ID</th>
                            <th>Part Name</th>
                            <th class="text-center">Current Quantity</th>
                            <th class="text-center">Reorder Level</th>
                            <th class="text-end">Unit Price</th>
                            <th class="text-center">Status</th>
                            <th class="text-center">Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:choose>
                            <c:when test="${empty criticalItems}">
                                <tr>
                                    <td colspan="7" class="text-center py-4 text-muted">
                                        <i class="bi bi-check2-circle text-success fs-2 d-block mb-1"></i>
                                        <span class="small">All stock levels are sufficient. No parts require urgent reorder.</span>
                                    </td>
                                </tr>
                            </c:when>
                            <c:otherwise>
                                <c:forEach var="item" items="${criticalItems}">
                                    <tr>
                                        <td><span class="sku-code">${item.partId}</span></td>
                                        <td class="fw-medium text-dark">${item.partName}</td>
                                        <td class="text-center">
                                            <span class="badge ${item.quantity == 0 ? 'bg-danger' : 'bg-warning text-dark'} px-2 py-1">
                                                ${item.quantity} Units
                                            </span>
                                        </td>
                                        <td class="text-center text-muted small">${item.reorderLevel} Units</td>
                                        <td class="text-end font-monospace text-dark">
                                            Rs. <fmt:formatNumber value="${item.unitPrice}" pattern="#,##0.00"/>
                                        </td>
                                        <td class="text-center">
                                            <c:choose>
                                                <c:when test="${item.quantity == 0}">
                                                    <span class="badge bg-danger-subtle text-danger border border-danger-subtle">Out of Stock</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-warning-subtle text-warning-emphasis border border-warning-subtle">Low Stock</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td class="text-center">
                                            <a href="/reorder" class="btn btn-sm btn-outline-success rounded px-2 py-1">
                                                + Restock
                                            </a>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
