package com.sparepartmanagementsystem.admin;

/**
 * OOP CONCEPTS: Custom Exception & Inheritance
 * Domain-specific unchecked exception for Master System Administration, user provisioning, and security policy enforcement.
 */
public class AdminException extends RuntimeException {

    // Constructs a new AdminException with detail message
    public AdminException(String message) {
        super(message);
    }

    // Constructs a new AdminException with detail message and root cause
    public AdminException(String message, Throwable cause) {
        super(message, cause);
    }
}
