package com.sparepartmanagementsystem.sales;

import com.sparepartmanagementsystem.core.PdfReportService;
import com.sparepartmanagementsystem.reportmanager.DashboardService;
import com.sparepartmanagementsystem.reportmanager.InventoryReport;
import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPT: Controller Layer
 * UML RELATIONSHIP: Association (SalesController associates with SalesService, PdfReportService, and DashboardService)
 * Handles HTTP requests for the Sales Manager dashboard, customer order queues, and executive audit transmissions.
 */
@Controller
public class SalesController {

    // UML RELATIONSHIP: Association
    @Autowired
    private SalesService salesService;

    // UML RELATIONSHIP: Association
    @Autowired
    private PdfReportService pdfReportService;

    // UML RELATIONSHIP: Association
    @Autowired
    private DashboardService dashboardService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    private static SalesService staticSalesService;

    // OOP CONCEPT: PostConstruct LifeCycle Hook
    // Initializes database tables and registers static service accessor
    @PostConstruct
    public void initSalesSchema() {
        salesService.initializeSalesSystem();
        staticSalesService = this.salesService;
    }

    // Static delegation helper for backward compatibility with checkout handlers
    public static void saveOrder(JdbcTemplate jdbcTemplate, String customerName, double totalAmount, String notes, List<Map<String, Object>> cartItems) {
        if (staticSalesService != null) {
            staticSalesService.recordNewOrder(customerName, totalAmount, notes, cartItems);
        }
    }

    // Helper method to verify authorization for sales workspaces (accessible by Sales Managers and Administrators)
    private boolean isSalesAuthorized(String userRole) {
        if (userRole == null) return false;
        String r = userRole.trim().toUpperCase();
        return "SALES".equals(r) || "ADMIN".equals(r) || "SYSADMIN".equals(r) || "SYSTEM_ADMIN".equals(r);
    }

    // Displays the main Sales Manager dashboard with KPIs and analytics
    @GetMapping("/sales")
    public String showSalesDashboard(Model model, HttpSession session) {
        String userRole = (String) session.getAttribute("userRole");
        if (!isSalesAuthorized(userRole)) {
            return "redirect:/login";
        }
        populateSalesModel(model);
        return "sales/sales_dashboard";
    }

    // Populates UI model with orders, revenues, and sales metrics
    private void populateSalesModel(Model model) {
        try {
            Map<String, Object> data = salesService.getSalesDashboardData();
            model.addAllAttributes(data);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Unable to load sales data: " + e.getMessage());
        }
    }

    // Updates a customer order to processing state with optional notes
    @PostMapping("/sales/order/process")
    public String processOrder(@RequestParam int orderId,
                               @RequestParam(defaultValue = "") String notes,
                               @RequestParam(defaultValue = "/sales/orders") String redirectUrl,
                               RedirectAttributes ra) {
        try {
            salesService.processOrder(orderId, notes);
            ra.addFlashAttribute("successMessage", "Order #" + orderId + " is now marked as PROCESSING. Customer can see their live order preparation status!");
        } catch (SalesException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error processing order: " + e.getMessage());
        }
        return "redirect:" + (redirectUrl != null && !redirectUrl.isBlank() ? redirectUrl : "/sales/orders");
    }

    // Marks an order as completed recognizing earned revenue
    @PostMapping("/sales/order/complete")
    public String completeOrder(@RequestParam int orderId,
                                @RequestParam(defaultValue = "/sales/orders") String redirectUrl,
                                RedirectAttributes ra) {
        try {
            salesService.completeOrder(orderId);
            ra.addFlashAttribute("successMessage", "Order #" + orderId + " marked as COMPLETED. Earned revenue officially recognized!");
        } catch (SalesException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error completing order: " + e.getMessage());
        }
        return "redirect:" + (redirectUrl != null && !redirectUrl.isBlank() ? redirectUrl : "/sales/orders");
    }

    // Cancels an order in the sales queue
    @PostMapping("/sales/order/cancel")
    public String cancelOrder(@RequestParam int orderId,
                              @RequestParam(defaultValue = "/sales/orders") String redirectUrl,
                              RedirectAttributes ra) {
        try {
            salesService.cancelOrder(orderId);
            ra.addFlashAttribute("successMessage", "Order #" + orderId + " cancelled.");
        } catch (SalesException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error cancelling order: " + e.getMessage());
        }
        return "redirect:" + (redirectUrl != null && !redirectUrl.isBlank() ? redirectUrl : "/sales/orders");
    }

    // Permanently removes a sales order and all its child line items
    @PostMapping("/sales/order/delete")
    public String deleteOrder(@RequestParam int orderId,
                              @RequestParam(defaultValue = "/sales/orders") String redirectUrl,
                              RedirectAttributes ra) {
        try {
            salesService.deleteOrder(orderId);
            ra.addFlashAttribute("successMessage", "Order #" + orderId + " was permanently deleted from both Sales queue and Customer order history.");
        } catch (SalesException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error deleting order: " + e.getMessage());
        }
        return "redirect:" + (redirectUrl != null && !redirectUrl.isBlank() ? redirectUrl : "/sales/orders");
    }

    // Displays the full customer orders queue and status management interface
    @GetMapping("/sales/orders")
    public String showCustomerOrdersQueue(Model model, HttpSession session) {
        String userRole = (String) session.getAttribute("userRole");
        if (!isSalesAuthorized(userRole)) {
            return "redirect:/login";
        }
        populateSalesModel(model);
        return "sales/sales_orders";
    }

    // Displays the commercial sales reports audit center
    @GetMapping("/sales/reports")
    public String showSalesReports(Model model, HttpSession session) {
        String userRole = (String) session.getAttribute("userRole");
        if (!isSalesAuthorized(userRole)) {
            return "redirect:/login";
        }
        populateSalesModel(model);
        return "sales/sales_reports";
    }

    // Compiles a new commercial sales performance audit and transmits it to the Administrator
    @PostMapping("/sales/reports/generate")
    public String generateSalesReport(@RequestParam(defaultValue = "Commercial Sales & Income Performance Audit") String reportTitle,
                                      @RequestParam(required = false) String fromDate,
                                      @RequestParam(required = false) String toDate,
                                      @RequestParam(defaultValue = "ALL_SALES") String reportScope,
                                      @RequestParam(defaultValue = "") String managerNotes,
                                      HttpSession session,
                                      RedirectAttributes ra) {
        try {
            String fullName = (String) session.getAttribute("fullName");
            salesService.generateAndSubmitSalesReport(reportTitle, fromDate, toDate, reportScope, managerNotes, fullName);
            ra.addFlashAttribute("successMessage", "Official Sales & Revenue Report '" + reportTitle.trim() + "' transmitted to Executive Administrator for review and approval!");
        } catch (SalesException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to generate sales report: " + e.getMessage());
        }
        return "redirect:/sales/reports";
    }

    // Downloads official certified PDF copy of a transmitted sales audit report
    @GetMapping("/sales/reports/download/{id}")
    public ResponseEntity<byte[]> downloadSalesReport(@PathVariable Long id) {
        Optional<InventoryReport> reportOpt = dashboardService.getInventoryReportById(id);
        if (reportOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        InventoryReport report = reportOpt.get();
        byte[] bytes = pdfReportService.generateInventoryReportPdf(report);
        String cleanTitle = (report.getReportTitle() != null ? report.getReportTitle() : "Sales_Report")
                .replaceAll("[^a-zA-Z0-9_-]", "_");
        String filename = "Sales_Report_#" + report.getReportId() + "_" + cleanTitle + ".pdf";

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .contentType(MediaType.APPLICATION_PDF)
                .body(bytes);
    }
}
