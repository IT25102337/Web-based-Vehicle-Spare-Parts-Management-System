package com.sparepartmanagementsystem.admin;

import com.sparepartmanagementsystem.customer.UserAccount;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Map;

/**
 * OOP CONCEPTS: Controller Layer, Association & Exception Handling
 * Central controller managing System Administrator console routes, user provisioning, account updates, suspensions, and recovery history.
 */
@Controller
@RequestMapping("/admin")
public class AdminController {

    // AdminService association for executing administrative business logic
    @Autowired
    private AdminService adminService;

    // UI 1: Displays the System Administrator Command Center & Master Telemetry Dashboard
    @GetMapping({"", "/", "/dashboard"})
    public String showCommandCenter(Model model, HttpSession session) {
        Map<String, Object> stats = adminService.getSystemOverviewStats();
        List<Map<String, Object>> securityLogs = adminService.getSecurityAuditFeed();
        List<UserAccount> allUsers = adminService.getAllUsers();
        List<SuspensionRecord> activeSuspensions = adminService.getActiveSuspensions();

        model.addAttribute("stats", stats);
        model.addAttribute("securityLogs", securityLogs);
        model.addAttribute("allUsers", allUsers);
        model.addAttribute("activeSuspensions", activeSuspensions);
        model.addAttribute("activeNav", "dashboard");
        return "admin/admin_dashboard";
    }

    // UI 2: Displays the Master User Directory with role filtering, full CRUD, and modal controllers
    @GetMapping("/users")
    public String showUserDirectory(@RequestParam(value = "role", defaultValue = "ALL") String filterRole,
                                    Model model, HttpSession session) {
        List<UserAccount> users = adminService.getUsersByRole(filterRole);
        Map<String, Object> stats = adminService.getSystemOverviewStats();

        model.addAttribute("users", users);
        model.addAttribute("stats", stats);
        model.addAttribute("currentFilter", filterRole);
        model.addAttribute("activeNav", "users");
        return "admin/admin_users";
    }

    // UI 3: Displays the Suspended Accounts History & One-Click Account Recovery Console
    @GetMapping("/suspensions")
    public String showSuspensionHistory(Model model, HttpSession session) {
        List<SuspensionRecord> history = adminService.getSuspensionHistory();
        List<SuspensionRecord> activeSuspensions = adminService.getActiveSuspensions();
        Map<String, Object> stats = adminService.getSystemOverviewStats();

        model.addAttribute("history", history);
        model.addAttribute("activeSuspensions", activeSuspensions);
        model.addAttribute("stats", stats);
        model.addAttribute("activeNav", "suspensions");
        return "admin/admin_suspensions";
    }

    // Displays the System Security Governance, Access Control Matrix, and Role Privileges
    @GetMapping("/roles")
    public String showRolesAndPermissions(Model model, HttpSession session) {
        List<Map<String, Object>> matrix = adminService.getRolePermissionMatrix();
        Map<String, Object> stats = adminService.getSystemOverviewStats();
        List<Map<String, Object>> securityLogs = adminService.getSecurityAuditFeed();

        model.addAttribute("matrix", matrix);
        model.addAttribute("stats", stats);
        model.addAttribute("securityLogs", securityLogs);
        model.addAttribute("activeNav", "roles");
        return "admin/admin_roles";
    }

    // Provisions a new verified customer account directly from the system admin workspace
    @PostMapping("/users/add-customer")
    public String addCustomer(@RequestParam String username,
                              @RequestParam String password,
                              @RequestParam(required = false) String confirmPassword,
                              @RequestParam String fullName,
                              @RequestParam String email,
                              @RequestParam(defaultValue = "+94 77 123 4567") String phone,
                              @RequestParam(required = false) String address,
                              @RequestParam(required = false) String city,
                              RedirectAttributes ra) {
        try {
            if (confirmPassword != null && !confirmPassword.isBlank() && !password.equals(confirmPassword)) {
                throw new AdminException("Passwords do not match. Please re-enter and confirm password.");
            }
            adminService.registerNewCustomer(username, password, fullName, email, phone);
            ra.addFlashAttribute("successMessage", "Customer account '" + username.trim() + "' created successfully!");
        } catch (AdminException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to create customer: " + e.getMessage());
        }
        return "redirect:/admin/users?role=CUSTOMER";
    }

    // Provisions a new staff or operational manager account assigned to a designated role
    @PostMapping("/users/add-staff")
    public String addStaff(@RequestParam String username,
                           @RequestParam String password,
                           @RequestParam(required = false) String confirmPassword,
                           @RequestParam String fullName,
                           @RequestParam String email,
                           @RequestParam(defaultValue = "+94 77 123 4567") String phone,
                           @RequestParam String role,
                           @RequestParam(required = false) String department,
                           @RequestParam(required = false) String employeeId,
                           RedirectAttributes ra) {
        try {
            if (confirmPassword != null && !confirmPassword.isBlank() && !password.equals(confirmPassword)) {
                throw new AdminException("Passwords do not match. Please re-enter and confirm password.");
            }
            adminService.registerNewStaff(username, password, fullName, email, phone, role);
            ra.addFlashAttribute("successMessage", "Staff account '" + username.trim() + "' created successfully as " + role + "!");
        } catch (AdminException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to create staff member: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    // Updates profile attributes, username, contact info, security role, status, and login password
    @PostMapping("/users/update")
    public String updateUserDetails(@RequestParam int userId,
                                    @RequestParam String username,
                                    @RequestParam String fullName,
                                    @RequestParam String email,
                                    @RequestParam String phone,
                                    @RequestParam String role,
                                    @RequestParam String status,
                                    @RequestParam(required = false) String password,
                                    @RequestParam(required = false) String newPassword,
                                    RedirectAttributes ra) {
        try {
            String effectivePassword = (password != null && !password.isBlank()) ? password : newPassword;
            adminService.updateUserDetails(userId, username, fullName, email, phone, role, status, effectivePassword);
            ra.addFlashAttribute("successMessage", "Account credentials and profile for @" + username.trim() + " updated successfully!");
        } catch (AdminException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to update user: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    // Permanently removes a user account from the platform database with administrator protection
    @PostMapping("/users/delete")
    public String deleteUser(@RequestParam int userId,
                             HttpSession session,
                             RedirectAttributes ra) {
        try {
            String currentAdmin = (session != null) ? (String) session.getAttribute("currentUser") : null;
            adminService.removeUser(userId, currentAdmin);
            ra.addFlashAttribute("successMessage", "User account permanently removed from the system.");
        } catch (AdminException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to delete user: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    // Suspends a user account with a mandatory reason and records the incident in suspension history
    @PostMapping("/users/suspend")
    public String suspendUser(@RequestParam int userId,
                              @RequestParam(defaultValue = "Policy review / administrative hold") String reason,
                              HttpSession session,
                              RedirectAttributes ra) {
        try {
            String currentAdmin = (session != null) ? (String) session.getAttribute("currentUser") : null;
            adminService.suspendAccount(userId, reason, currentAdmin);
            ra.addFlashAttribute("successMessage", "User account has been suspended and logged in Suspended History.");
        } catch (AdminException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to suspend account: " + e.getMessage());
        }
        return "redirect:/admin/suspensions";
    }

    // Recovers a previously suspended account from Suspended History and restores it to full Active status
    @PostMapping("/users/recover")
    public String recoverUser(@RequestParam int userId,
                              HttpSession session,
                              RedirectAttributes ra) {
        try {
            String currentAdmin = (session != null) ? (String) session.getAttribute("currentUser") : null;
            adminService.recoverAccount(userId, currentAdmin);
            ra.addFlashAttribute("successMessage", "Account successfully recovered! Access restored to ACTIVE status.");
        } catch (AdminException e) {
            ra.addFlashAttribute("errorMessage", e.getMessage());
        } catch (Exception e) {
            ra.addFlashAttribute("errorMessage", "Failed to recover account: " + e.getMessage());
        }
        return "redirect:/admin/suspensions";
    }
}
