package com.sparepartmanagementsystem.customer;

/**
 * OOP CONCEPT: Abstraction & Inheritance (Base Class)
 * Abstract base class representing shared identity and credentials for all system users.
 */
public abstract class BaseUser {

    // Encapsulated private identity fields
    private Integer userId;
    private String username;
    private String password;
    private String email;

    // Default constructor for frameworks
    public BaseUser() {}

    // Parameterized constructor to initialize common identity fields
    public BaseUser(Integer userId, String username, String password, String email) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.email = email;
    }

    // OOP CONCEPT: Polymorphism - abstract method to return user role title
    public abstract String getRoleName();

    // Gets the database user record ID
    public Integer getUserId() {
        return userId;
    }

    // Sets the database user record ID
    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    // Gets the account sign-in username
    public String getUsername() {
        return username;
    }

    // Sets the account sign-in username
    public void setUsername(String username) {
        this.username = (username != null) ? username.trim() : "";
    }

    // Gets the user authentication password
    public String getPassword() {
        return password;
    }

    // Sets the user authentication password
    public void setPassword(String password) {
        this.password = password;
    }

    // Gets the user contact email address
    public String getEmail() {
        return email;
    }

    // Sets the user contact email address
    public void setEmail(String email) {
        this.email = (email != null) ? email.trim() : "";
    }
}
