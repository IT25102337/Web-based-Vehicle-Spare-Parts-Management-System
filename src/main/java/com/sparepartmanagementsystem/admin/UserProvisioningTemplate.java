package com.sparepartmanagementsystem.admin;

import com.sparepartmanagementsystem.customer.UserAccount;

/**
 * DESIGN PATTERN: Template Method Pattern (Behavioral)
 * Abstract template defining the skeleton of the user account onboarding & provisioning algorithm.
 * Subclasses override specific steps without modifying the overall provisioning sequence.
 */
public abstract class UserProvisioningTemplate {

    /**
     * The Template Method (declared final so subclasses cannot alter the overall algorithm skeleton).
     */
    public final UserAccount provisionUser(String username, String password, String fullName, String email, String phone) {
        validateInput(username, password, email);
        UserAccount account = instantiateAccount(username, password, fullName, email, phone);
        assignRoleAndPermissions(account);
        applySecurityPolicy(account);
        logProvisioningAudit(account);
        return account;
    }

    // Step 1: Common validation across all account types
    protected void validateInput(String username, String password, String email) {
        if (username == null || username.trim().isEmpty()) {
            throw new AdminException("Provisioning error: Username cannot be blank.");
        }
        if (password == null || password.length() < 4) {
            throw new AdminException("Provisioning error: Password must be at least 4 characters.");
        }
        if (email == null || !email.contains("@")) {
            throw new AdminException("Provisioning error: A valid email address is required.");
        }
    }

    // Step 2: Instantiates the account instance
    protected UserAccount instantiateAccount(String username, String password, String fullName, String email, String phone) {
        return new UserAccount(null, username.trim(), password, (fullName != null ? fullName.trim() : ""), email.trim(), "CUSTOMER", phone, "ACTIVE", java.time.LocalDate.now().toString());
    }

    // Step 3: Abstract hook overridden by specific user types
    protected abstract void assignRoleAndPermissions(UserAccount account);

    // Step 4: Optional hook method with default security policy
    protected void applySecurityPolicy(UserAccount account) {
        account.setStatus("ACTIVE");
    }

    // Step 5: Common audit logging step
    protected void logProvisioningAudit(UserAccount account) {
        System.out.println("[PROVISIONING AUDIT] User '" + account.getUsername() + "' provisioned with role: " + account.getRole());
    }
}
