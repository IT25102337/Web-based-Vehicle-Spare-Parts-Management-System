package com.sparepartmanagementsystem.supplier;

import com.sparepartmanagementsystem.procurement.SupplierProduct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface Implementation (Repository Pattern)
 * UML RELATIONSHIP: Association (SupplierRepositoryImpl associates with JdbcTemplate)
 * Implements database persistence for automotive suppliers and portal purchase orders.
 */
@Repository
public class SupplierRepositoryImpl implements SupplierRepository {

    // UML RELATIONSHIP: Association
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Initializes database tables and default seed data for suppliers and orders
    @Override
    public void initSchema() {
        try {
            jdbcTemplate.execute(
                "IF OBJECT_ID('suppliers', 'U') IS NULL " +
                "CREATE TABLE suppliers (" +
                "  supplier_id    INT IDENTITY(1,1) PRIMARY KEY, " +
                "  supplier_name  NVARCHAR(150) NOT NULL, " +
                "  contact_person NVARCHAR(150), " +
                "  email          NVARCHAR(150), " +
                "  phone          NVARCHAR(50), " +
                "  category       NVARCHAR(100), " +
                "  address        NVARCHAR(255), " +
                "  status         NVARCHAR(30) DEFAULT 'ACTIVE', " +
                "  created_at     NVARCHAR(50) " +
                ")");
        } catch (Exception ignored) {}

        try {
            Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM suppliers", Integer.class);
            if (count == null || count == 0) {
                String now = LocalDate.now().toString();
                createSupplier("Apex Auto Components Ltd", "Sunil Perera", "supplier@apexparts.com", "+94 77 123 4567",
                        "Engine & Transmission", "No. 45, Panchikawatta Rd, Colombo 10", "ACTIVE", now);
                createSupplier("Brembo Brake Systems Global", "Marcus Silva", "orders@brembosouthasia.com", "+94 71 987 6543",
                        "Braking Systems", "Level 4, Orion City, Colombo 09", "ACTIVE", now);
                createSupplier("Denso OEM Genuine Parts", "Takeshi Tanaka", "denso.supply@denso-parts.com", "+94 76 555 4321",
                        "OEM Electrical & Sensors", "Plot 18, Biyagama Export Processing Zone", "ACTIVE", now);
                createSupplier("Titan Heavy Wheels & Tyres", "Roshan Fernando", "titan@titanwheels.lk", "+94 70 888 9999",
                        "Wheels & Suspension", "210 Negombo Road, Wattala", "ACTIVE", now);
            }
        } catch (Exception ignored) {}

        try {
            jdbcTemplate.execute(
                "IF OBJECT_ID('supplier_orders', 'U') IS NULL " +
                "CREATE TABLE supplier_orders (" +
                "  order_id           INT IDENTITY(1,1) PRIMARY KEY, " +
                "  restock_request_id INT NULL, " +
                "  part_id            NVARCHAR(50) NOT NULL, " +
                "  part_name          NVARCHAR(150) NOT NULL, " +
                "  supplier_name      NVARCHAR(150) NOT NULL, " +
                "  requested_qty      INT NOT NULL, " +
                "  expected_price     FLOAT DEFAULT 0, " +
                "  status             NVARCHAR(30) DEFAULT 'PENDING', " +
                "  order_date         NVARCHAR(50), " +
                "  delivery_notes     NVARCHAR(500), " +
                "  requested_by       NVARCHAR(100) " +
                ")");
        } catch (Exception ignored) {}

        try {
            Integer exists = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM users WHERE LOWER(username) = 'supplier'", Integer.class);
            if (exists == null || exists == 0) {
                String created = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
                jdbcTemplate.update(
                    "INSERT INTO users (username, password, full_name, email, role, created_at) VALUES (?, ?, ?, ?, ?, ?)",
                    "supplier", "supplier123", "Apex Auto Components (Supplier)", "supplier@apexparts.com", "SUPPLIER", created);
            }
        } catch (Exception ignored) {}
    }

    // Retrieves all suppliers ordered alphabetically
    @Override
    public List<Supplier> findAllSuppliers() {
        try {
            String sql = "SELECT * FROM suppliers ORDER BY supplier_id ASC";
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

    // Retrieves a single supplier by its primary key ID
    @Override
    public Optional<Supplier> findSupplierById(int supplierId) {
        String sql = "SELECT * FROM suppliers WHERE supplier_id = ?";
        List<Supplier> list = jdbcTemplate.query(sql, (rs, rowNum) -> new Supplier(
            rs.getInt("supplier_id"),
            rs.getString("supplier_name"),
            rs.getString("contact_person"),
            rs.getString("email"),
            rs.getString("phone"),
            rs.getString("category"),
            rs.getString("address"),
            rs.getString("status"),
            rs.getString("created_at")
        ), supplierId);
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    // Inserts a new supplier company record into the database
    @Override
    public int createSupplier(String supplierName, String contactPerson, String email, String phone, String category, String address, String status, String createdAt) {
        String sql = "INSERT INTO suppliers (supplier_name, contact_person, email, phone, category, address, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, supplierName.trim(), contactPerson.trim(), email.trim(), phone.trim(), category.trim(), address.trim(), status.trim().toUpperCase(), createdAt);
    }

    // Updates supplier business details and operational status
    @Override
    public int updateSupplier(int supplierId, String supplierName, String contactPerson, String email, String phone, String category, String address, String status) {
        String sql = "UPDATE suppliers SET supplier_name = ?, contact_person = ?, email = ?, phone = ?, category = ?, address = ?, status = ? WHERE supplier_id = ?";
        return jdbcTemplate.update(sql, supplierName.trim(), contactPerson.trim(), email.trim(), phone.trim(), category.trim(), address.trim(), status.trim().toUpperCase(), supplierId);
    }

    // Permanently removes a supplier record from the database
    @Override
    public int deleteSupplier(int supplierId) {
        return jdbcTemplate.update("DELETE FROM suppliers WHERE supplier_id = ?", supplierId);
    }

    // Retrieves all purchase requests dispatched to suppliers
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

    // Retrieves a single purchase order by its primary key
    @Override
    public Optional<SupplierOrder> findSupplierOrderById(int orderId) {
        String sql = "SELECT * FROM supplier_orders WHERE order_id = ?";
        List<SupplierOrder> list = jdbcTemplate.query(sql, (rs, rowNum) -> new SupplierOrder(
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
        ), orderId);
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    // Persists a newly created purchase order to a supplier
    @Override
    public int createSupplierOrder(Integer restockRequestId, String partId, String partName, String supplierName, int requestedQty, double expectedPrice, String status, String orderDate, String deliveryNotes, String requestedBy) {
        String sql = "INSERT INTO supplier_orders (restock_request_id, part_id, part_name, supplier_name, requested_qty, expected_price, status, order_date, delivery_notes, requested_by) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, restockRequestId, partId.trim().toUpperCase(), partName.trim(), supplierName.trim(), requestedQty, expectedPrice, status, orderDate, deliveryNotes.trim(), requestedBy);
    }

    // Updates the dispatch or rejection status of a supplier order
    @Override
    public int updateSupplierOrderStatus(int orderId, String status, String deliveryNotes) {
        String sql = "UPDATE supplier_orders SET status = ?, delivery_notes = ? WHERE order_id = ?";
        return jdbcTemplate.update(sql, status, deliveryNotes, orderId);
    }

    // Registers a newly dispatched delivery batch in the QA inspection table
    @Override
    public int createSupplierProductBatch(String partId, String partName, String supplierName, int receivedQty, double supplierPrice, String qaNotes, String arrivalDate) {
        String sql = "INSERT INTO supplier_products (part_id, part_name, supplier_name, received_qty, available_qty, supplier_price, quality_status, quality_notes, arrival_date) VALUES (?, ?, ?, ?, ?, ?, 'PENDING', ?, ?)";
        return jdbcTemplate.update(sql, partId, partName, supplierName, receivedQty, receivedQty, supplierPrice, qaNotes, arrivalDate);
    }

    // Updates workflow status of linked warehouse restock requests
    @Override
    public int updateRestockRequestStatus(int requestId, String status) {
        return jdbcTemplate.update("UPDATE restock_requests SET status = ? WHERE request_id = ?", status, requestId);
    }

    // Queries active delivery batches undergoing quality inspection
    @Override
    public List<SupplierProduct> findActiveDeliveries() {
        try {
            String sql = "SELECT * FROM supplier_products WHERE NOT (quality_status = 'APPROVED' AND available_qty <= 0) ORDER BY batch_id DESC";
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
}
