package com.sparepartmanagementsystem.sales;

/**
 * OOP CONCEPT: Custom Exception & Inheritance (extends RuntimeException)
 * Thrown when sales operations encounter domain or validation failures.
 */
public class SalesException extends RuntimeException {

    // OOP CONCEPT: Parameterized Constructor
    // Constructs the exception with a specific error message
    public SalesException(String message) {
        super(message);
    }

    // OOP CONCEPT: Parameterized Constructor with cause
    // Constructs the exception with an error message and underlying throwable cause
    public SalesException(String message, Throwable cause) {
        super(message, cause);
    }
}
