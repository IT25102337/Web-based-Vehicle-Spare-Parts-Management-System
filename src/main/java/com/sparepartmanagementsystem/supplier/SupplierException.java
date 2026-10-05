package com.sparepartmanagementsystem.supplier;

/**
 * OOP CONCEPT: Custom Exception & Inheritance (extends RuntimeException)
 * Thrown when automotive supplier operations or portal orders encounter business failures.
 */
public class SupplierException extends RuntimeException {

    // OOP CONCEPT: Parameterized Constructor
    // Constructs the exception with a specific error message
    public SupplierException(String message) {
        super(message);
    }

    // OOP CONCEPT: Parameterized Constructor with cause
    // Constructs the exception with an error message and underlying throwable
    public SupplierException(String message, Throwable cause) {
        super(message, cause);
    }
}
