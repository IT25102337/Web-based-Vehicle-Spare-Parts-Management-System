package com.sparepartmanagementsystem.procurement;

/**
 * DESIGN PATTERN: Chain of Responsibility Pattern (Handler Interface/Base)
 * Defines the contract for steps in the Quality Control (QC) inspection pipeline.
 * Each handler evaluates a specific automotive quality standard before passing to the next step.
 */
public abstract class QualityInspectionStep {

    private QualityInspectionStep nextStep;

    // Links the next inspection step in the chain
    public QualityInspectionStep setNext(QualityInspectionStep nextStep) {
        this.nextStep = nextStep;
        return nextStep;
    }

    // Inspects the supplier batch. Subclasses implement specific criteria evaluation.
    public abstract boolean inspect(SupplierProduct batch);

    // Passes evaluation along to the next step if one exists
    protected boolean checkNext(SupplierProduct batch) {
        if (nextStep == null) {
            return true;
        }
        return nextStep.inspect(batch);
    }
}
