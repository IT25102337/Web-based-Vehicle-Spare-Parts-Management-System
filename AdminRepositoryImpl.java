package com.sparepartmanagementsystem.admin;

import com.sparepartmanagementsystem.customer.UserAccount;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.stereotype.Repository;

import java.util.*;

/**
 * {ignors non critical errors}
 * OOP CONCEPTS: Interface Realization & Repository Pattern
 * UML RELATIONSHIP: Association (AdminRepositoryImpl associates with JdbcTemplate)
 * Implements database persistence for Master System Administrator and account governance.
 */
@Repository
public class AdminRepositoryImpl implements AdminRepository {

    // Spring JdbcTemplate association for relational database operations
    @Autowired
    private JdbcTemplate jdbcTemplate;

    // RowMapper converting SQL Server result set rows into UserAccount domain entities
    private final RowMapper<UserAccount> userRowMapper = (rs, rowNum) -> {
        String phone = "+94 77 123 4567";
        String status = "ACTIVE";
        try {
            String dbPhone = rs.getString("phone");
            if (dbPhone != null && !dbPhone.isBlank()) phone = dbPhone.trim();
        } catch (Exception ignored) {}
        try {
            String dbStatus = rs.getString("status");
            if (dbStatus != null && !dbStatus.isBlank()) status = dbStatus.trim().toUpperCase();
        } catch (Exception ignored) {}

        return new UserAccount(
                rs.getInt("user_id"),
                rs.getString("username"),
                rs.getString("password"),
                rs.getString("full_name"),
                rs.getString("email"),
                rs.getString("role"),
                phone,
                status,
                rs.getString("created_at")
        );
    };

    // RowMapper converting SQL Server result set rows into SuspensionRecord domain entities
    private final RowMapper<SuspensionRecord> suspensionRowMapper = (rs, rowNum) -> new SuspensionRecord(
            rs.getInt("history_id"),
            rs.getInt("user_id"),
            rs.getString("username"),
            rs.getString("full_name"),
            rs.getString("role"),
            rs.getString("suspended_at"),
            rs.getString("suspended_by"),
            rs.getString("reason"),
            rs.getString("recovered_at"),
            rs.getString("recovered_by"),
            rs.getString("status")
    );

    // Retrieves all registered user accounts sorted by user ID descending
    @Override
    public List<UserAccount> findAllUsers() {
        String sql = "SELECT user_id, username, password, full_name, email, role, phone, status, created_at FROM users ORDER BY user_id DESC";
        return jdbcTemplate.query(sql, userRowMapper);
    }

    // Retrieves registered user accounts filtered by specific system security role
    @Override
    public List<UserAccount> findUsersByRole(String role) {
        String sql = "SELECT user_id, username, password, full_name, email, role, phone, status, created_at FROM users WHERE UPPER(role) = UPPER(?) ORDER BY user_id DESC";
        return jdbcTemplate.query(sql, userRowMapper, role.trim());
    }

    // Queries a single user account by database primary key ID
    @Override
    public Optional<UserAccount> findUserById(int userId) {
        String sql = "SELECT user_id, username, password, full_name, email, role, phone, status, created_at FROM users WHERE user_id = ?";
        List<UserAccount> list = jdbcTemplate.query(sql, userRowMapper, userId);
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    // Queries a single user account by unique username
    @Override
    public Optional<UserAccount> findUserByUsername(String username) {
        String sql = "SELECT user_id, username, password, full_name, email, role, phone, status, created_at FROM users WHERE LOWER(username) = LOWER(?)";
        List<UserAccount> list = jdbcTemplate.query(sql, userRowMapper, username.trim());
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    // Inserts a new user account into the users database table
    @Override
    public int insertUser(UserAccount user) {
        String sql = "INSERT INTO users (username, password, full_name, email, role, phone, status, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                user.getUsername(),
                user.getPassword(),
                user.getFullName(),
                user.getEmail(),
                user.getRole(),
                user.getPhone(),
                user.getStatus(),
                user.getCreatedAt());
    }

    // Updates existing user account profile, username, contact details, role, status, and optional password
    @Override
    public int updateUser(UserAccount user, boolean updatePassword) {
        if (updatePassword && user.getPassword() != null && !user.getPassword().isBlank()) {
            String sql = "UPDATE users SET username = ?, full_name = ?, email = ?, phone = ?, role = ?, status = ?, password = ? WHERE user_id = ?";
            return jdbcTemplate.update(sql, user.getUsername(), user.getFullName(), user.getEmail(), user.getPhone(), user.getRole(), user.getStatus(), user.getPassword(), user.getUserId());
        } else {
            String sql = "UPDATE users SET username = ?, full_name = ?, email = ?, phone = ?, role = ?, status = ? WHERE user_id = ?";
            return jdbcTemplate.update(sql, user.getUsername(), user.getFullName(), user.getEmail(), user.getPhone(), user.getRole(), user.getStatus(), user.getUserId());
        }
    }

    // Permanently removes a user account from the users database table by user ID
    @Override
    public int deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        return jdbcTemplate.update(sql, userId);
    }

    // Updates the active or suspended operational status of a user account in users table
    @Override
    public int updateUserStatus(int userId, String status) {
        String sql = "UPDATE users SET status = ? WHERE user_id = ?";
        return jdbcTemplate.update(sql, status.trim().toUpperCase(), userId);
    }

    // Records a new account suspension incident in the suspension history audit log
    @Override
    public int insertSuspension(SuspensionRecord record) {
        String sql = "INSERT INTO suspension_history (user_id, username, full_name, role, suspended_at, suspended_by, reason, recovered_at, recovered_by, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        return jdbcTemplate.update(sql,
                record.getUserId(),
                record.getUsername(),
                record.getFullName(),
                record.getRole(),
                record.getSuspendedAt(),
                record.getSuspendedBy(),
                record.getReason(),
                record.getRecoveredAt(),
                record.getRecoveredBy(),
                record.getStatus());
    }

    // Updates a suspension record with recovery timestamp, recovering administrator, and RECOVERED status
    @Override
    public int updateSuspensionRecovery(int userId, String recoveredBy, String recoveredAt) {
        String sql = "UPDATE suspension_history SET recovered_at = ?, recovered_by = ?, status = 'RECOVERED' WHERE user_id = ? AND UPPER(status) = 'SUSPENDED'";
        return jdbcTemplate.update(sql, recoveredAt, recoveredBy, userId);
    }

    // Retrieves full chronological audit history of all account suspension and recovery events
    @Override
    public List<SuspensionRecord> findAllSuspensions() {
        String sql = "SELECT history_id, user_id, username, full_name, role, suspended_at, suspended_by, reason, recovered_at, recovered_by, status " +
                     "FROM suspension_history ORDER BY history_id DESC";
        return jdbcTemplate.query(sql, suspensionRowMapper);
    }

    // Retrieves only accounts that are currently suspended awaiting administrative recovery
    @Override
    public List<SuspensionRecord> findActiveSuspensions() {
        String sql = "SELECT history_id, user_id, username, full_name, role, suspended_at, suspended_by, reason, recovered_at, recovered_by, status " +
                     "FROM suspension_history WHERE UPPER(status) = 'SUSPENDED' ORDER BY history_id DESC";
        return jdbcTemplate.query(sql, suspensionRowMapper);
    }

    // Queries a single suspension audit record by its primary key ID
    @Override
    public Optional<SuspensionRecord> findSuspensionById(int historyId) {
        String sql = "SELECT history_id, user_id, username, full_name, role, suspended_at, suspended_by, reason, recovered_at, recovered_by, status " +
                     "FROM suspension_history WHERE history_id = ?";
        List<SuspensionRecord> list = jdbcTemplate.query(sql, suspensionRowMapper, historyId);
        return list.isEmpty() ? Optional.empty() : Optional.of(list.get(0));
    }

    // Aggregates real-time system metrics including total users, role breakdown, and platform stats
    @Override
    public Map<String, Object> getSystemMetrics() {
        Map<String, Object> metrics = new LinkedHashMap<>();
        try {
            Integer totalUsers = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users", Integer.class);
            Integer totalCustomers = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE UPPER(role) = 'CUSTOMER'", Integer.class);
            Integer totalInventory = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE UPPER(role) = 'INVENTORY'", Integer.class);
            Integer totalSpareparts = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE UPPER(role) = 'SPAREPARTS'", Integer.class);
            Integer totalSales = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE UPPER(role) = 'SALES'", Integer.class);
            Integer totalSuppliers = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE UPPER(role) = 'SUPPLIER'", Integer.class);
            Integer totalReportManagers = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE UPPER(role) IN ('REPORT_MANAGER', 'REPORTS')", Integer.class);
            Integer totalSysAdmins = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE UPPER(role) IN ('SYSADMIN', 'SYSTEM_ADMIN', 'ADMIN')", Integer.class);
            Integer activeUsers = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE UPPER(status) = 'ACTIVE' OR status IS NULL", Integer.class);
            Integer suspendedUsers = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM users WHERE UPPER(status) = 'SUSPENDED'", Integer.class);
            Integer totalSuspensionEvents = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM suspension_history", Integer.class);

            metrics.put("totalUsers", totalUsers != null ? totalUsers : 0);
            metrics.put("totalCustomers", totalCustomers != null ? totalCustomers : 0);
            metrics.put("totalInventory", totalInventory != null ? totalInventory : 0);
            metrics.put("totalSpareparts", totalSpareparts != null ? totalSpareparts : 0);
            metrics.put("totalSales", totalSales != null ? totalSales : 0);
            metrics.put("totalSuppliers", totalSuppliers != null ? totalSuppliers : 0);
            metrics.put("totalReportManagers", totalReportManagers != null ? totalReportManagers : 0);
            metrics.put("totalSysAdmins", totalSysAdmins != null ? totalSysAdmins : 0);
            metrics.put("activeUsers", activeUsers != null ? activeUsers : 0);
            metrics.put("suspendedUsers", suspendedUsers != null ? suspendedUsers : 0);
            metrics.put("totalSuspensionEvents", totalSuspensionEvents != null ? totalSuspensionEvents : 0);

            int staffCount = (totalUsers != null ? totalUsers : 0) - (totalCustomers != null ? totalCustomers : 0);
            metrics.put("totalStaff", Math.max(0, staffCount));
        } catch (Exception e) {
            metrics.put("totalUsers", 0);
            metrics.put("totalCustomers", 0);
            metrics.put("totalInventory", 0);
            metrics.put("totalSpareparts", 0);
            metrics.put("totalSales", 0);
            metrics.put("totalSuppliers", 0);
            metrics.put("totalReportManagers", 0);
            metrics.put("totalSysAdmins", 0);
            metrics.put("activeUsers", 0);
            metrics.put("suspendedUsers", 0);
            metrics.put("totalSuspensionEvents", 0);
            metrics.put("totalStaff", 0);
        }
        return metrics;
    }

    // Retrieves recent user security, registration, and modification audit records
    @Override
    public List<Map<String, Object>> getRecentSecurityLogs() {
        String sql = "SELECT TOP 10 user_id, username, full_name, email, role, status, created_at FROM users ORDER BY user_id DESC";
        return jdbcTemplate.queryForList(sql);
    }
}
