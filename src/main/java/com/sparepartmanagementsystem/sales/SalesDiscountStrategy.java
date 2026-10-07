package com.sparepartmanagementsystem.sales;

/**
 * DESIGN PATTERN: Strategy Pattern (Behavioral)
 * Strategy interface defining commercial pricing and discount evaluation algorithms for sales orders.
 */
public interface SalesDiscountStrategy {

    // Calculates discount amount (in Rupees) applicable to the sales order
    double calculateDiscount(SalesOrder order);

    // Human-readable description of the applied commercial discount tier
    String getStrategyName();
}
