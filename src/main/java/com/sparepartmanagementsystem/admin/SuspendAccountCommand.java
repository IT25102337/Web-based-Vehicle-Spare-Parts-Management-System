package com.sparepartmanagementsystem.admin;

/**
 * DESIGN PATTERN: Command Pattern (Concrete Command)
 * Encapsulates the user suspension and recovery action as a reversible command object.
 */
public class SuspendAccountCommand implements AdminCommand {

    private final AdminService adminService;
    private final int targetUserId;
    private final String reason;
    private final String adminUsername;
    private boolean executed = false;

    public SuspendAccountCommand(AdminService adminService, int targetUserId, String reason, String adminUsername) {
        this.adminService = adminService;
        this.targetUserId = targetUserId;
        this.reason = reason;
        this.adminUsername = adminUsername;
    }

    @Override
    public void execute() {
        if (adminService != null) {
            adminService.suspendAccount(targetUserId, reason, adminUsername);
            this.executed = true;
        }
    }

    @Override
    public void undo() {
        if (executed && adminService != null) {
            // Reverses the suspension by restoring the account
            adminService.recoverAccount(targetUserId, adminUsername);
            this.executed = false;
        }
    }

    @Override
    public String getDescription() {
        return "SuspendAccountCommand [Target User ID: " + targetUserId + ", Reason: " + reason + ", Executed By: " + adminUsername + "]";
    }

    public int getTargetUserId() {
        return targetUserId;
    }

    public boolean isExecuted() {
        return executed;
    }
}
