package com.sparepartmanagementsystem.customer;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sparepartmanagementsystem.inventory.InventoryItem;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.*;

/**
 * OOP CONCEPT: Controller Layer
 * UML RELATIONSHIP: Association (UserAccessController associates with CustomerService)
 * Handles customer authentication, account registration, profile updates, and shopping catalog.
 */
@Controller
public class UserAccessController {

    // UML RELATIONSHIP: Association (Controller associates with CustomerService)
    @Autowired
    private CustomerService customerService;

    @Autowired
    private JdbcTemplate jdbcTemplate;

    // Displays the role-based login and registration portal
    @GetMapping({"/", "/login"})
    public String showLoginPage(@RequestParam(value = "role", required = false) String preselectedRole,
                                @RequestParam(value = "tab", required = false) String tab,
                                Model model) {
        model.addAttribute("selectedRole", preselectedRole != null ? preselectedRole : "customer");
        model.addAttribute("activeTab", tab != null ? tab : "signin");
        return "customer/login";
    }

    // Processes customer registration with custom exception handling
    @PostMapping("/signup")
    public String processSignUp(@RequestParam String username,
                                @RequestParam String password,
                                @RequestParam String confirmPassword,
                                @RequestParam(defaultValue = "") String fullName,
                                @RequestParam(defaultValue = "") String email,
                                RedirectAttributes redirectAttributes) {
        try {
            customerService.registerCustomer(username, password, confirmPassword, fullName, email);
            redirectAttributes.addFlashAttribute("successMessage", "Account created successfully for " + username + "! Please sign in with your credentials.");
            return "redirect:/login?tab=signin";
        } catch (CustomerException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/login?tab=signup";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Registration failed: " + e.getMessage());
            return "redirect:/login?tab=signup";
        }
    }

    // Authenticates user credentials and routes them to their specific role portal
    @PostMapping("/login")
    public String processLogin(@RequestParam(defaultValue = "") String username,
                               @RequestParam(defaultValue = "") String password,
                               @RequestParam(defaultValue = "customer") String role,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        try {
            Optional<UserAccount> userOpt = customerService.authenticateUser(username, password);

            if (userOpt.isPresent()) {
                UserAccount user = userOpt.get();
                String userRole = user.getRole() != null ? user.getRole().trim().toUpperCase() : "CUSTOMER";
                session.setAttribute("userRole", userRole);
                session.setAttribute("currentUser", user.getUsername());
                session.setAttribute("fullName", user.getFullName());
                session.setAttribute("email", user.getEmail());

                switch (userRole) {
                    case "SYSADMIN":
                    case "SYSTEM_ADMIN":
                    case "ADMIN":
                        redirectAttributes.addFlashAttribute("successMessage", "Welcome back, " + user.getFullName() + "! Signed in as System Administrator.");
                        return "redirect:/admin/dashboard";
                    case "REPORT_MANAGER":
                    case "REPORTS":
                        redirectAttributes.addFlashAttribute("successMessage", "Welcome back, " + user.getFullName() + "! Signed in as Report & Business Dashboard Manager.");
                        return "redirect:/reports/dashboard";
                    case "INVENTORY":
                        redirectAttributes.addFlashAttribute("successMessage", "Welcome back, " + user.getFullName() + "! Signed in as Inventory Manager.");
                        return "redirect:/inventory/dashboard";
                    case "SPAREPARTS":
                        redirectAttributes.addFlashAttribute("successMessage", "Welcome back, " + user.getFullName() + "! Signed in as Spare Part Manager.");
                        return "redirect:/spareparts";
                    case "SALES":
                        redirectAttributes.addFlashAttribute("successMessage", "Welcome back, " + user.getFullName() + "! Signed in as Sales Manager.");
                        return "redirect:/sales";
                    case "SUPPLIER":
                        redirectAttributes.addFlashAttribute("successMessage", "Welcome back, " + user.getFullName() + "! Signed in as Supplier Partner.");
                        return "redirect:/supplier";
                    case "CUSTOMER":
                    default:
                        redirectAttributes.addFlashAttribute("successMessage", "Welcome back, " + user.getFullName() + "!");
                        return "redirect:/customer";
                }
            }

            redirectAttributes.addFlashAttribute("errorMessage", "Invalid username or password. Please verify your credentials or create a new customer account.");
            return "redirect:/login";
        } catch (CustomerException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/login";
        }
    }

    // Terminates current user session and clears session attributes
    @GetMapping("/logout")
    public String logout(HttpSession session, RedirectAttributes redirectAttributes) {
        if (session != null) {
            session.invalidate();
        }
        redirectAttributes.addFlashAttribute("successMessage", "You have been logged out successfully.");
        return "redirect:/login";
    }

    // Redirects template aliases directly to report manager templates portal
    @GetMapping({"/report-templates", "/report_templates", "/templates"})
    public String redirectReportTemplates() {
        return "redirect:/reports/templates";
    }

    // Displays available spare parts catalog and order history for customer
    @GetMapping({"/customer", "/store"})
    public String showCustomerStore(Model model, HttpSession session) {
        try {
            List<InventoryItem> items = customerService.getStoreProducts();
            model.addAttribute("products", items);

            String currentUser = session != null ? (String) session.getAttribute("currentUser") : null;
            String fullName = session != null ? (String) session.getAttribute("fullName") : null;
            String userEmail = (session != null && session.getAttribute("email") != null) ? ((String) session.getAttribute("email")).trim() : "";

            List<Map<String, Object>> myOrders = new ArrayList<>();
            Map<Integer, List<Map<String, Object>>> myOrderItemsMap = new LinkedHashMap<>();
            int myProcessingCount = 0;
            int myPendingCount = 0;
            int myInPrepCount = 0;

            if ((currentUser != null && !currentUser.isBlank()) || (fullName != null && !fullName.isBlank())) {
                String searchName = (fullName != null && !fullName.isBlank()) ? fullName : currentUser;
                myOrders = customerService.getCustomerOrders(searchName, userEmail);
                myOrderItemsMap = customerService.getCustomerOrderItemsMap(myOrders);

                for (Map<String, Object> ord : myOrders) {
                    String st = String.valueOf(ord.getOrDefault("status", "PENDING"));
                    if ("PROCESSING".equalsIgnoreCase(st)) {
                        myInPrepCount++;
                        myProcessingCount++;
                    } else if ("PENDING".equalsIgnoreCase(st)) {
                        myPendingCount++;
                        myProcessingCount++;
                    }
                }
            }

            model.addAttribute("myOrders", myOrders);
            model.addAttribute("myOrderItemsMap", myOrderItemsMap);
            model.addAttribute("myProcessingCount", myProcessingCount);
            model.addAttribute("myPendingCount", myPendingCount);
            model.addAttribute("myInPrepCount", myInPrepCount);

        } catch (Exception e) {
            model.addAttribute("errorMessage", "Unable to load products: " + e.getMessage());
            model.addAttribute("myOrders", new ArrayList<>());
            model.addAttribute("myOrderItemsMap", new HashMap<>());
            model.addAttribute("myProcessingCount", 0);
            model.addAttribute("myPendingCount", 0);
        }
        return "customer/customer_store";
    }

    // Executes single-item instant purchase deducting inventory stock
    @PostMapping("/customer/buy")
    public String buyProduct(@RequestParam String partId,
                             @RequestParam int quantity,
                             @RequestParam(defaultValue = "Guest Customer") String customerName,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        try {
            String effectiveName = customerName;
            if (session != null) {
                String fn = (String) session.getAttribute("fullName");
                String un = (String) session.getAttribute("currentUser");
                if (fn != null && !fn.isBlank() && !"Guest Customer".equalsIgnoreCase(fn)) {
                    effectiveName = fn.trim();
                } else if (un != null && !un.isBlank() && !"Guest Customer".equalsIgnoreCase(un)) {
                    effectiveName = un.trim();
                }
            }

            customerService.purchasePart(partId, quantity, effectiveName);
            redirectAttributes.addFlashAttribute("successMessage", 
                    "Order confirmed for " + effectiveName + "! Purchased " + quantity + " units of part #" + partId + ".");
        } catch (CustomerException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Order failed: " + e.getMessage());
        }
        return "redirect:/customer";
    }

    // Executes multi-item shopping cart checkout with transaction rollback support
    @PostMapping("/customer/cart/checkout")
    @Transactional
    public String checkoutCart(@RequestParam(defaultValue = "Guest Customer") String customerName,
                               @RequestParam String cartData,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        try {
            if (cartData == null || cartData.trim().isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Cart is empty. Please select parts before placing an order.");
                return "redirect:/customer";
            }

            String effectiveName = customerName;
            if (session != null) {
                String fn = (String) session.getAttribute("fullName");
                String un = (String) session.getAttribute("currentUser");
                if (fn != null && !fn.isBlank() && !"Guest Customer".equalsIgnoreCase(fn)) {
                    effectiveName = fn.trim();
                } else if (un != null && !un.isBlank() && !"Guest Customer".equalsIgnoreCase(un)) {
                    effectiveName = un.trim();
                }
            }

            ObjectMapper mapper = new ObjectMapper();
            JsonNode itemsNode = mapper.readTree(cartData);

            if (!itemsNode.isArray() || itemsNode.isEmpty()) {
                redirectAttributes.addFlashAttribute("errorMessage", "Cart has no valid items.");
                return "redirect:/customer";
            }

            // Step 1: Validate stock for all items
            for (JsonNode item : itemsNode) {
                String partId = item.path("partId").asText("").trim();
                int qty = item.path("quantity").asInt(0);
                String partName = item.path("partName").asText(partId);

                if (partId.isEmpty() || qty <= 0) {
                    redirectAttributes.addFlashAttribute("errorMessage", "Invalid quantity for item: " + partName);
                    return "redirect:/customer";
                }

                Integer stock = jdbcTemplate.queryForObject(
                        "SELECT quantity FROM inventory WHERE part_id = ?", Integer.class, partId);
                if (stock == null) {
                    redirectAttributes.addFlashAttribute("errorMessage", "Part #" + partId + " does not exist in inventory.");
                    return "redirect:/customer";
                }
                if (stock < qty) {
                    redirectAttributes.addFlashAttribute("errorMessage",
                            "Insufficient stock for '" + partName + "'. Requested: " + qty + ", Available: " + stock);
                    return "redirect:/customer";
                }
            }

            // Step 2: Deduct stock and calculate totals
            int totalUnitsCount = 0;
            double grandTotal = 0.0;
            StringBuilder orderSummary = new StringBuilder();
            List<Map<String, Object>> cartForSales = new ArrayList<>();

            for (JsonNode item : itemsNode) {
                String partId = item.path("partId").asText("").trim();
                int qty = item.path("quantity").asInt(0);

                int updated = jdbcTemplate.update(
                        "UPDATE inventory SET quantity = quantity - ? WHERE part_id = ? AND quantity >= ?",
                        qty, partId, qty);
                if (updated == 0) {
                    throw new CustomerException("Concurrent stock change prevented purchase of part: " + partId);
                }

                String partName = jdbcTemplate.queryForObject(
                        "SELECT part_name FROM inventory WHERE part_id = ?", String.class, partId);
                Double price = jdbcTemplate.queryForObject(
                        "SELECT unit_price FROM inventory WHERE part_id = ?", Double.class, partId);
                double linePrice = (price != null ? price : 0.0) * qty;

                totalUnitsCount += qty;
                grandTotal += linePrice;

                if (orderSummary.length() > 0) orderSummary.append(", ");
                orderSummary.append(qty).append("x ").append(partName != null ? partName : partId);

                Map<String, Object> m = new HashMap<>();
                m.put("partId", partId);
                m.put("partName", partName != null ? partName : partId);
                m.put("quantity", qty);
                m.put("unitPrice", price != null ? price : 0.0);
                cartForSales.add(m);
            }

            // Forward to sales queue
            try {
                com.sparepartmanagementsystem.sales.SalesController.saveOrder(
                        jdbcTemplate, effectiveName, grandTotal, orderSummary.toString(), cartForSales);
            } catch (Exception ignored) {}

            redirectAttributes.addFlashAttribute("successMessage",
                    "Order successfully placed for " + effectiveName + "! " + totalUnitsCount + " units (" + orderSummary + ") for Rs. " + String.format("%.2f", grandTotal));
            redirectAttributes.addFlashAttribute("cartCleared", true);

        } catch (CustomerException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Order failed: " + e.getMessage());
        }
        return "redirect:/customer";
    }

    // Updates user profile details including name, email, and password
    @PostMapping({"/account/update-profile", "/customer/update-profile"})
    public String updateProfile(@RequestParam(defaultValue = "") String fullName,
                                @RequestParam(defaultValue = "") String email,
                                @RequestParam(defaultValue = "") String newPassword,
                                @RequestParam(defaultValue = "") String confirmNewPassword,
                                @RequestParam(required = false) String redirectUrl,
                                HttpSession session,
                                RedirectAttributes redirectAttributes) {
        String currentUser = (String) session.getAttribute("currentUser");
        String userRole = (String) session.getAttribute("userRole");
        if (currentUser == null) {
            return "redirect:/login";
        }

        String targetRedirect = redirectUrl;
        if (targetRedirect == null || targetRedirect.isBlank()) {
            if ("ADMIN".equalsIgnoreCase(userRole)) targetRedirect = "/admin/dashboard";
            else if ("INVENTORY".equalsIgnoreCase(userRole)) targetRedirect = "/inventory/dashboard";
            else if ("SPAREPARTS".equalsIgnoreCase(userRole)) targetRedirect = "/spareparts";
            else if ("SALES".equalsIgnoreCase(userRole)) targetRedirect = "/sales";
            else if ("SUPPLIER".equalsIgnoreCase(userRole)) targetRedirect = "/supplier";
            else targetRedirect = "/customer";
        }

        try {
            customerService.updateProfile(currentUser, fullName, email, newPassword, confirmNewPassword);
            if (!fullName.trim().isEmpty()) session.setAttribute("fullName", fullName.trim());
            if (!email.trim().isEmpty()) session.setAttribute("email", email.trim());
            redirectAttributes.addFlashAttribute("successMessage", "Account details updated successfully!");
        } catch (CustomerException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Update failed: " + e.getMessage());
        }
        return "redirect:" + targetRedirect;
    }
}
