package com.sparepartmanagementsystem.admin;

import com.sparepartmanagementsystem.customer.UserAccount;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * OOP CONCEPTS: Interface Realization, Service Layer & Factory Pattern
 * UML RELATIONSHIP: Aggregation (AdminServiceImpl aggregates AdminRepository)
 * Concrete business service managing System Administration, user provisioning, account suspensions, and recovery history.
 */
@Service
public class AdminServiceImpl implements AdminService {

    // UML RELATIONSHIP: Aggregation
    @Autowired
    private AdminRepository adminRepository;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // Retrieves all registered users in the platform
    @Override
    public List<UserAccount> getAllUsers() {
        return adminRepository.findAllUsers();
    }

    // Retrieves users filtered by system role
    @Override
    public List<UserAccount> getUsersByRole(String role) {
        if (role == null || role.isBlank() || "ALL".equalsIgnoreCase(role)) {
            return adminRepository.findAllUsers();
        }
        return adminRepository.findUsersByRole(role.trim());
    }

    // Retrieves a specific user by database user ID
    @Override
    public UserAccount getUserById(int userId) {
        return adminRepository.findUserById(userId)
                .orElseThrow(() -> new AdminException("User account not found with ID: " + userId));
    }

    // Registers a new verified customer account directly from the system admin console
    @Override
    @Transactional
    public UserAccount registerNewCustomer(String username, String password, String fullName, String email, String phone) {
        validateCredentials(username, password);

        if (adminRepository.findUserByUsername(username.trim()).isPresent()) {
            throw new AdminException("Username '" + username.trim() + "' is already registered in the system.");
        }

        String createdAt = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        String cleanPhone = (phone != null && !phone.isBlank()) ? phone.trim() : "+94 77 123 4567";
        String cleanEmail = (email != null && !email.isBlank()) ? email.trim() : username.trim() + "@parttrack.com";
        String cleanName = (fullName != null && !fullName.isBlank()) ? fullName.trim() : username.trim();

        // DESIGN PATTERN: Factory Pattern - Creates user profile type dynamically via factory method
        UserAccount newCustomer = UserAccount.createUser("CUSTOMER", username.trim(), cleanEmail, cleanName);
        newCustomer.setPassword(password.trim());
        newCustomer.setPhone(cleanPhone);
        newCustomer.setCreatedAt(createdAt);

        adminRepository.insertUser(newCustomer);
        return adminRepository.findUserByUsername(username.trim()).orElse(newCustomer);
    }

    // Registers a new staff or manager account assigned to a designated operational role
    @Override
    @Transactional
    public UserAccount registerNewStaff(String username, String password, String fullName, String email, String phone, String role) {
        validateCredentials(username, password);

        if (adminRepository.findUserByUsername(username.trim()).isPresent()) {
            throw new AdminException("Username '" + username.trim() + "' is already registered in the system.");
        }

        String targetRole = (role != null && !role.isBlank()) ? role.trim().toUpperCase() : "INVENTORY";
        String createdAt = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        String cleanPhone = (phone != null && !phone.isBlank()) ? phone.trim() : "+94 77 123 4567";
        String cleanEmail = (email != null && !email.isBlank()) ? email.trim() : username.trim() + "@parttrack.com";
        String cleanName = (fullName != null && !fullName.isBlank()) ? fullName.trim() : username.trim();

        // DESIGN PATTERN: Factory Pattern - Creates designated staff account dynamically by role string
        UserAccount newStaff = UserAccount.createUser(targetRole, username.trim(), cleanEmail, cleanName);
        newStaff.setPassword(password.trim());
        newStaff.setPhone(cleanPhone);
        newStaff.setCreatedAt(createdAt);

        adminRepository.insertUser(newStaff);
        return adminRepository.findUserByUsername(username.trim()).orElse(newStaff);
    }

    // Updates profile details, username, email, phone, role, status, and login password for an existing user
    @Override
    @Transactional
    public void updateUserDetails(int userId, String username, String fullName, String email, String phone, String role, String status, String password) {
        UserAccount existing = getUserById(userId);

        if (username != null && !username.isBlank()) {
            String cleanUsername = username.trim();
            if (!cleanUsername.equalsIgnoreCase(existing.getUsername())) {
                Optional<UserAccount> duplicate = adminRepository.findUserByUsername(cleanUsername);
                if (duplicate.isPresent() && duplicate.get().getUserId() != existing.getUserId()) {
                    throw new AdminException("Username '@" + cleanUsername + "' is already taken by another user account.");
                }
                existing.setUsername(cleanUsername);
            }
        }

        if (fullName != null && !fullName.isBlank()) {
            existing.setFullName(fullName.trim());
        }
        if (email != null && !email.isBlank()) {
            existing.setEmail(email.trim());
        }
        if (phone != null && !phone.isBlank()) {
            existing.setPhone(phone.trim());
        }
        if (role != null && !role.isBlank()) {
            existing.setRole(role.trim().toUpperCase());
        }
        if (status != null && !status.isBlank()) {
            existing.setStatus(status.trim().toUpperCase());
        }

        boolean updatePass = false;
        if (password != null && !password.isBlank()) {
            if (password.trim().length() < 4) {
                throw new AdminException("Password must be at least 4 characters long.");
            }
            existing.setPassword(password.trim());
            updatePass = true;
        }

        adminRepository.updateUser(existing, updatePass);
    }

    // Permanently removes a user account from the system while protecting active admin accounts from deletion
    @Override
    @Transactional
    public void removeUser(int userId, String currentAdminUsername) {
        UserAccount target = getUserById(userId);

        if (currentAdminUsername != null && target.getUsername().equalsIgnoreCase(currentAdminUsername.trim())) {
            throw new AdminException("Security Policy: You cannot delete your currently active System Administrator account.");
        }

        if ("SYSADMIN".equalsIgnoreCase(target.getRole()) || "SYSTEM_ADMIN".equalsIgnoreCase(target.getRole()) || "ADMIN".equalsIgnoreCase(target.getRole())) {
            int adminCount = adminRepository.findUsersByRole("SYSADMIN").size() + adminRepository.findUsersByRole("ADMIN").size();
            if (adminCount <= 1) {
                throw new AdminException("Security Policy: Cannot delete the sole remaining System Administrator on the platform.");
            }
        }

        adminRepository.deleteUser(userId);
    }

    // Suspends a user account and records the incident in the suspension history audit log
    @Override
    @Transactional
    public void suspendAccount(int userId, String reason, String currentAdminUsername) {
        UserAccount target = getUserById(userId);

        if (currentAdminUsername != null && target.getUsername().equalsIgnoreCase(currentAdminUsername.trim())) {
            throw new AdminException("Security Policy: You cannot suspend your currently active System Administrator account.");
        }

        String adminName = (currentAdminUsername != null && !currentAdminUsername.isBlank()) ? currentAdminUsername.trim() : "System Administrator";
        String suspendReason = (reason != null && !reason.isBlank()) ? reason.trim() : "Administrative security review";
        String now = LocalDateTime.now().format(DATE_TIME_FORMATTER);

        // 1. Update user account status to SUSPENDED in users table
        adminRepository.updateUserStatus(userId, "SUSPENDED");

        // 2. Persist audit history record into suspension_history table
        SuspensionRecord record = SuspensionRecord.createSuspension(
                target.getUserId(),
                target.getUsername(),
                target.getFullName(),
                target.getRole(),
                now,
                adminName,
                suspendReason
        );
        adminRepository.insertSuspension(record);
    }

    // Recovers a previously suspended account and restores it to full active status
    @Override
    @Transactional
    public void recoverAccount(int userId, String currentAdminUsername) {
        UserAccount target = getUserById(userId);
        String adminName = (currentAdminUsername != null && !currentAdminUsername.isBlank()) ? currentAdminUsername.trim() : "System Administrator";
        String now = LocalDateTime.now().format(DATE_TIME_FORMATTER);

        // 1. Restore user account status to ACTIVE in users table
        adminRepository.updateUserStatus(userId, "ACTIVE");

        // 2. Mark suspension record as RECOVERED in suspension_history table
        adminRepository.updateSuspensionRecovery(userId, adminName, now);
    }

    // Retrieves chronological audit history of all account suspensions and recoveries
    @Override
    public List<SuspensionRecord> getSuspensionHistory() {
        return adminRepository.findAllSuspensions();
    }

    // Retrieves accounts currently suspended that are eligible for recovery
    @Override
    public List<SuspensionRecord> getActiveSuspensions() {
        return adminRepository.findActiveSuspensions();
    }

    // Aggregates real-time system metrics, user totals, and operational statistics
    @Override
    public Map<String, Object> getSystemOverviewStats() {
        Map<String, Object> stats = adminRepository.getSystemMetrics();
        stats.put("serverStatus", "ACTIVE");
        stats.put("databaseEngine", "Microsoft SQL Server 2022");
        stats.put("dbPort", "1433");
        stats.put("authSecurityMode", "Active Role-Based Access Control (RBAC)");
        // DESIGN PATTERN: Singleton Pattern - Accesses global centralized configuration
        stats.put("systemName", com.sparepartmanagementsystem.core.AppConfigManager.getInstance().getSystemName());
        stats.put("maxWarehouseCapacity", com.sparepartmanagementsystem.core.AppConfigManager.getInstance().getMaxWarehouseCapacity());
        return stats;
    }

    // Retrieves recent user security, registration, and modification audit trail events
    @Override
    public List<Map<String, Object>> getSecurityAuditFeed() {
        return adminRepository.getRecentSecurityLogs();
    }

    // Generates the comprehensive system role and module access permissions matrix
    @Override
    public List<Map<String, Object>> getRolePermissionMatrix() {
        List<Map<String, Object>> matrix = new ArrayList<>();

        matrix.add(createMatrixRow("Customer Access", "CUSTOMER",
                "Self-service automotive parts browsing, shopping cart checkout, order tracking, and profile management.",
                true, false, false, false, false, false, false));

        matrix.add(createMatrixRow("Inventory Manager", "INVENTORY",
                "Warehouse inventory stock levels, parts catalog CRUD, reorder threshold alerts, restock dispatching.",
                false, true, false, false, false, false, false));

        matrix.add(createMatrixRow("Spare Part Manager", "SPAREPARTS",
                "Receiving supplier part shipments, QA pass/fail inspection, warehouse restocking, warranty certification.",
                false, true, true, false, false, false, false));

        matrix.add(createMatrixRow("Sales Manager", "SALES",
                "Commercial purchases, order processing, realized revenue cashflow, customer shipment dispatches.",
                false, false, false, true, false, false, false));

        matrix.add(createMatrixRow("Supplier Partner", "SUPPLIER",
                "Supplier catalog pricing, delivery dispatch tracking, stock intake receipts, supply contract oversight.",
                false, false, false, false, true, false, false));

        matrix.add(createMatrixRow("Report & Business Dashboard Manager", "REPORT_MANAGER",
                "Executive 360° analytics, unified cross-department PDF/TXT report compilation, manager audit approvals, automated schedulers.",
                true, true, true, true, true, true, false));

        matrix.add(createMatrixRow("System Administrator", "SYSADMIN",
                "Master directory governance, user provisioning & deletion, account suspension recovery, credential resets, security policy control.",
                true, true, true, true, true, true, true));

        return matrix;
    }

    // Validates username and password format constraints
    private void validateCredentials(String username, String password) {
        if (username == null || username.trim().length() < 3) {
            throw new AdminException("Username must be at least 3 characters long.");
        }
        if (password == null || password.trim().length() < 4) {
            throw new AdminException("Password must be at least 4 characters long.");
        }
    }

    // Helper building individual row in the role-permission access matrix
    private Map<String, Object> createMatrixRow(String roleTitle, String roleCode, String description,
                                                boolean customerStore, boolean inventory, boolean qualityQa,
                                                boolean sales, boolean supplier, boolean reports, boolean sysAdmin) {
        Map<String, Object> row = new LinkedHashMap<>();
        row.put("roleTitle", roleTitle);
        row.put("roleCode", roleCode);
        row.put("description", description);
        row.put("permCustomerStore", customerStore);
        row.put("permInventory", inventory);
        row.put("permQualityQa", qualityQa);
        row.put("permSales", sales);
        row.put("permSupplier", supplier);
        row.put("permReports", reports);
        row.put("permSysAdmin", sysAdmin);
        return row;
    }
}
