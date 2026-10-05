package com.sparepartmanagementsystem.supplier;

/**
 * OOP CONCEPT: Encapsulation
 * Represents a purchase request sent by the Spare Part Manager to an automotive supplier.
 */
public class SupplierOrder {
    private int orderId;
    private Integer restockRequestId;
    private String partId;
    private String partName;
    private String supplierName;
    private int requestedQty;
    private double expectedPrice;
    private String status;
    private String orderDate;
    private String deliveryNotes;
    private String requestedBy;

    // OOP CONCEPT: Default Constructor
    // Initializes an empty supplier purchase order instance
    public SupplierOrder() {}

    // OOP CONCEPT: Parameterized Constructor
    // Initializes a complete supplier purchase order instance
    public SupplierOrder(int orderId, Integer restockRequestId, String partId, String partName, 
                         String supplierName, int requestedQty, double expectedPrice, 
                         String status, String orderDate, String deliveryNotes, String requestedBy) {
        this.orderId = orderId;
        this.restockRequestId = restockRequestId;
        this.partId = partId;
        this.partName = partName;
        this.supplierName = supplierName;
        this.requestedQty = requestedQty;
        this.expectedPrice = expectedPrice;
        this.status = status;
        this.orderDate = orderDate;
        this.deliveryNotes = deliveryNotes;
        this.requestedBy = requestedBy;
    }

    // DESIGN PATTERN: Factory Pattern - Factory method creating purchase order instances
    public static SupplierOrder createPurchaseOrder(Integer restockId, String partId, String partName, String supplierName, int requestedQty, double expectedPrice, String requestedBy) {
        return new SupplierOrder(0, restockId, partId, partName, supplierName, requestedQty, expectedPrice, "PENDING", java.time.LocalDate.now().toString(), "Auto Generated Restock Order", requestedBy);
    }

    // Retrieves unique purchase order ID
    public int getOrderId() { return orderId; }

    // Sets unique purchase order ID
    public void setOrderId(int orderId) { this.orderId = orderId; }

    // Retrieves optional linked warehouse restock request ID
    public Integer getRestockRequestId() { return restockRequestId; }

    // Sets optional linked warehouse restock request ID
    public void setRestockRequestId(Integer restockRequestId) { this.restockRequestId = restockRequestId; }

    // Retrieves spare part SKU code
    public String getPartId() { return partId; }

    // Sets spare part SKU code
    public void setPartId(String partId) { this.partId = partId; }

    // Retrieves descriptive name of requested spare part
    public String getPartName() { return partName; }

    // Sets descriptive name of requested spare part
    public void setPartName(String partName) { this.partName = partName; }

    // Retrieves assigned supplier vendor name
    public String getSupplierName() { return supplierName; }

    // Sets assigned supplier vendor name
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    // Retrieves requested order quantity
    public int getRequestedQty() { return requestedQty; }

    // Sets requested order quantity
    public void setRequestedQty(int requestedQty) { this.requestedQty = requestedQty; }

    // Retrieves target per-unit expected purchase cost
    public double getExpectedPrice() { return expectedPrice; }

    // Sets target per-unit expected purchase cost
    public void setExpectedPrice(double expectedPrice) { this.expectedPrice = expectedPrice; }

    // Retrieves current order status (PENDING, DISPATCHED, REJECTED)
    public String getStatus() { return status; }

    // Sets current order status
    public void setStatus(String status) { this.status = status; }

    // Retrieves calendar date when the order was submitted
    public String getOrderDate() { return orderDate; }

    // Sets calendar date when the order was submitted
    public void setOrderDate(String orderDate) { this.orderDate = orderDate; }

    // Retrieves shipment delivery notes and instructions
    public String getDeliveryNotes() { return deliveryNotes; }

    // Sets shipment delivery notes and instructions
    public void setDeliveryNotes(String deliveryNotes) { this.deliveryNotes = deliveryNotes; }

    // Retrieves system user or manager who submitted the purchase request
    public String getRequestedBy() { return requestedBy; }

    // Sets system user or manager who submitted the purchase request
    public void setRequestedBy(String requestedBy) { this.requestedBy = requestedBy; }

    // Checks if the order is still awaiting supplier dispatch
    public boolean isPending() {
        return "PENDING".equalsIgnoreCase(this.status);
    }

    // Checks if the supplier has shipped the order
    public boolean isDispatched() {
        return "DISPATCHED".equalsIgnoreCase(this.status);
    }

    // Checks if the order was declined by the supplier
    public boolean isRejected() {
        return "REJECTED".equalsIgnoreCase(this.status);
    }
}
