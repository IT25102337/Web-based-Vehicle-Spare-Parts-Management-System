package com.sparepartmanagementsystem.inventory;

// DESIGN PATTERN: Observer Pattern (Behavioral) - Subject interface managing event observers
public interface InventorySubject {

    // DESIGN PATTERN: Observer Pattern - Registers an observer
    void addObserver(InventoryObserver observer);

    // DESIGN PATTERN: Observer Pattern - Removes an observer
    void removeObserver(InventoryObserver observer);

    // DESIGN PATTERN: Observer Pattern - Broadcasts state changes to all registered observers
    void notifyObservers(String partId, int currentQuantity);
}
