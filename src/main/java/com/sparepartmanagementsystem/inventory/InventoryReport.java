package com.sparepartmanagementsystem.inventory;


//Represents a certified warehouse inventory audit report submitted to Executive Administration.

public class InventoryReport {

    // Encapsulated private fields
    private Long reportId;
    private String reportTitle;
    private String reportType;
    private String fromDate;
    private String toDate;
    private String generatedBy;
    private String generatedDate;
    private String reportContent;
    private String status; // 'Pending Admin Review', 'Reviewed', 'Approved'
    private String notes;

    // Default constructor for frameworks
    public InventoryReport() {}

    // Parameterized constructor to initialize a certified report
    public InventoryReport(Long reportId, String reportTitle, String reportType, String fromDate, String toDate,
                           String generatedBy, String generatedDate, String reportContent, String status, String notes) {
        this.reportId = reportId;
        this.reportTitle = reportTitle;
        this.reportType = reportType;
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.generatedBy = generatedBy;
        this.generatedDate = generatedDate;
        this.reportContent = reportContent;
        this.status = status;
        this.notes = notes;
    }

    // Gets the database report record ID
    public Long getReportId() {
        return reportId;
    }

    // Sets the database report record ID
    public void setReportId(Long reportId) {
        this.reportId = reportId;
    }

    // Gets the report heading title
    public String getReportTitle() {
        return reportTitle;
    }

    // Sets the report heading title
    public void setReportTitle(String reportTitle) {
        this.reportTitle = reportTitle;
    }

    // Gets the category/type of the report
    public String getReportType() {
        return reportType;
    }

    // Sets the category/type of the report
    public void setReportType(String reportType) {
        this.reportType = reportType;
    }

    // Gets the audit start date
    public String getFromDate() {
        return fromDate;
    }

    // Sets the audit start date
    public void setFromDate(String fromDate) {
        this.fromDate = fromDate;
    }

    // Gets the audit end date
    public String getToDate() {
        return toDate;
    }

    // Sets the audit end date
    public void setToDate(String toDate) {
        this.toDate = toDate;
    }

    // Gets the author/role that generated the report
    public String getGeneratedBy() {
        return generatedBy;
    }

    // Sets the author/role that generated the report
    public void setGeneratedBy(String generatedBy) {
        this.generatedBy = generatedBy;
    }

    // Gets the timestamp when generated
    public String getGeneratedDate() {
        return generatedDate;
    }

    // Sets the timestamp when generated
    public void setGeneratedDate(String generatedDate) {
        this.generatedDate = generatedDate;
    }

    // Gets the full textual audit report content
    public String getReportContent() {
        return reportContent;
    }

    // Sets the full textual audit report content
    public void setReportContent(String reportContent) {
        this.reportContent = reportContent;
    }

    // Gets the administrative review status
    public String getStatus() {
        return status;
    }

    // Sets the administrative review status
    public void setStatus(String status) {
        this.status = status;
    }

    // Gets additional managerial audit notes
    public String getNotes() {
        return notes;
    }

    // Sets additional managerial audit notes
    public void setNotes(String notes) {
        this.notes = notes;
    }
}
