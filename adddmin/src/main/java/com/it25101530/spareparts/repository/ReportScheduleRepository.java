package com.it25101530.spareparts.repository;

import com.it25101530.spareparts.model.ReportSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ReportScheduleRepository extends JpaRepository<ReportSchedule, Long> {
}