package com.sparepartmanagementsystem.reportmanager;

// DESIGN PATTERN: Builder Pattern - Builder interface specifying steps to build a ReportTemplate
public interface ReportBuilder {

    // Sets the template display name
    ReportBuilder setTemplateName(String templateName);

    // Sets the filter criteria for data extraction
    ReportBuilder setTemplateFilters(String templateFilters);

    // Sets the recurring dispatch frequency
    ReportBuilder setFrequency(String frequency);

    // Assembles and returns the final ReportTemplate instance
    ReportTemplate build();
}
