package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: State Pattern (Concrete State 4)
 * Represents a successfully delivered and received purchase order (Terminal State).
 */
public class DeliveredOrderState implements SupplierOrderState {

    @Override
    public void markDispatched(SupplierOrderContext context, String trackingNotes) {
        throw new SupplierException("Invalid state transition: Order has already been delivered to the warehouse.");
    }

    @Override
    public void markRejected(SupplierOrderContext context, String rejectionReason) {
        throw new SupplierException("Invalid state transition: Cannot reject an order that has already been received and delivered.");
    }

    @Override
    public void markDelivered(SupplierOrderContext context) {
        // Idempotent
    }

    @Override
    public String getStatusName() {
        return "DELIVERED";
    }
}
