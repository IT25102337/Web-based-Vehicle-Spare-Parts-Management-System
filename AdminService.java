package com.sparepartmanagementsystem.admin;

import com.sparepartmanagementsystem.customer.UserAccount;
import java.util.List;
import java.util.Map;

/**
 * OOP CONCEPTS: Abstraction & Service Layer
 * Business service interface for Master System Administrator managing user provisioning, suspensions, and account recovery.
 */
public interface AdminService {

    // Retrieves all registered users in the platform
    List<UserAccount> getAllUsers();

    // Retrieves users filtered by system role
    List<UserAccount> getUsersByRole(String role);

    // Retrieves a specific user by database user ID
    UserAccount getUserById(int userId);

    // Registers a new verified customer account directly from the system admin console
    UserAccount registerNewCustomer(String username, String password, String fullName, String email, String phone);

    // Registers a new staff or manager account assigned to a designated operational role
    UserAccount registerNewStaff(String username, String password, String fullName, String email, String phone, String role);

    // Updates profile details, username, email, phone, role, status, and login password for an existing user
    void updateUserDetails(int userId, String username, String fullName, String email, String phone, String role, String status, String password);

    // Permanently removes a user account from the system while protecting active admin accounts from deletion
    void removeUser(int userId, String currentAdminUsername);

    // Suspends a user account and records the incident in the suspension history audit log
    void suspendAccount(int userId, String reason, String currentAdminUsername);

    // Recovers a previously suspended account and restores it to full active status
    void recoverAccount(int userId, String currentAdminUsername);

    // Retrieves chronological audit history of all account suspensions and recoveries
    List<SuspensionRecord> getSuspensionHistory();

    // Retrieves accounts currently suspended that are eligible for recovery
    List<SuspensionRecord> getActiveSuspensions();

    // Aggregates real-time system metrics, user totals, and operational statistics
    Map<String, Object> getSystemOverviewStats();

    // Retrieves recent user security, registration, and modification audit trail events
    List<Map<String, Object>> getSecurityAuditFeed();

    // Generates the comprehensive system role and module access permissions matrix
    List<Map<String, Object>> getRolePermissionMatrix();
}
