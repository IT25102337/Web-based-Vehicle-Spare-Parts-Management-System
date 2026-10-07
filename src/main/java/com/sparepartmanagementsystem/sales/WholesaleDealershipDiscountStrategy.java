package com.sparepartmanagementsystem.sales;

/**
 * DESIGN PATTERN: Strategy Pattern (Concrete Strategy 2)
 * Evaluates authorized automotive dealerships & garage partners: flat 15% wholesale commercial discount.
 */
public class WholesaleDealershipDiscountStrategy implements SalesDiscountStrategy {

    private static final double WHOLESALE_DISCOUNT_RATE = 0.15;

    @Override
    public double calculateDiscount(SalesOrder order) {
        if (order == null) return 0.0;
        double baseTotal = order.calculateTotalFromItems();
        if (baseTotal <= 0.0) {
            baseTotal = order.getTotalAmount();
        }
        return baseTotal * WHOLESALE_DISCOUNT_RATE;
    }

    @Override
    public String getStrategyName() {
        return "Wholesale Commercial Partner Tier (15% Trade Discount)";
    }
}
