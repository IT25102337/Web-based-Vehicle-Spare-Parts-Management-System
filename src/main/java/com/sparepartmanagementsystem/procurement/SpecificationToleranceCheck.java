package com.sparepartmanagementsystem.procurement;

/**
 * DESIGN PATTERN: Chain of Responsibility Pattern (Concrete Handler 2)
 * Verifies automotive technical specification tolerances and purchase price sanity.
 */
public class SpecificationToleranceCheck extends QualityInspectionStep {

    @Override
    public boolean inspect(SupplierProduct batch) {
        if (batch == null) {
            return false;
        }

        // Validate part description
        if (batch.getPartName() == null || batch.getPartName().trim().isEmpty()) {
            batch.setQualityNotes("Failed Specification Inspection: Part name description is missing.");
            return false;
        }

        // Validate pricing bounds
        if (batch.getSupplierPrice() < 0.0) {
            batch.setQualityNotes("Failed Specification Inspection: Supplier unit price cannot be negative.");
            return false;
        }

        // Passed step 2, proceed to next step in chain
        return checkNext(batch);
    }
}
