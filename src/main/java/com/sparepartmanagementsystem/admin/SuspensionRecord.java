package com.sparepartmanagementsystem.admin;

/**
 * OOP CONCEPTS: Encapsulation & Domain Entity
 * Represents an audit history record documenting account suspension and reactivation recovery events.
 */
public class SuspensionRecord {

    // Encapsulated audit record fields
    private Integer historyId;
    private Integer userId;
    private String username;
    private String fullName;
    private String role;
    private String suspendedAt;
    private String suspendedBy;
    private String reason;
    private String recoveredAt;
    private String recoveredBy;
    private String status;

    // Default constructor for frameworks
    public SuspensionRecord() {
        this.status = "SUSPENDED";
    }

    // Parameterized constructor initializing suspension event details
    public SuspensionRecord(Integer historyId, Integer userId, String username, String fullName, String role,
                            String suspendedAt, String suspendedBy, String reason,
                            String recoveredAt, String recoveredBy, String status) {
        this.historyId = historyId;
        this.userId = userId;
        this.username = username;
        this.fullName = fullName;
        this.role = role;
        this.suspendedAt = suspendedAt;
        this.suspendedBy = suspendedBy;
        this.reason = reason;
        this.recoveredAt = recoveredAt;
        this.recoveredBy = recoveredBy;
        this.status = (status != null && !status.isBlank()) ? status.trim().toUpperCase() : "SUSPENDED";
    }

    // Factory method (Factory Pattern) to construct a fresh suspension history record
    public static SuspensionRecord createSuspension(Integer userId, String username, String fullName, String role,
                                                    String suspendedAt, String suspendedBy, String reason) {
        return new SuspensionRecord(null, userId, username, fullName, role, suspendedAt, suspendedBy, reason, null, null, "SUSPENDED");
    }

    // Gets database primary key history ID
    public Integer getHistoryId() {
        return historyId;
    }

    // Sets database primary key history ID
    public void setHistoryId(Integer historyId) {
        this.historyId = historyId;
    }

    // Gets target suspended user ID
    public Integer getUserId() {
        return userId;
    }

    // Sets target suspended user ID
    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    // Gets username of the affected account
    public String getUsername() {
        return username;
    }

    // Sets username of the affected account
    public void setUsername(String username) {
        this.username = username;
    }

    // Gets full display name of the affected user
    public String getFullName() {
        return fullName;
    }

    // Sets full display name of the affected user
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    // Gets assigned security role of the suspended account
    public String getRole() {
        return role;
    }

    // Sets assigned security role of the suspended account
    public void setRole(String role) {
        this.role = role;
    }

    // Gets timestamp when the account was suspended
    public String getSuspendedAt() {
        return suspendedAt;
    }

    // Sets timestamp when the account was suspended
    public void setSuspendedAt(String suspendedAt) {
        this.suspendedAt = suspendedAt;
    }

    // Gets administrator username who enacted the suspension
    public String getSuspendedBy() {
        return suspendedBy;
    }

    // Sets administrator username who enacted the suspension
    public void setSuspendedBy(String suspendedBy) {
        this.suspendedBy = suspendedBy;
    }

    // Gets administrative reason or policy violation for the suspension
    public String getReason() {
        return (reason != null && !reason.isBlank()) ? reason : "Administrative security review";
    }

    // Sets administrative reason for the suspension
    public void setReason(String reason) {
        this.reason = reason;
    }

    // Gets timestamp when the account was recovered and restored to active status
    public String getRecoveredAt() {
        return recoveredAt;
    }

    // Sets timestamp when the account was recovered
    public void setRecoveredAt(String recoveredAt) {
        this.recoveredAt = recoveredAt;
    }

    // Gets administrator username who restored the account
    public String getRecoveredBy() {
        return recoveredBy;
    }

    // Sets administrator username who restored the account
    public void setRecoveredBy(String recoveredBy) {
        this.recoveredBy = recoveredBy;
    }

    // Gets current lifecycle status of the suspension audit record
    public String getStatus() {
        return (status != null) ? status : "SUSPENDED";
    }

    // Sets current lifecycle status of the suspension audit record
    public void setStatus(String status) {
        this.status = status;
    }
}
