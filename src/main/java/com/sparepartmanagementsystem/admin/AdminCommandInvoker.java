package com.sparepartmanagementsystem.admin;

import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.List;

/**
 * DESIGN PATTERN: Command Pattern (Invoker)
 * Dispatches administrative commands and maintains execution history for undo / audit trail capabilities.
 */
public class AdminCommandInvoker {

    private final Deque<AdminCommand> history = new ArrayDeque<>();
    private final List<String> executionLogs = new ArrayList<>();

    // Executes a given command and pushes it onto the undo stack
    public void executeCommand(AdminCommand command) {
        if (command == null) return;
        command.execute();
        history.push(command);
        executionLogs.add("EXECUTED: " + command.getDescription());
    }

    // Reverses the last executed administrative command
    public boolean undoLastCommand() {
        if (!history.isEmpty()) {
            AdminCommand lastCommand = history.pop();
            lastCommand.undo();
            executionLogs.add("UNDONE: " + lastCommand.getDescription());
            return true;
        }
        return false;
    }

    // Returns chronological execution logs
    public List<String> getExecutionLogs() {
        return new ArrayList<>(executionLogs);
    }

    // Returns the count of commands currently available to undo
    public int getHistorySize() {
        return history.size();
    }
}
