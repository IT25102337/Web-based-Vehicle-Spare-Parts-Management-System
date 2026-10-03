package com.sparepartmanagementsystem.inventory;

/**
 * OOP CONCEPT: Exception Handling (Custom Base Exception)
 * Root exception for all inventory and warehouse error conditions.
 */
public class InventoryException extends RuntimeException {

    // Constructs inventory exception with an informative error message
    public InventoryException(String message) {
        super(message);
    }

    // Constructs inventory exception with message and root cause
    public InventoryException(String message, Throwable cause) {
        super(message, cause);
    }
}
