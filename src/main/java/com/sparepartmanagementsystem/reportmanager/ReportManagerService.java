package com.sparepartmanagementsystem.reportmanager;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPTS: Abstraction & Service Layer
 * Business service interface for Report & Business Dashboard Manager coordinating multi-department reports, templates, and audits.
 */
public interface ReportManagerService {

    // Retrieves consolidated live system metrics from inventory, sales, and procurement
    DashboardSummary retrieveDashboardData();

    // Persists a newly created report template
    void saveTemplate(ReportTemplate template);

    // Updates template attributes for the specified ID
    void updateTemplate(Long id, ReportTemplate updatedTemplate);

    // Removes a report template and any associated delivery schedules
    void deleteTemplate(Long id);

    // Retrieves all configured report templates
    List<ReportTemplate> getAllTemplates();

    // Retrieves a single report template by ID
    Optional<ReportTemplate> getTemplateById(Long id);

    // Checks if the given template name is already in use
    boolean isTemplateNameTaken(String name);

    // Checks if another template already uses the given name
    boolean isTemplateNameTakenByOther(String name, Long excludeId);

    // Persists a new automated report delivery schedule
    void saveSchedule(ReportSchedule schedule);

    // Updates an existing automated delivery schedule
    void updateSchedule(Long id, ReportSchedule updatedSchedule);

    // Cancels and deletes an automated delivery schedule
    void cancelSchedule(Long id);

    // Retrieves all automated delivery schedules
    List<ReportSchedule> getAllSchedules();

    // Persists an official certified business audit report
    void saveInventoryReport(InventoryReport report);

    // Retrieves all submitted audit reports in reverse chronological order
    List<InventoryReport> getAllInventoryReports();

    // Retrieves an individual official report record by its ID
    Optional<InventoryReport> getInventoryReportById(Long id);

    // Updates official approval status and review notes for an audit report
    void reviewReport(Long reportId, String status, String notes);

    // Permanently removes a report from the official audit archive
    void deleteReport(Long reportId);

    // Dynamically aggregates operational datasets across selected enterprise departments
    Map<String, Object> compileMultiDepartmentReport(List<String> selectedDepts, String title, String scope, String notes, String author);

    // Persists an officially compiled multi-department audit report returning its primary key ID
    Long saveGeneratedUnifiedReport(String title, String scope, String format, String content, String notes, String author);

    // Aggregates full enterprise data across all 5 operational departments
    Map<String, Object> getComprehensiveEnterpriseMetrics();
}
