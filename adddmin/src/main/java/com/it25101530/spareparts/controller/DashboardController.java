package com.it25101530.spareparts.controller;

import com.it25101530.spareparts.dto.DashboardSummary;
import com.it25101530.spareparts.model.ReportSchedule;
import com.it25101530.spareparts.model.ReportTemplate;
import com.it25101530.spareparts.service.DashboardService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@Controller
@RequestMapping("/admin/dashboard")
public class DashboardController {

    @Autowired
    private DashboardService dashboardService;

    @GetMapping
    public String viewDashboard(Model model){
        DashboardSummary summary = dashboardService.retrieveDashboardData();
        model.addAttribute("summary", summary);
        model.addAttribute("templates", dashboardService.getAllTemplates());
        model.addAttribute("schedules", dashboardService.getAllSchedules());
        return "dashboard";
    }

    @PostMapping("/templates/create")
    public String createTemplate(@ModelAttribute ReportTemplate template, Model model) {
        String name = template.getTemplateName() == null ? "" : template.getTemplateName().trim();
        if (name.isBlank()) {
            model.addAttribute("templateError", "Template name must not be blank.");
            model.addAttribute("enteredName", name);
            model.addAttribute("enteredFilters", template.getTemplateFilters());
            return viewDashboard(model);
        }
        if (dashboardService.isTemplateNameTaken(name)) {
            model.addAttribute("templateError", "Template name already in use");
            model.addAttribute("enteredName", name);
            model.addAttribute("enteredFilters", template.getTemplateFilters());
            return viewDashboard(model);
        }
        try {
            template.setTemplateName(name);
            dashboardService.saveTemplate(template);
        } catch (DataIntegrityViolationException e) {
            model.addAttribute("templateError", "Template name already in use");
            model.addAttribute("enteredName", name);
            model.addAttribute("enteredFilters", template.getTemplateFilters());
            return viewDashboard(model);
        }
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/templates/delete/{id}")
    public String deleteTemplate(@PathVariable Long id) {
        dashboardService.deleteTemplate(id);
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/templates/update/{id}")
    public String updateTemplate(@PathVariable Long id,
                                 @ModelAttribute ReportTemplate template,
                                 Model model) {
        String name = template.getTemplateName() == null ? "" : template.getTemplateName().trim();
        if (name.isBlank() || template.getTemplateFilters() == null || template.getTemplateFilters().isBlank()) {
            model.addAttribute("templateEditError", "Template name and filters must not be blank.");
            return viewDashboard(model);
        }
        if (dashboardService.isTemplateNameTakenByOther(name, id)) {
            model.addAttribute("templateEditError", "Template name already in use");
            return viewDashboard(model);
        }
        try {
            template.setTemplateName(name);
            dashboardService.updateTemplate(id, template);
        } catch (DataIntegrityViolationException e) {
            model.addAttribute("templateEditError", "Template name already in use");
            return viewDashboard(model);
        }
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/schedules/create")
    public String createSchedule(@RequestParam("templateId") Long templateId,
                                 @RequestParam("frequency") String frequency,
                                 @RequestParam("deliveryEmail") String deliveryEmail,
                                 Model model) {
        if (deliveryEmail == null || !deliveryEmail.contains("@")) {
            model.addAttribute("scheduleEmailError", "Invalid Email");
            return viewDashboard(model);
        }
        Optional<ReportTemplate> tpl = dashboardService.getTemplateById(templateId);
        if (tpl.isEmpty()) {
            model.addAttribute("scheduleEmailError", "Please select a valid template.");
            return viewDashboard(model);
        }
        ReportSchedule schedule = new ReportSchedule();
        schedule.setTemplate(tpl.get());
        schedule.setFrequency(frequency);
        schedule.setDeliveryEmail(deliveryEmail);
        dashboardService.saveSchedule(schedule);
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/schedules/cancel/{id}")
    public String cancelSchedule(@PathVariable Long id) {
        dashboardService.cancelSchedule(id);
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/schedules/update/{id}")
    public String updateSchedule(@PathVariable Long id,
                                 @RequestParam("templateId") Long templateId,
                                 @RequestParam("frequency") String frequency,
                                 @RequestParam("deliveryEmail") String deliveryEmail,
                                 Model model) {
        if (frequency == null || frequency.isBlank()) {
            model.addAttribute("scheduleEmailError", "Frequency must not be blank.");
            return viewDashboard(model);
        }
        if (deliveryEmail == null || !deliveryEmail.contains("@")) {
            model.addAttribute("scheduleEmailError", "Invalid Email");
            return viewDashboard(model);
        }
        Optional<ReportTemplate> tpl = dashboardService.getTemplateById(templateId);
        if (tpl.isEmpty()) {
            model.addAttribute("scheduleEmailError", "Please select a valid template.");
            return viewDashboard(model);
        }
        ReportSchedule updated = new ReportSchedule();
        updated.setTemplate(tpl.get());
        updated.setFrequency(frequency);
        updated.setDeliveryEmail(deliveryEmail);
        dashboardService.updateSchedule(id, updated);
        return "redirect:/admin/dashboard";
    }

    @PostMapping("/reports/generate")
    public String generateReport(@RequestParam(value = "templateId", required = false) Long templateId,
                                 @RequestParam(value = "fromDate", required = false)
                                     @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate fromDate,
                                 @RequestParam(value = "toDate", required = false)
                                     @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate toDate,
                                 Model model) {
        // Parameter validation
        if (templateId == null) {
            model.addAttribute("reportMessage", "Please select a template before generating a report.");
            return viewDashboard(model);
        }
        if (fromDate == null || toDate == null) {
            model.addAttribute("reportMessage", "Please specify both a start date and an end date.");
            return viewDashboard(model);
        }
        if (fromDate.isAfter(toDate)) {
            model.addAttribute("reportMessage", "Start date must not be later than end date.");
            return viewDashboard(model);
        }
        // Proceed with generation
        DashboardSummary summary = dashboardService.retrieveDashboardData();
        if (summary.isDataAvailable()) {
            Optional<ReportTemplate> templateOpt = dashboardService.getTemplateById(templateId);
            String templateName = templateOpt.map(ReportTemplate::getTemplateName).orElse("Unknown");
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            
            model.addAttribute("reportMessage",
                "Business Report Generated Successfully for template " + templateName
                    + " from " + fromDate.format(formatter) + " to " + toDate.format(formatter) + ".");
        } else {
            model.addAttribute("reportMessage", "No records available for report generation.");
        }
        return viewDashboard(model);
    }
}