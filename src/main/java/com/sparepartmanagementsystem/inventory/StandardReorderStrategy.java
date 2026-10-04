package com.sparepartmanagementsystem.inventory;


//DESIGN PATTERN: Strategy Pattern (Concrete Strategy 1)
//Triggers an alert when quantity is less than or equal to reorderLevel.

public class StandardReorderStrategy implements ReorderAlertStrategy {

    // Returns true when stock quantity falls to or below the safety reorder threshold
    @Override
    public boolean isAlertTriggered(InventoryItem item) {
        return item != null && item.getQuantity() <= item.getReorderLevel();
    }
}
