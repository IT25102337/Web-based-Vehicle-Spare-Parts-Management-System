package com.sparepartmanagementsystem.inventory;


//Design pattern
//Triggers an emergency alert when quantity has reached absolute zero (Out of Stock).
public class CriticalDepletionStrategy implements ReorderAlertStrategy {

    // Returns true when stock quantity is completely depleted to zero
    @Override
    public boolean isAlertTriggered(InventoryItem item) {
        return item != null && item.getQuantity() == 0;
    }
}
