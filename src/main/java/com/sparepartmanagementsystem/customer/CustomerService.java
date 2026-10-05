package com.sparepartmanagementsystem.customer;

import com.sparepartmanagementsystem.inventory.InventoryItem;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface (Service Layer Contract)
 * Defines business logic contracts for customer registration, authentication, and shopping.
 */
public interface CustomerService {

    // Registers a new customer account validating passwords and username uniqueness
    void registerCustomer(String username, String password, String confirmPassword, String fullName, String email);

    // Authenticates a user by username or email and verifies password
    Optional<UserAccount> authenticateUser(String username, String password);

    // Retrieves all inventory products available in the customer store
    List<InventoryItem> getStoreProducts();

    // Purchases a part from warehouse stock and creates an order record
    void purchasePart(String partId, int quantity, String customerName);

    // Retrieves past orders placed by the current logged-in customer
    List<Map<String, Object>> getCustomerOrders(String customerName, String email);

    // Retrieves item rows for each of the customer's orders
    Map<Integer, List<Map<String, Object>>> getCustomerOrderItemsMap(List<Map<String, Object>> orders);

    // Updates profile details and optional new password for an authenticated user
    void updateProfile(String username, String fullName, String email, String newPassword, String confirmNewPassword);
}
