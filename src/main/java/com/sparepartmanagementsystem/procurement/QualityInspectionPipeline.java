package com.sparepartmanagementsystem.procurement;

/**
 * DESIGN PATTERN: Chain of Responsibility Pattern (Pipeline Client)
 * Builds and executes the chain of quality inspection handlers for arriving vendor shipments.
 */
public class QualityInspectionPipeline {

    private final QualityInspectionStep rootStep;

    public QualityInspectionPipeline() {
        // Build the chain of responsibility: Packaging -> Specifications
        QualityInspectionStep packaging = new PackagingIntegrityCheck();
        QualityInspectionStep specification = new SpecificationToleranceCheck();

        packaging.setNext(specification);
        this.rootStep = packaging;
    }

    // Runs a batch through the inspection pipeline
    public boolean processInspection(SupplierProduct batch) {
        if (batch == null) return false;

        boolean passed = rootStep.inspect(batch);
        if (passed) {
            batch.setQualityStatus("APPROVED");
            batch.setQualityNotes("Passed Quality Inspection Chain (Packaging & Specifications Verified).");
        } else {
            batch.setQualityStatus("REJECTED");
        }
        return passed;
    }
}
