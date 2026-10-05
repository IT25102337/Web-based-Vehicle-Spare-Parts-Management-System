package com.sparepartmanagementsystem.supplier;

import com.sparepartmanagementsystem.procurement.SupplierProduct;

import java.util.List;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface & Repository Pattern
 * Contract defining database access operations for automotive suppliers and purchase orders.
 */
public interface SupplierRepository {

    // Initializes database tables and default seed data for suppliers and orders
    void initSchema();

    // Retrieves all suppliers ordered alphabetically
    List<Supplier> findAllSuppliers();

    // Retrieves a single supplier by its primary key ID
    Optional<Supplier> findSupplierById(int supplierId);

    // Inserts a new supplier company record into the database
    int createSupplier(String supplierName, String contactPerson, String email, String phone, String category, String address, String status, String createdAt);

    // Updates supplier business details and operational status
    int updateSupplier(int supplierId, String supplierName, String contactPerson, String email, String phone, String category, String address, String status);

    // Permanently removes a supplier record from the database
    int deleteSupplier(int supplierId);

    // Retrieves all purchase requests dispatched to suppliers
    List<SupplierOrder> findAllSupplierOrders();

    // Retrieves a single purchase order by its primary key
    Optional<SupplierOrder> findSupplierOrderById(int orderId);

    // Persists a newly created purchase order to a supplier
    int createSupplierOrder(Integer restockRequestId, String partId, String partName, String supplierName, int requestedQty, double expectedPrice, String status, String orderDate, String deliveryNotes, String requestedBy);

    // Updates the dispatch or rejection status of a supplier order
    int updateSupplierOrderStatus(int orderId, String status, String deliveryNotes);

    // Registers a newly dispatched delivery batch in the QA inspection table
    int createSupplierProductBatch(String partId, String partName, String supplierName, int receivedQty, double supplierPrice, String qaNotes, String arrivalDate);

    // Updates workflow status of linked warehouse restock requests
    int updateRestockRequestStatus(int requestId, String status);

    // Queries active delivery batches undergoing quality inspection
    List<SupplierProduct> findActiveDeliveries();
}
