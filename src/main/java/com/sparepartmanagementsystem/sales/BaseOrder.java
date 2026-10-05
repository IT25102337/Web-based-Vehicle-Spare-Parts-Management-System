package com.sparepartmanagementsystem.sales;

/**
 * OOP CONCEPT: Abstract Class
 * Serves as the generalized base template for all order records in the system.
 */
public abstract class BaseOrder {
    private int orderId;
    private String customerName;
    private String orderDate;
    private double totalAmount;
    private String status;
    private String notes;

    // OOP CONCEPT: Default Constructor
    // Initializes a blank base order instance
    public BaseOrder() {}

    // OOP CONCEPT: Parameterized Constructor
    // Initializes a base order with complete core attributes
    public BaseOrder(int orderId, String customerName, String orderDate, double totalAmount, String status, String notes) {
        this.orderId = orderId;
        this.customerName = customerName;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.notes = notes;
    }

    // OOP CONCEPT: Polymorphism (Abstract Method)
    // Subclasses must define their specialized order classification
    public abstract String getOrderType();

    // Retrieves the unique order identifier
    public int getOrderId() { return orderId; }

    // Sets the unique order identifier
    public void setOrderId(int orderId) { this.orderId = orderId; }

    // Retrieves customer or ordering entity name
    public String getCustomerName() { return customerName; }

    // Sets customer or ordering entity name
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    // Retrieves the timestamp string of order creation
    public String getOrderDate() { return orderDate; }

    // Sets the timestamp string of order creation
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }

    // Retrieves the commercial financial value of the order
    public double getTotalAmount() { return totalAmount; }

    // Sets the commercial financial value of the order
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    // Retrieves the workflow status string
    public String getStatus() { return status; }

    // Sets the workflow status string
    public void setStatus(String status) { this.status = status; }

    // Retrieves manager or system audit notes
    public String getNotes() { return notes; }

    // Sets manager or system audit notes
    public void setNotes(String notes) { this.notes = notes; }
}
