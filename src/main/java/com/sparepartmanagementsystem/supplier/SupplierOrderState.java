package com.sparepartmanagementsystem.supplier;

/**
 * DESIGN PATTERN: State Pattern (State Interface)
 * Encapsulates state-dependent behavior of a Supplier purchase order lifecycle.
 * Defines transition operations allowed from each state.
 */
public interface SupplierOrderState {

    // Action when vendor dispatches parts
    void markDispatched(SupplierOrderContext context, String trackingNotes);

    // Action when vendor rejects the purchase order
    void markRejected(SupplierOrderContext context, String rejectionReason);

    // Action when warehouse receives and signs off delivery
    void markDelivered(SupplierOrderContext context);

    // Returns the string code representing the status
    String getStatusName();
}
