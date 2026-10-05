package com.sparepartmanagementsystem.reportmanager;

import java.time.LocalDate;

// DESIGN PATTERN: Builder Pattern - Concrete builder that constructs a ReportTemplate step-by-step
public class ExecutiveReportBuilder implements ReportBuilder {

    // Internal state representing report template attributes
    private String templateName = "Executive Report";
    private String templateFilters = "ALL_CATEGORIES";
    private String frequency = "Weekly";

    @Override
    // Sets the template display name
    public ReportBuilder setTemplateName(String templateName) {
        this.templateName = templateName;
        return this;
    }

    @Override
    // Sets the filter criteria for data extraction
    public ReportBuilder setTemplateFilters(String templateFilters) {
        this.templateFilters = templateFilters;
        return this;
    }

    @Override
    // Sets the recurring dispatch frequency
    public ReportBuilder setFrequency(String frequency) {
        this.frequency = frequency;
        return this;
    }

    @Override
    // Assembles and returns the final configured ReportTemplate instance
    public ReportTemplate build() {
        return new ReportTemplate(null, templateName, templateFilters, frequency, LocalDate.now().toString());
    }
}
