package com.sparepartmanagementsystem.inventory;

import com.sparepartmanagementsystem.reportmanager.ReportTemplate;
import com.sparepartmanagementsystem.procurement.SupplierProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;



//Implements database queries for InventoryRepository using Spring's JdbcTemplate.

@Repository
public class InventoryRepositoryImpl implements InventoryRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // Fetches all inventory items ordered by part ID
    @Override
    public List<InventoryItem> findAll() {
        String sql = "SELECT * FROM inventory ORDER BY part_id ASC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            String loc = "Rack A-01";
            try {
                loc = rs.getString("storage_location");
                if (loc == null || loc.trim().isEmpty()) loc = "Rack A-01";
            } catch (Exception ignored) {}
            return new InventoryItem(
                    rs.getString("part_id"),
                    rs.getString("part_name"),
                    rs.getInt("quantity"),
                    rs.getInt("reorder_level"),
                    rs.getDouble("unit_price"),
                    loc
            );
        });
    }

    // Fetches a single inventory item matching the given part ID
    @Override
    public Optional<InventoryItem> findById(String partId) {
        String sql = "SELECT * FROM inventory WHERE part_id = ?";
        List<InventoryItem> items = jdbcTemplate.query(sql, (rs, rowNum) -> {
            String loc = "Rack A-01";
            try {
                loc = rs.getString("storage_location");
                if (loc == null || loc.trim().isEmpty()) loc = "Rack A-01";
            } catch (Exception ignored) {}
            return new InventoryItem(
                    rs.getString("part_id"),
                    rs.getString("part_name"),
                    rs.getInt("quantity"),
                    rs.getInt("reorder_level"),
                    rs.getDouble("unit_price"),
                    loc
            );
        }, partId != null ? partId.trim() : "");
        return items.isEmpty() ? Optional.empty() : Optional.of(items.get(0));
    }

    // Checks whether an item ID already exists in the database table
    @Override
    public boolean existsById(String partId) {
        String sql = "SELECT COUNT(*) FROM inventory WHERE part_id = ?";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, partId != null ? partId.trim() : "");
        return count != null && count > 0;
    }

    // Inserts a new inventory record into the inventory table
    @Override
    public int insertItem(String partId, String partName, int quantity, int reorderLevel, double unitPrice, String storageLocation) {
        String sql = "INSERT INTO inventory (part_id, part_name, quantity, reorder_level, unit_price, storage_location) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, partId.trim(), partName.trim(), quantity, reorderLevel, unitPrice, storageLocation.trim());
    }

    // Updates name, threshold, price, and rack for an existing item
    @Override
    public int updateItem(String partId, String partName, int reorderLevel, double unitPrice, String storageLocation) {
        String sql = "UPDATE inventory SET part_name = ?, reorder_level = ?, unit_price = ?, storage_location = ? WHERE part_id = ?";
        return jdbcTemplate.update(sql, partName.trim(), reorderLevel, unitPrice, storageLocation.trim(), partId.trim());
    }

    // Increments stock quantity and updates unit price and location
    @Override
    public int increaseStockAndDetails(String partId, int quantity, double unitPrice, int reorderLevel, String storageLocation) {
        String sql = "UPDATE inventory SET quantity = quantity + ?, unit_price = ?, reorder_level = ?, storage_location = ? WHERE part_id = ?";
        return jdbcTemplate.update(sql, quantity, unitPrice, reorderLevel, storageLocation.trim(), partId.trim());
    }

    // Decrements stock quantity ensuring quantity never drops below zero
    @Override
    public int dispatchStock(String partId, int amount) {
        String sql = "UPDATE inventory SET quantity = CASE WHEN (quantity - ?) < 0 THEN 0 ELSE (quantity - ?) END WHERE part_id = ?";
        return jdbcTemplate.update(sql, amount, amount, partId.trim());
    }

    // Removes an inventory item completely from the database
    @Override
    public int deleteById(String partId) {
        String sql = "DELETE FROM inventory WHERE part_id = ?";
        return jdbcTemplate.update(sql, partId.trim());
    }

    // Queries total sum of physical units stored across the entire warehouse
    @Override
    public int getTotalStockUnits() {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM inventory";
        Integer stock = jdbcTemplate.queryForObject(sql, Integer.class);
        return stock != null ? stock : 0;
    }

    // Queries total units currently allocated to a specific rack shelf
    @Override
    public int getRackStockUnits(String rackLetter) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM inventory WHERE UPPER(storage_location) LIKE '%" + rackLetter.toUpperCase() + "%'";
        Integer stock = jdbcTemplate.queryForObject(sql, Integer.class);
        return stock != null ? stock : 0;
    }

    // Queries all pending restock requests submitted by warehouse to spare parts
    @Override
    public List<RestockRequest> findPendingRestockRequests() {
        try {
            String sql = "SELECT * FROM restock_requests WHERE status = 'PENDING' ORDER BY request_id DESC";
            return jdbcTemplate.query(sql, (rs, rowNum) -> new RestockRequest(
                    rs.getInt("request_id"),
                    rs.getString("part_id"),
                    rs.getString("part_name"),
                    rs.getInt("current_quantity"),
                    rs.getInt("requested_quantity"),
                    rs.getString("request_message"),
                    rs.getString("request_date"),
                    rs.getString("status")
            ));
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    // Collects set of part IDs currently awaiting supply replenishment
    @Override
    public Set<String> findPendingRequestedPartIds() {
        Set<String> ids = new HashSet<>();
        for (RestockRequest req : findPendingRestockRequests()) {
            if (req.getPartId() != null) {
                ids.add(req.getPartId().trim());
            }
        }
        return ids;
    }

    // Inserts a new pending restock request into the restock_requests table
    @Override
    public int insertRestockRequest(String partId, String partName, int currentQty, int requestedQty, String message, String dateStr) {
        String sql = "INSERT INTO restock_requests (part_id, part_name, current_quantity, requested_quantity, request_message, request_date, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'PENDING')";
        return jdbcTemplate.update(sql, partId.trim(), partName.trim(), currentQty, requestedQty, message.trim(), dateStr);
    }

    // Marks pending restock request for part as fulfilled upon successful intake
    @Override
    public int fulfillPendingRestockRequest(String partId) {
        try {
            return jdbcTemplate.update("UPDATE restock_requests SET status = 'FULFILLED' WHERE part_id = ? AND status = 'PENDING'", partId.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    // Queries all supplier deliveries certified as APPROVED by QA with available units
    @Override
    public List<SupplierProduct> findApprovedSupplierProducts() {
        try {
            String sql = "SELECT * FROM supplier_products WHERE quality_status = 'APPROVED' AND available_qty > 0 ORDER BY batch_id ASC";
            return jdbcTemplate.query(sql, (rs, rowNum) -> new SupplierProduct(
                    rs.getInt("batch_id"),
                    rs.getString("part_id"),
                    rs.getString("part_name"),
                    rs.getString("supplier_name"),
                    rs.getInt("received_qty"),
                    rs.getInt("available_qty"),
                    rs.getDouble("supplier_price"),
                    rs.getString("quality_status"),
                    rs.getString("quality_notes"),
                    rs.getString("arrival_date")
            ));
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    // Queries specific supplier delivery batch by its primary key batch ID
    @Override
    public Optional<SupplierProduct> findSupplierProductById(int batchId) {
        try {
            String sql = "SELECT * FROM supplier_products WHERE batch_id = ?";
            List<SupplierProduct> list = jdbcTemplate.query(sql, (rs, rowNum) -> new SupplierProduct(
                    rs.getInt("batch_id"),
                    rs.getString("part_id"),
                    rs.getString("part_name"),
                    rs.getString("supplier_name"),
                    rs.getInt("received_qty"),
                    rs.getInt("available_qty"),
                    rs.getDouble("supplier_price"),
                    rs.getString("quality_status"),
                    rs.getString("quality_notes"),
                    rs.getString("arrival_date")
            ), batchId);
            return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
        } catch (Exception e) {
            return Optional.empty();
        }
    }

    // Deducts intake quantity from available units in the supplier delivery batch
    @Override
    public int deductSupplierProductAvailableQty(int batchId, int quantity) {
        String sql = "UPDATE supplier_products SET available_qty = available_qty - ? WHERE batch_id = ?";
        return jdbcTemplate.update(sql, quantity, batchId);
    }

    // Saves a newly generated warehouse audit report to inventory_reports table
    @Override
    public void saveInventoryReport(InventoryReport report) {
        String generated = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        jdbcTemplate.update(
                "INSERT INTO inventory_reports (report_title, report_type, from_date, to_date, generated_by, generated_date, report_content, status, notes) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                report.getReportTitle(),
                report.getReportType(),
                report.getFromDate(),
                report.getToDate(),
                report.getGeneratedBy() != null ? report.getGeneratedBy() : "Inventory Admin",
                generated,
                report.getReportContent(),
                report.getStatus() != null ? report.getStatus() : "Pending Admin Review",
                report.getNotes() != null ? report.getNotes() : ""
        );
    }

    // Queries all inventory reports in descending order of generation
    @Override
    public List<InventoryReport> findAllInventoryReports() {
        String sql = "SELECT report_id, report_title, report_type, from_date, to_date, generated_by, generated_date, report_content, status, notes " +
                "FROM inventory_reports ORDER BY report_id DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new InventoryReport(
                rs.getLong("report_id"),
                rs.getString("report_title"),
                rs.getString("report_type"),
                rs.getString("from_date"),
                rs.getString("to_date"),
                rs.getString("generated_by"),
                rs.getString("generated_date"),
                rs.getString("report_content"),
                rs.getString("status"),
                rs.getString("notes")
        ));
    }

    // Queries a specific inventory report record by its primary key ID
    @Override
    public Optional<InventoryReport> findInventoryReportById(Long reportId) {
        String sql = "SELECT report_id, report_title, report_type, from_date, to_date, generated_by, generated_date, report_content, status, notes " +
                "FROM inventory_reports WHERE report_id = ?";
        List<InventoryReport> list = jdbcTemplate.query(sql, (rs, rowNum) -> new InventoryReport(
                rs.getLong("report_id"),
                rs.getString("report_title"),
                rs.getString("report_type"),
                rs.getString("from_date"),
                rs.getString("to_date"),
                rs.getString("generated_by"),
                rs.getString("generated_date"),
                rs.getString("report_content"),
                rs.getString("status"),
                rs.getString("notes")
        ), reportId);
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    // Deletes an inventory report from the inventory_reports table
    @Override
    public void deleteInventoryReport(Long reportId) {
        jdbcTemplate.update("DELETE FROM inventory_reports WHERE report_id = ?", reportId);
    }

    // Queries all active report templates from the database
    @Override
    public List<ReportTemplate> findAllReportTemplates() {
        try {
            String sql = "SELECT id, template_name, template_filters, created_at FROM report_template ORDER BY id ASC";
            return jdbcTemplate.query(sql, (rs, rowNum) -> new ReportTemplate(
                    rs.getLong("id"),
                    rs.getString("template_name"),
                    rs.getString("template_filters"),
                    rs.getString("created_at")
            ));
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }
}
