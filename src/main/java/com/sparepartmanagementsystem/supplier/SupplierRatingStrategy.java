package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: Strategy Pattern (Strategy Interface)
 * Contract for evaluating supplier vendor reliability performance scores on a scale of 0 to 100.
 */
public interface SupplierRatingStrategy {

    // Computes supplier evaluation score based on order history metrics
    double calculateScore(int totalOrders, int completedOrders, int rejectedOrders, double avgLeadTimeDays);

    // Human-readable evaluation tier (e.g., "Tier 1 - Preferred", "Tier 2 - Qualified", "Probationary")
    String getTierName(double score);

    // Strategy algorithm name
    String getStrategyName();
}
