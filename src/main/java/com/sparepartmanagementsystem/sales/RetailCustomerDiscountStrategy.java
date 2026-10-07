package com.sparepartmanagementsystem.sales;

/**
 * DESIGN PATTERN: Strategy Pattern (Concrete Strategy 1)
 * Evaluates retail consumer discounts: 5% promotional discount on orders exceeding Rs. 10,000.
 */
public class RetailCustomerDiscountStrategy implements SalesDiscountStrategy {

    private static final double MIN_QUALIFYING_AMOUNT = 10000.0;
    private static final double DISCOUNT_RATE = 0.05;

    @Override
    public double calculateDiscount(SalesOrder order) {
        if (order == null) return 0.0;
        double baseTotal = order.calculateTotalFromItems();
        if (baseTotal <= 0.0) {
            baseTotal = order.getTotalAmount();
        }
        if (baseTotal >= MIN_QUALIFYING_AMOUNT) {
            return baseTotal * DISCOUNT_RATE;
        }
        return 0.0;
    }

    @Override
    public String getStrategyName() {
        return "Standard Retail Tier (5% discount over Rs. 10,000)";
    }
}
