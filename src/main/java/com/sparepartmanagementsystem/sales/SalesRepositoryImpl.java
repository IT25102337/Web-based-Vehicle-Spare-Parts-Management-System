package com.sparepartmanagementsystem.sales;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import java.sql.PreparedStatement;
import java.sql.Statement;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface Implementation (Repository Pattern)
 * UML RELATIONSHIP: Association (SalesRepositoryImpl associates with Spring JdbcTemplate)
 * Implements database persistence for the Sales management module.
 */
@Repository
public class SalesRepositoryImpl implements SalesRepository {

    // UML RELATIONSHIP: Association
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Initializes database tables for sales orders and order items
    @Override
    public void initSchema() {
        try {
            jdbcTemplate.execute(
                "IF OBJECT_ID('sales_orders', 'U') IS NULL " +
                "CREATE TABLE sales_orders (" +
                "  order_id   INT IDENTITY(1,1) PRIMARY KEY, " +
                "  customer_name NVARCHAR(200) NOT NULL, " +
                "  order_date    NVARCHAR(50), " +
                "  total_amount  FLOAT DEFAULT 0, " +
                "  status        NVARCHAR(30) DEFAULT 'PENDING', " +
                "  notes         NVARCHAR(1000) " +
                ")");
        } catch (Exception ignored) {}

        try {
            jdbcTemplate.execute(
                "IF OBJECT_ID('order_items', 'U') IS NULL " +
                "CREATE TABLE order_items (" +
                "  item_id    INT IDENTITY(1,1) PRIMARY KEY, " +
                "  order_id   INT, " +
                "  part_id    NVARCHAR(50), " +
                "  part_name  NVARCHAR(200), " +
                "  quantity   INT, " +
                "  unit_price FLOAT, " +
                "  line_total FLOAT " +
                ")");
        } catch (Exception ignored) {}
    }

    // Retrieves all sales orders mapped into SalesOrder entity objects
    @Override
    public List<SalesOrder> findAllOrders() {
        String sql = "SELECT * FROM sales_orders ORDER BY order_id DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> {
            SalesOrder order = new SalesOrder(
                rs.getInt("order_id"),
                rs.getString("customer_name"),
                rs.getString("order_date"),
                rs.getDouble("total_amount"),
                rs.getString("status"),
                rs.getString("notes")
            );
            return order;
        });
    }

    // Retrieves raw order map list for dashboard view rendering
    @Override
    public List<Map<String, Object>> findAllOrdersAsMap() {
        return jdbcTemplate.queryForList("SELECT * FROM sales_orders ORDER BY order_id DESC");
    }

    // Retrieves individual order by its primary key
    @Override
    public Optional<SalesOrder> findOrderById(int orderId) {
        String sql = "SELECT * FROM sales_orders WHERE order_id = ?";
        List<SalesOrder> orders = jdbcTemplate.query(sql, (rs, rowNum) -> new SalesOrder(
            rs.getInt("order_id"),
            rs.getString("customer_name"),
            rs.getString("order_date"),
            rs.getDouble("total_amount"),
            rs.getString("status"),
            rs.getString("notes")
        ), orderId);
        return orders.isEmpty() ? Optional.empty() : Optional.of(orders.get(0));
    }

    // Retrieves composite line items belonging to a specific order
    @Override
    public List<OrderItem> findOrderItems(int orderId) {
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new OrderItem(
            rs.getInt("item_id"),
            rs.getInt("order_id"),
            rs.getString("part_id"),
            rs.getString("part_name"),
            rs.getInt("quantity"),
            rs.getDouble("unit_price"),
            rs.getDouble("line_total")
        ), orderId);
    }

    // Retrieves composite line items as map list for modal rendering
    @Override
    public List<Map<String, Object>> findOrderItemsAsMap(int orderId) {
        return jdbcTemplate.queryForList("SELECT * FROM order_items WHERE order_id = ?", orderId);
    }

    // Persists a newly placed sales order returning generated primary key
    @Override
    public int createOrder(String customerName, String orderDate, double totalAmount, String status, String notes) {
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(con -> {
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO sales_orders (customer_name, order_date, total_amount, status, notes) VALUES (?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, customerName);
            ps.setString(2, orderDate);
            ps.setDouble(3, totalAmount);
            ps.setString(4, status);
            ps.setString(5, notes);
            return ps;
        }, keyHolder);

        Number key = keyHolder.getKey();
        return key != null ? key.intValue() : 0;
    }

    // Persists an individual item row linked to a parent sales order
    @Override
    public int createOrderItem(int orderId, String partId, String partName, int quantity, double unitPrice, double lineTotal) {
        String sql = "INSERT INTO order_items (order_id, part_id, part_name, quantity, unit_price, line_total) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, orderId, partId, partName, quantity, unitPrice, lineTotal);
    }

    // Updates the workflow status and audit notes of a sales order
    @Override
    public int updateOrderStatus(int orderId, String status, String notes) {
        if (notes != null && !notes.isBlank()) {
            return jdbcTemplate.update(
                "UPDATE sales_orders SET status = ?, notes = CONCAT(ISNULL(notes,''), ?) WHERE order_id = ?",
                status, notes, orderId);
        }
        return jdbcTemplate.update("UPDATE sales_orders SET status = ? WHERE order_id = ?", status, orderId);
    }

    // Deletes an order and its cascaded line items from the database
    @Override
    public int deleteOrder(int orderId) {
        jdbcTemplate.update("DELETE FROM order_items WHERE order_id = ?", orderId);
        return jdbcTemplate.update("DELETE FROM sales_orders WHERE order_id = ?", orderId);
    }

    // Aggregates total order count matching specific status filter
    @Override
    public int countOrdersByStatus(String status) {
        if (status == null || status.isBlank()) {
            Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM sales_orders", Integer.class);
            return count != null ? count : 0;
        }
        Integer count = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM sales_orders WHERE status = ?", Integer.class, status.toUpperCase());
        return count != null ? count : 0;
    }

    // Sums the gross monetary value of orders matching specific status
    @Override
    public double sumRevenueByStatus(String status) {
        Double sum = jdbcTemplate.queryForObject(
            "SELECT ISNULL(SUM(total_amount), 0) FROM sales_orders WHERE status = ?", Double.class, status.toUpperCase());
        return sum != null ? sum : 0.0;
    }

    // Queries top selling spare parts by volume and commercial revenue
    @Override
    public List<Map<String, Object>> findTopSellingParts(int limit) {
        String sql = String.format(
            "SELECT TOP %d part_id, part_name, SUM(quantity) as total_qty, SUM(line_total) as total_sales " +
            "FROM order_items GROUP BY part_id, part_name ORDER BY total_sales DESC", limit);
        return jdbcTemplate.queryForList(sql);
    }

    // Queries sales audit reports submitted to the Administrator
    @Override
    public List<Map<String, Object>> findSalesReports() {
        return jdbcTemplate.queryForList(
            "SELECT * FROM inventory_reports WHERE generated_by LIKE '%Sales%' OR report_type LIKE '%Sales%' ORDER BY report_id DESC");
    }

    // Persists a newly compiled commercial sales report for executive review
    @Override
    public int saveSalesReport(String reportTitle, String startDate, String endDate, String author, String date, String content, String notes) {
        String sql = "INSERT INTO inventory_reports (report_title, report_type, from_date, to_date, generated_by, generated_date, report_content, status, notes) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, 'Pending Admin Review', ?)";
        return jdbcTemplate.update(sql, reportTitle, "Sales & Revenue Performance", startDate, endDate, author, date, content, notes);
    }
}
