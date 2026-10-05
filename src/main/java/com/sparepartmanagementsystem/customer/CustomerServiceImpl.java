package com.sparepartmanagementsystem.customer;

import com.sparepartmanagementsystem.inventory.InventoryItem;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface Implementation (Service Layer)
 * Implements customer registration, authentication, and shopping business rules.
 */
@Service
public class CustomerServiceImpl implements CustomerService {

    // UML RELATIONSHIP: Association (CustomerService associates with CustomerRepository)
    @Autowired
    private CustomerRepository customerRepository;

    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    // Registers a new customer validating credentials and checking duplicate username
    @Override
    public void registerCustomer(String username, String password, String confirmPassword, String fullName, String email) {
        String cleanUser = (username != null) ? username.trim() : "";
        String cleanEmail = (email != null) ? email.trim() : "";
        String cleanName = (fullName != null && !fullName.isBlank()) ? fullName.trim() : cleanUser;

        if (cleanUser.length() < 3) {
            throw new CustomerException("Username must be at least 3 characters.");
        }
        if (password == null || password.length() < 4) {
            throw new CustomerException("Password must be at least 4 characters.");
        }
        if (!password.equals(confirmPassword)) {
            throw new CustomerException("Passwords do not match. Please re-enter.");
        }
        if (customerRepository.isUsernameTaken(cleanUser)) {
            throw new CustomerException("Username '" + cleanUser + "' is already registered. Please choose another or sign in.");
        }

        String created = LocalDateTime.now().format(DATE_FORMATTER);
        customerRepository.createUser(cleanUser, password, cleanName, cleanEmail, "CUSTOMER", created);
    }

    // Authenticates user credentials against the database records
    @Override
    public Optional<UserAccount> authenticateUser(String username, String password) {
        Optional<UserAccount> userOpt = customerRepository.findByUsernameOrEmail(username);
        if (userOpt.isPresent()) {
            UserAccount user = userOpt.get();
            if (user.getPassword() != null && user.getPassword().trim().equals(password != null ? password.trim() : "")) {
                if ("SUSPENDED".equalsIgnoreCase(user.getStatus())) {
                    throw new CustomerException("Account Suspended: Access for @" + user.getUsername() + " has been placed on hold by the System Administrator.");
                }
                return Optional.of(user);
            }
        }
        return Optional.empty();
    }

    // Fetches all available parts from the inventory catalog
    @Override
    public List<InventoryItem> getStoreProducts() {
        return customerRepository.findCatalogProducts();
    }

    // Performs checkout purchase deducting warehouse stock and creating sales order
    @Override
    @Transactional
    public void purchasePart(String partId, int quantity, String customerName) {
        if (quantity <= 0) {
            throw new CustomerException("Purchase quantity must be at least 1 unit.");
        }

        Integer currentStock = customerRepository.getPartStock(partId);
        if (currentStock == null) {
            throw new CustomerException("Selected product does not exist.");
        }
        if (currentStock < quantity) {
            throw new CustomerException(String.format("Cannot purchase %d units! Only %d units available in stock.", quantity, currentStock));
        }

        int updated = customerRepository.deductPartStock(partId, quantity);
        if (updated <= 0) {
            throw new CustomerException("Failed to deduct stock. Please try again.");
        }

        // Create sales order record
        String orderDate = LocalDateTime.now().format(DATE_FORMATTER);
        customerRepository.createSalesOrder(customerName, 0.0, "PROCESSING", orderDate, "Purchased " + quantity + " units of " + partId);
    }

    // Queries past order records belonging to the customer
    @Override
    public List<Map<String, Object>> getCustomerOrders(String customerName, String email) {
        return customerRepository.findOrdersByCustomer(customerName, email);
    }

    // Groups order item rows mapped by order ID for UI rendering
    @Override
    public Map<Integer, List<Map<String, Object>>> getCustomerOrderItemsMap(List<Map<String, Object>> orders) {
        Map<Integer, List<Map<String, Object>>> map = new LinkedHashMap<>();
        for (Map<String, Object> ord : orders) {
            int oid = ((Number) ord.get("order_id")).intValue();
            map.put(oid, customerRepository.findOrderItemsByOrderId(oid));
        }
        return map;
    }

    // Updates profile details and optional new password for an authenticated user
    @Override
    @Transactional
    public void updateProfile(String username, String fullName, String email, String newPassword, String confirmNewPassword) {
        if (username == null || username.trim().isEmpty()) {
            throw new CustomerException("User must be logged in to update profile.");
        }
        String cleanName = fullName != null ? fullName.trim() : "";
        String cleanEmail = email != null ? email.trim() : "";

        // Update full name and email
        if (!cleanName.isEmpty() || !cleanEmail.isEmpty()) {
            customerRepository.updateUserProfile(username, cleanName, cleanEmail);
        }

        // Validate and update password if provided
        if (newPassword != null && !newPassword.trim().isEmpty()) {
            if (newPassword.trim().length() < 4) {
                throw new CustomerException("Password must be at least 4 characters.");
            }
            if (!newPassword.equals(confirmNewPassword)) {
                throw new CustomerException("Passwords do not match.");
            }
            customerRepository.updateUserPassword(username, newPassword.trim());
        }
    }
}
