package com.sparepartmanagementsystem.inventory;

public class InsufficientStockException extends InventoryException {

    private final String partId;
    private final int requestedAmount;
    private final int currentStock;

    //Thrown when trying to dispatch more units than available in current stock.
    // Constructs exception with specific part ID, requested units, and available units
    public InsufficientStockException(String partId, int requestedAmount, int currentStock) {
        super(String.format("Cannot dispatch %d units for part '%s'! Current stock is only %d units.",
                requestedAmount, partId, currentStock));
        this.partId = partId;
        this.requestedAmount = requestedAmount;
        this.currentStock = currentStock;
    }

    // Gets the part ID with insufficient stock
    public String getPartId() {
        return partId;
    }

    // Gets the quantity that was attempted to be dispatched
    public int getRequestedAmount() {
        return requestedAmount;
    }

    // Gets the current available stock for the part
    public int getCurrentStock() {
        return currentStock;
    }
}
