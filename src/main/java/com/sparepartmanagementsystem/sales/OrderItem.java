package com.sparepartmanagementsystem.sales;

/**
 * OOP CONCEPT: Encapsulation
 * Represents an individual line item within a customer sales order.
 * Part of the Composition relationship where OrderItem belongs to a SalesOrder.
 */
public class OrderItem {
    private int itemId;
    private int orderId;
    private String partId;
    private String partName;
    private int quantity;
    private double unitPrice;
    private double lineTotal;

    // OOP CONCEPT: Default Constructor
    // Initializes an empty order item instance
    public OrderItem() {}

    // OOP CONCEPT: Parameterized Constructor
    // Initializes a complete order item instance with unit calculations
    public OrderItem(int itemId, int orderId, String partId, String partName, int quantity, double unitPrice, double lineTotal) {
        this.itemId = itemId;
        this.orderId = orderId;
        this.partId = partId;
        this.partName = partName;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = lineTotal;
    }

    // Retrieves the unique line item ID
    public int getItemId() { return itemId; }

    // Sets the unique line item ID
    public void setItemId(int itemId) { this.itemId = itemId; }

    // Retrieves the parent sales order ID
    public int getOrderId() { return orderId; }

    // Sets the parent sales order ID
    public void setOrderId(int orderId) { this.orderId = orderId; }

    // Retrieves the spare part SKU code
    public String getPartId() { return partId; }

    // Sets the spare part SKU code
    public void setPartId(String partId) { this.partId = partId; }

    // Retrieves the name of the spare part
    public String getPartName() { return partName; }

    // Sets the name of the spare part
    public void setPartName(String partName) { this.partName = partName; }

    // Retrieves the quantity purchased
    public int getQuantity() { return quantity; }

    // Sets the quantity purchased
    public void setQuantity(int quantity) { this.quantity = quantity; }

    // Retrieves the unit price per item
    public double getUnitPrice() { return unitPrice; }

    // Sets the unit price per item
    public void setUnitPrice(double unitPrice) { this.unitPrice = unitPrice; }

    // Retrieves the calculated line total price
    public double getLineTotal() { return lineTotal; }

    // Sets the calculated line total price
    public void setLineTotal(double lineTotal) { this.lineTotal = lineTotal; }
}
