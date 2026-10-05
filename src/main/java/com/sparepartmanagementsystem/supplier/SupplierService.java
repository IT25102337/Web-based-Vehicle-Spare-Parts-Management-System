package com.sparepartmanagementsystem.supplier;

import java.util.List;
import java.util.Map;

/**
 * OOP CONCEPT: Interface (Service Layer Contract)
 * Defines business logic contracts for supplier management, purchase order fulfillment, and dispatches.
 */
public interface SupplierService {

    // Initializes database schemas and default supplier seed records
    void initializeSupplierSystem();

    // Retrieves all active and registered suppliers in the network
    List<Supplier> getAllSuppliers();

    // Registers a new automotive parts supplier in the network
    void registerSupplier(String supplierName, String contactPerson, String email, String phone, String category, String address);

    // Updates supplier profile, contact information, and operational status
    void updateSupplier(int supplierId, String supplierName, String contactPerson, String email, String phone, String category, String address, String status);

    // Removes an existing supplier from the procurement network
    void deleteSupplier(int supplierId);

    // Fulfills a purchase order dispatching parts to Quality Inspection
    void fulfillOrder(int orderId, String supplierName, int shippedQty, double supplierPrice, String shippingNotes);

    // Declines a purchase order notifying the Spare Part Manager
    void rejectOrder(int orderId, String reason);

    // Creates a new purchase request sent to a specific supplier
    void createPurchaseOrder(String partId, String partName, String supplierName, int requestedQty, double expectedPrice, String deliveryNotes, Integer restockRequestId, String requestedBy);

    // Aggregates metrics and orders for the supplier portal view
    Map<String, Object> getSupplierPortalData();
}
