package com.sparepartmanagementsystem.inventory;

/**
 * OOP CONCEPTS: Inheritance, Polymorphism & Encapsulation
 * Represents physical stock stored inside warehouse racks.
 */
public class InventoryItem extends BasePart {

    // Encapsulated inventory-specific private fields
    private int quantity;                          // Current units in storage
    private int reorderLevel;                      // Minimum threshold before alert
    private String storageLocation = "Rack A-01";  // Physical rack shelf location

    // Default constructor for frameworks and JSON binding
    public InventoryItem() {
        super();
    }

    // Constructor with 5 arguments for backward compatibility
    public InventoryItem(String partId, String partName, int quantity, int reorderLevel, double unitPrice) {
        this(partId, partName, quantity, reorderLevel, unitPrice, "Rack A-01");
    }

    // Full constructor initializing all fields using parent constructor (Inheritance)
    public InventoryItem(String partId, String partName, int quantity, int reorderLevel, double unitPrice, String storageLocation) {
        super(partId, partName, unitPrice);
        this.quantity = quantity;
        this.reorderLevel = reorderLevel;
        this.storageLocation = (storageLocation != null && !storageLocation.trim().isEmpty()) ? storageLocation.trim() : "Rack A-01";
    }

    // POLYMORPHISM: Overrides abstract calculateValuation() from BasePart
    @Override
    public double calculateValuation() {
        return this.quantity * getUnitPrice();
    }

    // POLYMORPHISM: Overrides abstract isRestockNeeded() from BasePart
    @Override
    public boolean isRestockNeeded() {
        return this.quantity <= this.reorderLevel;
    }

    // Helper getter for JSP EL expression ${item.totalValue}
    public double getTotalValue() {
        return calculateValuation();
    }

    // Helper getter for JSP EL expression ${item.lowStock}
    public boolean isLowStock() {
        return isRestockNeeded();
    }

    // Returns true if the part is completely out of stock
    public boolean isOutOfStock() {
        return this.quantity == 0;
    }

    // Gets the current stock quantity in warehouse
    public int getQuantity() {
        return quantity;
    }

    // Sets the stock quantity with minimum zero validation
    public void setQuantity(int quantity) {
        this.quantity = Math.max(0, quantity);
    }

    // Gets the safety reorder alert threshold
    public int getReorderLevel() {
        return reorderLevel;
    }

    // Sets the safety reorder alert threshold
    public void setReorderLevel(int reorderLevel) {
        this.reorderLevel = Math.max(0, reorderLevel);
    }

    // Gets the physical warehouse rack location
    public String getStorageLocation() {
        return (storageLocation != null && !storageLocation.trim().isEmpty()) ? storageLocation.trim() : "Rack A-01";
    }

    // Sets the physical warehouse rack location
    public void setStorageLocation(String storageLocation) {
        this.storageLocation = storageLocation;
    }

    // Resolves part image URL based on part name and SKU
    public String getImageUrl() {
        String name = getPartName();
        String id = getPartId();
        if (name == null && id == null) return "/images/parts/default_part.jpg";
        String lower = ((name != null ? name : "") + " " + (id != null ? id : "")).toLowerCase();
        if (lower.contains("engine")) return "/images/parts/engine.jpg";
        if (lower.contains("wheel") || lower.contains("tire") || lower.contains("tyre") || lower.contains("rim")) return "/images/parts/wheel.jpg";
        if (lower.contains("nut") || lower.contains("bolt") || lower.contains("screw") || lower.contains("peanut") || lower.contains("fastener")) return "/images/parts/nuts.jpg";
        if (lower.contains("brake") || lower.contains("pad") || lower.contains("disc") || lower.contains("rotor") || lower.contains("caliper")) return "/images/parts/brake_pad.jpg";
        if (lower.contains("spark") || lower.contains("plug") || lower.contains("ignition")) return "/images/parts/spark_plug.jpg";
        if (lower.contains("oil") || lower.contains("filter") || lower.contains("lube")) return "/images/parts/oil_filter.jpg";
        return "/images/parts/default_part.jpg";
    }
}
