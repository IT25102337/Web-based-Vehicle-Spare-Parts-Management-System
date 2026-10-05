package com.sparepartmanagementsystem.sales;

import java.util.ArrayList;
import java.util.List;

/**
 * OOP CONCEPT: Inheritance (extends BaseOrder)
 * UML RELATIONSHIP: Composition (SalesOrder owns a collection of OrderItem instances)
 * Represents a customer sales order with its constituent line items.
 */
public class SalesOrder extends BaseOrder {

    // UML RELATIONSHIP: Composition (OrderItems cannot exist without this SalesOrder)
    private List<OrderItem> items = new ArrayList<>();

    // OOP CONCEPT: Default Constructor
    // Initializes an empty sales order instance
    public SalesOrder() {
        super();
    }

    // OOP CONCEPT: Parameterized Constructor with super() call
    // Initializes a sales order calling the BaseOrder parent constructor
    public SalesOrder(int orderId, String customerName, String orderDate, double totalAmount, String status, String notes) {
        super(orderId, customerName, orderDate, totalAmount, status, notes);
    }

    // OOP CONCEPT: Polymorphism (@Override)
    // Overrides abstract method to classify this as a Customer Sales Order
    @Override
    public String getOrderType() {
        return "CUSTOMER_SALES_ORDER";
    }

    // UML RELATIONSHIP: Composition helper method
    // Appends a child order line item to this sales order
    public void addItem(OrderItem item) {
        if (item != null) {
            this.items.add(item);
        }
    }

    // Retrieves the composite list of order items
    public List<OrderItem> getItems() {
        return items;
    }

    // Replaces the composite list of order items
    public void setItems(List<OrderItem> items) {
        this.items = (items != null) ? items : new ArrayList<>();
    }

    // Computes the total order value across all composed line items
    public double calculateTotalFromItems() {
        double total = 0.0;
        for (OrderItem item : items) {
            total += item.getLineTotal();
        }
        return total;
    }
}
