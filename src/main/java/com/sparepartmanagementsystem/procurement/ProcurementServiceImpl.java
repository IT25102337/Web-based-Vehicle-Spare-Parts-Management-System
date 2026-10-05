package com.sparepartmanagementsystem.procurement;

import com.sparepartmanagementsystem.inventory.RestockRequest;
import com.sparepartmanagementsystem.supplier.Supplier;
import com.sparepartmanagementsystem.supplier.SupplierOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface Implementation (Service Layer)
 * UML RELATIONSHIP: Association (ProcurementServiceImpl associates with ProcurementRepository)
 * Handles receiving spare parts from suppliers, QA inspection, and pipeline management.
 */
@Service
public class ProcurementServiceImpl implements ProcurementService {

    // UML RELATIONSHIP: Association
    @Autowired
    private ProcurementRepository procurementRepository;

    // Retrieves all incoming supplier deliveries and QA batches
    @Override
    public List<SupplierProduct> getAllProducts() {
        return procurementRepository.findAllSupplierProducts();
    }

    // Retrieves pending restock requests sent by inventory
    @Override
    public List<RestockRequest> getPendingRestockRequests() {
        return procurementRepository.findPendingRestockRequests();
    }

    // Retrieves authorized automotive suppliers directory
    @Override
    public List<Supplier> getAllSuppliers() {
        return procurementRepository.findAllSuppliers();
    }

    // Retrieves purchase orders sent to suppliers
    @Override
    public List<SupplierOrder> getAllSupplierOrders() {
        return procurementRepository.findAllSupplierOrders();
    }

    // Registers a new supplier delivery batch awaiting quality inspection
    @Override
    public void registerDelivery(String partId, String partName, String supplierName, int receivedQty, double supplierPrice) {
        if (partId == null || partId.trim().isEmpty()) {
            throw new ProcurementException("Part SKU cannot be empty.");
        }
        if (receivedQty <= 0) {
            throw new ProcurementException("Received quantity must be greater than zero.");
        }
        String today = LocalDate.now().toString();
        int rows = procurementRepository.insertSupplierProduct(partId.trim(), partName.trim(), supplierName.trim(), receivedQty, supplierPrice, today);
        if (rows <= 0) {
            throw new ProcurementException("Failed to register supplier delivery in database.");
        }
    }

    // Evaluates quality condition of a batch approving or rejecting for warehouse intake
    @Override
    public void performInspection(int batchId, String qualityStatus, String qualityNotes) {
        Optional<SupplierProduct> batchOpt = procurementRepository.findSupplierProductById(batchId);
        if (batchOpt.isEmpty()) {
            throw new ProcurementException("Batch #" + batchId + " does not exist.");
        }
        SupplierProduct batch = batchOpt.get();

        if ("APPROVED".equalsIgnoreCase(qualityStatus)) {
            // Approved: available quantity remains intact
            int rows = procurementRepository.updateQualityStatus(batchId, "APPROVED", qualityNotes != null ? qualityNotes.trim() : "Approved QA", batch.getReceivedQty());
            if (rows <= 0) {
                throw new ProcurementException("Failed to update inspection status for batch #" + batchId);
            }
        } else {
            // Rejected: available quantity set to 0
            int rows = procurementRepository.updateQualityStatus(batchId, "REJECTED", qualityNotes != null ? qualityNotes.trim() : "Failed QA", 0);
            if (rows <= 0) {
                throw new ProcurementException("Failed to record rejection for batch #" + batchId);
            }
        }
    }

    // Removes an erroneous supplier delivery batch record
    @Override
    public void deleteDelivery(int batchId) {
        int rows = procurementRepository.deleteSupplierProduct(batchId);
        if (rows <= 0) {
            throw new ProcurementException("Supplier delivery record #" + batchId + " not found or could not be deleted.");
        }
    }

    // Removes a purchase order from the supplier procurement pipeline
    @Override
    public void deleteSupplierOrder(int orderId) {
        int rows = procurementRepository.deleteSupplierOrder(orderId);
        if (rows <= 0) {
            throw new ProcurementException("Purchase Order #PO-" + orderId + " was not found.");
        }
    }

    // Compiles comprehensive statistical metrics for the spare parts and QA dashboard
    @Override
    public Map<String, Object> getDashboardData() {
        Map<String, Object> map = new HashMap<>();

        List<SupplierProduct> products = getAllProducts();
        List<RestockRequest> incomingRequests = getPendingRestockRequests();
        List<Supplier> suppliers = getAllSuppliers();
        List<SupplierOrder> sentOrders = getAllSupplierOrders();

        int totalDeliveries = products.size();
        int pendingCount = 0;
        int approvedCount = 0;
        int rejectedCount = 0;
        int totalReceivedUnits = 0;
        int totalAvailableUnits = 0;

        for (SupplierProduct item : products) {
            totalReceivedUnits += item.getReceivedQty();
            totalAvailableUnits += item.getAvailableQty();
            if (item.isPending()) pendingCount++;
            else if (item.isApproved()) approvedCount++;
            else if (item.isRejected()) rejectedCount++;
        }

        int inspectedCount = approvedCount + rejectedCount;
        int passRatePct = inspectedCount > 0 ? (int) Math.round(((double) approvedCount / inspectedCount) * 100) : 100;

        int pendingSupplierOrdersCount = 0;
        int dispatchedSupplierOrdersCount = 0;
        for (SupplierOrder so : sentOrders) {
            if (so.isPending()) pendingSupplierOrdersCount++;
            else if (so.isDispatched()) dispatchedSupplierOrdersCount++;
        }

        map.put("productList", products);
        map.put("incomingRequests", incomingRequests);
        map.put("pendingRestockCount", incomingRequests.size());
        map.put("totalDeliveries", totalDeliveries);
        map.put("pendingCount", pendingCount);
        map.put("approvedCount", approvedCount);
        map.put("rejectedCount", rejectedCount);
        map.put("totalReceivedUnits", totalReceivedUnits);
        map.put("totalAvailableUnits", totalAvailableUnits);
        map.put("passRatePct", passRatePct);
        map.put("suppliers", suppliers);
        map.put("sentOrders", sentOrders);
        map.put("pendingSupplierOrdersCount", pendingSupplierOrdersCount);
        map.put("dispatchedSupplierOrdersCount", dispatchedSupplierOrdersCount);

        return map;
    }
}
