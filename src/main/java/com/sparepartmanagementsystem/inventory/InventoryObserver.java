package com.sparepartmanagementsystem.inventory;

// DESIGN PATTERN: Observer Pattern (Behavioral) - Observer interface receiving notifications
public interface InventoryObserver {

    // DESIGN PATTERN: Observer Pattern - Callback method invoked by Subject upon state change
    void update(String partId, int currentQuantity);
}
