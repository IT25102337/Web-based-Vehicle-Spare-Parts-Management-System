<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Main Portal | PartTrack Enterprise System</title>
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
            color: #0f172a;
            min-height: 100vh;
        }

        /* Top Navigation Bar */
        .navbar-custom {
            background-color: #ffffff;
            border-bottom: 1px solid #e2e8f0;
        }

        /* Box Type Card Container */
        .box-card {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
            transition: transform 0.15s ease, box-shadow 0.15s ease, border-color 0.15s ease;
        }

        .box-card-hover:hover {
            border-color: #cbd5e1;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.06);
        }

        .box-header {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid #e2e8f0;
            background-color: #ffffff;
            border-radius: 8px 8px 0 0;
        }

        /* Metric Mini Box */
        .mini-stat {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 0.85rem 1rem;
        }

        .sku-code {
            font-family: 'JetBrains Mono', monospace;
            font-size: 0.85rem;
        }

        .integration-step {
            background: #ffffff;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1.25rem;
            position: relative;
        }

        .step-number {
            width: 28px;
            height: 28px;
            background: #0f172a;
            color: #ffffff;
            border-radius: 50%;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
            font-weight: 700;
        }
    </style>
</head>
<body>

    <!-- ========================================== -->
    <!-- 1. TOP GLOBAL NAVIGATION                   -->
    <!-- ========================================== -->
    <nav class="navbar navbar-expand-lg navbar-custom sticky-top py-2 mb-4">
        <div class="container-xl">
            <!-- Brand -->
            <a class="navbar-brand fw-bold text-dark d-flex align-items-center gap-2" href="/">
                <span class="p-2 bg-primary text-white rounded"><i class="bi bi-diagram-3-fill"></i></span>
                <span>PartTrack Enterprise</span>
                <span class="badge bg-light text-secondary border fw-normal" style="font-size: 0.75rem;">Central Hub</span>
            </a>

            <!-- Quick Jump Buttons in Nav -->
            <div class="ms-auto d-flex align-items-center gap-2">
                <a href="/spareparts" class="btn btn-outline-secondary btn-sm rounded px-3">
                    <i class="bi bi-patch-check text-primary me-1"></i> Spare Part Module
                </a>
                <a href="/inventory/dashboard" class="btn btn-primary btn-sm rounded px-3">
                    <i class="bi bi-box-seam me-1"></i> Inventory Module
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Container -->
    <div class="container-xl pb-5">

        <!-- Welcome Banner Box -->
        <div class="box-card p-4 mb-4">
            <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
                <div>
                    <div class="d-flex align-items-center gap-2 mb-1">
                        <span class="badge bg-primary text-white">Academic Project Architecture</span>
                        <span class="badge bg-light text-secondary border">Two Independent Sub-Systems</span>
                    </div>
                    <h3 class="fw-bold text-dark mb-1">Executive Management Portal</h3>
                    <p class="text-secondary small mb-0">
                        Select a sub-system to manage. Both systems operate independently with separated controllers and interfaces, interconnected one-to-one via database verification.
                    </p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2">
                        <i class="bi bi-circle-fill me-1" style="font-size: 0.5rem;"></i> System Status: Online
                    </span>
                </div>
            </div>
        </div>

        <!-- ======================================================== -->
        <!-- 2 MAIN CARDS: THE TWO SEPARATE MODULES                   -->
        <!-- ======================================================== -->
        <div class="row g-4 mb-4">

            <!-- ============================================== -->
            <!-- MODULE 1: SPARE PART & QUALITY MANAGEMENT      -->
            <!-- (Friend's Module)                              -->
            <!-- ============================================== -->
            <div class="col-lg-6">
                <div class="box-card box-card-hover h-100 d-flex flex-column">
                    <!-- Card Header -->
                    <div class="box-header d-flex justify-content-between align-items-start">
                        <div>
                            <span class="badge bg-info-subtle text-info-emphasis border border-info-subtle mb-2">
                                <i class="bi bi-people-fill me-1"></i> Friend's Module
                            </span>
                            <h4 class="fw-bold text-dark mb-1">Spare Part & Quality Management</h4>
                            <p class="text-secondary small mb-0">Supplier Deliveries, QA Inspections & Defect Handling</p>
                        </div>
                        <div class="p-3 bg-light rounded border text-primary fs-3">
                            <i class="bi bi-patch-check-fill"></i>
                        </div>
                    </div>

                    <!-- Card Body -->
                    <div class="p-4 flex-grow-1 d-flex flex-column justify-content-between">
                        <!-- Brief description -->
                        <p class="text-muted small mb-3">
                            Responsible for receiving spare parts shipments from external vendors, conducting physical quality inspections (Good/Bad condition), approving verified batches, and flagging defective parts for supplier return.
                        </p>

                        <!-- Live Mini Metrics -->
                        <div class="row g-2 mb-4">
                            <div class="col-6">
                                <div class="mini-stat">
                                    <div class="text-secondary small fw-medium">Total Shipments</div>
                                    <div class="fs-4 fw-bold text-dark mt-1">${totalBatches} <span class="text-muted small fw-normal">batches</span></div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="mini-stat">
                                    <div class="text-secondary small fw-medium">Pending QA Check</div>
                                    <div class="fs-4 fw-bold ${pendingInspectionCount > 0 ? 'text-warning-emphasis' : 'text-dark'} mt-1">
                                        ${pendingInspectionCount}
                                        <c:if test="${pendingInspectionCount > 0}">
                                            <span class="badge bg-warning text-dark rounded-pill ms-1" style="font-size: 0.65rem;">Action Needed</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="mini-stat">
                                    <div class="text-secondary small fw-medium">Approved (Good Quality)</div>
                                    <div class="fs-4 fw-bold text-success mt-1">${approvedBatchCount} <span class="text-muted small fw-normal">ready</span></div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="mini-stat">
                                    <div class="text-secondary small fw-medium">Rejected / Defective</div>
                                    <div class="fs-4 fw-bold text-danger mt-1">${rejectedBatchCount} <span class="text-muted small fw-normal">supplier notified</span></div>
                                </div>
                            </div>
                        </div>

                        <!-- Technical Specs for Viva -->
                        <div class="bg-light p-3 rounded border mb-4 small text-secondary">
                            <div class="fw-semibold text-dark mb-1"><i class="bi bi-code-slash me-1"></i> Architecture Highlights:</div>
                            <ul class="mb-0 ps-3">
                                <li><strong>Controller:</strong> <code>ProductProcurementController.java</code></li>
                                <li><strong>Model & Table:</strong> <code>SupplierProduct.java</code> &rarr; <code>supplier_products</code></li>
                                <li><strong>QA Logic:</strong> Status transitions <code>PENDING &rarr; APPROVED / REJECTED</code></li>
                            </ul>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2 mt-auto">
                            <a href="/spareparts" class="btn btn-primary rounded px-3 py-2 fw-medium flex-grow-1 text-center">
                                Open Quality Dashboard <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                            <a href="/procurement" class="btn btn-outline-secondary rounded px-3 py-2 fw-medium">
                                <i class="bi bi-card-checklist me-1"></i> Inspection Board
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ============================================== -->
            <!-- MODULE 2: WAREHOUSE INVENTORY & STOCK          -->
            <!-- (Your Module)                                  -->
            <!-- ============================================== -->
            <div class="col-lg-6">
                <div class="box-card box-card-hover h-100 d-flex flex-column">
                    <!-- Card Header -->
                    <div class="box-header d-flex justify-content-between align-items-start">
                        <div>
                            <span class="badge bg-primary-subtle text-primary border border-primary-subtle mb-2">
                                <i class="bi bi-person-check-fill me-1"></i> Your Module
                            </span>
                            <h4 class="fw-bold text-dark mb-1">Warehouse Inventory & Stock</h4>
                            <p class="text-secondary small mb-0">Stock Repository, Depot Capacity, Reorder Alerts & Intake</p>
                        </div>
                        <div class="p-3 bg-light rounded border text-primary fs-3">
                            <i class="bi bi-boxes"></i>
                        </div>
                    </div>

                    <!-- Card Body -->
                    <div class="p-4 flex-grow-1 d-flex flex-column justify-content-between">
                        <!-- Brief description -->
                        <p class="text-muted small mb-3">
                            Manages warehouse shelf stock, monitors depot physical storage limit (500 units max), triggers safety reorder alerts with red-dot marks, and conducts intake of QA-approved parts from Module 1.
                        </p>

                        <!-- Live Mini Metrics -->
                        <div class="row g-2 mb-4">
                            <div class="col-6">
                                <div class="mini-stat">
                                    <div class="text-secondary small fw-medium">Catalog Part Models</div>
                                    <div class="fs-4 fw-bold text-dark mt-1">${totalInventoryItems} <span class="text-muted small fw-normal">SKUs</span></div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="mini-stat">
                                    <div class="text-secondary small fw-medium">Current Stock in Depot</div>
                                    <div class="fs-4 fw-bold text-dark mt-1">${totalPhysicalStock} <span class="text-muted small fw-normal">units</span></div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="mini-stat">
                                    <div class="text-secondary small fw-medium">Depot Storage Used</div>
                                    <div class="fs-4 fw-bold text-dark mt-1">
                                        ${capacityUtilizationPct}%
                                        <span class="text-muted small fw-normal">(${availableWarehouseSpace} free)</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-6">
                                <div class="mini-stat">
                                    <div class="text-secondary small fw-medium">Low Stock Alerts</div>
                                    <div class="fs-4 fw-bold ${lowStockCount > 0 ? 'text-danger' : 'text-success'} mt-1">
                                        ${lowStockCount}
                                        <c:if test="${lowStockCount > 0}">
                                            <span class="badge bg-danger rounded-pill ms-1" style="font-size: 0.65rem;">Restock</span>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Technical Specs for Viva -->
                        <div class="bg-light p-3 rounded border mb-4 small text-secondary">
                            <div class="fw-semibold text-dark mb-1"><i class="bi bi-code-slash me-1"></i> Architecture Highlights:</div>
                            <ul class="mb-0 ps-3">
                                <li><strong>Controller:</strong> <code>InventoryController.java</code></li>
                                <li><strong>Model & Table:</strong> <code>InventoryItem.java</code> &rarr; <code>inventory</code></li>
                                <li><strong>Business Rules:</strong> 500-unit capacity guard, reorder safety threshold, intake validator</li>
                            </ul>
                        </div>

                        <!-- Action Buttons -->
                        <div class="d-flex gap-2 mt-auto">
                            <a href="/inventory/dashboard" class="btn btn-primary rounded px-3 py-2 fw-medium flex-grow-1 text-center">
                                Open Inventory Dashboard <i class="bi bi-arrow-right ms-1"></i>
                            </a>
                            <a href="/inventory" class="btn btn-outline-secondary rounded px-3 py-2 fw-medium">
                                <i class="bi bi-table me-1"></i> Stock Repository
                            </a>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- ======================================================== -->
        <!-- 3. ONE-TO-ONE INTEGRATION ARCHITECTURE BANNER (FOR MARKS)-->
        <!-- ======================================================== -->
        <div class="box-card p-4">
            <div class="d-flex align-items-center justify-content-between mb-3">
                <div>
                    <h5 class="fw-bold text-dark mb-1"><i class="bi bi-arrow-left-right text-primary me-2"></i>One-to-One Internal System Integration</h5>
                    <p class="text-secondary small mb-0">How the two independent modules interact across database boundaries while preserving code isolation.</p>
                </div>
                <span class="badge bg-light text-dark border px-3 py-2">Viva Presentation Model</span>
            </div>

            <div class="row g-3">
                <div class="col-md-3">
                    <div class="integration-step h-100">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="step-number">1</span>
                            <span class="fw-bold small text-dark">Supplier Shipment</span>
                        </div>
                        <p class="text-muted small mb-0">
                            Vendor delivers spare parts. Friend records batch in <code>supplier_products</code> with initial status <code>PENDING</code>.
                        </p>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="integration-step h-100">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="step-number">2</span>
                            <span class="fw-bold small text-dark">Quality Inspection</span>
                        </div>
                        <p class="text-muted small mb-0">
                            Friend verifies physical quality. Good condition becomes <code>APPROVED</code>; defective items are <code>REJECTED</code>.
                        </p>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="integration-step h-100">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="step-number">3</span>
                            <span class="fw-bold small text-dark">Warehouse Check</span>
                        </div>
                        <p class="text-muted small mb-0">
                            Your module verifies storage space against <code>MAX_WAREHOUSE_CAPACITY (1000)</code> before allowing batch intake (4 Racks &times; 250 units).
                        </p>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="integration-step h-100">
                        <div class="d-flex align-items-center gap-2 mb-2">
                            <span class="step-number">4</span>
                            <span class="fw-bold small text-dark">Intake & Deduct</span>
                        </div>
                        <p class="text-muted small mb-0">
                            Parts added to <code>inventory</code> with retail price, deducting taken quantity from friend's batch in 1 transaction.
                        </p>
                    </div>
                </div>
            </div>
        </div>

    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
