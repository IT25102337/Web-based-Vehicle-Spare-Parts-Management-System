package com.sparepartmanagementsystem.sales;

// DESIGN PATTERN: Decorator Pattern (Structural) - Common Component Interface for order pricing
public interface OrderPriceComponent {
    // Calculates total price dynamically including any runtime decorators
    double calculatePrice();
    // Returns human-readable pricing breakdown
    String getDescription();
}
