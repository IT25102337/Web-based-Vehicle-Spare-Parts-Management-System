package com.sparepartmanagementsystem.admin;

/**
 * DESIGN PATTERN: Command Pattern (Behavioral)
 * Command interface that encapsulates administrative actions into standalone objects.
 * Enables parameterization of clients with queues, requests, and undoable operations.
 */
public interface AdminCommand {

    // Executes the administrative action
    void execute();

    // Reverses or un-does the administrative action
    void undo();

    // Human-readable summary of the command for audit logs
    String getDescription();
}
