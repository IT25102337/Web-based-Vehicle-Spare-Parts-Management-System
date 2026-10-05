package com.sparepartmanagementsystem.reportmanager;

import com.sparepartmanagementsystem.core.PdfReportService;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.*;

/**
 * OOP CONCEPTS: Controller Layer, Association & Dependency Injection
 * UML RELATIONSHIP: Association (ReportManagerController associates with ReportManagerService and PdfReportService)
 * Central controller managing Report & Business Dashboard Manager views, unified multi-department reports, audit approvals, and automated schedulers.
 */
@Controller
@RequestMapping({"/reports", "/reportmanager", "/report"})
public class ReportManagerController {

    // UML RELATIONSHIP: Association
    @Autowired
    private ReportManagerService reportManagerService;

    // UML RELATIONSHIP: Association
    @Autowired
    private PdfReportService pdfReportService;

    // UI 1: Displays the Report & Business Dashboard Manager 360-degree executive control tower
    @GetMapping({"", "/", "/dashboard"})
    public String viewDashboard(Model model) {
        DashboardSummary summary = reportManagerService.retrieveDashboardData();
        Map<String, Object> enterpriseData = reportManagerService.getComprehensiveEnterpriseMetrics();

        model.addAttribute("summary", summary);
        model.addAttribute("inventoryReports", reportManagerService.getAllInventoryReports());
        model.addAttribute("invData", enterpriseData.get("inventory"));
        model.addAttribute("supplierData", enterpriseData.get("supplier"));
        model.addAttribute("qaData", enterpriseData.get("procurement"));
        model.addAttribute("salesData", enterpriseData.get("sales"));
        model.addAttribute("custData", enterpriseData.get("customer"));
        model.addAttribute("activeNav", "dashboard");

        return "reportmanager/report_dashboard";
    }

    // UI 2: Displays the multi-department unified report generator interface
    @GetMapping("/generator")
    public String viewGenerator(Model model) {
        model.addAttribute("summary", reportManagerService.retrieveDashboardData());
        model.addAttribute("inventoryReports", reportManagerService.getAllInventoryReports());
        model.addAttribute("activeNav", "generator");
        return "reportmanager/report_generator";
    }

    // UI 3: Displays the manager audit and inspection inbox interface for executive approval decisions
    @GetMapping("/audits")
    public String viewAudits(Model model) {
        model.addAttribute("summary", reportManagerService.retrieveDashboardData());
        model.addAttribute("inventoryReports", reportManagerService.getAllInventoryReports());
        model.addAttribute("activeNav", "audits");
        return "reportmanager/report_audits";
    }

    // UI 4: Displays the report template engine and automated recurring report scheduler
    @GetMapping({"/templates", "/schedules", "/report-templates", "/report_templates", "/template", "/report-schedules", "/report_schedules"})
    public String viewTemplates(Model model) {
        model.addAttribute("summary", reportManagerService.retrieveDashboardData());
        model.addAttribute("templates", reportManagerService.getAllTemplates());
        model.addAttribute("schedules", reportManagerService.getAllSchedules());
        model.addAttribute("inventoryReports", reportManagerService.getAllInventoryReports());
        model.addAttribute("activeNav", "templates");
        return "reportmanager/report_templates";
    }

    // Compiles a combined multi-department audit report with options to download as PDF, TXT, or save to queue
    @PostMapping("/generate-combined")
    public Object generateCombinedReport(@RequestParam(defaultValue = "Executive Cross-Functional Operations Audit") String reportTitle,
                                         @RequestParam(name = "selectedModules", required = false) List<String> selectedModules,
                                         @RequestParam(required = false) String fromDate,
                                         @RequestParam(required = false) String toDate,
                                         @RequestParam(defaultValue = "Weekly") String frequency,
                                         @RequestParam(defaultValue = "pdf") String outputFormat,
                                         HttpSession session,
                                         RedirectAttributes redirectAttributes) {
        try {
            String author = (String) session.getAttribute("fullName");
            if (author == null || author.isBlank()) author = (String) session.getAttribute("currentUser");
            if (author == null || author.isBlank()) author = "Report & Business Dashboard Manager";

            if (selectedModules == null || selectedModules.isEmpty()) {
                selectedModules = Arrays.asList("inventory", "supplier", "spareparts", "sales", "customer");
            }

            Map<String, Object> compiled = reportManagerService.compileMultiDepartmentReport(selectedModules, reportTitle, frequency, "", author);
            String content = (String) compiled.get("textSummary");

            Long reportId = reportManagerService.saveGeneratedUnifiedReport(reportTitle, frequency, outputFormat, content, "Auto-generated multi-department audit", author);
            InventoryReport report = reportManagerService.getInventoryReportById(reportId).orElse(null);

            if ("txt".equalsIgnoreCase(outputFormat)) {
                byte[] txtBytes = content.getBytes(StandardCharsets.UTF_8);
                String filename = "Report_#" + reportId + "_" + reportTitle.replaceAll("[^a-zA-Z0-9_-]", "_") + ".txt";
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                        .contentType(MediaType.TEXT_PLAIN)
                        .body(txtBytes);
            } else {
                byte[] pdfBytes = (report != null) ? pdfReportService.generateInventoryReportPdf(report) : content.getBytes(StandardCharsets.UTF_8);
                String filename = "Report_#" + reportId + "_" + reportTitle.replaceAll("[^a-zA-Z0-9_-]", "_") + ".pdf";
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                        .contentType(MediaType.APPLICATION_PDF)
                        .body(pdfBytes);
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to compile multi-department report: " + e.getMessage());
            return "redirect:/reports/generator";
        }
    }

    // Downloads an existing official report record in PDF format
    @GetMapping("/download/{id}")
    public ResponseEntity<byte[]> downloadPdf(@PathVariable Long id) {
        Optional<InventoryReport> repOpt = reportManagerService.getInventoryReportById(id);
        if (repOpt.isPresent()) {
            InventoryReport report = repOpt.get();
            byte[] pdfBytes = pdfReportService.generateInventoryReportPdf(report);
            String filename = "Report_#" + report.getReportId() + "_" + report.getReportTitle().replaceAll("[^a-zA-Z0-9_-]", "_") + ".pdf";
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                    .contentType(MediaType.APPLICATION_PDF)
                    .body(pdfBytes);
        }
        return ResponseEntity.notFound().build();
    }

    // Downloads an existing official report record in TXT format
    @GetMapping("/download-txt/{id}")
    public ResponseEntity<byte[]> downloadTxt(@PathVariable Long id) {
        Optional<InventoryReport> repOpt = reportManagerService.getInventoryReportById(id);
        if (repOpt.isPresent()) {
            InventoryReport report = repOpt.get();
            byte[] txtBytes = report.getReportContent() != null ? report.getReportContent().getBytes(StandardCharsets.UTF_8) : new byte[0];
            String filename = "Report_#" + report.getReportId() + "_" + report.getReportTitle().replaceAll("[^a-zA-Z0-9_-]", "_") + ".txt";
            return ResponseEntity.ok()
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                    .contentType(MediaType.TEXT_PLAIN)
                    .body(txtBytes);
        }
        return ResponseEntity.notFound().build();
    }

    // Reviews and certifies manager audit reports with Approved or Rejected decision status
    @RequestMapping(value = "/review", method = {RequestMethod.GET, RequestMethod.POST})
    public String reviewReport(@RequestParam Long reportId,
                               @RequestParam(required = false) String decision,
                               @RequestParam(required = false) String status,
                               @RequestParam(defaultValue = "") String notes,
                               @RequestParam(defaultValue = "/reports/audits") String redirectUrl,
                               RedirectAttributes redirectAttributes) {
        String finalStatus = (status != null && !status.isBlank()) ? status : decision;
        if (finalStatus == null || finalStatus.isBlank()) {
            finalStatus = "Approved";
        } else if ("APPROVE".equalsIgnoreCase(finalStatus)) {
            finalStatus = "Approved";
        } else if ("REJECT".equalsIgnoreCase(finalStatus)) {
            finalStatus = "Rejected";
        }
        reportManagerService.reviewReport(reportId, finalStatus, notes);
        redirectAttributes.addFlashAttribute("reportMessage", "Report #" + reportId + " status updated to " + finalStatus + "!");
        redirectAttributes.addFlashAttribute("reportSuccess", !"Rejected".equalsIgnoreCase(finalStatus));
        return "redirect:" + (redirectUrl != null && !redirectUrl.isBlank() ? redirectUrl : "/reports/audits");
    }

    // Deletes an official audit report from the system archive
    @PostMapping("/delete")
    public String deleteReport(@RequestParam Long reportId,
                               @RequestParam(defaultValue = "/reports/audits") String redirectUrl,
                               RedirectAttributes redirectAttributes) {
        reportManagerService.deleteReport(reportId);
        redirectAttributes.addFlashAttribute("reportMessage", "Report #" + reportId + " deleted successfully.");
        redirectAttributes.addFlashAttribute("reportSuccess", true);
        return "redirect:" + (redirectUrl != null && !redirectUrl.isBlank() ? redirectUrl : "/reports/audits");
    }

    // Creates and saves a new report template
    @PostMapping("/templates/create")
    public String createTemplate(@RequestParam String templateName,
                                 @RequestParam(name = "selectedModules", required = false) List<String> selectedModules,
                                 @RequestParam(name = "modules", required = false) List<String> modules,
                                 @RequestParam(defaultValue = "Weekly") String frequency,
                                 RedirectAttributes redirectAttributes) {
        try {
            if (templateName == null || templateName.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Template title is required.");
                return "redirect:/reports/templates";
            }
            if (reportManagerService.isTemplateNameTaken(templateName)) {
                redirectAttributes.addFlashAttribute("errorMessage", "Template '" + templateName.trim() + "' already exists.");
                return "redirect:/reports/templates";
            }
            List<String> targetModules = (selectedModules != null && !selectedModules.isEmpty()) ? selectedModules : modules;
            String filters = (targetModules != null && !targetModules.isEmpty()) ? String.join(", ", targetModules) : "All Departments";
            reportManagerService.saveTemplate(new ReportTemplate(null, templateName.trim(), filters, frequency, null));
            redirectAttributes.addFlashAttribute("successMessage", "Report Template '" + templateName.trim() + "' saved successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to save template: " + e.getMessage());
        }
        return "redirect:/reports/templates";
    }

    // Updates an existing report template
    @PostMapping("/templates/update/{id}")
    public String updateTemplate(@PathVariable Long id,
                                 @RequestParam String templateName,
                                 @RequestParam(name = "selectedModules", required = false) List<String> selectedModules,
                                 @RequestParam(name = "modules", required = false) List<String> modules,
                                 @RequestParam(defaultValue = "Weekly") String frequency,
                                 RedirectAttributes redirectAttributes) {
        try {
            List<String> targetModules = (selectedModules != null && !selectedModules.isEmpty()) ? selectedModules : modules;
            String filters = (targetModules != null && !targetModules.isEmpty()) ? String.join(", ", targetModules) : "All Departments";
            reportManagerService.updateTemplate(id, new ReportTemplate(id, templateName.trim(), filters, frequency, null));
            redirectAttributes.addFlashAttribute("successMessage", "Report Template updated successfully!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to update template: " + e.getMessage());
        }
        return "redirect:/reports/templates";
    }

    // Deletes an existing report template and associated recurring schedules
    @PostMapping("/templates/delete/{id}")
    public String deleteTemplate(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            reportManagerService.deleteTemplate(id);
            redirectAttributes.addFlashAttribute("successMessage", "Template and associated recurring schedules deleted.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to delete template: " + e.getMessage());
        }
        return "redirect:/reports/templates";
    }

    // Compiles on-demand report from a saved template and provides immediate file download
    @GetMapping("/templates/generate/{id}")
    public Object generateFromTemplate(@PathVariable Long id,
                                       @RequestParam(defaultValue = "pdf") String format,
                                       HttpSession session,
                                       RedirectAttributes redirectAttributes) {
        Optional<ReportTemplate> tplOpt = reportManagerService.getTemplateById(id);
        if (tplOpt.isEmpty()) {
            redirectAttributes.addFlashAttribute("errorMessage", "Template #" + id + " not found.");
            return "redirect:/reports/templates";
        }
        ReportTemplate tpl = tplOpt.get();
        List<String> modules = Arrays.asList(tpl.getTemplateFilters().toLowerCase().split(",\\s*"));
        return generateCombinedReport(tpl.getTemplateName(), modules, null, null, tpl.getFrequency(), format, session, redirectAttributes);
    }

    // Creates an automated report delivery schedule linked to a template
    @PostMapping("/schedules/create")
    public String createSchedule(@RequestParam Long templateId,
                                 @RequestParam String frequency,
                                 @RequestParam String deliveryEmail,
                                 RedirectAttributes redirectAttributes) {
        try {
            Optional<ReportTemplate> tplOpt = reportManagerService.getTemplateById(templateId);
            if (tplOpt.isPresent()) {
                reportManagerService.saveSchedule(new ReportSchedule(null, tplOpt.get(), frequency, deliveryEmail));
                redirectAttributes.addFlashAttribute("successMessage", "Automated email delivery schedule created!");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to create schedule: " + e.getMessage());
        }
        return "redirect:/reports/templates";
    }

    // Cancels and deletes an automated report schedule
    @PostMapping("/schedules/cancel/{id}")
    public String cancelSchedule(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            reportManagerService.cancelSchedule(id);
            redirectAttributes.addFlashAttribute("successMessage", "Automated schedule canceled.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to cancel schedule: " + e.getMessage());
        }
        return "redirect:/reports/templates";
    }

    // Simulates an automated email dispatch trigger for demonstration
    @PostMapping("/schedules/simulate-dispatch/{id}")
    public String simulateDispatch(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("successMessage", "Automated dispatch simulated! Report sent to designated recipients.");
        return "redirect:/reports/templates";
    }
}
