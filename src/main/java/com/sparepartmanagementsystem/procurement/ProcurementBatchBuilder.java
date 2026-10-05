package com.sparepartmanagementsystem.procurement;

import java.time.LocalDate;

/**
 * DESIGN PATTERN: Builder Pattern (Creational)
 * Provides a fluent, step-by-step API to construct complex SupplierProduct procurement delivery batches.
 */
public class ProcurementBatchBuilder {

    private int batchId = 0;
    private String partId;
    private String partName;
    private String supplierName = "Generic Automotive Supplier";
    private int receivedQty = 1;
    private int availableQty = 1;
    private double supplierPrice = 0.0;
    private String qualityStatus = "PENDING";
    private String qualityNotes = "Awaiting QA Inspection";
    private String arrivalDate = LocalDate.now().toString();

    public ProcurementBatchBuilder() {}

    public ProcurementBatchBuilder withBatchId(int batchId) {
        this.batchId = batchId;
        return this;
    }

    public ProcurementBatchBuilder withPartId(String partId) {
        this.partId = partId;
        return this;
    }

    public ProcurementBatchBuilder withPartName(String partName) {
        this.partName = partName;
        return this;
    }

    public ProcurementBatchBuilder withSupplierName(String supplierName) {
        this.supplierName = supplierName;
        return this;
    }

    public ProcurementBatchBuilder withReceivedQty(int receivedQty) {
        this.receivedQty = Math.max(0, receivedQty);
        this.availableQty = this.receivedQty;
        return this;
    }

    public ProcurementBatchBuilder withAvailableQty(int availableQty) {
        this.availableQty = Math.max(0, availableQty);
        return this;
    }

    public ProcurementBatchBuilder withSupplierPrice(double supplierPrice) {
        this.supplierPrice = Math.max(0.0, supplierPrice);
        return this;
    }

    public ProcurementBatchBuilder withQualityStatus(String qualityStatus) {
        this.qualityStatus = qualityStatus;
        return this;
    }

    public ProcurementBatchBuilder withQualityNotes(String qualityNotes) {
        this.qualityNotes = qualityNotes;
        return this;
    }

    public ProcurementBatchBuilder withArrivalDate(String arrivalDate) {
        this.arrivalDate = arrivalDate;
        return this;
    }

    // Builds and returns the final SupplierProduct object
    public SupplierProduct build() {
        if (partId == null || partId.trim().isEmpty()) {
            throw new ProcurementException("Cannot build procurement batch: Part ID (SKU) is required.");
        }
        if (partName == null || partName.trim().isEmpty()) {
            throw new ProcurementException("Cannot build procurement batch: Part Name is required.");
        }
        return new SupplierProduct(
                batchId,
                partId.trim(),
                partName.trim(),
                supplierName != null ? supplierName.trim() : "Generic Automotive Supplier",
                receivedQty,
                availableQty,
                supplierPrice,
                qualityStatus,
                qualityNotes,
                arrivalDate
        );
    }
}
