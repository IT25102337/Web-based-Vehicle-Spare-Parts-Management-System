package com.sparepartmanagementsystem.procurement;

import com.sparepartmanagementsystem.supplier.Supplier;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

/**
 * OOP CONCEPT: Controller Layer
 * UML RELATIONSHIP: Association (ProductProcurementController associates with ProcurementService)
 * Handles receiving spare parts from suppliers and performing quality control inspection.
 */
@Controller
public class ProductProcurementController {

    // UML RELATIONSHIP: Association
    @Autowired
    private ProcurementService procurementService;

    // Displays the dedicated Spare Part & Quality Control dashboard
    @GetMapping({"/spareparts", "/procurement/dashboard"})
    public String showSparePartDashboard(Model model) {
        Map<String, Object> stats = procurementService.getDashboardData();
        model.addAllAttributes(stats);
        return "procurement/sparepart_dashboard";
    }

    // Displays the Supplier Deliveries and QA inspection board view
    @GetMapping("/procurement")
    public String showProcurementBoard(Model model) {
        Map<String, Object> stats = procurementService.getDashboardData();
        model.addAllAttributes(stats);
        return "procurement/procurement";
    }

    // Displays authorized OEM suppliers directory for the Spare Part Manager
    @GetMapping({"/spareparts/suppliers", "/procurement/suppliers"})
    public String showSuppliersDirectory(Model model) {
        List<Supplier> suppliers = procurementService.getAllSuppliers();
        int activeCount = 0;
        int inactiveCount = 0;
        for (Supplier s : suppliers) {
            if ("ACTIVE".equalsIgnoreCase(s.getStatus())) activeCount++;
            else inactiveCount++;
        }

        List<SupplierProduct> products = procurementService.getAllProducts();
        int pendingQACount = 0;
        for (SupplierProduct p : products) {
            if (p.isPending()) pendingQACount++;
        }

        model.addAttribute("suppliers", suppliers);
        model.addAttribute("totalSuppliers", suppliers.size());
        model.addAttribute("activeCount", activeCount);
        model.addAttribute("inactiveCount", inactiveCount);
        model.addAttribute("pendingRestockCount", procurementService.getPendingRestockRequests().size());
        model.addAttribute("pendingCount", pendingQACount);

        return "procurement/sparepart_suppliers";
    }

    // Registers a newly arrived shipment batch from an automotive supplier
    @PostMapping("/procurement/add")
    public String registerSupplierDelivery(@RequestParam String partId,
                                           @RequestParam String partName,
                                           @RequestParam String supplierName,
                                           @RequestParam int receivedQty,
                                           @RequestParam double supplierPrice,
                                           RedirectAttributes redirectAttributes) {
        try {
            procurementService.registerDelivery(partId, partName, supplierName, receivedQty, supplierPrice);
            redirectAttributes.addFlashAttribute("successMessage", 
                    "Supplier batch for '" + partName.trim() + "' received from " + supplierName.trim() + ". Awaiting quality inspection.");
        } catch (ProcurementException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to register delivery: " + e.getMessage());
        }
        return "redirect:/procurement";
    }

    // Performs QA evaluation approving shipment for inventory intake or rejecting defects
    @PostMapping("/procurement/inspect")
    public String inspectQuality(@RequestParam int batchId,
                                 @RequestParam String qualityStatus,
                                 @RequestParam String qualityNotes,
                                 RedirectAttributes redirectAttributes) {
        try {
            procurementService.performInspection(batchId, qualityStatus, qualityNotes);
            if ("APPROVED".equalsIgnoreCase(qualityStatus)) {
                redirectAttributes.addFlashAttribute("successMessage", 
                        "Batch #" + batchId + " passed quality check and is APPROVED for warehouse intake!");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", 
                        "Batch #" + batchId + " failed inspection (REJECTED). Supplier flagged for return / replacement!");
            }
        } catch (ProcurementException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Inspection update failed: " + e.getMessage());
        }
        return "redirect:/procurement";
    }

    // Deletes an erroneous delivery batch from quality inspection records
    @PostMapping("/procurement/delete")
    public String deleteSupplierProduct(@RequestParam int batchId,
                                        RedirectAttributes redirectAttributes) {
        try {
            procurementService.deleteDelivery(batchId);
            redirectAttributes.addFlashAttribute("successMessage", "Supplier delivery record #" + batchId + " deleted.");
        } catch (ProcurementException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Delete failed: " + e.getMessage());
        }
        return "redirect:/procurement";
    }

    // Deletes a purchase order from the Supplier Procurement Pipeline
    @PostMapping("/procurement/order/delete")
    public String deleteSupplierOrder(@RequestParam int orderId,
                                      @RequestParam(required = false, defaultValue = "/spareparts") String redirectUrl,
                                      RedirectAttributes redirectAttributes) {
        try {
            procurementService.deleteSupplierOrder(orderId);
            redirectAttributes.addFlashAttribute("successMessage", "Purchase Order #PO-" + orderId + " was successfully deleted from the pipeline.");
        } catch (ProcurementException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to delete Purchase Order #PO-" + orderId + ": " + e.getMessage());
        }
        return "redirect:" + (redirectUrl != null && !redirectUrl.isBlank() ? redirectUrl : "/spareparts");
    }
}
