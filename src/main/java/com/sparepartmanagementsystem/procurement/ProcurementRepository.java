package com.sparepartmanagementsystem.procurement;

import com.sparepartmanagementsystem.inventory.RestockRequest;
import com.sparepartmanagementsystem.supplier.Supplier;
import com.sparepartmanagementsystem.supplier.SupplierOrder;

import java.util.List;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface & Repository Pattern
 * Contract defining database access operations for supplier shipments, QA checks, and orders.
 */
public interface ProcurementRepository {

    // Retrieves all supplier product delivery batches sorted by newest first
    List<SupplierProduct> findAllSupplierProducts();

    // Retrieves a single supplier product batch by its batch ID
    Optional<SupplierProduct> findSupplierProductById(int batchId);

    // Inserts a new incoming supplier delivery batch awaiting quality inspection
    int insertSupplierProduct(String partId, String partName, String supplierName, int receivedQty, double supplierPrice, String arrivalDate);

    // Updates quality status, notes, and remaining available quantity for a batch
    int updateQualityStatus(int batchId, String qualityStatus, String qualityNotes, int availableQty);

    // Permanently removes a supplier product delivery batch from the database
    int deleteSupplierProduct(int batchId);

    // Retrieves all pending restock requests submitted by warehouse inventory
    List<RestockRequest> findPendingRestockRequests();

    // Retrieves all registered suppliers in the system
    List<Supplier> findAllSuppliers();

    // Retrieves all purchase orders dispatched to suppliers
    List<SupplierOrder> findAllSupplierOrders();

    // Deletes an order from the supplier procurement pipeline
    int deleteSupplierOrder(int orderId);
}
