package com.sparepartmanagementsystem.sales;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

/**
 * DESIGN PATTERN: Builder Pattern (Creational)
 * Provides a fluent interface to construct complex SalesOrder instances along with nested OrderItems.
 */
public class SalesOrderBuilder {

    private int orderId = 0;
    private String customerName = "Walk-in Customer";
    private String orderDate = LocalDate.now().toString();
    private double totalAmount = 0.0;
    private String status = "PENDING";
    private String notes = "Standard Automotive Sales Order";
    private final List<OrderItem> items = new ArrayList<>();

    public SalesOrderBuilder() {}

    public SalesOrderBuilder withOrderId(int orderId) {
        this.orderId = orderId;
        return this;
    }

    public SalesOrderBuilder forCustomer(String customerName) {
        this.customerName = customerName;
        return this;
    }

    public SalesOrderBuilder onDate(String orderDate) {
        this.orderDate = orderDate;
        return this;
    }

    public SalesOrderBuilder withStatus(String status) {
        this.status = status;
        return this;
    }

    public SalesOrderBuilder withNotes(String notes) {
        this.notes = notes;
        return this;
    }

    // Fluently appends an individual line item to the order
    public SalesOrderBuilder addItem(String partId, String partName, int quantity, double unitPrice) {
        double lineTotal = quantity * unitPrice;
        OrderItem item = new OrderItem(0, this.orderId, partId, partName, quantity, unitPrice, lineTotal);
        this.items.add(item);
        this.totalAmount += lineTotal;
        return this;
    }

    // Appends a pre-constructed OrderItem
    public SalesOrderBuilder addItem(OrderItem item) {
        if (item != null) {
            this.items.add(item);
            this.totalAmount += item.getLineTotal();
        }
        return this;
    }

    // Builds the composite SalesOrder instance
    public SalesOrder build() {
        if (customerName == null || customerName.trim().isEmpty()) {
            throw new SalesException("Cannot build sales order: Customer name is required.");
        }
        SalesOrder order = new SalesOrder(orderId, customerName.trim(), orderDate, totalAmount, status, notes);
        order.setItems(new ArrayList<>(this.items));
        return order;
    }
}
