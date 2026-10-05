package com.sparepartmanagementsystem.admin;

import com.sparepartmanagementsystem.customer.UserAccount;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPTS: Abstraction & Repository Pattern
 * Contract defining database access operations for System Administrator account governance, user lifecycle, and suspension history tracking.
 */
public interface AdminRepository {

    // Retrieves all registered user accounts sorted by user ID descending
    List<UserAccount> findAllUsers();

    // Retrieves registered user accounts filtered by specific system security role
    List<UserAccount> findUsersByRole(String role);

    // Queries a single user account by database primary key ID
    Optional<UserAccount> findUserById(int userId);

    // Queries a single user account by unique username
    Optional<UserAccount> findUserByUsername(String username);

    // Inserts a new user account into the users database table
    int insertUser(UserAccount user);

    // Updates existing user account profile, contact details, role, status, and optional password
    int updateUser(UserAccount user, boolean updatePassword);

    // Permanently removes a user account from the users database table by user ID
    int deleteUser(int userId);

    // Updates the active or suspended operational status of a user account in users table
    int updateUserStatus(int userId, String status);

    // Records a new account suspension incident in the suspension history audit log
    int insertSuspension(SuspensionRecord record);

    // Updates a suspension record with recovery timestamp, recovering administrator, and RECOVERED status
    int updateSuspensionRecovery(int userId, String recoveredBy, String recoveredAt);

    // Retrieves full chronological audit history of all account suspension and recovery events
    List<SuspensionRecord> findAllSuspensions();

    // Retrieves only accounts that are currently suspended awaiting administrative recovery
    List<SuspensionRecord> findActiveSuspensions();

    // Queries a single suspension audit record by its primary key ID
    Optional<SuspensionRecord> findSuspensionById(int historyId);

    // Aggregates real-time system metrics including total users, role breakdown, and platform stats
    Map<String, Object> getSystemMetrics();

    // Retrieves recent user security, registration, and modification audit records
    List<Map<String, Object>> getRecentSecurityLogs();
}
