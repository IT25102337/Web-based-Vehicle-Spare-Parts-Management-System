package com.sparepartmanagementsystem.reportmanager;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface & Repository Pattern
 * Contract defining database access operations for Report & Business Dashboard Manager metrics, templates, schedules, and audits.
 */
public interface ReportManagerRepository {

    // Ensures database tables and schema columns are initialized
    void initSchema();

    // Retrieves consolidated live system metrics from inventory, sales, and procurement
    DashboardSummary retrieveSummaryMetrics();

    // Persists a newly designed report template
    void insertTemplate(ReportTemplate template, String createdAt);

    // Updates name, category filters, and frequency of an existing report template
    void updateTemplate(Long id, ReportTemplate template);

    // Removes a report template and its cascaded delivery schedules
    void deleteTemplate(Long id);

    // Retrieves all saved business report templates
    List<ReportTemplate> findAllTemplates();

    // Retrieves a single report template by its primary key
    Optional<ReportTemplate> findTemplateById(Long id);

    // Verifies whether a template name already exists in the system
    boolean isTemplateNameTaken(String name);

    // Verifies whether another template already uses the given title
    boolean isTemplateNameTakenByOther(String name, Long excludeId);

    // Persists an automated report delivery schedule
    void insertSchedule(ReportSchedule schedule);

    // Updates recurrence frequency and recipient email of a report schedule
    void updateSchedule(Long id, ReportSchedule schedule);

    // Cancels and removes an automated report delivery schedule
    void deleteSchedule(Long id);

    // Retrieves all automated delivery schedules joined with their templates
    List<ReportSchedule> findAllSchedules();

    // Persists an official certified business audit report
    void insertInventoryReport(InventoryReport report, String generatedDate);

    // Persists an official audit report and returns the generated primary key
    Long insertReportReturningId(InventoryReport report, String generatedDate);

    // Retrieves all audit reports submitted to the Report Manager
    List<InventoryReport> findAllInventoryReports();

    // Retrieves an individual official report record by its ID
    Optional<InventoryReport> findInventoryReportById(Long id);

    // Updates approval status and executive review notes for an audit report
    void updateReportReview(Long reportId, String status, String notes);

    // Deletes an official audit report from the system archive
    void deleteInventoryReport(Long reportId);

    // Fetches live operational data for the Warehouse Inventory module
    Map<String, Object> fetchInventoryDepartmentData();

    // Fetches live operational data for the Supplier Partner Network module
    Map<String, Object> fetchSupplierDepartmentData();

    // Fetches live operational data for the Quality Control and Procurement module
    Map<String, Object> fetchProcurementDepartmentData();

    // Fetches live operational data for the Commercial Sales module
    Map<String, Object> fetchSalesDepartmentData();

    // Fetches live operational data for the Customer Portal module
    Map<String, Object> fetchCustomerDepartmentData();
}
