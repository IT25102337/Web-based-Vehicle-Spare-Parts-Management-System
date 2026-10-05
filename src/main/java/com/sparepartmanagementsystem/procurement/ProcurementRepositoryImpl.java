package com.sparepartmanagementsystem.procurement;

import com.sparepartmanagementsystem.inventory.RestockRequest;
import com.sparepartmanagementsystem.supplier.Supplier;
import com.sparepartmanagementsystem.supplier.SupplierOrder;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface Implementation (Repository Pattern)
 * UML RELATIONSHIP: Association (ProcurementRepositoryImpl associates with JdbcTemplate)
 * Implements database queries for spare parts procurement and quality inspection.
 */
@Repository
public class ProcurementRepositoryImpl implements ProcurementRepository {

    // UML RELATIONSHIP: Association
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Retrieves all supplier product delivery batches sorted by newest first
    @Override
    public List<SupplierProduct> findAllSupplierProducts() {
        String sql = "SELECT * FROM supplier_products ORDER BY batch_id DESC";
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
    }

    // Retrieves a single supplier product batch by its batch ID
    @Override
    public Optional<SupplierProduct> findSupplierProductById(int batchId) {
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
    }

    // Inserts a new incoming supplier delivery batch awaiting quality inspection
    @Override
    public int insertSupplierProduct(String partId, String partName, String supplierName, int receivedQty, double supplierPrice, String arrivalDate) {
        String sql = "INSERT INTO supplier_products (part_id, part_name, supplier_name, received_qty, available_qty, supplier_price, quality_status, quality_notes, arrival_date) " +
                     "VALUES (?, ?, ?, ?, ?, ?, 'PENDING', 'Awaiting Quality Inspection', ?)";
        return jdbcTemplate.update(sql, partId.trim(), partName.trim(), supplierName.trim(), receivedQty, receivedQty, supplierPrice, arrivalDate);
    }

    // Updates quality status, notes, and remaining available quantity for a batch
    @Override
    public int updateQualityStatus(int batchId, String qualityStatus, String qualityNotes, int availableQty) {
        String sql = "UPDATE supplier_products SET quality_status = ?, quality_notes = ?, available_qty = ? WHERE batch_id = ?";
        return jdbcTemplate.update(sql, qualityStatus, qualityNotes.trim(), availableQty, batchId);
    }

    // Permanently removes a supplier product delivery batch from the database
    @Override
    public int deleteSupplierProduct(int batchId) {
        String sql = "DELETE FROM supplier_products WHERE batch_id = ?";
        return jdbcTemplate.update(sql, batchId);
    }

    // Retrieves all pending restock requests submitted by warehouse inventory
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

    // Retrieves all registered suppliers in the system
    @Override
    public List<Supplier> findAllSuppliers() {
        try {
            String sql = "SELECT * FROM suppliers ORDER BY supplier_name ASC";
            return jdbcTemplate.query(sql, (rs, rowNum) -> new Supplier(
                    rs.getInt("supplier_id"),
                    rs.getString("supplier_name"),
                    rs.getString("contact_person"),
                    rs.getString("email"),
                    rs.getString("phone"),
                    rs.getString("category"),
                    rs.getString("address"),
                    rs.getString("status"),
                    rs.getString("created_at")
            ));
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    // Retrieves all purchase orders dispatched to suppliers
    @Override
    public List<SupplierOrder> findAllSupplierOrders() {
        try {
            String sql = "SELECT * FROM supplier_orders ORDER BY order_id DESC";
            return jdbcTemplate.query(sql, (rs, rowNum) -> new SupplierOrder(
                    rs.getInt("order_id"),
                    (Integer) rs.getObject("restock_request_id"),
                    rs.getString("part_id"),
                    rs.getString("part_name"),
                    rs.getString("supplier_name"),
                    rs.getInt("requested_qty"),
                    rs.getDouble("expected_price"),
                    rs.getString("status"),
                    rs.getString("order_date"),
                    rs.getString("delivery_notes"),
                    rs.getString("requested_by")
            ));
        } catch (Exception e) {
            return new ArrayList<>();
        }
    }

    // Deletes an order from the supplier procurement pipeline
    @Override
    public int deleteSupplierOrder(int orderId) {
        String sql = "DELETE FROM supplier_orders WHERE order_id = ?";
        return jdbcTemplate.update(sql, orderId);
    }
}
