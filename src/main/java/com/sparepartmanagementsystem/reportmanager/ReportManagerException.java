package com.sparepartmanagementsystem.reportmanager;

/**
 * OOP CONCEPTS: Custom Exception & Inheritance
 * Custom domain exception for Report & Business Dashboard Manager operations.
 */
public class ReportManagerException extends RuntimeException {

    // Constructs a new ReportManagerException with detail message
    public ReportManagerException(String message) {
        super(message);
    }

    // Constructs a new ReportManagerException with detail message and root cause
    public ReportManagerException(String message, Throwable cause) {
        super(message, cause);
    }
}
