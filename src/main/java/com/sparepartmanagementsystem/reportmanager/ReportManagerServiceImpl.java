package com.sparepartmanagementsystem.reportmanager;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * OOP CONCEPTS: Interface Implementation (Service Layer) & Aggregation
 * UML RELATIONSHIP: Association (ReportManagerServiceImpl associates with ReportManagerRepository)
 * Coordinates executive business analytics, multi-department report compilation, template authoring, and automated delivery schedules.
 */
@Service
public class ReportManagerServiceImpl implements ReportManagerService {

    // UML RELATIONSHIP: Association (Injects repository persistence layer)
    @Autowired
    private ReportManagerRepository reportManagerRepository;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // Retrieves consolidated live system metrics from inventory, sales, and procurement
    @Override
    public DashboardSummary retrieveDashboardData() {
        return reportManagerRepository.retrieveSummaryMetrics();
    }

    // Persists a newly created report template with current timestamp
    @Override
    public void saveTemplate(ReportTemplate template) {
        String created = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        reportManagerRepository.insertTemplate(template, created);
    }

    // Updates template attributes for the specified ID
    @Override
    public void updateTemplate(Long id, ReportTemplate updatedTemplate) {
        reportManagerRepository.updateTemplate(id, updatedTemplate);
    }

    // Removes a report template and any associated delivery schedules
    @Override
    public void deleteTemplate(Long id) {
        reportManagerRepository.deleteTemplate(id);
    }

    // Retrieves all configured report templates
    @Override
    public List<ReportTemplate> getAllTemplates() {
        return reportManagerRepository.findAllTemplates();
    }

    // Retrieves a single report template by ID
    @Override
    public Optional<ReportTemplate> getTemplateById(Long id) {
        return reportManagerRepository.findTemplateById(id);
    }

    // Checks if the given template name is already in use
    @Override
    public boolean isTemplateNameTaken(String name) {
        return reportManagerRepository.isTemplateNameTaken(name);
    }

    // Checks if another template already uses the given name
    @Override
    public boolean isTemplateNameTakenByOther(String name, Long excludeId) {
        return reportManagerRepository.isTemplateNameTakenByOther(name, excludeId);
    }

    // Persists a new automated report delivery schedule
    @Override
    public void saveSchedule(ReportSchedule schedule) {
        reportManagerRepository.insertSchedule(schedule);
    }

    // Updates an existing automated delivery schedule
    @Override
    public void updateSchedule(Long id, ReportSchedule updatedSchedule) {
        reportManagerRepository.updateSchedule(id, updatedSchedule);
    }

    // Cancels and deletes an automated delivery schedule
    @Override
    public void cancelSchedule(Long id) {
        reportManagerRepository.deleteSchedule(id);
    }

    // Retrieves all automated delivery schedules
    @Override
    public List<ReportSchedule> getAllSchedules() {
        return reportManagerRepository.findAllSchedules();
    }

    // Persists an official certified business audit report
    @Override
    public void saveInventoryReport(InventoryReport report) {
        String generated = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        reportManagerRepository.insertInventoryReport(report, generated);
    }

    // Retrieves all submitted audit reports in reverse chronological order
    @Override
    public List<InventoryReport> getAllInventoryReports() {
        return reportManagerRepository.findAllInventoryReports();
    }

    // Retrieves an individual official report record by its ID
    @Override
    public Optional<InventoryReport> getInventoryReportById(Long id) {
        return reportManagerRepository.findInventoryReportById(id);
    }

    // Updates official approval status and review notes for an audit report
    @Override
    public void reviewReport(Long reportId, String status, String notes) {
        reportManagerRepository.updateReportReview(reportId, status, notes);
    }

    // Permanently removes a report from the official audit archive
    @Override
    public void deleteReport(Long reportId) {
        reportManagerRepository.deleteInventoryReport(reportId);
    }

    // Dynamically aggregates operational datasets across selected enterprise departments
    @Override
    public Map<String, Object> compileMultiDepartmentReport(List<String> selectedDepts, String title, String scope, String notes, String author) {
        Set<String> activeModules = new HashSet<>();
        if (selectedDepts != null) {
            for (String dept : selectedDepts) {
                if (dept != null && !dept.isBlank()) {
                    activeModules.add(dept.trim().toLowerCase().replaceAll("[^a-z]", ""));
                }
            }
        }
        if (activeModules.isEmpty()) {
            activeModules.addAll(Arrays.asList("inventory", "supplier", "spareparts", "sales", "customer"));
        }

        LocalDate now = LocalDate.now();
        String reportFreq = (scope != null && !scope.isBlank()) ? scope.trim() : "On-Demand";
        String submitter = (author != null && !author.isBlank()) ? author.trim() : "Report & Business Dashboard Manager";
        String reportTitle = (title != null && !title.isBlank()) ? title.trim() : "Executive Unified Cross-Department Operations Audit";

        StringBuilder sb = new StringBuilder();
        sb.append("========================================================================\n");
        sb.append(" PARTTRACK EXECUTIVE BUSINESS INTELLIGENCE SYSTEM\n");
        sb.append(" OFFICIAL UNIFIED CROSS-DEPARTMENT AUDIT REPORT\n");
        sb.append("========================================================================\n\n");
        sb.append(String.format("Report Title: %s\n", reportTitle));
        sb.append(String.format("Auditing Timeframe: %s\n", reportFreq));
        sb.append(String.format("Generated By: %s\n", submitter));
        sb.append(String.format("Generated Timestamp: %s\n", LocalDateTime.now().format(DATE_TIME_FORMATTER)));
        sb.append(String.format("Included Modules: %s\n\n", selectedDepts != null ? String.join(", ", selectedDepts).toUpperCase() : "ALL MODULES"));

        Map<String, Object> reportPayload = new LinkedHashMap<>();

        // 1. INVENTORY MODULE
        if (activeModules.contains("inventory") || activeModules.contains("warehouse") || activeModules.contains("stock")) {
            Map<String, Object> inv = reportManagerRepository.fetchInventoryDepartmentData();
            reportPayload.put("inventory", inv);
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 1: WAREHOUSE INVENTORY & STOCK REPOSITORY]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Registered Unique Spare Part SKUs: %d parts\n", inv.get("totalParts")));
            sb.append(String.format("• Total Physical Stock on Hand: %d units\n", inv.get("totalUnits")));
            sb.append(String.format("• Total Inventory Asset Valuation: Rs. %,.2f\n", (Double) inv.get("totalValue")));
            sb.append(String.format("• Low Stock Reorder Alerts: %d parts requiring replenishment\n\n", inv.get("lowStockCount")));
        }

        // 2. SUPPLIER MODULE
        if (activeModules.contains("supplier") || activeModules.contains("suppliers") || activeModules.contains("vendor")) {
            Map<String, Object> sup = reportManagerRepository.fetchSupplierDepartmentData();
            reportPayload.put("supplier", sup);
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 2: AUTOMOTIVE SUPPLIER PARTNER NETWORK]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Total Authorized OEM Suppliers: %d vendors\n", sup.get("totalSuppliers")));
            sb.append(String.format("• Active Procurement Partners: %d suppliers\n", sup.get("activeSuppliers")));
            sb.append(String.format("• Purchase Requests Transmitted: %d total orders\n", sup.get("totalOrders")));
            sb.append(String.format("• Shipments Dispatched by Suppliers: %d batches\n\n", sup.get("dispatchedOrders")));
        }

        // 3. SPARE PARTS / PROCUREMENT QA MODULE
        if (activeModules.contains("spareparts") || activeModules.contains("sparepart") || activeModules.contains("procurement") || activeModules.contains("qa")) {
            Map<String, Object> qa = reportManagerRepository.fetchProcurementDepartmentData();
            reportPayload.put("procurement", qa);
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 3: SPARE PART QUALITY CONTROL & INSPECTION GATE]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Total Incoming Delivery Batches: %d shipments\n", qa.get("totalBatches")));
            sb.append(String.format("• Approved for Warehouse Intake: %d batches\n", qa.get("approvedBatches")));
            sb.append(String.format("• Rejected Defective Shipments: %d batches\n", qa.get("rejectedBatches")));
            sb.append(String.format("• Batches Awaiting Quality Check: %d batches\n", qa.get("pendingBatches")));
            sb.append(String.format("• Quality Inspection Acceptance Rate: %d%%\n\n", qa.get("passRate")));
        }

        // 4. SALES MODULE
        if (activeModules.contains("sales") || activeModules.contains("salesreport") || activeModules.contains("orders")) {
            Map<String, Object> sal = reportManagerRepository.fetchSalesDepartmentData();
            reportPayload.put("sales", sal);
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 4: COMMERCIAL SALES & REVENUE PERFORMANCE]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Total Customer Orders: %d orders\n", sal.get("totalOrders")));
            sb.append(String.format("• Completed Orders: %d orders\n", sal.get("completedOrders")));
            sb.append(String.format("• Realized Cash Income: Rs. %,.2f\n", (Double) sal.get("completedRevenue")));
            sb.append(String.format("• Open Sales Pipeline Value: Rs. %,.2f\n\n", (Double) sal.get("pipelineRevenue")));
        }

        // 5. CUSTOMER PORTAL MODULE
        if (activeModules.contains("customer") || activeModules.contains("customerportal") || activeModules.contains("users")) {
            Map<String, Object> cust = reportManagerRepository.fetchCustomerDepartmentData();
            reportPayload.put("customer", cust);
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [SECTION 5: CUSTOMER PORTAL & SHOPPER ENGAGEMENT]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(String.format("• Registered Customer Accounts: %d shoppers\n", cust.get("totalCustomers")));
            sb.append(String.format("• Total Active Platform Users: %d users\n\n", cust.get("totalUsers")));
        }

        if (notes != null && !notes.isBlank()) {
            sb.append("------------------------------------------------------------------------\n");
            sb.append(" [EXECUTIVE MANAGER AUDIT NOTES]\n");
            sb.append("------------------------------------------------------------------------\n");
            sb.append(notes.trim()).append("\n\n");
        }

        sb.append("========================================================================\n");
        sb.append(" END OF CERTIFIED EXECUTIVE AUDIT REPORT — PARTTRACK ENTERPRISE\n");
        sb.append("========================================================================\n");

        reportPayload.put("textSummary", sb.toString());
        reportPayload.put("title", reportTitle);
        reportPayload.put("scope", reportFreq);
        reportPayload.put("author", submitter);
        return reportPayload;
    }

    // Persists an officially compiled multi-department audit report returning its primary key ID
    @Override
    public Long saveGeneratedUnifiedReport(String title, String scope, String format, String content, String notes, String author) {
        String submitter = (author != null && !author.isBlank()) ? author.trim() : "Report & Business Dashboard Manager";
        String now = LocalDateTime.now().format(DATE_TIME_FORMATTER);

        InventoryReport report = new InventoryReport(
                null,
                title,
                "Unified Multi-Department (" + format.toUpperCase() + ")",
                scope,
                "Current",
                submitter,
                now,
                content,
                "Certified Executive Audit",
                notes
        );

        return reportManagerRepository.insertReportReturningId(report, now);
    }

    // Aggregates full enterprise data across all 5 operational departments
    @Override
    public Map<String, Object> getComprehensiveEnterpriseMetrics() {
        Map<String, Object> metrics = new LinkedHashMap<>();
        metrics.put("inventory", reportManagerRepository.fetchInventoryDepartmentData());
        metrics.put("supplier", reportManagerRepository.fetchSupplierDepartmentData());
        metrics.put("procurement", reportManagerRepository.fetchProcurementDepartmentData());
        metrics.put("sales", reportManagerRepository.fetchSalesDepartmentData());
        metrics.put("customer", reportManagerRepository.fetchCustomerDepartmentData());
        metrics.put("summary", reportManagerRepository.retrieveSummaryMetrics());
        return metrics;
    }
}
