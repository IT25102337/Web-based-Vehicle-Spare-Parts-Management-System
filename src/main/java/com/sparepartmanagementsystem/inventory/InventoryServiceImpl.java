package com.sparepartmanagementsystem.inventory;

import com.sparepartmanagementsystem.reportmanager.ReportTemplate;
import com.sparepartmanagementsystem.core.PdfReportService;
import com.sparepartmanagementsystem.procurement.SupplierProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.*;

/**
 * OOP CONCEPT: Interface Implementation (Service Layer)
 * Business logic implementation for InventoryService enforcing capacity limits and business rules.
 */
@Service
public class InventoryServiceImpl implements InventoryService, InventorySubject {

    // DESIGN PATTERN: Observer Pattern - Registered list of stock observers
    private final List<InventoryObserver> observers = new ArrayList<>(List.of(new StockAlertObserver()));

    // DESIGN PATTERN: Observer Pattern - Registers an observer
    @Override
    public void addObserver(InventoryObserver observer) {
        if (observer != null) observers.add(observer);
    }

    // DESIGN PATTERN: Observer Pattern - Removes an observer
    @Override
    public void removeObserver(InventoryObserver observer) {
        observers.remove(observer);
    }

    // DESIGN PATTERN: Observer Pattern - Broadcasts state updates to all registered observers
    @Override
    public void notifyObservers(String partId, int currentQuantity) {
        for (InventoryObserver obs : observers) {
            obs.update(partId, currentQuantity);
        }
    }

    @Autowired
    private InventoryRepository inventoryRepository;

    @Autowired
    private PdfReportService pdfReportService;

    // Retrieves all items from repository
    @Override
    public List<InventoryItem> getAllInventoryItems() {
        return inventoryRepository.findAll();
    }

    // Retrieves specific item by part ID from repository
    @Override
    public Optional<InventoryItem> getInventoryItemById(String partId) {
        return inventoryRepository.findById(partId);
    }

    // Queries total stock count across entire depot
    @Override
    public int getTotalStockUnits() {
        return inventoryRepository.getTotalStockUnits();
    }

    // Calculates total valuation using polymorphic calculateValuation() calls
    @Override
    public double getTotalInventoryValuation() {
        return getAllInventoryItems().stream()
                .mapToDouble(InventoryItem::calculateValuation)
                .sum();
    }

    // Calculates remaining free capacity under MAX_WAREHOUSE_CAPACITY
    @Override
    public int getAvailableSpace() {
        int current = getTotalStockUnits();
        // DESIGN PATTERN: Singleton Pattern - Accesses centralized capacity limit from AppConfigManager
        int maxCap = com.sparepartmanagementsystem.core.AppConfigManager.getInstance().getMaxWarehouseCapacity();
        return Math.max(0, maxCap - current);
    }

    // Calculates warehouse storage fullness percentage
    @Override
    public int getCapacityPercentage() {
        int current = getTotalStockUnits();
        if (MAX_WAREHOUSE_CAPACITY <= 0) return 0;
        return (int) Math.min(100, Math.round(((double) current / MAX_WAREHOUSE_CAPACITY) * 100));
    }

    // Groups warehouse stock units into Racks A, B, C, and D
    @Override
    public Map<String, Integer> getRackQuantities(List<InventoryItem> items) {
        int rackA = 0, rackB = 0, rackC = 0, rackD = 0;
        for (InventoryItem item : items) {
            String loc = item.getStorageLocation().toUpperCase();
            if (loc.contains("RACK A") || loc.equals("A")) rackA += item.getQuantity();
            else if (loc.contains("RACK B") || loc.equals("B")) rackB += item.getQuantity();
            else if (loc.contains("RACK C") || loc.equals("C")) rackC += item.getQuantity();
            else if (loc.contains("RACK D") || loc.equals("D")) rackD += item.getQuantity();
            else rackA += item.getQuantity();
        }
        Map<String, Integer> racks = new HashMap<>();
        racks.put("A", rackA);
        racks.put("B", rackB);
        racks.put("C", rackC);
        racks.put("D", rackD);
        return racks;
    }

    // Queries pending restock requests awaiting procurement action
    @Override
    public List<RestockRequest> getPendingRestockRequests() {
        return inventoryRepository.findPendingRestockRequests();
    }

    // Queries part IDs currently pending restock fulfillment
    @Override
    public Set<String> getPendingRequestedPartIds() {
        return inventoryRepository.findPendingRequestedPartIds();
    }

    // DESIGN PATTERN: Strategy Pattern - Context reference to current active strategy
    private ReorderAlertStrategy alertStrategy = new StandardReorderStrategy();

    // DESIGN PATTERN: Strategy Pattern - Context setter to dynamically switch strategy at runtime
    @Override
    public void setAlertStrategy(ReorderAlertStrategy alertStrategy) {
        this.alertStrategy = (alertStrategy != null) ? alertStrategy : new StandardReorderStrategy();
    }

    // DESIGN PATTERN: Strategy Pattern - Client-facing method executing the active strategy
    @Override
    public List<InventoryItem> getReorderList() {
        return getAlertItemsWithStrategy(this.alertStrategy);
    }

    // DESIGN PATTERN: Strategy Pattern - filters alert items polymorphically
    @Override
    public List<InventoryItem> getAlertItemsWithStrategy(ReorderAlertStrategy strategy) {
        List<InventoryItem> allItems = getAllInventoryItems();
        Set<String> requestedPartIds = getPendingRequestedPartIds();
        List<InventoryItem> result = new ArrayList<>();

        for (InventoryItem item : allItems) {
            if (strategy.isAlertTriggered(item) && !requestedPartIds.contains(item.getPartId())) {
                result.add(item);
            }
        }
        return result;
    }

    // Sends a restock request to spare parts after validating quantity
    @Override
    public void sendRestockRequest(String partId, String partName, int currentQuantity, int requestedQuantity, String requestMessage) {
        if (requestedQuantity <= 0) {
            throw new InventoryException("Requested quantity must be at least 1 unit.");
        }
        String dateStr = LocalDate.now().toString();
        String message = (requestMessage != null && !requestMessage.isBlank()) ? requestMessage.trim() : "Stock running low, please supply.";
        inventoryRepository.insertRestockRequest(partId, partName, currentQuantity, requestedQuantity, message, dateStr);
    }

    // Queries supplier deliveries approved by QA ready for intake
    @Override
    public List<SupplierProduct> getApprovedSupplierProducts() {
        return inventoryRepository.findApprovedSupplierProducts();
    }

    // Performs warehouse intake checking warehouse and rack storage capacities
    @Override
    @Transactional
    public void intakeApprovedProduct(int batchId, String partId, String partName, int quantity,
                                      int reorderLevel, double unitPrice, String storageLocation) {
        if (quantity <= 0) {
            throw new InventoryException("Intake quantity must be greater than 0.");
        }

        // 1. Verify batch exists and is approved by quality inspection
        Optional<SupplierProduct> batchOpt = inventoryRepository.findSupplierProductById(batchId);
        if (batchOpt.isEmpty() || !batchOpt.get().isApproved()) {
            throw new InventoryException("Selected batch #" + batchId + " is not approved by Quality Inspection.");
        }

        SupplierProduct batch = batchOpt.get();
        if (quantity > batch.getAvailableQty()) {
            throw new InventoryException(String.format("Cannot intake %d units! Only %d available in batch.", quantity, batch.getAvailableQty()));
        }

        // 2. Validate warehouse total storage capacity (1000 units max)
        int currentStock = inventoryRepository.getTotalStockUnits();
        if (currentStock + quantity > MAX_WAREHOUSE_CAPACITY) {
            int freeSpace = Math.max(0, MAX_WAREHOUSE_CAPACITY - currentStock);
            throw new WarehouseCapacityExceededException(
                    "Warehouse Total Capacity Exceeded! Maximum storage is " + MAX_WAREHOUSE_CAPACITY + " units.",
                    quantity, freeSpace);
        }

        // 3. Validate rack storage capacity (250 units max per rack)
        String rackTerm = "A";
        if (storageLocation != null) {
            String loc = storageLocation.toUpperCase();
            if (loc.contains("B") || loc.equals("B")) rackTerm = "B";
            else if (loc.contains("C") || loc.equals("C")) rackTerm = "C";
            else if (loc.contains("D") || loc.equals("D")) rackTerm = "D";
        }
        int currentRackStock = inventoryRepository.getRackStockUnits(rackTerm);
        if (currentRackStock + quantity > RACK_CAPACITY) {
            int rackFreeSpace = Math.max(0, RACK_CAPACITY - currentRackStock);
            throw new WarehouseCapacityExceededException(
                    "Rack " + rackTerm + " Capacity Exceeded! Maximum storage per rack is " + RACK_CAPACITY + " units.",
                    quantity, rackFreeSpace);
        }

        // 4. Update or insert inventory item
        String cleanLocation = (storageLocation != null && !storageLocation.isBlank()) ? storageLocation.trim() : "Rack " + rackTerm + "-01";
        if (inventoryRepository.existsById(partId)) {
            inventoryRepository.increaseStockAndDetails(partId.trim(), quantity, unitPrice, reorderLevel, cleanLocation);
        } else {
            inventoryRepository.insertItem(partId.trim(), partName.trim(), quantity, reorderLevel, unitPrice, cleanLocation);
        }

        // 5. Deduct quantity from batch and fulfill pending restock request
        inventoryRepository.deductSupplierProductAvailableQty(batchId, quantity);
        inventoryRepository.fulfillPendingRestockRequest(partId);
    }

    // Dispatches stock units checking current availability
    @Override
    @Transactional
    public void dispatchStock(String partId, int amount) {
        if (amount <= 0) {
            throw new InventoryException("Dispatch quantity must be greater than 0.");
        }
        Optional<InventoryItem> itemOpt = inventoryRepository.findById(partId);
        if (itemOpt.isEmpty()) {
            throw new InventoryException("Part '" + partId + "' not found in inventory!");
        }
        InventoryItem item = itemOpt.get();
        if (amount > item.getQuantity()) {
            throw new InsufficientStockException(partId, amount, item.getQuantity());
        }
        inventoryRepository.dispatchStock(partId.trim(), amount);
        // DESIGN PATTERN: Observer Pattern - Notifies observers of decremented stock level
        notifyObservers(partId.trim(), item.getQuantity() - amount);
    }

    // Edits existing part metadata in repository
    @Override
    public boolean editPart(String partId, String partName, int reorderLevel, double unitPrice, String storageLocation) {
        String cleanLoc = (storageLocation != null && !storageLocation.isBlank()) ? storageLocation.trim() : "Rack A-01";
        int rows = inventoryRepository.updateItem(partId.trim(), partName.trim(), reorderLevel, unitPrice, cleanLoc);
        return rows > 0;
    }

    // Deletes an inventory part by its ID
    @Override
    public boolean deletePart(String partId) {
        int rows = inventoryRepository.deleteById(partId.trim());
        return rows > 0;
    }

    // DESIGN PATTERN: Factory Pattern - compiles report using InventoryReportFactory
    @Override
    public String compileReportPreview(String reportType, String fromDate, String toDate, String notes) {
        List<InventoryItem> items = getAllInventoryItems();
        return InventoryReportFactory.createReportContent(reportType, items, MAX_WAREHOUSE_CAPACITY, RACK_CAPACITY, fromDate, toDate, notes);
    }

    // Creates and dispatches an inventory report record to Admin
    @Override
    public InventoryReport dispatchReportToAdmin(String title, String type, String fromDate, String toDate, String content, String notes) {
        if (title == null || title.isBlank()) {
            title = (type != null && !type.isBlank() ? type : "Warehouse Inventory Report") + " [Audit Report]";
        }
        if (content == null || content.isBlank()) {
            content = compileReportPreview(type, fromDate, toDate, notes);
        }

        InventoryReport report = new InventoryReport();
        report.setReportTitle(title.trim());
        report.setReportType(type != null ? type.trim() : "Warehouse Inventory Report");
        report.setFromDate(fromDate != null && !fromDate.isBlank() ? fromDate.trim() : "All");
        report.setToDate(toDate != null && !toDate.isBlank() ? toDate.trim() : "Current");
        report.setGeneratedBy("Inventory Admin");
        report.setReportContent(content);
        report.setStatus("Pending Admin Review");
        report.setNotes(notes != null ? notes.trim() : "");

        inventoryRepository.saveInventoryReport(report);
        return report;
    }

    // Queries all reports submitted for admin review
    @Override
    public List<InventoryReport> getAllSubmittedReports() {
        return inventoryRepository.findAllInventoryReports();
    }

    // Queries report by primary key record ID
    @Override
    public Optional<InventoryReport> getReportById(Long id) {
        return inventoryRepository.findInventoryReportById(id);
    }

    // Deletes report by record ID
    @Override
    public void deleteReport(Long id) {
        inventoryRepository.deleteInventoryReport(id);
    }

    // Queries available report templates
    @Override
    public List<ReportTemplate> getAllTemplates() {
        return inventoryRepository.findAllReportTemplates();
    }

    // Generates PDF document bytes for a saved report
    @Override
    public byte[] generateReportPdf(InventoryReport report) {
        return pdfReportService.generateInventoryReportPdf(report);
    }

    // Generates PDF document bytes directly from raw report preview text
    @Override
    public byte[] generateRawContentPdf(String title, String type, String notes, String content) {
        return pdfReportService.generateRawContentPdf(title, type, notes, content);
    }
}
