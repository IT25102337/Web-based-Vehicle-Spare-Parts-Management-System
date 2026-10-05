package com.sparepartmanagementsystem.customer;

import com.sparepartmanagementsystem.inventory.InventoryItem;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface & Repository Pattern
 * Contract defining database access operations for customer authentication and shopping.
 */
public interface CustomerRepository {

    // Finds user account by username or email
    Optional<UserAccount> findByUsernameOrEmail(String identifier);

    // Checks if a username is already registered in the users table
    boolean isUsernameTaken(String username);

    // Registers a new user account into the users database table
    int createUser(String username, String password, String fullName, String email, String role, String createdAt);

    // Queries available inventory parts sorted by name for the customer store
    List<InventoryItem> findCatalogProducts();

    // Finds catalog product by part ID
    Optional<InventoryItem> findProductById(String partId);

    // Queries stock count for a given part ID
    Integer getPartStock(String partId);

    // Deducts purchased quantity from inventory table
    int deductPartStock(String partId, int quantity);

    // Creates an order record in the sales_orders table
    int createSalesOrder(String customerName, double totalAmount, String status, String orderDate, String notes);

    // Inserts an item row into the order_items table
    int createOrderItem(int orderId, String partId, String partName, int quantity, double unitPrice, double subtotal);

    // Retrieves customer orders matching customer username or email
    List<Map<String, Object>> findOrdersByCustomer(String customerName, String email);

    // Retrieves order item rows for a specific order ID
    List<Map<String, Object>> findOrderItemsByOrderId(int orderId);

    // Updates user profile details such as full name and email
    int updateUserProfile(String username, String fullName, String email);

    // Updates user password for the given username
    int updateUserPassword(String username, String newPassword);
}
