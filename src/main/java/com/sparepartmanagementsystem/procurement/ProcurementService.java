package com.sparepartmanagementsystem.procurement;

import com.sparepartmanagementsystem.inventory.RestockRequest;
import com.sparepartmanagementsystem.supplier.Supplier;
import com.sparepartmanagementsystem.supplier.SupplierOrder;

import java.util.List;
import java.util.Map;

/**
 * OOP CONCEPT: Interface (Service Layer Contract)
 * Defines business logic contracts for supplier delivery intake, QA inspection, and pipeline management.
 */
public interface ProcurementService {

    // Retrieves all incoming supplier deliveries and QA batches
    List<SupplierProduct> getAllProducts();

    // Retrieves pending restock requests sent by inventory
    List<RestockRequest> getPendingRestockRequests();

    // Retrieves authorized automotive suppliers directory
    List<Supplier> getAllSuppliers();

    // Retrieves purchase orders sent to suppliers
    List<SupplierOrder> getAllSupplierOrders();

    // Registers a new supplier delivery batch awaiting quality inspection
    void registerDelivery(String partId, String partName, String supplierName, int receivedQty, double supplierPrice);

    // Evaluates quality condition of a batch approving or rejecting for warehouse intake
    void performInspection(int batchId, String qualityStatus, String qualityNotes);

    // Removes an erroneous supplier delivery batch record
    void deleteDelivery(int batchId);

    // Removes a purchase order from the supplier procurement pipeline
    void deleteSupplierOrder(int orderId);

    // Compiles comprehensive statistical metrics for the spare parts and QA dashboard
    Map<String, Object> getDashboardData();
}
