package com.sparepartmanagementsystem.inventory;

import com.sparepartmanagementsystem.reportmanager.ReportTemplate;
import com.sparepartmanagementsystem.procurement.SupplierProduct;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.Set;


//Defines business logic contracts for warehouse operations, capacity rules, and alerts.

public interface InventoryService {

    // Maximum rack storage capacity: 250 units
    int RACK_CAPACITY = 250;

    // Maximum warehouse total storage: 4 Racks x 250 units = 1000 units
    int MAX_WAREHOUSE_CAPACITY = RACK_CAPACITY * 4;

    // Retrieves all inventory items currently cataloged in the warehouse
    List<InventoryItem> getAllInventoryItems();

    // Finds a specific inventory part by its unique SKU / part ID
    Optional<InventoryItem> getInventoryItemById(String partId);

    // Calculates the total number of physical units currently stored
    int getTotalStockUnits();

    // Calculates the total financial valuation of all inventory in stock
    double getTotalInventoryValuation();

    // Calculates remaining free storage capacity in the warehouse
    int getAvailableSpace();

    // Calculates current warehouse occupancy percentage (0 - 100%)
    int getCapacityPercentage();

    // Calculates unit distribution across Racks A, B, C, and D
    Map<String, Integer> getRackQuantities(List<InventoryItem> items);

    // Retrieves all pending replenishment requests sent to spare parts
    List<RestockRequest> getPendingRestockRequests();

    // Retrieves set of part IDs currently awaiting restock fulfillment
    Set<String> getPendingRequestedPartIds();

    // Retrieves parts needing restock using the default standard strategy
    List<InventoryItem> getReorderList();

    // DESIGN PATTERN: Evaluates alert items using a chosen Strategy Pattern
    List<InventoryItem> getAlertItemsWithStrategy(ReorderAlertStrategy strategy);

    // DESIGN PATTERN: Strategy Pattern - Context setter to switch alert strategy dynamically at runtime
    void setAlertStrategy(ReorderAlertStrategy strategy);

    // Submits a formal restock request to the spare part department
    void sendRestockRequest(String partId, String partName, int currentQuantity, int requestedQuantity, String requestMessage);

    // Retrieves all supplier delivery batches certified by QA for intake
    List<SupplierProduct> getApprovedSupplierProducts();

    // Conducts intake of approved parts with warehouse and rack capacity validation
    void intakeApprovedProduct(int batchId, String partId, String partName, int quantity,
                               int reorderLevel, double unitPrice, String storageLocation);

    // Dispatches stock units for outbound orders with quantity check
    void dispatchStock(String partId, int amount);

    // Updates metadata attributes for a cataloged spare part
    boolean editPart(String partId, String partName, int reorderLevel, double unitPrice, String storageLocation);

    // Permanently removes a spare part item from warehouse storage
    boolean deletePart(String partId);

    // DESIGN PATTERN: Compiles an audit report preview using the Factory Pattern
    String compileReportPreview(String reportType, String fromDate, String toDate, String notes);

    // Dispatches an official audit report to Executive Administration
    InventoryReport dispatchReportToAdmin(String title, String type, String fromDate, String toDate, String content, String notes);

    // Retrieves all submitted warehouse reports from the database
    List<InventoryReport> getAllSubmittedReports();

    // Retrieves an inventory report by its primary key ID
    Optional<InventoryReport> getReportById(Long id);

    // Deletes an inventory report by its primary key ID
    void deleteReport(Long id);

    // Retrieves all available report templates
    List<ReportTemplate> getAllTemplates();

    // Generates a downloadable PDF byte array for an inventory report
    byte[] generateReportPdf(InventoryReport report);

    // Generates a downloadable PDF byte array from raw report text
    byte[] generateRawContentPdf(String title, String type, String notes, String content);
}
