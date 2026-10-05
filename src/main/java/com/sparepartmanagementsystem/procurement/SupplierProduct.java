package com.sparepartmanagementsystem.procurement;

/**
 * OOP CONCEPT: Encapsulation
 * Represents a Supplier Product Batch received from vendors undergoing Quality Control inspection.
 */
public class SupplierProduct {
    private int batchId;
    private String partId;
    private String partName;
    private String supplierName;
    private int receivedQty;
    private int availableQty;
    private double supplierPrice;
    private String qualityStatus;
    private String qualityNotes;
    private String arrivalDate;

    // OOP CONCEPT: Default Constructor
    // Initializes an empty supplier product batch instance
    public SupplierProduct() {}

    // OOP CONCEPT: Parameterized Constructor
    // Initializes a complete supplier product batch with received shipment details
    public SupplierProduct(int batchId, String partId, String partName, String supplierName, 
                           int receivedQty, int availableQty, double supplierPrice, 
                           String qualityStatus, String qualityNotes, String arrivalDate) {
        this.batchId = batchId;
        this.partId = partId;
        this.partName = partName;
        this.supplierName = supplierName;
        this.receivedQty = receivedQty;
        this.availableQty = availableQty;
        this.supplierPrice = supplierPrice;
        this.qualityStatus = qualityStatus;
        this.qualityNotes = qualityNotes;
        this.arrivalDate = arrivalDate;
    }

    // DESIGN PATTERN: Factory Pattern - Factory method creating shipment delivery batches
    public static SupplierProduct createDeliveryBatch(String partId, String partName, String supplierName, int receivedQty, double supplierPrice) {
        return new SupplierProduct(0, partId, partName, supplierName, receivedQty, receivedQty, supplierPrice, "PENDING", "Pending QA Review", java.time.LocalDate.now().toString());
    }

    // Retrieves unique batch shipment ID
    public int getBatchId() { return batchId; }

    // Sets unique batch shipment ID
    public void setBatchId(int batchId) { this.batchId = batchId; }

    // Retrieves spare part SKU code
    public String getPartId() { return partId; }

    // Sets spare part SKU code
    public void setPartId(String partId) { this.partId = partId; }

    // Retrieves descriptive name of the part
    public String getPartName() { return partName; }

    // Sets descriptive name of the part
    public void setPartName(String partName) { this.partName = partName; }

    // Retrieves the supplier or vendor company name
    public String getSupplierName() { return supplierName; }

    // Sets the supplier or vendor company name
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    // Retrieves quantity originally delivered
    public int getReceivedQty() { return receivedQty; }

    // Sets quantity originally delivered
    public void setReceivedQty(int receivedQty) { this.receivedQty = receivedQty; }

    // Retrieves remaining quantity available for warehouse intake
    public int getAvailableQty() { return availableQty; }

    // Sets remaining quantity available for warehouse intake
    public void setAvailableQty(int availableQty) { this.availableQty = availableQty; }

    // Retrieves per-unit supplier purchase cost
    public double getSupplierPrice() { return supplierPrice; }

    // Sets per-unit supplier purchase cost
    public void setSupplierPrice(double supplierPrice) { this.supplierPrice = supplierPrice; }

    // Retrieves current QA status (PENDING, APPROVED, REJECTED)
    public String getQualityStatus() { return qualityStatus; }

    // Sets current QA status
    public void setQualityStatus(String qualityStatus) { this.qualityStatus = qualityStatus; }

    // Retrieves inspector QA evaluation notes
    public String getQualityNotes() { return qualityNotes; }

    // Sets inspector QA evaluation notes
    public void setQualityNotes(String qualityNotes) { this.qualityNotes = qualityNotes; }

    // Retrieves calendar arrival date
    public String getArrivalDate() { return arrivalDate; }

    // Sets calendar arrival date
    public void setArrivalDate(String arrivalDate) { this.arrivalDate = arrivalDate; }

    // Checks if the shipment passed quality inspection
    public boolean isApproved() {
        return "APPROVED".equalsIgnoreCase(this.qualityStatus);
    }

    // Checks if the shipment was rejected due to quality defect
    public boolean isRejected() {
        return "REJECTED".equalsIgnoreCase(this.qualityStatus);
    }

    // Checks if the shipment is awaiting quality inspection
    public boolean isPending() {
        return "PENDING".equalsIgnoreCase(this.qualityStatus);
    }

    // Resolves image asset URL based on part description
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
