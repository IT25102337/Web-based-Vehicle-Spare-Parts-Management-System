package com.sparepartmanagementsystem.inventory;

public abstract class BasePart {

    // Encapsulated private fields
    private String partId;
    private String partName;
    private double unitPrice;

    // Default constructor
    public BasePart() {}

    // Parameterized constructor
    public BasePart(String partId, String partName, double unitPrice) {
        this.partId = partId;
        this.partName = partName;
        this.unitPrice = unitPrice;
    }

    //Polymorphism - abstract method to calculate monetary valuation
    public abstract double calculateValuation();

    //Polymorphism - abstract method to check if stock needs replenishment
    public abstract boolean isRestockNeeded();

    // Gets the unique part ID
    public String getPartId() {
        return partId;
    }

    // Sets the unique part ID with safe null check
    public void setPartId(String partId) {
        this.partId = (partId != null) ? partId.trim() : "";
    }

    // Gets the human-readable part description
    public String getPartName() {
        return partName;
    }

    // Sets the human-readable part description
    public void setPartName(String partName) {
        this.partName = (partName != null) ? partName.trim() : "";
    }

    // Gets the retail unit price in Rupees
    public double getUnitPrice() {
        return unitPrice;
    }

    // Sets the unit price with minimum zero validation
    public void setUnitPrice(double unitPrice) {
        this.unitPrice = Math.max(0.0, unitPrice);
    }
}
