package com.sparepartmanagementsystem.reportmanager;

/**
 * OOP CONCEPT: Inheritance (extends com.sparepartmanagementsystem.inventory.InventoryReport)
 * Certified audit report entity used by Report & Business Dashboard Manager for cross-department audit certifications.
 */
public class InventoryReport extends com.sparepartmanagementsystem.inventory.InventoryReport {

    // Default Constructor calling super()
    public InventoryReport() {
        super();
    }

    // Parameterized Constructor delegating to parent InventoryReport
    public InventoryReport(Long reportId, String reportTitle, String reportType, String fromDate, String toDate,
                           String generatedBy, String generatedDate, String reportContent, String status, String notes) {
        super(reportId, reportTitle, reportType, fromDate, toDate, generatedBy, generatedDate, reportContent, status, notes);
    }
}
