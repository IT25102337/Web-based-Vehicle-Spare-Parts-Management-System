package com.sparepartmanagementsystem.procurement;

/**
 * OOP CONCEPT: Custom Exception & Inheritance (extends RuntimeException)
 * Thrown when spare parts procurement or quality inspection operations fail.
 */
public class ProcurementException extends RuntimeException {

    // OOP CONCEPT: Parameterized Constructor
    // Constructs the exception with a descriptive error message
    public ProcurementException(String message) {
        super(message);
    }

    // OOP CONCEPT: Parameterized Constructor with cause
    // Constructs the exception with an error message and underlying throwable
    public ProcurementException(String message, Throwable cause) {
        super(message, cause);
    }
}
