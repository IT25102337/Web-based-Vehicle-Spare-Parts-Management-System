package com.sparepartmanagementsystem.reportmanager;

// DESIGN PATTERN: Builder Pattern - Director that coordinates standard report template creation workflows
public class ReportDirector {

    // Reference to the active builder instance
    private final ReportBuilder builder;

    // Initializes director with a specific report builder implementation
    public ReportDirector(ReportBuilder builder) {
        this.builder = builder;
    }

    // Directs the creation of a standard monthly inventory audit report template
    public ReportTemplate constructMonthlyAuditTemplate() {
        return builder.setTemplateName("Monthly Inventory Audit")
                      .setTemplateFilters("AUDIT_CERTIFIED")
                      .setFrequency("Monthly")
                      .build();
    }

    // Directs the creation of a standard daily critical stock alert report template
    public ReportTemplate constructDailyStockAlertTemplate() {
        return builder.setTemplateName("Daily Critical Stock Alert")
                      .setTemplateFilters("LOW_STOCK_CRITICAL")
                      .setFrequency("Daily")
                      .build();
    }
}
