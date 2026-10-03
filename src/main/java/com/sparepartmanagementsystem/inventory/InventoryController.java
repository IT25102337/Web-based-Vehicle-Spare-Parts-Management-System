package com.sparepartmanagementsystem.inventory;

import com.sparepartmanagementsystem.procurement.SupplierProduct;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * Controller class managing HTTP web routes and user actions for warehouse inventory.
 */
@Controller
public class InventoryController {

    // Injecting InventoryService interface (OOP: Interfaces & Dependency Injection)
    @Autowired
    private InventoryService inventoryService;

    // =========================================================================
    // 1. READ OPERATIONS (Displaying Web Interfaces)
    // =========================================================================

    // Renders the main warehouse dashboard with KPI summary metrics
    @GetMapping({"/inventory/dashboard", "/inventory-dashboard"})
    public String showInventoryDashboard(Model model) {
        List<InventoryItem> allItems = inventoryService.getAllInventoryItems();
        Set<String> requestedPartIds = inventoryService.getPendingRequestedPartIds();

        int totalStock = 0;
        double totalValue = 0.0;
        int lowStockCount = 0;
        List<InventoryItem> criticalItems = new ArrayList<>();

        for (InventoryItem item : allItems) {
            totalStock += item.getQuantity();
            totalValue += item.calculateValuation(); // Polymorphic method call

            if (item.isLowStock() && !requestedPartIds.contains(item.getPartId())) {
                lowStockCount++;
                criticalItems.add(item);
            }
        }

        Map<String, Integer> racks = inventoryService.getRackQuantities(allItems);
        List<SupplierProduct> approvedProducts = inventoryService.getApprovedSupplierProducts();

        int availableSpace = inventoryService.getAvailableSpace();
        int capacityPct = inventoryService.getCapacityPercentage();

        model.addAttribute("totalItems", allItems.size());
        model.addAttribute("totalStock", totalStock);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("totalValue", totalValue);
        model.addAttribute("criticalItems", criticalItems);
        model.addAttribute("maxCapacity", InventoryService.MAX_WAREHOUSE_CAPACITY);
        model.addAttribute("availableSpace", availableSpace);
        model.addAttribute("capacityPct", capacityPct);
        model.addAttribute("approvedProducts", approvedProducts);

        model.addAttribute("rackA", racks.get("A"));
        model.addAttribute("rackB", racks.get("B"));
        model.addAttribute("rackC", racks.get("C"));
        model.addAttribute("rackD", racks.get("D"));
        model.addAttribute("rackCapacity", InventoryService.RACK_CAPACITY);
        model.addAttribute("itemList", allItems);
        model.addAttribute("inventoryList", allItems);

        return "inventory/inventory_dashboard";
    }

    // Renders the full warehouse inventory repository table
    @GetMapping("/inventory")
    public String showInventoryRepository(Model model) {
        List<InventoryItem> allItems = inventoryService.getAllInventoryItems();
        Set<String> requestedPartIds = inventoryService.getPendingRequestedPartIds();

        int lowStockCount = 0;
        int currentTotalUnits = 0;
        double totalValue = 0.0;

        for (InventoryItem item : allItems) {
            currentTotalUnits += item.getQuantity();
            totalValue += item.calculateValuation();

            if (item.isLowStock() && !requestedPartIds.contains(item.getPartId())) {
                lowStockCount++;
            }
        }

        Map<String, Integer> racks = inventoryService.getRackQuantities(allItems);
        List<SupplierProduct> approvedProducts = inventoryService.getApprovedSupplierProducts();

        int availableSpace = inventoryService.getAvailableSpace();
        int capacityPct = inventoryService.getCapacityPercentage();

        model.addAttribute("inventoryList", allItems);
        model.addAttribute("itemList", allItems);
        model.addAttribute("totalItems", allItems.size());
        model.addAttribute("totalStock", currentTotalUnits);
        model.addAttribute("currentTotalUnits", currentTotalUnits);
        model.addAttribute("totalValue", totalValue);
        model.addAttribute("capacityPct", capacityPct);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("approvedProducts", approvedProducts);
        model.addAttribute("maxCapacity", InventoryService.MAX_WAREHOUSE_CAPACITY);
        model.addAttribute("availableSpace", availableSpace);

        model.addAttribute("rackA", racks.get("A"));
        model.addAttribute("rackB", racks.get("B"));
        model.addAttribute("rackC", racks.get("C"));
        model.addAttribute("rackD", racks.get("D"));
        model.addAttribute("rackCapacity", InventoryService.RACK_CAPACITY);

        return "inventory/inventory";
    }

    // Renders the safety reorder and low stock alert center
    @GetMapping("/reorder")
    public String showReorderAlerts(Model model) {
        List<InventoryItem> reorderList = inventoryService.getReorderList();
        List<RestockRequest> pendingRequests = inventoryService.getPendingRestockRequests();

        model.addAttribute("reorderList", reorderList);
        model.addAttribute("pendingRequests", pendingRequests);
        model.addAttribute("lowStockCount", reorderList.size());

        return "inventory/reorder";
    }

    // =========================================================================
    // 2. CREATE OPERATIONS (Intake & Reorder Requests)
    // =========================================================================

    // Blocks independent part creation without approved supplier delivery
    @PostMapping("/add")
    public String addPart(RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage",
                "Inventory cannot add spare parts independently! Spare parts must first arrive via supplier delivery and be verified in Good Condition (Approved) by Spare Part & Quality Management.");
        return "redirect:/inventory";
    }

    // Conducts intake of approved supplier parts into warehouse racks
    @PostMapping("/inventory/intake")
    public String intakeApprovedProduct(@RequestParam int batchId,
                                        @RequestParam String partId,
                                        @RequestParam String partName,
                                        @RequestParam int quantity,
                                        @RequestParam int reorderLevel,
                                        @RequestParam double unitPrice,
                                        @RequestParam(defaultValue = "Rack A-01") String storageLocation,
                                        RedirectAttributes redirectAttributes) {
        try {
            inventoryService.intakeApprovedProduct(batchId, partId, partName, quantity, reorderLevel, unitPrice, storageLocation);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Successfully intaked " + quantity + " units of '" + partName.trim() + "' into warehouse (Storage: " + storageLocation.trim() + ", Price: Rs. " + unitPrice + ")!");
        } catch (WarehouseCapacityExceededException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage() + " Available space: " + e.getAvailableSpace() + " units.");
        } catch (InventoryException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Unexpected intake error: " + e.getMessage());
        }
        return "redirect:/inventory";
    }

    // Submits a formal replenishment restock request to spare parts
    @PostMapping("/reorder/request")
    public String sendRestockRequest(@RequestParam String partId,
                                     @RequestParam String partName,
                                     @RequestParam int currentQuantity,
                                     @RequestParam int requestedQuantity,
                                     @RequestParam(defaultValue = "Stock running low, please supply.") String requestMessage,
                                     @RequestParam(value = "source", required = false, defaultValue = "reorder") String source,
                                     RedirectAttributes redirectAttributes) {
        try {
            inventoryService.sendRestockRequest(partId, partName, currentQuantity, requestedQuantity, requestMessage);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Restock request sent to Spare Part Dept for '" + partName.trim() + "' (" + requestedQuantity + " units requested).");
        } catch (InventoryException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to send restock request: " + e.getMessage());
        }
        return "redirect:/" + ("inventory".equalsIgnoreCase(source) ? "inventory" : "reorder");
    }

    // =========================================================================
    // 3. UPDATE OPERATIONS (Edit Metadata & Stock Dispatch)
    // =========================================================================

    // Updates metadata details for an existing cataloged part
    @PostMapping("/edit")
    public String editPart(@RequestParam String partId,
                           @RequestParam String partName,
                           @RequestParam int reorderLevel,
                           @RequestParam double unitPrice,
                           @RequestParam(value = "storageLocation", required = false, defaultValue = "Rack A-01") String storageLocation,
                           RedirectAttributes redirectAttributes) {
        try {
            boolean updated = inventoryService.editPart(partId, partName, reorderLevel, unitPrice, storageLocation);
            if (updated) {
                redirectAttributes.addFlashAttribute("successMessage", "Part '" + partId.trim() + "' updated successfully!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Part '" + partId.trim() + "' not found.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Update failed: " + e.getMessage());
        }
        return "redirect:/inventory";
    }

    // Dispatches physical stock units for outbound customer shipments
    @PostMapping({"/update", "/reorder/dispatch", "/inventory/dispatch", "/inventory/update"})
    public String updateStock(@RequestParam(value = "action", required = false, defaultValue = "sub") String action,
                              @RequestParam String partId,
                              @RequestParam(value = "change", required = false) Integer change,
                              @RequestParam(value = "quantity", required = false) Integer quantity,
                              @RequestParam(value = "source", required = false, defaultValue = "inventory") String source,
                              RedirectAttributes redirectAttributes) {
        try {
            int amount = (quantity != null && quantity > 0) ? quantity : ((change != null && change > 0) ? change : 0);

            if ("add".equalsIgnoreCase(action)) {
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Inventory cannot add stock independently! Please send a restock request to the Spare Part Department or accept an approved shipment.");
            } else {
                inventoryService.dispatchStock(partId, amount);
                redirectAttributes.addFlashAttribute("successMessage",
                        "Successfully dispatched " + amount + " units from Part ID: " + partId.trim() + ".");
            }
        } catch (InsufficientStockException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (InventoryException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Stock adjustment failed: " + e.getMessage());
        }

        if ("reorder".equalsIgnoreCase(source)) {
            return "redirect:/reorder";
        }
        return "redirect:/inventory";
    }

    // =========================================================================
    // 4. DELETE OPERATION
    // =========================================================================

    // Deletes an inventory part record from storage
    @PostMapping("/delete")
    public String deletePart(@RequestParam String partId, RedirectAttributes redirectAttributes) {
        try {
            boolean deleted = inventoryService.deletePart(partId);
            if (deleted) {
                redirectAttributes.addFlashAttribute("successMessage", "Part '" + partId.trim() + "' was deleted successfully.");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Part '" + partId.trim() + "' was not found.");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Delete failed: " + e.getMessage());
        }
        return "redirect:/inventory";
    }

    // =========================================================================
    // 5. INVENTORY REPORTING & ANALYTICS (Factory Pattern)
    // =========================================================================

    // Renders the warehouse inventory reporting center
    @GetMapping("/inventory/reports")
    public String showInventoryReports(Model model) {
        List<InventoryItem> items = inventoryService.getAllInventoryItems();
        int totalStock = items.stream().mapToInt(InventoryItem::getQuantity).sum();
        double totalValuation = items.stream().mapToDouble(InventoryItem::calculateValuation).sum();
        long lowStockCount = items.stream().filter(InventoryItem::isLowStock).count();
        int capacityPct = inventoryService.getCapacityPercentage();

        model.addAttribute("totalItems", items.size());
        model.addAttribute("totalStock", totalStock);
        model.addAttribute("totalValuation", totalValuation);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("maxCapacity", InventoryService.MAX_WAREHOUSE_CAPACITY);
        model.addAttribute("capacityPct", capacityPct);
        model.addAttribute("submittedReports", inventoryService.getAllSubmittedReports());
        model.addAttribute("templates", inventoryService.getAllTemplates());

        return "inventory/inventory_reports";
    }

    // Generates a live report preview using the Factory Pattern
    @PostMapping("/inventory/reports/generate")
    public String generateInventoryReport(@RequestParam String reportType,
                                          @RequestParam(required = false) String fromDate,
                                          @RequestParam(required = false) String toDate,
                                          @RequestParam(defaultValue = "") String notes,
                                          Model model) {
        List<InventoryItem> items = inventoryService.getAllInventoryItems();
        int totalStock = items.stream().mapToInt(InventoryItem::getQuantity).sum();
        double totalValuation = items.stream().mapToDouble(InventoryItem::calculateValuation).sum();
        long lowStockCount = items.stream().filter(InventoryItem::isLowStock).count();
        int capacityPct = inventoryService.getCapacityPercentage();

        // Factory Pattern compiles report content based on reportType parameter
        String reportContent = inventoryService.compileReportPreview(reportType, fromDate, toDate, notes);

        model.addAttribute("generatedReport", reportContent);
        model.addAttribute("reportTitle", reportType);
        model.addAttribute("reportType", reportType);
        model.addAttribute("fromDate", fromDate);
        model.addAttribute("toDate", toDate);
        model.addAttribute("notes", notes);
        model.addAttribute("totalItems", items.size());
        model.addAttribute("totalStock", totalStock);
        model.addAttribute("totalValuation", totalValuation);
        model.addAttribute("lowStockCount", lowStockCount);
        model.addAttribute("maxCapacity", InventoryService.MAX_WAREHOUSE_CAPACITY);
        model.addAttribute("capacityPct", capacityPct);
        model.addAttribute("submittedReports", inventoryService.getAllSubmittedReports());
        model.addAttribute("templates", inventoryService.getAllTemplates());
        model.addAttribute("successMessage", "Report successfully generated! You can download it or send it directly to the Admin below.");

        return "inventory/inventory_reports";
    }

    // Transmits generated audit report to Executive Administration for review
    @PostMapping({"/inventory/reports/send-admin", "/inventory/reports/dispatch-admin"})
    public String sendReportToAdmin(@RequestParam(value = "reportTitle", required = false) String reportTitle,
                                    @RequestParam(value = "reportType", required = false, defaultValue = "Warehouse Inventory Valuation & Stock Summary") String reportType,
                                    @RequestParam(value = "fromDate", required = false) String fromDate,
                                    @RequestParam(value = "toDate", required = false) String toDate,
                                    @RequestParam(value = "reportContent", required = false) String reportContent,
                                    @RequestParam(value = "notes", required = false, defaultValue = "") String notes,
                                    RedirectAttributes redirectAttributes) {
        try {
            InventoryReport report = inventoryService.dispatchReportToAdmin(reportTitle, reportType, fromDate, toDate, reportContent, notes);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Official Report '" + report.getReportTitle() + "' was successfully dispatched to Executive Admin! Added to submission table below.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to dispatch report to Admin: " + e.getMessage());
        }
        return "redirect:/inventory/reports";
    }

    // Downloads raw report preview text directly as a PDF attachment
    @PostMapping("/inventory/reports/download-content")
    public ResponseEntity<byte[]> downloadGeneratedContent(
            @RequestParam(required = false, defaultValue = "Warehouse Inventory Valuation & Stock Summary") String reportTitle,
            @RequestParam(required = false, defaultValue = "Warehouse Inventory Valuation & Stock Summary") String reportType,
            @RequestParam(required = false, defaultValue = "") String notes,
            @RequestParam String reportContent) {

        byte[] pdfBytes = inventoryService.generateRawContentPdf(reportTitle, reportType, notes, reportContent);
        String cleanTitle = (reportTitle != null ? reportTitle : "Report").replaceAll("[^a-zA-Z0-9_-]", "_");
        String filename = cleanTitle + "_" + System.currentTimeMillis() + ".pdf";

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdfBytes);
    }

    // Downloads raw report preview text directly as a plain text file
    @PostMapping("/inventory/reports/download-content-txt")
    public ResponseEntity<byte[]> downloadGeneratedContentTxt(
            @RequestParam(required = false, defaultValue = "Warehouse_Inventory_Report") String reportTitle,
            @RequestParam String reportContent) {

        byte[] bytes = reportContent.getBytes(StandardCharsets.UTF_8);
        String cleanTitle = (reportTitle != null ? reportTitle : "Report").replaceAll("[^a-zA-Z0-9_-]", "_");
        String filename = cleanTitle + "_" + System.currentTimeMillis() + ".txt";

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .contentType(MediaType.TEXT_PLAIN)
                .contentLength(bytes.length)
                .body(bytes);
    }

    // Downloads an existing submitted inventory report as a PDF attachment
    @GetMapping({"/inventory/reports/download/{id}", "/inventory-reports/download/{id}"})
    public ResponseEntity<byte[]> downloadInventoryReportPdf(@PathVariable Long id) {
        Optional<InventoryReport> reportOpt = inventoryService.getReportById(id);
        if (reportOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        InventoryReport report = reportOpt.get();
        byte[] pdfBytes = inventoryService.generateReportPdf(report);
        String cleanTitle = (report.getReportTitle() != null ? report.getReportTitle() : "Report")
                .replaceAll("[^a-zA-Z0-9_-]", "_");
        String filename = "Report_#" + report.getReportId() + "_" + cleanTitle + ".pdf";

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .contentType(MediaType.APPLICATION_PDF)
                .body(pdfBytes);
    }

    // Downloads an existing submitted inventory report as a plain text file
    @GetMapping({"/inventory/reports/download-txt/{id}", "/inventory-reports/download-txt/{id}"})
    public ResponseEntity<byte[]> downloadInventoryReportTxt(@PathVariable Long id) {
        Optional<InventoryReport> reportOpt = inventoryService.getReportById(id);
        if (reportOpt.isEmpty()) {
            return ResponseEntity.notFound().build();
        }
        InventoryReport report = reportOpt.get();
        String content = report.getReportContent() != null ? report.getReportContent() : "";
        byte[] bytes = content.getBytes(StandardCharsets.UTF_8);
        String cleanTitle = (report.getReportTitle() != null ? report.getReportTitle() : "Report")
                .replaceAll("[^a-zA-Z0-9_-]", "_");
        String filename = "Report_#" + report.getReportId() + "_" + cleanTitle + ".txt";

        return ResponseEntity.ok()
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + filename + "\"")
                .contentType(MediaType.TEXT_PLAIN)
                .contentLength(bytes.length)
                .body(bytes);
    }

    // Deletes an inventory report from the submission record list
    @PostMapping({"/inventory/reports/delete", "/admin/dashboard/reports/delete"})
    public String deleteReport(@RequestParam Long reportId, HttpServletRequest request, RedirectAttributes redirectAttributes) {
        try {
            inventoryService.deleteReport(reportId);
            redirectAttributes.addFlashAttribute("successMessage", "Report deleted successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to delete report: " + e.getMessage());
        }
        String referer = request.getHeader("Referer");
        return referer != null ? "redirect:" + referer : "redirect:/inventory/reports";
    }
}
