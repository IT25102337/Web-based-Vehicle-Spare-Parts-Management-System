package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: Strategy Pattern (Context)
 * Coordinates supplier vendor ratings by delegating calculation to the configured SupplierRatingStrategy.
 */
public class SupplierEvaluationContext {

    private SupplierRatingStrategy strategy;

    public SupplierEvaluationContext(SupplierRatingStrategy strategy) {
        this.strategy = (strategy != null) ? strategy : new QualityReliabilityStrategy();
    }

    public void setStrategy(SupplierRatingStrategy strategy) {
        this.strategy = (strategy != null) ? strategy : new QualityReliabilityStrategy();
    }

    public SupplierRatingStrategy getStrategy() {
        return strategy;
    }

    // Evaluates a supplier vendor and produces a summary assessment report string
    public String evaluateSupplier(Supplier supplier, int totalOrders, int completedOrders, int rejectedOrders, double avgLeadTimeDays) {
        double score = strategy.calculateScore(totalOrders, completedOrders, rejectedOrders, avgLeadTimeDays);
        String tier = strategy.getTierName(score);
        String vendorName = supplier != null ? supplier.getSupplierName() : "Unknown Vendor";

        return String.format("Vendor: %s | Algorithm: %s | Score: %.1f/100 | Tier: %s",
                vendorName, strategy.getStrategyName(), score, tier);
    }
}
