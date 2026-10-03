package com.it25101530.spareparts.service;

import com.it25101530.spareparts.dto.DashboardSummary;
import com.it25101530.spareparts.model.ReportSchedule;
import com.it25101530.spareparts.model.ReportTemplate;
import com.it25101530.spareparts.repository.ReportScheduleRepository;
import com.it25101530.spareparts.repository.ReportTemplateRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class DashboardService {

    @Autowired
    private ReportTemplateRepository templateRepository;

    @Autowired
    private ReportScheduleRepository scheduleRepository;

    public DashboardSummary retrieveDashboardData() {
        DashboardSummary summary = new DashboardSummary();

        // Simulating data retrieval for inventory, sales, suppliers, etc.
        // In a full implementation, these would query their respective repositories.
        summary.setTotalSales(1450);
        summary.setStockItems(8200);
        summary.setPendingOrders(34);
        summary.setSupplierDeliveries(12);

        // Fulfilling the "Is required data available?" decision node
        summary.setDataAvailable(summary.getTotalSales() > 0 || summary.getStockItems() > 0);

        return summary;
    }

    // --- Template Management ---
    public void saveTemplate(ReportTemplate template) {
        templateRepository.save(template);
    }

    public void updateTemplate(Long id, ReportTemplate updatedTemplate) {
        Optional<ReportTemplate> existing = templateRepository.findById(id);
        if (existing.isPresent()) {
            ReportTemplate template = existing.get();
            template.setTemplateName(updatedTemplate.getTemplateName());
            template.setTemplateFilters(updatedTemplate.getTemplateFilters());
            templateRepository.save(template);
        }
    }

    public void deleteTemplate(Long id) {
        templateRepository.deleteById(id);
    }

    public List<ReportTemplate> getAllTemplates() {
        return templateRepository.findAll();
    }

    public boolean isTemplateNameTaken(String name) {
        return templateRepository.existsByTemplateNameIgnoreCase(name.trim());
    }

    public boolean isTemplateNameTakenByOther(String name, Long excludeId) {
        return templateRepository.existsByTemplateNameIgnoreCaseAndIdNot(name.trim(), excludeId);
    }

    // --- Schedule Management ---
    public void saveSchedule(ReportSchedule schedule) {
        scheduleRepository.save(schedule);
    }

    public Optional<ReportTemplate> getTemplateById(Long id) {
        return templateRepository.findById(id);
    }

    public void updateSchedule(Long id, ReportSchedule updatedSchedule) {
        Optional<ReportSchedule> existing = scheduleRepository.findById(id);
        if(existing.isPresent()){
            ReportSchedule schedule = existing.get();
            schedule.setTemplate(updatedSchedule.getTemplate());
            schedule.setFrequency(updatedSchedule.getFrequency());
            schedule.setDeliveryEmail(updatedSchedule.getDeliveryEmail());
            scheduleRepository.save(schedule);
        }
    }

    public void cancelSchedule(Long id) {
        scheduleRepository.deleteById(id);
    }

    public List<ReportSchedule> getAllSchedules() {
        return scheduleRepository.findAll();
    }
}