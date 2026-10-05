package com.sparepartmanagementsystem.admin;

import com.sparepartmanagementsystem.customer.UserAccount;

/**
 * DESIGN PATTERN: Template Method Pattern (Concrete Implementation 1)
 * Specializes user provisioning for retail Customer accounts.
 */
public class CustomerProvisioningProcess extends UserProvisioningTemplate {

    @Override
    protected void assignRoleAndPermissions(UserAccount account) {
        account.setRole("CUSTOMER");
    }

    @Override
    protected void applySecurityPolicy(UserAccount account) {
        super.applySecurityPolicy(account);
        // Default customer security policy
        account.setStatus("ACTIVE");
    }
}
