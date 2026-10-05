package com.sparepartmanagementsystem.reportmanager;

/**
 * OOP CONCEPT: Encapsulation
 * UML RELATIONSHIP: Aggregation (ReportSchedule aggregates ReportTemplate; ReportTemplate exists independently)
 * Represents an automated delivery schedule linked to a reusable report template.
 */
public class ReportSchedule {
    private Long id;

    // UML RELATIONSHIP: Aggregation (Holds a reference to an independent ReportTemplate)
    private ReportTemplate template;

    private String frequency;
    private String deliveryEmail;

    // Default constructor for frameworks
    public ReportSchedule() {}

    // Parameterized constructor initializing complete report schedule referencing aggregated ReportTemplate
    public ReportSchedule(Long id, ReportTemplate template, String frequency, String deliveryEmail) {
        this.id = id;
        this.template = template;
        this.frequency = frequency;
        this.deliveryEmail = deliveryEmail;
    }

    // Retrieves unique schedule ID
    public Long getId() { return id; }

    // Sets unique schedule ID
    public void setId(Long id) { this.id = id; }

    // Retrieves the aggregated ReportTemplate instance
    public ReportTemplate getTemplate() { return template; }

    // Sets the aggregated ReportTemplate instance
    public void setTemplate(ReportTemplate template) { this.template = template; }

    // Retrieves schedule recurrence frequency (Daily, Weekly, Monthly)
    public String getFrequency() { return frequency; }

    // Sets schedule recurrence frequency
    public void setFrequency(String frequency) { this.frequency = frequency; }

    // Retrieves target executive recipient email
    public String getDeliveryEmail() { return deliveryEmail; }

    // Sets target executive recipient email
    public void setDeliveryEmail(String deliveryEmail) { this.deliveryEmail = deliveryEmail; }
}
