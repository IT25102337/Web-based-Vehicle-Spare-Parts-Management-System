package com.sparepartmanagementsystem.reportmanager;

/**
 * OOP CONCEPTS: Encapsulation & Entity
 * Represents an executive business report template configured with category filters and dispatch frequency.
 * Part of the Aggregation relationship where ReportSchedule aggregates ReportTemplate.
 */
public class ReportTemplate {
    private Long id;
    private String templateName;
    private String templateFilters;
    private String frequency = "Weekly";
    private String createdAt;

    // Default constructor for frameworks
    public ReportTemplate() {}

    // Parameterized constructor initializing complete report template instance with category filters
    public ReportTemplate(Long id, String templateName, String templateFilters, String createdAt) {
        this.id = id;
        this.templateName = templateName;
        this.templateFilters = templateFilters;
        this.createdAt = createdAt;
    }

    // Overloaded parameterized constructor with explicit dispatch recurrence frequency
    public ReportTemplate(Long id, String templateName, String templateFilters, String frequency, String createdAt) {
        this.id = id;
        this.templateName = templateName;
        this.templateFilters = templateFilters;
        this.frequency = (frequency != null && !frequency.isBlank()) ? frequency : "Weekly";
        this.createdAt = createdAt;
    }

    // DESIGN PATTERN: Factory Pattern - Factory method to instantiate report templates
    public static ReportTemplate createTemplate(String templateName, String templateFilters, String frequency) {
        return new ReportTemplate(null, templateName, templateFilters, frequency, java.time.LocalDate.now().toString());
    }

    // Retrieves unique template ID
    public Long getId() { return id; }

    // Sets unique template ID
    public void setId(Long id) { this.id = id; }

    // Retrieves descriptive title of the template
    public String getTemplateName() { return templateName; }

    // Sets descriptive title of the template
    public void setTemplateName(String templateName) { this.templateName = templateName; }

    // Retrieves criteria and category filter expression
    public String getTemplateFilters() { return templateFilters; }

    // Sets criteria and category filter expression
    public void setTemplateFilters(String templateFilters) { this.templateFilters = templateFilters; }

    // Retrieves target recurrence frequency (Daily, Weekly, Monthly)
    public String getFrequency() { return frequency != null ? frequency : "Weekly"; }

    // Sets target recurrence frequency
    public void setFrequency(String frequency) { this.frequency = frequency; }

    // Retrieves creation timestamp string
    public String getCreatedAt() { return createdAt; }

    // Sets creation timestamp string
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}
