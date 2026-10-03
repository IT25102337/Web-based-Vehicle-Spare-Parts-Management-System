package com.sparepartmanagementsystem.inventory;

/**
 * DESIGN PATTERN: Strategy Pattern (Strategy Interface)
 * Defines the contract to evaluate whether a part triggers an inventory alert.
 */
public interface ReorderAlertStrategy {

    // Evaluates if the given inventory item meets the alert criteria
    boolean isAlertTriggered(InventoryItem item);
}
