package com.sparepartmanagementsystem.inventory;


//Thrown when batch intake exceeds warehouse storage (1000) or rack storage (250).
public class WarehouseCapacityExceededException extends InventoryException {

    private final int requestedQuantity;
    private final int availableSpace;

    // Constructs capacity exception with details on requested qty and free space
    public WarehouseCapacityExceededException(String message, int requestedQuantity, int availableSpace) {
        super(message);
        this.requestedQuantity = requestedQuantity;
        this.availableSpace = availableSpace;
    }

    // Returns the quantity that failed to fit into warehouse
    public int getRequestedQuantity() {
        return requestedQuantity;
    }

    // Returns remaining free space available in warehouse or rack
    public int getAvailableSpace() {
        return availableSpace;
    }
}
