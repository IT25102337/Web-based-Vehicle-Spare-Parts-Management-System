package com.sparepartmanagementsystem.customer;

/**
 * OOP CONCEPTS: Inheritance, Polymorphism & Encapsulation
 * Represents a concrete user account with specific role, profile attributes, and system status.
 */
public class UserAccount extends BaseUser {

    // Encapsulated profile and status fields
    private String fullName;
    private String role;
    private String phone;
    private String status;
    private String createdAt;

    // Default constructor for frameworks
    public UserAccount() {
        super();
        this.status = "ACTIVE";
    }

    // Constructor initializing base identity and standard profile attributes (Inheritance)
    public UserAccount(Integer userId, String username, String password, String fullName, String email, String role, String createdAt) {
        super(userId, username, password, email);
        this.fullName = fullName;
        this.role = role;
        this.phone = "+94 77 123 4567";
        this.status = "ACTIVE";
        this.createdAt = createdAt;
    }

    // Full constructor initializing base identity, profile, phone, status, and creation date
    public UserAccount(Integer userId, String username, String password, String fullName, String email, String role, String phone, String status, String createdAt) {
        super(userId, username, password, email);
        this.fullName = fullName;
        this.role = role;
        this.phone = (phone != null && !phone.isBlank()) ? phone.trim() : "+94 77 123 4567";
        this.status = (status != null && !status.isBlank()) ? status.trim().toUpperCase() : "ACTIVE";
        this.createdAt = createdAt;
    }

    // DESIGN PATTERN: Factory Pattern - Factory method creating distinct user profile types by role string
    public static UserAccount createUser(String role, String username, String email, String fullName) {
        return new UserAccount(null, username, "default123", fullName, email, (role != null ? role.toUpperCase() : "CUSTOMER"), "+94 77 123 4567", "ACTIVE", java.time.LocalDate.now().toString());
    }

    // POLYMORPHISM: Overrides abstract getRoleName() from BaseUser
    @Override
    public String getRoleName() {
        return (this.role != null) ? this.role.toUpperCase() : "CUSTOMER";
    }

    // Gets the user's full display name
    public String getFullName() {
        return fullName;
    }

    // Sets the user's full display name
    public void setFullName(String fullName) {
        this.fullName = (fullName != null) ? fullName.trim() : "";
    }

    // Gets the assigned system security role
    public String getRole() {
        return role;
    }

    // Sets the assigned system security role
    public void setRole(String role) {
        this.role = (role != null) ? role.trim().toUpperCase() : "CUSTOMER";
    }

    // Gets the user's contact telephone number
    public String getPhone() {
        return phone;
    }

    // Sets the user's contact telephone number
    public void setPhone(String phone) {
        this.phone = (phone != null) ? phone.trim() : "";
    }

    // Gets the account status flag
    public String getStatus() {
        return (status != null) ? status : "ACTIVE";
    }

    // Sets the account status flag
    public void setStatus(String status) {
        this.status = (status != null) ? status.trim().toUpperCase() : "ACTIVE";
    }

    // Gets the registration creation timestamp
    public String getCreatedAt() {
        return createdAt;
    }

    // Sets the registration creation timestamp
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }
}
