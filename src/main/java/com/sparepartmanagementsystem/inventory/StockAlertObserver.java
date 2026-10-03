package com.sparepartmanagementsystem.inventory;

// DESIGN PATTERN: Observer Pattern (Behavioral) - Concrete Observer reacting to stock state changes
public class StockAlertObserver implements InventoryObserver {

    // DESIGN PATTERN: Observer Pattern - Reacts to stock update notification
    @Override
    public void update(String partId, int currentQuantity) {
        if (currentQuantity <= 5) {
            System.out.println("[OBSERVER NOTIFICATION] Stock alert triggered for part: " + partId + " (Remaining: " + currentQuantity + ")");
        }
    }
}
