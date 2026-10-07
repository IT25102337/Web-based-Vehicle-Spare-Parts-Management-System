package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: Strategy Pattern (Concrete Strategy 2)
 * Lead Time & Speed Focused Evaluation: Rewards rapid order dispatch times.
 */
public class SpeedFulfillmentStrategy implements SupplierRatingStrategy {

    private static final double TARGET_LEAD_TIME_DAYS = 3.0;

    @Override
    public double calculateScore(int totalOrders, int completedOrders, int rejectedOrders, double avgLeadTimeDays) {
        if (totalOrders <= 0) return 50.0;

        double baseScore = ((double) completedOrders / totalOrders) * 60.0;
        double speedBonus = 0.0;

        if (avgLeadTimeDays <= TARGET_LEAD_TIME_DAYS) {
            speedBonus = 40.0;
        } else if (avgLeadTimeDays <= 7.0) {
            speedBonus = 40.0 - ((avgLeadTimeDays - TARGET_LEAD_TIME_DAYS) * 5.0);
        }

        double score = baseScore + speedBonus;
        return Math.max(0.0, Math.min(100.0, score));
    }

    @Override
    public String getTierName(double score) {
        if (score >= 80.0) return "Express Rapid Fulfillment Partner";
        if (score >= 60.0) return "Standard Turnaround Vendor";
        return "Lagging Dispatch Lead Time";
    }

    @Override
    public String getStrategyName() {
        return "Lead Time & Speed Dispatch Assessment";
    }
}
