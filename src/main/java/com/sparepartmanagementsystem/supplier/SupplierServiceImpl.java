package com.sparepartmanagementsystem.supplier;

import com.sparepartmanagementsystem.procurement.SupplierProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;

/**
 * OOP CONCEPT: Interface Implementation (Service Layer)
 * UML RELATIONSHIP: Association (SupplierServiceImpl associates with SupplierRepository)
 * Handles supplier directory management, purchase order fulfillment, and QA dispatching.
 */
@Service
public class SupplierServiceImpl implements SupplierService {

    // UML RELATIONSHIP: Association
    @Autowired
    private SupplierRepository supplierRepository;

    // Initializes database schemas and default supplier seed records
    @Override
    public void initializeSupplierSystem() {
        supplierRepository.initSchema();
    }

    // Retrieves all active and registered suppliers in the network
    @Override
    public List<Supplier> getAllSuppliers() {
        return supplierRepository.findAllSuppliers();
    }

    // Registers a new automotive parts supplier in the network
    @Override
    public void registerSupplier(String supplierName, String contactPerson, String email, String phone, String category, String address) {
        if (supplierName == null || supplierName.trim().isEmpty()) {
            throw new SupplierException("Supplier company name is required.");
        }
        String today = LocalDate.now().toString();
        int rows = supplierRepository.createSupplier(supplierName.trim(), contactPerson.trim(), email.trim(), phone.trim(), category.trim(), address.trim(), "ACTIVE", today);
        if (rows <= 0) {
            throw new SupplierException("Failed to register supplier in database.");
        }
    }

    // Updates supplier profile, contact information, and operational status
    @Override
    public void updateSupplier(int supplierId, String supplierName, String contactPerson, String email, String phone, String category, String address, String status) {
        if (supplierName == null || supplierName.trim().isEmpty()) {
            throw new SupplierException("Supplier company name is required.");
        }
        int rows = supplierRepository.updateSupplier(supplierId, supplierName.trim(), contactPerson.trim(), email.trim(), phone.trim(), category.trim(), address.trim(), status.trim().toUpperCase());
        if (rows <= 0) {
            throw new SupplierException("Supplier #" + supplierId + " could not be updated.");
        }
    }

    // Removes an existing supplier from the procurement network
    @Override
    public void deleteSupplier(int supplierId) {
        int rows = supplierRepository.deleteSupplier(supplierId);
        if (rows <= 0) {
            throw new SupplierException("Supplier #" + supplierId + " not found or could not be removed.");
        }
    }

    // Fulfills a purchase order dispatching parts to Quality Inspection
    @Override
    @Transactional
    public void fulfillOrder(int orderId, String supplierName, int shippedQty, double supplierPrice, String shippingNotes) {
        Optional<SupplierOrder> orderOpt = supplierRepository.findSupplierOrderById(orderId);
        if (orderOpt.isEmpty()) {
            throw new SupplierException("Purchase Order #" + orderId + " not found.");
        }
        SupplierOrder order = orderOpt.get();

        String today = LocalDate.now().toString();
        String assignedSupplier = (supplierName != null && !supplierName.isBlank()) ? supplierName.trim() : order.getSupplierName();
        String notes = (shippingNotes != null && !shippingNotes.isBlank()) ? shippingNotes.trim() : "Dispatched by supplier on " + today;

        // 1. Mark order dispatched
        supplierRepository.updateSupplierOrderStatus(orderId, "DISPATCHED", notes);

        // 2. Register delivery in supplier_products for QA inspection
        String qaNotes = "Dispatched against Order #" + orderId + " - " + notes;
        supplierRepository.createSupplierProductBatch(order.getPartId(), order.getPartName(), assignedSupplier, shippedQty, supplierPrice, qaNotes, today);

        // 3. Update restock request if linked
        if (order.getRestockRequestId() != null && order.getRestockRequestId() > 0) {
            supplierRepository.updateRestockRequestStatus(order.getRestockRequestId(), "DISPATCHED");
        }
    }

    // Declines a purchase order notifying the Spare Part Manager
    @Override
    public void rejectOrder(int orderId, String reason) {
        String declineNote = (reason != null && !reason.isBlank()) ? "Declined: " + reason.trim() : "Order declined by supplier.";
        int rows = supplierRepository.updateSupplierOrderStatus(orderId, "REJECTED", declineNote);
        if (rows <= 0) {
            throw new SupplierException("Failed to decline order #" + orderId);
        }
    }

    // Creates a new purchase request sent to a specific supplier
    @Override
    @Transactional
    public void createPurchaseOrder(String partId, String partName, String supplierName, int requestedQty, double expectedPrice, String deliveryNotes, Integer restockRequestId, String requestedBy) {
        if (partId == null || partId.trim().isEmpty() || partName == null || partName.trim().isEmpty()) {
            throw new SupplierException("Both Part SKU and Part Name are required.");
        }
        if (requestedQty <= 0) {
            throw new SupplierException("Requested quantity must be at least 1 unit.");
        }
        String today = LocalDate.now().toString();
        String requester = (requestedBy != null && !requestedBy.isBlank()) ? requestedBy.trim() : "Spare Part Manager";

        int rows = supplierRepository.createSupplierOrder(restockRequestId, partId.trim().toUpperCase(), partName.trim(), supplierName.trim(), requestedQty, expectedPrice, "PENDING", today, deliveryNotes != null ? deliveryNotes.trim() : "", requester);
        if (rows <= 0) {
            throw new SupplierException("Failed to transmit purchase request to supplier.");
        }

        if (restockRequestId != null && restockRequestId > 0) {
            supplierRepository.updateRestockRequestStatus(restockRequestId, "ORDERED_FROM_SUPPLIER");
        }
    }

    // Aggregates metrics and orders for the supplier portal view
    @Override
    public Map<String, Object> getSupplierPortalData() {
        Map<String, Object> map = new HashMap<>();

        List<SupplierOrder> allOrders = supplierRepository.findAllSupplierOrders();
        List<SupplierOrder> pendingOrders = new ArrayList<>();
        List<SupplierOrder> dispatchedOrders = new ArrayList<>();

        for (SupplierOrder o : allOrders) {
            if (o.isPending()) pendingOrders.add(o);
            else dispatchedOrders.add(o);
        }

        List<SupplierProduct> deliveries = supplierRepository.findActiveDeliveries();
        int totalDispatchedUnits = 0;
        int approvedCount = 0;
        int rejectedCount = 0;
        int pendingQACount = 0;

        for (SupplierProduct p : deliveries) {
            totalDispatchedUnits += p.getReceivedQty();
            if (p.isApproved()) approvedCount++;
            else if (p.isRejected()) rejectedCount++;
            else if (p.isPending()) pendingQACount++;
        }

        List<Supplier> suppliers = supplierRepository.findAllSuppliers();

        map.put("pendingOrders", pendingOrders);
        map.put("dispatchedOrders", dispatchedOrders);
        map.put("deliveries", deliveries);
        map.put("suppliers", suppliers);
        map.put("pendingOrdersCount", pendingOrders.size());
        map.put("dispatchedOrdersCount", dispatchedOrders.size());
        map.put("totalDispatchedUnits", totalDispatchedUnits);
        map.put("approvedCount", approvedCount);
        map.put("rejectedCount", rejectedCount);
        map.put("pendingQACount", pendingQACount);
        map.put("totalSuppliers", suppliers.size());

        return map;
    }
}
