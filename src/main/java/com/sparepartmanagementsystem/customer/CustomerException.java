package com.sparepartmanagementsystem.customer;

/**
 * OOP CONCEPT: Exception Handling (Custom Base Exception)
 * Base custom unchecked exception for the customer domain.
 */
public class CustomerException extends RuntimeException {

    // Constructs customer exception with an informative error message
    public CustomerException(String message) {
        super(message);
    }

    // Constructs customer exception with message and root cause
    public CustomerException(String message, Throwable cause) {
        super(message, cause);
    }
}
