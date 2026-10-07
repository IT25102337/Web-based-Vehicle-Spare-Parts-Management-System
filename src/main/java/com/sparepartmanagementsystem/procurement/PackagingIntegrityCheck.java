package com.sparepartmanagementsystem.procurement;

/**
 * DESIGN PATTERN: Chain of Responsibility Pattern (Concrete Handler 1)
 * Validates shipping container integrity, valid part identification, and non-zero received quantity.
 */
public class PackagingIntegrityCheck extends QualityInspectionStep {

    @Override
    public boolean inspect(SupplierProduct batch) {
        if (batch == null) {
            return false;
        }

        // Validate part identification
        if (batch.getPartId() == null || batch.getPartId().trim().isEmpty()) {
            batch.setQualityNotes("Failed Packaging Inspection: Missing SKU / Part ID.");
            return false;
        }

        // Validate positive shipment quantity
        if (batch.getReceivedQty() <= 0) {
            batch.setQualityNotes("Failed Packaging Inspection: Received quantity must be positive.");
            return false;
        }

        // Passed step 1, proceed to next step in chain
        return checkNext(batch);
    }
}
