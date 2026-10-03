package com.sparepartmanagementsystem.inventory;

/**
 * OOP CONCEPT: Encapsulation (Entity Model)
 * Represents an inter-departmental replenishment request sent from Inventory to Spare Parts.
 */
public class RestockRequest {

    // Encapsulated private fields
    private int requestId;
    private String partId;
    private String partName;
    private int currentQuantity;
    private int requestedQuantity;
    private String requestMessage;
    private String requestDate;
    private String status; // 'PENDING', 'FULFILLED', 'ORDERED_FROM_SUPPLIER'

    // Default constructor for frameworks
    public RestockRequest() {}

    // Parameterized constructor to initialize a restock request
    public RestockRequest(int requestId, String partId, String partName, int currentQuantity,
                          int requestedQuantity, String requestMessage, String requestDate, String status) {
        this.requestId = requestId;
        this.partId = partId;
        this.partName = partName;
        this.currentQuantity = currentQuantity;
        this.requestedQuantity = requestedQuantity;
        this.requestMessage = requestMessage;
        this.requestDate = requestDate;
        this.status = status;
    }

    // Gets the database request ID
    public int getRequestId() {
        return requestId;
    }

    // Sets the database request ID
    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    // Gets the part ID needing restock
    public String getPartId() {
        return partId;
    }

    // Sets the part ID needing restock
    public void setPartId(String partId) {
        this.partId = partId;
    }

    // Gets the part name description
    public String getPartName() {
        return partName;
    }

    // Sets the part name description
    public void setPartName(String partName) {
        this.partName = partName;
    }

    // Gets the current quantity at time of request
    public int getCurrentQuantity() {
        return currentQuantity;
    }

    // Sets the current quantity at time of request
    public void setCurrentQuantity(int currentQuantity) {
        this.currentQuantity = currentQuantity;
    }

    // Gets the number of units requested from procurement
    public int getRequestedQuantity() {
        return requestedQuantity;
    }

    // Sets the number of units requested from procurement
    public void setRequestedQuantity(int requestedQuantity) {
        this.requestedQuantity = requestedQuantity;
    }

    // Gets the custom manager request message
    public String getRequestMessage() {
        return requestMessage;
    }

    // Sets the custom manager request message
    public void setRequestMessage(String requestMessage) {
        this.requestMessage = requestMessage;
    }

    // Gets the date when the request was transmitted
    public String getRequestDate() {
        return requestDate;
    }

    // Sets the date when the request was transmitted
    public void setRequestDate(String requestDate) {
        this.requestDate = requestDate;
    }

    // Gets the request lifecycle status
    public String getStatus() {
        return status;
    }

    // Sets the request lifecycle status
    public void setStatus(String status) {
        this.status = status;
    }

    // Checks if the request is still awaiting action from spare parts
    public boolean isPending() {
        return "PENDING".equalsIgnoreCase(this.status);
    }

    // Checks if the request has been completed and intaked
    public boolean isFulfilled() {
        return "FULFILLED".equalsIgnoreCase(this.status);
    }

    // Resolves image for requested part
    public String getImageUrl() {
        if (partName == null && partId == null) return "/images/parts/default_part.jpg";
        String lower = ((partName != null ? partName : "") + " " + (partId != null ? partId : "")).toLowerCase();
        if (lower.contains("engine")) return "/images/parts/engine.jpg";
        if (lower.contains("wheel") || lower.contains("tire") || lower.contains("tyre") || lower.contains("rim")) return "/images/parts/wheel.jpg";
        if (lower.contains("nut") || lower.contains("bolt") || lower.contains("screw") || lower.contains("peanut") || lower.contains("fastener")) return "/images/parts/nuts.jpg";
        if (lower.contains("brake") || lower.contains("pad") || lower.contains("disc") || lower.contains("rotor") || lower.contains("caliper")) return "/images/parts/brake_pad.jpg";
        if (lower.contains("spark") || lower.contains("plug") || lower.contains("ignition")) return "/images/parts/spark_plug.jpg";
        if (lower.contains("oil") || lower.contains("filter") || lower.contains("lube")) return "/images/parts/oil_filter.jpg";
        return "/images/parts/default_part.jpg";
    }
}
