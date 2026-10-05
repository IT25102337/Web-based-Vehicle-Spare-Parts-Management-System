package com.sparepartmanagementsystem.customer;

import com.sparepartmanagementsystem.inventory.InventoryItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface Implementation (Repository Layer)
 * Implements database queries for CustomerRepository using Spring's JdbcTemplate.
 */
@Repository
public class CustomerRepositoryImpl implements CustomerRepository {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Queries user account by matching username or email address
    @Override
    public Optional<UserAccount> findByUsernameOrEmail(String identifier) {
        String sql = "SELECT user_id, username, password, full_name, email, role, phone, status, created_at FROM users WHERE LOWER(username) = LOWER(?) OR LOWER(email) = LOWER(?)";
        List<UserAccount> users = jdbcTemplate.query(sql, (rs, rowNum) -> {
            String phone = "+94 77 123 4567";
            String status = "ACTIVE";
            try { phone = rs.getString("phone"); } catch (Exception ignored) {}
            try { status = rs.getString("status"); } catch (Exception ignored) {}
            return new UserAccount(
                    rs.getInt("user_id"),
                    rs.getString("username"),
                    rs.getString("password"),
                    rs.getString("full_name"),
                    rs.getString("email"),
                    rs.getString("role"),
                    (phone != null && !phone.isBlank() ? phone : "+94 77 123 4567"),
                    (status != null && !status.isBlank() ? status : "ACTIVE"),
                    rs.getString("created_at")
            );
        }, identifier.trim(), identifier.trim());
        return users.isEmpty() ? Optional.empty() : Optional.of(users.get(0));
    }

    // Checks if the given username already exists in users table
    @Override
    public boolean isUsernameTaken(String username) {
        String sql = "SELECT COUNT(*) FROM users WHERE LOWER(username) = LOWER(?)";
        Integer count = jdbcTemplate.queryForObject(sql, Integer.class, username.trim());
        return count != null && count > 0;
    }

    // Inserts a new customer or staff account into users table
    @Override
    public int createUser(String username, String password, String fullName, String email, String role, String createdAt) {
        String sql = "INSERT INTO users (username, password, full_name, email, role, created_at) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, username.trim(), password, fullName.trim(), email.trim(), role.toUpperCase(), createdAt);
    }

    // Retrieves all inventory items sorted by name for store catalog
    @Override
    public List<InventoryItem> findCatalogProducts() {
        String sql = "SELECT * FROM inventory ORDER BY part_name ASC";
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

    // Queries current stock count for a given part SKU
    @Override
    public Integer getPartStock(String partId) {
        String sql = "SELECT quantity FROM inventory WHERE part_id = ?";
        return jdbcTemplate.queryForObject(sql, Integer.class, partId.trim());
    }

    // Deducts purchased quantity from inventory table ensuring quantity does not drop below zero
    @Override
    public int deductPartStock(String partId, int quantity) {
        String sql = "UPDATE inventory SET quantity = quantity - ? WHERE part_id = ? AND quantity >= ?";
        return jdbcTemplate.update(sql, quantity, partId.trim(), quantity);
    }

    // Creates an order in sales_orders table
    @Override
    public int createSalesOrder(String customerName, double totalAmount, String status, String orderDate, String notes) {
        try {
            org.springframework.jdbc.support.KeyHolder keyHolder = new org.springframework.jdbc.support.GeneratedKeyHolder();
            String sql = "INSERT INTO sales_orders (customer_name, total_amount, status, order_date, notes) VALUES (?, ?, ?, ?, ?)";
            jdbcTemplate.update(connection -> {
                java.sql.PreparedStatement ps = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, customerName);
                ps.setDouble(2, totalAmount);
                ps.setString(3, status);
                ps.setString(4, orderDate);
                ps.setString(5, notes);
                return ps;
            }, keyHolder);
            Number key = keyHolder.getKey();
            return (key != null) ? key.intValue() : 0;
        } catch (Exception e) {
            return 0;
        }
    }

    // Inserts an item into order_items table
    @Override
    public int createOrderItem(int orderId, String partId, String partName, int quantity, double unitPrice, double subtotal) {
        String sql = "INSERT INTO order_items (order_id, part_id, part_name, quantity, unit_price, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql, orderId, partId.trim(), partName.trim(), quantity, unitPrice, subtotal);
    }

    // Queries orders strictly belonging to a customer
    @Override
    public List<Map<String, Object>> findOrdersByCustomer(String customerName, String email) {
        String sql = "SELECT * FROM sales_orders WHERE LOWER(customer_name) = LOWER(?) OR LOWER(customer_name) = LOWER(?) OR (LOWER(customer_name) = LOWER(?) AND ? <> '') ORDER BY order_id DESC";
        return jdbcTemplate.queryForList(sql, customerName, email, email, email);
    }

    // Queries items purchased in a specific order
    @Override
    public List<Map<String, Object>> findOrderItemsByOrderId(int orderId) {
        String sql = "SELECT * FROM order_items WHERE order_id = ?";
        return jdbcTemplate.queryForList(sql, orderId);
    }

    // Updates user profile details such as full name and email
    @Override
    public int updateUserProfile(String username, String fullName, String email) {
        String sql = "UPDATE users SET full_name = ?, email = ? WHERE LOWER(username) = LOWER(?)";
        return jdbcTemplate.update(sql, fullName, email, username.trim());
    }

    // Updates user password for the specified username
    @Override
    public int updateUserPassword(String username, String newPassword) {
        String sql = "UPDATE users SET password = ? WHERE LOWER(username) = LOWER(?)";
        return jdbcTemplate.update(sql, newPassword.trim(), username.trim());
    }
}
