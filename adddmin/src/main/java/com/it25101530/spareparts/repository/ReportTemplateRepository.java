package com.it25101530.spareparts.repository;

import com.it25101530.spareparts.model.ReportTemplate;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReportTemplateRepository extends JpaRepository<ReportTemplate, Long> {

    /** True if any row has this name (case-insensitive) — used when creating a new template. */
    boolean existsByTemplateNameIgnoreCase(String templateName);

    /** True if any row OTHER than {@code id} has this name — used when editing an existing template. */
    boolean existsByTemplateNameIgnoreCaseAndIdNot(String templateName, Long id);
}