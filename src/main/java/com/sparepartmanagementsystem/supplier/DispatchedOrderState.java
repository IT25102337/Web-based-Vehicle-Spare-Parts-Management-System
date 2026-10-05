package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: State Pattern (Concrete State 2)
 * Represents an in-transit order dispatched by the vendor. Can transition to Delivered.
 */
public class DispatchedOrderState implements SupplierOrderState {

    @Override
    public void markDispatched(SupplierOrderContext context, String trackingNotes) {
        // Already dispatched, simply update tracking notes
        if (context.getOrder() != null && trackingNotes != null) {
            context.getOrder().setDeliveryNotes(trackingNotes);
        }
    }

    @Override
    public void markRejected(SupplierOrderContext context, String rejectionReason) {
        throw new SupplierException("Invalid state transition: Cannot reject an order that has already been dispatched into transit.");
    }

    @Override
    public void markDelivered(SupplierOrderContext context) {
        context.setState(new DeliveredOrderState());
    }

    @Override
    public String getStatusName() {
        return "DISPATCHED";
    }
}
