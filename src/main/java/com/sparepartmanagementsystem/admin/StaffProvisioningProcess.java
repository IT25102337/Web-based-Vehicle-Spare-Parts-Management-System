package com.sparepartmanagementsystem.admin;

import com.sparepartmanagementsystem.customer.UserAccount;

/**
 * DESIGN PATTERN: Template Method Pattern (Concrete Implementation 2)
 * Specializes user provisioning for operational Staff & Manager accounts (INVENTORY, SPAREPARTS, ADMIN).
 */
public class StaffProvisioningProcess extends UserProvisioningTemplate {

    private final String targetDepartmentRole;

    public StaffProvisioningProcess(String targetDepartmentRole) {
        this.targetDepartmentRole = (targetDepartmentRole != null && !targetDepartmentRole.isBlank())
                ? targetDepartmentRole.trim().toUpperCase()
                : "INVENTORY";
    }

    @Override
    protected void assignRoleAndPermissions(UserAccount account) {
        account.setRole(this.targetDepartmentRole);
    }

    @Override
    protected void applySecurityPolicy(UserAccount account) {
        super.applySecurityPolicy(account);
        // Additional security validation for staff clearance
        if ("ADMIN".equalsIgnoreCase(this.targetDepartmentRole)) {
            System.out.println("[SECURITY] Elevated Administrative clearance granted to user: " + account.getUsername());
        }
    }
}
