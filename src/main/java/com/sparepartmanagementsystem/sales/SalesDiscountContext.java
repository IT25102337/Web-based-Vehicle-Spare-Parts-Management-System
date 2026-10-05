package com.sparepartmanagementsystem.sales;

/**
 * DESIGN PATTERN: Strategy Pattern (Context)
 * Maintains reference to the chosen SalesDiscountStrategy and calculates final discounted totals dynamically.
 */
public class SalesDiscountContext {

    private SalesDiscountStrategy strategy;

    public SalesDiscountContext(SalesDiscountStrategy strategy) {
        this.strategy = (strategy != null) ? strategy : new RetailCustomerDiscountStrategy();
    }

    public void setStrategy(SalesDiscountStrategy strategy) {
        this.strategy = (strategy != null) ? strategy : new RetailCustomerDiscountStrategy();
    }

    public SalesDiscountStrategy getStrategy() {
        return strategy;
    }

    // Calculates net total after applying strategy discount
    public double calculateFinalAmount(SalesOrder order) {
        if (order == null) return 0.0;
        double subtotal = order.calculateTotalFromItems();
        if (subtotal <= 0.0) {
            subtotal = order.getTotalAmount();
        }
        double discount = strategy.calculateDiscount(order);
        return Math.max(0.0, subtotal - discount);
    }
}
