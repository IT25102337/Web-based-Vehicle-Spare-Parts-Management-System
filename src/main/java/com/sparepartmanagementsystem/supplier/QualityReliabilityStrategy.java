package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: Strategy Pattern (Concrete Strategy 1)
 * Quality & Reliability Focused Evaluation: Prioritizes low rejection/cancellation rates.
 */
public class QualityReliabilityStrategy implements SupplierRatingStrategy {

    @Override
    public double calculateScore(int totalOrders, int completedOrders, int rejectedOrders, double avgLeadTimeDays) {
        if (totalOrders <= 0) return 50.0; // Default neutral baseline

        double completionRatio = (double) completedOrders / totalOrders;
        double rejectionPenalty = ((double) rejectedOrders / totalOrders) * 40.0;

        // Base score from fulfillment success minus rejection penalty
        double score = (completionRatio * 100.0) - rejectionPenalty;
        return Math.max(0.0, Math.min(100.0, score));
    }

    @Override
    public String getTierName(double score) {
        if (score >= 85.0) return "Tier 1 - Preferred Quality Vendor";
        if (score >= 65.0) return "Tier 2 - Qualified Vendor";
        return "Tier 3 - Probationary Quality Review";
    }

    @Override
    public String getStrategyName() {
        return "Quality & Reliability Focused Assessment";
    }
}
