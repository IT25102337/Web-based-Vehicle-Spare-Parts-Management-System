package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: State Pattern (Concrete State 3)
 * Represents a declined/rejected purchase order (Terminal State).
 */
public class RejectedOrderState implements SupplierOrderState {

    @Override
    public void markDispatched(SupplierOrderContext context, String trackingNotes) {
        throw new SupplierException("Invalid state transition: Cannot dispatch an order that was rejected by the supplier.");
    }

    @Override
    public void markRejected(SupplierOrderContext context, String rejectionReason) {
        // Already rejected, idempotent operation
    }

    @Override
    public void markDelivered(SupplierOrderContext context) {
        throw new SupplierException("Invalid state transition: A rejected order cannot be marked as delivered.");
    }

    @Override
    public String getStatusName() {
        return "REJECTED";
    }
}
