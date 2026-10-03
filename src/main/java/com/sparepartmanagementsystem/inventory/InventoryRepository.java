package com.sparepartmanagementsystem.inventory;

import com.sparepartmanagementsystem.reportmanager.ReportTemplate;
import com.sparepartmanagementsystem.procurement.SupplierProduct;

import java.util.List;
import java.util.Optional;
import java.util.Set;

/**
 * OOP CONCEPT: Interface & Repository Pattern
 * Contract defining all database persistence operations for the inventory module.
 */
public interface InventoryRepository {

    // Retrieves all inventory parts from the database
    List<InventoryItem> findAll();

    // Finds a specific inventory part by its unique part ID
    Optional<InventoryItem> findById(String partId);

    // Checks whether an inventory part ID already exists in the database
    boolean existsById(String partId);

    // Inserts a newly registered part into inventory storage
    int insertItem(String partId, String partName, int quantity, int reorderLevel, double unitPrice, String storageLocation);

    // Updates name, reorder threshold, price, and rack location for an existing part
    int updateItem(String partId, String partName, int reorderLevel, double unitPrice, String storageLocation);

    // Increases existing stock quantity and updates retail price and rack location
    int increaseStockAndDetails(String partId, int quantity, double unitPrice, int reorderLevel, String storageLocation);

    // Decreases stock quantity for outbound warehouse dispatch
    int dispatchStock(String partId, int amount);

    // Permanently removes a part record from the database
    int deleteById(String partId);

    // Calculates the total sum of all physical stock units in the warehouse
    int getTotalStockUnits();

    // Calculates total stock currently stored in a specific rack (A, B, C, or D)
    int getRackStockUnits(String rackLetter);

    // Retrieves all pending restock requests submitted to spare parts
    List<RestockRequest> findPendingRestockRequests();

    // Returns a set of part IDs currently awaiting restock approval
    Set<String> findPendingRequestedPartIds();

    // Records a new restock request in the database
    int insertRestockRequest(String partId, String partName, int currentQty, int requestedQty, String message, String dateStr);

    // Marks any pending restock request for a part as fulfilled
    int fulfillPendingRestockRequest(String partId);

    // Retrieves all supplier batches approved by QA that have available stock
    List<SupplierProduct> findApprovedSupplierProducts();

    // Finds a supplier product delivery batch by its batch ID
    Optional<SupplierProduct> findSupplierProductById(int batchId);

    // Deducts intake quantity from available units in the supplier delivery batch
    int deductSupplierProductAvailableQty(int batchId, int quantity);

    // Saves a certified inventory report to the database
    void saveInventoryReport(InventoryReport report);

    // Retrieves all submitted warehouse reports ordered by latest ID
    List<InventoryReport> findAllInventoryReports();

    // Retrieves a single inventory report by its record ID
    Optional<InventoryReport> findInventoryReportById(Long reportId);

    // Deletes an inventory report by its record ID
    void deleteInventoryReport(Long reportId);

    // Retrieves all administrative report templates from the database
    List<ReportTemplate> findAllReportTemplates();
}
