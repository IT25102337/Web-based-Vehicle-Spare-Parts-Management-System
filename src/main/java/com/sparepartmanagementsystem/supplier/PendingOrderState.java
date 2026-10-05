package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: State Pattern (Concrete State 1)
 * Represents an order awaiting supplier response. Can transition to Dispatched or Rejected.
 */
public class PendingOrderState implements SupplierOrderState {

    @Override
    public void markDispatched(SupplierOrderContext context, String trackingNotes) {
        if (context.getOrder() != null) {
            context.getOrder().setDeliveryNotes(trackingNotes != null ? trackingNotes : "Dispatched by supplier");
        }
        context.setState(new DispatchedOrderState());
    }

    @Override
    public void markRejected(SupplierOrderContext context, String rejectionReason) {
        if (context.getOrder() != null) {
            context.getOrder().setDeliveryNotes("Declined: " + (rejectionReason != null ? rejectionReason : "Out of stock at vendor"));
        }
        context.setState(new RejectedOrderState());
    }

    @Override
    public void markDelivered(SupplierOrderContext context) {
        throw new SupplierException("Invalid state transition: Pending orders cannot be directly marked as delivered before dispatch.");
    }

    @Override
    public String getStatusName() {
        return "PENDING";
    }
}
