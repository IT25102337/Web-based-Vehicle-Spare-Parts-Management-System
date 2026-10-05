package com.sparepartmanagementsystem.reportmanager;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * OOP CONCEPT: Service Layer
 * UML RELATIONSHIP: Association (DashboardService associates with ReportManagerRepository)
 * Coordinates executive analytics, cross-department reporting, template authoring, and automated delivery schedules.
 */
@Service
public class DashboardService {

    // UML RELATIONSHIP: Association
    @Autowired
    private ReportManagerRepository reportManagerRepository;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // Initializes database schemas and seed data on startup
    @PostConstruct
    public void init() {
        reportManagerRepository.initSchema();
    }

    // Retrieves consolidated live system metrics from inventory, sales, and procurement
    public DashboardSummary retrieveDashboardData() {
        return reportManagerRepository.retrieveSummaryMetrics();
    }

    // Persists a newly created report template with current timestamp
    public void saveTemplate(ReportTemplate template) {
        String created = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        reportManagerRepository.insertTemplate(template, created);
    }

    // Updates template attributes for the specified ID
    public void updateTemplate(Long id, ReportTemplate updatedTemplate) {
        reportManagerRepository.updateTemplate(id, updatedTemplate);
    }

    // Removes a report template and any associated schedules
    public void deleteTemplate(Long id) {
        reportManagerRepository.deleteTemplate(id);
    }

    // Retrieves all configured report templates
    public List<ReportTemplate> getAllTemplates() {
        return reportManagerRepository.findAllTemplates();
    }

    // Retrieves a single report template by ID
    public Optional<ReportTemplate> getTemplateById(Long id) {
        return reportManagerRepository.findTemplateById(id);
    }

    // Checks if the given template name is already in use
    public boolean isTemplateNameTaken(String name) {
        return reportManagerRepository.isTemplateNameTaken(name);
    }

    // Checks if another template already uses the given name
    public boolean isTemplateNameTakenByOther(String name, Long excludeId) {
        return reportManagerRepository.isTemplateNameTakenByOther(name, excludeId);
    }

    // Persists a new automated report delivery schedule
    public void saveSchedule(ReportSchedule schedule) {
        reportManagerRepository.insertSchedule(schedule);
    }

    // Updates an existing automated delivery schedule
    public void updateSchedule(Long id, ReportSchedule updatedSchedule) {
        reportManagerRepository.updateSchedule(id, updatedSchedule);
    }

    // Cancels and deletes an automated delivery schedule
    public void cancelSchedule(Long id) {
        reportManagerRepository.deleteSchedule(id);
    }

    // Retrieves all automated delivery schedules
    public List<ReportSchedule> getAllSchedules() {
        return reportManagerRepository.findAllSchedules();
    }

    // Persists an official certified business audit report
    public void saveInventoryReport(InventoryReport report) {
        String generated = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        reportManagerRepository.insertInventoryReport(report, generated);
    }

    // Retrieves all submitted audit reports in reverse chronological order
    public List<InventoryReport> getAllInventoryReports() {
        return reportManagerRepository.findAllInventoryReports();
    }

    // Retrieves an individual official report record by ID
    public Optional<InventoryReport> getInventoryReportById(Long reportId) {
        return reportManagerRepository.findInventoryReportById(reportId);
    }

    // Updates approval status and executive review notes for an audit report
    public void updateReportReview(Long reportId, String status, String notes) {
        reportManagerRepository.updateReportReview(reportId, status, notes);
    }

    // Deletes an audit report from the system archive
    public void deleteInventoryReport(Long reportId) {
        reportManagerRepository.deleteInventoryReport(reportId);
    }

    // Compiles a comprehensive multi-department combined report and persists it
    public InventoryReport generateCombinedReport(String reportTitle, List<String> selectedModules, String fromDate, String toDate, String frequency, String author) {
        if (selectedModules == null || selectedModules.isEmpty()) {
            selectedModules = Arrays.asList("inventory", "supplier", "spareparts", "sales", "customer");
        }

        LocalDate now = LocalDate.now();
        String startDate = (fromDate != null && !fromDate.isBlank()) ? fromDate.trim() : now.minusDays(7).format(DATE_FORMATTER);
        String endDate = (toDate != null && !toDate.isBlank()) ? toDate.trim() : now.format(DATE_FORMATTER);
        String reportFreq = (frequency != null && !frequency.isBlank()) ? frequency.trim() : "On-Demand";
        String submitter = (author != null && !author.isBlank()) ? author.trim() : "Executive Administrator";
        String title = (reportTitle != null && !reportTitle.isBlank()) ? reportTitle.trim() : "Executive Cross-Functional Operations Audit";

        StringBuilder sb = new StringBuilder();
        sb.append("========================================================================\n");
        sb.append(" PARTTRACK EXECUTIVE BUSINESS INTELLIGENCE SYSTEM\n");
        sb.append(" OFFICIAL CROSS-FUNCTIONAL MANAGEMENT AUDIT REPORT\n");
        sb.append("========================================================================\n\n");

        sb.append(String.format("Report Title: %s\n", title));
        sb.append(String.format("Auditing Timeframe: %s to %s\n", startDate, endDate));
        sb.append(String.format("Frequency: %s\n", reportFreq));
        sb.append(String.format("Generated By: %s\n", submitter));
        sb.append(String.format("Generated Timestamp: %s\n", LocalDateTime.now().format(DATE_TIME_FORMATTER)));
        sb.append(String.format("Included Modules: %s\n\n", String.join(", ", selectedModules).toUpperCase()));

        // 1. INVENTORY MODULE
        if (selectedModules.contains("inventory")) {
            Map<String, Object> inv = reportManagerRepository.fetchInventoryDepartmentData();
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 1: WAREHOUSE INVENTORY & STOCK REPOSITORY]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Registered Unique Spare Part SKUs: %d parts\n", inv.get("totalParts")));
            sb.append(String.format("• Total Physical Stock on Hand: %d units\n", inv.get("totalUnits")));
            sb.append(String.format("• Total Inventory Asset Valuation: Rs. %,.2f\n", (Double) inv.get("totalValue")));
            sb.append(String.format("• Low Stock Reorder Alerts: %d parts requiring replenishment\n", inv.get("lowStockCount")));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> lowStockList = (List<Map<String, Object>>) inv.get("lowStockList");
            if (lowStockList != null && !lowStockList.isEmpty()) {
                sb.append("• Priority Restock Checklist:\n");
                for (Map<String, Object> itm : lowStockList) {
                    sb.append(String.format("   - [%s] %s | Qty: %d (Reorder Level: %d) | Shelf: %s | Price: Rs. %,.2f\n",
                            itm.get("part_id"), itm.get("part_name"), itm.get("quantity"), itm.get("reorder_level"),
                            itm.get("storage_location"), ((Number) itm.get("unit_price")).doubleValue()));
                }
            } else {
                sb.append("• All warehouse parts currently exceed minimum safety thresholds.\n");
            }
            sb.append("\n");
        }

        // 2. SUPPLIER MODULE
        if (selectedModules.contains("supplier")) {
            Map<String, Object> sup = reportManagerRepository.fetchSupplierDepartmentData();
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 2: AUTOMOTIVE SUPPLIER PARTNER NETWORK]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Total Authorized OEM Suppliers: %d vendors\n", sup.get("totalSuppliers")));
            sb.append(String.format("• Active Procurement Partners: %d suppliers\n", sup.get("activeSuppliers")));
            sb.append(String.format("• Purchase Requests Transmitted: %d total orders\n", sup.get("totalOrders")));
            sb.append(String.format("• Shipments Dispatched by Suppliers: %d batches\n", sup.get("dispatchedOrders")));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> supplierList = (List<Map<String, Object>>) sup.get("supplierList");
            if (supplierList != null && !supplierList.isEmpty()) {
                sb.append("• Registered Supplier Directory Sample:\n");
                for (Map<String, Object> s : supplierList) {
                    sb.append(String.format("   - [#%s] %s | Contact: %s | Category: %s | Status: %s\n",
                            s.get("supplier_id"), s.get("supplier_name"), s.get("contact_person"), s.get("category"), s.get("status")));
                }
            }
            sb.append("\n");
        }

        // 3. SPARE PART MANAGER / PROCUREMENT QA MODULE
        if (selectedModules.contains("spareparts") || selectedModules.contains("procurement")) {
            Map<String, Object> qa = reportManagerRepository.fetchProcurementDepartmentData();
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 3: SPARE PART QUALITY CONTROL & INSPECTION GATE]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Total Incoming Delivery Batches: %d shipments\n", qa.get("totalBatches")));
            sb.append(String.format("• Approved for Warehouse Intake: %d batches\n", qa.get("approvedBatches")));
            sb.append(String.format("• Rejected Defective Shipments: %d batches\n", qa.get("rejectedBatches")));
            sb.append(String.format("• Batches Awaiting Quality Check: %d batches\n", qa.get("pendingBatches")));
            sb.append(String.format("• Quality Inspection Acceptance Rate: %d%%\n", qa.get("passRate")));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> recentBatches = (List<Map<String, Object>>) qa.get("recentBatches");
            if (recentBatches != null && !recentBatches.isEmpty()) {
                sb.append("• Recent Quality Inspections:\n");
                for (Map<String, Object> b : recentBatches) {
                    sb.append(String.format("   - Batch #%s | %s [%s] | Supplier: %s | Qty: %d | Status: %s\n",
                            b.get("batch_id"), b.get("part_name"), b.get("part_id"), b.get("supplier_name"),
                            b.get("received_qty"), b.get("quality_status")));
                }
            }
            sb.append("\n");
        }

        // 4. SALES MANAGER MODULE
        if (selectedModules.contains("sales") || selectedModules.contains("salesreport")) {
            Map<String, Object> sal = reportManagerRepository.fetchSalesDepartmentData();
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 4: COMMERCIAL SALES & REVENUE PERFORMANCE]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Total Customer Orders: %d orders\n", sal.get("totalOrders")));
            sb.append(String.format("• Completed & Reconciled Orders: %d orders\n", sal.get("completedOrders")));
            sb.append(String.format("• In-Flight Processing Orders: %d orders\n", sal.get("processingOrders")));
            sb.append(String.format("• Pending Customer Orders: %d orders\n", sal.get("pendingOrders")));
            sb.append(String.format("• Realized Cash Income: Rs. %,.2f\n", (Double) sal.get("completedRevenue")));
            sb.append(String.format("• Open Sales Pipeline Value: Rs. %,.2f\n", (Double) sal.get("pipelineRevenue")));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> topSelling = (List<Map<String, Object>>) sal.get("topSelling");
            if (topSelling != null && !topSelling.isEmpty()) {
                sb.append("• Top Demand Spare Parts:\n");
                for (Map<String, Object> p : topSelling) {
                    sb.append(String.format("   - %s [%s] | Sold: %d units | Commercial Total: Rs. %,.2f\n",
                            p.get("part_name"), p.get("part_id"), ((Number) p.get("total_qty")).intValue(),
                            ((Number) p.get("total_sales")).doubleValue()));
                }
            }
            sb.append("\n");
        }

        // 5. CUSTOMER PORTAL MODULE
        if (selectedModules.contains("customer") || selectedModules.contains("customerportal")) {
            Map<String, Object> cust = reportManagerRepository.fetchCustomerDepartmentData();
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 5: CUSTOMER PORTAL & SHOPPER ENGAGEMENT]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Registered Customer Accounts: %d shoppers\n", cust.get("totalCustomers")));
            sb.append(String.format("• Total Active Platform Users: %d users\n", cust.get("totalUsers")));

            @SuppressWarnings("unchecked")
            List<Map<String, Object>> customerList = (List<Map<String, Object>>) cust.get("customerList");
            if (customerList != null && !customerList.isEmpty()) {
                sb.append("• Recent Customer Accounts Sample:\n");
                for (Map<String, Object> c : customerList) {
                    sb.append(String.format("   - User #%s: %s (%s) | Email: %s | Registered: %s\n",
                            c.get("user_id"), c.get("username"), c.get("full_name"), c.get("email"), c.get("created_at")));
                }
            }
            sb.append("\n");
        }

        sb.append("========================================================================\n");
        sb.append(" EXECUTIVE AUDIT CERTIFICATION\n");
        sb.append(" Officially compiled, audited, and approved by PartTrack Executive Administration.\n");
        sb.append(" All underlying SQL transactional ledger records reconciled and verified.\n");
        sb.append("========================================================================\n");

        String genDate = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        String category = selectedModules.size() == 5 ? "Full 360° Operations Audit" : "Cross-Functional (" + String.join(", ", selectedModules) + ")";

        InventoryReport report = new InventoryReport();
        report.setReportTitle(title);
        report.setReportType(category);
        report.setFromDate(startDate);
        report.setToDate(endDate);
        report.setGeneratedBy("Executive Admin (" + submitter + ")");
        report.setGeneratedDate(genDate);
        report.setReportContent(sb.toString());
        report.setStatus("Approved (Executive Audit)");
        report.setNotes("Combined Multi-Department Report (" + String.join(", ", selectedModules) + ") - Frequency: " + reportFreq);

        Long reportId = reportManagerRepository.insertReportReturningId(report, genDate);
        report.setReportId(reportId);

        return report;
    }

    // Generates a complete report on the fly based on a saved template definition
    public InventoryReport generateReportFromTemplate(Long templateId) {
        Optional<ReportTemplate> tplOpt = reportManagerRepository.findTemplateById(templateId);
        if (tplOpt.isEmpty()) {
            throw new ReportManagerException("Report template #" + templateId + " not found.");
        }
        ReportTemplate tpl = tplOpt.get();

        String filters = tpl.getTemplateFilters() != null ? tpl.getTemplateFilters().toLowerCase() : "";
        List<String> modules = new ArrayList<>();
        if (filters.contains("inventory")) modules.add("inventory");
        if (filters.contains("supplier")) modules.add("supplier");
        if (filters.contains("spare") || filters.contains("procurement")) modules.add("spareparts");
        if (filters.contains("sales") || filters.contains("order")) modules.add("sales");
        if (filters.contains("customer") || filters.contains("user")) modules.add("customer");
        if (modules.isEmpty()) {
            modules = Arrays.asList("inventory", "supplier", "sales");
        }

        LocalDate now = LocalDate.now();
        String fromDate;
        String freq = tpl.getFrequency() != null ? tpl.getFrequency() : "Weekly";
        if ("Daily".equalsIgnoreCase(freq)) {
            fromDate = now.minusDays(1).format(DATE_FORMATTER);
        } else if ("Monthly".equalsIgnoreCase(freq)) {
            fromDate = now.minusDays(30).format(DATE_FORMATTER);
        } else {
            fromDate = now.minusDays(7).format(DATE_FORMATTER);
        }
        String toDate = now.format(DATE_FORMATTER);

        String title = tpl.getTemplateName() + " [" + freq + " Audit]";
        return generateCombinedReport(title, modules, fromDate, toDate, freq, "Template Engine");
    }

    // Retrieves live operational data for the Warehouse Inventory module
    public Map<String, Object> getInventoryDepartmentData() {
        return reportManagerRepository.fetchInventoryDepartmentData();
    }

    // Retrieves live operational data for the Supplier Partner Network module
    public Map<String, Object> getSupplierDepartmentData() {
        return reportManagerRepository.fetchSupplierDepartmentData();
    }

    // Retrieves live operational data for the Quality Control and Procurement module
    public Map<String, Object> getProcurementDepartmentData() {
        return reportManagerRepository.fetchProcurementDepartmentData();
    }

    // Retrieves live operational data for the Commercial Sales module
    public Map<String, Object> getSalesDepartmentData() {
        return reportManagerRepository.fetchSalesDepartmentData();
    }

    // Retrieves live operational data for the Customer Portal module
    public Map<String, Object> getCustomerDepartmentData() {
        return reportManagerRepository.fetchCustomerDepartmentData();
    }
}

