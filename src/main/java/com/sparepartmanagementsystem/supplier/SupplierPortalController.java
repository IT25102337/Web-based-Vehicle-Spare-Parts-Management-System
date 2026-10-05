package com.sparepartmanagementsystem.supplier;

import jakarta.annotation.PostConstruct;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Map;

/**
 * OOP CONCEPT: Controller Layer
 * UML RELATIONSHIP: Association (SupplierPortalController associates with SupplierService)
 * Handles supplier portal interactions, purchase order fulfillment, and supplier network management.
 */
@Controller
public class SupplierPortalController {

    // UML RELATIONSHIP: Association
    @Autowired
    private SupplierService supplierService;

    // OOP CONCEPT: PostConstruct LifeCycle Hook
    // Initializes database schemas and default supplier seed records
    @PostConstruct
    public void initSupplierSchema() {
        supplierService.initializeSupplierSystem();
    }

    // Populates UI model with pending orders, deliveries, and supplier stats
    private void populateSupplierMetrics(Model model) {
        try {
            Map<String, Object> data = supplierService.getSupplierPortalData();
            model.addAllAttributes(data);
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Error loading supplier data: " + e.getMessage());
        }
    }

    // Helper method to verify access permissions for supplier portals (accessible by Suppliers, Administrators, and QA Managers)
    private boolean isSupplierAuthorized(String role) {
        if (role == null) return false;
        String r = role.trim().toUpperCase();
        return "SUPPLIER".equals(r) || "ADMIN".equals(r) || "SYSADMIN".equals(r) || "SYSTEM_ADMIN".equals(r) || "SPAREPARTS".equals(r);
    }

    // Displays the main Supplier Portal dashboard with pending purchase requests
    @GetMapping({"/supplier", "/supplier/orders", "/supplier/portal"})
    public String showSupplierOrders(Model model, HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        if (!isSupplierAuthorized(role)) {
            return "redirect:/login";
        }
        populateSupplierMetrics(model);
        return "supplier/supplier_portal";
    }

    // Displays dispatched shipments and active quality inspection board
    @GetMapping("/supplier/deliveries")
    public String showSupplierDeliveries(Model model, HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        if (!isSupplierAuthorized(role)) {
            return "redirect:/login";
        }
        populateSupplierMetrics(model);
        return "supplier/supplier_deliveries";
    }

    // Displays the authorized automotive supplier directory
    @GetMapping("/supplier/network")
    public String showSupplierNetwork(Model model, HttpSession session) {
        String role = (String) session.getAttribute("userRole");
        if (!isSupplierAuthorized(role)) {
            return "redirect:/login";
        }
        populateSupplierMetrics(model);
        return "supplier/supplier_network";
    }

    // Dispatches a supplier order and forwards batch to QA inspection
    @PostMapping("/supplier/order/fulfill")
    public String fulfillOrder(@RequestParam int orderId,
                               @RequestParam(defaultValue = "") String supplierName,
                               @RequestParam int shippedQty,
                               @RequestParam double supplierPrice,
                               @RequestParam(defaultValue = "") String shippingNotes,
                               RedirectAttributes ra) {
        try {
            supplierService.fulfillOrder(orderId, supplierName, shippedQty, supplierPrice, shippingNotes);
            ra.addFlashAttribute("successMessage", 
                "Shipment for Order #" + orderId + " (" + shippedQty + " units) successfully dispatched! Sent to Spare Part Manager for Quality Inspection.");
        } catch (SupplierException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to dispatch order: " + e.getMessage());
        }
        return "redirect:/supplier";
    }

    // Declines a purchase order with explanation notes
    @PostMapping("/supplier/order/reject")
    public String rejectOrder(@RequestParam int orderId,
                              @RequestParam(defaultValue = "") String reason,
                              RedirectAttributes ra) {
        try {
            supplierService.rejectOrder(orderId, reason);
            ra.addFlashAttribute("successMessage", "Order #" + orderId + " marked as declined.");
        } catch (SupplierException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Error updating order: " + e.getMessage());
        }
        return "redirect:/supplier";
    }

    // Creates a purchase request transmitting an order to a supplier
    @PostMapping({"/procurement/request-supplier", "/procurement/request-new-part"})
    public String requestFromSupplier(@RequestParam String partId,
                                      @RequestParam String partName,
                                      @RequestParam String supplierName,
                                      @RequestParam int requestedQty,
                                      @RequestParam(defaultValue = "0.0") double expectedPrice,
                                      @RequestParam(defaultValue = "") String deliveryNotes,
                                      @RequestParam(required = false) Integer restockRequestId,
                                      @RequestParam(required = false) String redirectUrl,
                                      HttpSession session,
                                      RedirectAttributes ra) {
        String targetRedirect = (redirectUrl != null && !redirectUrl.isBlank()) ? "redirect:" + redirectUrl : "redirect:/spareparts";
        try {
            String currentUser = (String) session.getAttribute("fullName");
            if (currentUser == null) currentUser = (String) session.getAttribute("currentUser");
            if (currentUser == null) currentUser = "Spare Part Manager";

            supplierService.createPurchaseOrder(partId, partName, supplierName, requestedQty, expectedPrice, deliveryNotes, restockRequestId, currentUser);
            ra.addFlashAttribute("successMessage", 
                "New Spare Part '" + partName.trim() + "' (SKU: " + partId.trim().toUpperCase() + ") registered! Purchase order for " + 
                requestedQty + " units transmitted to supplier '" + supplierName.trim() + "'.");
        } catch (SupplierException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to register spare part and transmit request: " + e.getMessage());
        }
        return targetRedirect;
    }

    // Registers a new supplier in the automotive supplier directory
    @PostMapping({"/supplier/create", "/procurement/supplier/create"})
    public String createSupplier(@RequestParam String supplierName,
                                 @RequestParam(defaultValue = "") String contactPerson,
                                 @RequestParam(defaultValue = "") String email,
                                 @RequestParam(defaultValue = "") String phone,
                                 @RequestParam(defaultValue = "General Parts") String category,
                                 @RequestParam(defaultValue = "") String address,
                                 @RequestParam(required = false) String redirectUrl,
                                 RedirectAttributes ra) {
        try {
            supplierService.registerSupplier(supplierName, contactPerson, email, phone, category, address);
            ra.addFlashAttribute("successMessage", "Supplier '" + supplierName.trim() + "' successfully registered in database!");
        } catch (SupplierException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to add supplier: " + e.getMessage());
        }
        return redirectUrl != null && !redirectUrl.isBlank() ? "redirect:" + redirectUrl : "redirect:/supplier";
    }

    // Updates supplier business contact details and active status
    @PostMapping({"/supplier/update", "/procurement/supplier/update"})
    public String updateSupplier(@RequestParam int supplierId,
                                 @RequestParam String supplierName,
                                 @RequestParam(defaultValue = "") String contactPerson,
                                 @RequestParam(defaultValue = "") String email,
                                 @RequestParam(defaultValue = "") String phone,
                                 @RequestParam(defaultValue = "") String category,
                                 @RequestParam(defaultValue = "") String address,
                                 @RequestParam(defaultValue = "ACTIVE") String status,
                                 @RequestParam(required = false) String redirectUrl,
                                 RedirectAttributes ra) {
        try {
            supplierService.updateSupplier(supplierId, supplierName, contactPerson, email, phone, category, address, status);
            ra.addFlashAttribute("successMessage", "Supplier #" + supplierId + " (" + supplierName.trim() + ") updated successfully.");
        } catch (SupplierException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to update supplier: " + e.getMessage());
        }
        return redirectUrl != null && !redirectUrl.isBlank() ? "redirect:" + redirectUrl : "redirect:/supplier";
    }

    // Removes an existing supplier from the procurement network
    @PostMapping({"/supplier/delete", "/procurement/supplier/delete"})
    public String deleteSupplier(@RequestParam int supplierId,
                                 @RequestParam(required = false) String redirectUrl,
                                 RedirectAttributes ra) {
        try {
            supplierService.deleteSupplier(supplierId);
            ra.addFlashAttribute("successMessage", "Supplier record #" + supplierId + " removed from system.");
        } catch (SupplierException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to delete supplier: " + e.getMessage());
        }
        return redirectUrl != null && !redirectUrl.isBlank() ? "redirect:" + redirectUrl : "redirect:/supplier";
    }
}
