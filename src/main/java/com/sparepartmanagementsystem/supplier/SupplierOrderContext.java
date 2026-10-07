package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: State Pattern (Context)
 * Holds the current SupplierOrder and delegates state-dependent operations to the active SupplierOrderState.
 */
public class SupplierOrderContext {

    private final SupplierOrder order;
    private SupplierOrderState currentState;

    public SupplierOrderContext(SupplierOrder order) {
        this.order = order;
        // Initialize state based on existing order status
        if (order != null && "DISPATCHED".equalsIgnoreCase(order.getStatus())) {
            this.currentState = new DispatchedOrderState();
        } else if (order != null && "REJECTED".equalsIgnoreCase(order.getStatus())) {
            this.currentState = new RejectedOrderState();
        } else if (order != null && "DELIVERED".equalsIgnoreCase(order.getStatus())) {
            this.currentState = new DeliveredOrderState();
        } else {
            this.currentState = new PendingOrderState();
        }
    }

    public void setState(SupplierOrderState state) {
        this.currentState = state;
        if (order != null && state != null) {
            order.setStatus(state.getStatusName());
        }
    }

    public SupplierOrderState getState() {
        return currentState;
    }

    public SupplierOrder getOrder() {
        return order;
    }

    // Context delegation methods
    public void markDispatched(String trackingNotes) {
        currentState.markDispatched(this, trackingNotes);
    }

    public void markRejected(String rejectionReason) {
        currentState.markRejected(this, rejectionReason);
    }

    public void markDelivered() {
        currentState.markDelivered(this);
    }
}
