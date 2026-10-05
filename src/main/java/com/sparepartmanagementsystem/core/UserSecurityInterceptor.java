package com.sparepartmanagementsystem.core;
import com.sparepartmanagementsystem.core.*;
import com.sparepartmanagementsystem.inventory.*;
import com.sparepartmanagementsystem.procurement.*;
import com.sparepartmanagementsystem.admin.*;
import com.sparepartmanagementsystem.customer.*;


import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * =========================================================================
 * TEAM MEMBER 3: ROLE-BASED PRIVACY & ACCESS CONTROL INTERCEPTOR
 * =========================================================================
 * Enforces strict role privacy across the system:
 * 1. Customer: Restricted exclusively to Customer Store (/customer, /store)
 * 2. Inventory Admin: Restricted to Inventory & Stock (/inventory, /reorder)
 * 3. Spare Part Manager: Restricted to Quality & Procurement (/spareparts, /procurement)
 * 
 * Unauthenticated users are redirected back to the login portal.
 */
@Component
public class UserSecurityInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();
        String path = uri.substring(contextPath.length());

        // 1. Allow public & authentication assets
        if (isPublicPath(path)) {
            return true;
        }

        // 2. Check active session
        HttpSession session = request.getSession(false);
        String role = (session != null) ? (String) session.getAttribute("userRole") : null;

        // If not logged in, enforce authentication
        if (role == null || role.trim().isEmpty()) {
            if (session != null) {
                session.setAttribute("sessionErrorMessage", "Privacy Notice: Please sign in with your account to access this system.");
            }
            response.sendRedirect(contextPath + "/login");
            return false;
        }

        // 3. Enforce Role-Based Privacy
        switch (role.toUpperCase()) {
            case "SYSADMIN":
            case "SYSTEM_ADMIN":
            case "ADMIN":
                // System Admin has master access across administrative workspaces and operational portals
                return true;

            case "REPORT_MANAGER":
            case "REPORTS":
                // Report & Business Dashboard Manager can access /reports, /inventory/reports
                if (path.startsWith("/admin")) {
                    session.setAttribute("sessionErrorMessage", "Security Policy: System Administrator privileges required to access User Governance.");
                    response.sendRedirect(contextPath + "/reports/dashboard");
                    return false;
                }
                if (path.startsWith("/customer") || path.startsWith("/store")) {
                    session.setAttribute("sessionErrorMessage", "Privacy Restriction: Please log out to browse as a customer.");
                    response.sendRedirect(contextPath + "/reports/dashboard");
                    return false;
                }
                return true;

            case "INVENTORY":
                // Inventory Admin can only access /inventory, /reorder, /update
                if (path.startsWith("/admin") || path.startsWith("/reports")) {
                    session.setAttribute("sessionErrorMessage", "Privacy Notice: Administrator access requires System Admin privileges.");
                    response.sendRedirect(contextPath + "/inventory/dashboard");
                    return false;
                }
                if (path.startsWith("/spareparts") || path.startsWith("/procurement") || path.startsWith("/supplier-products")) {
                    session.setAttribute("sessionErrorMessage", "Privacy Restriction: Inventory Admin accounts cannot access Spare Part Quality Management.");
                    response.sendRedirect(contextPath + "/inventory/dashboard");
                    return false;
                }
                if (path.startsWith("/customer") || path.startsWith("/store")) {
                    session.setAttribute("sessionErrorMessage", "Privacy Restriction: Please log out to browse as a customer.");
                    response.sendRedirect(contextPath + "/inventory/dashboard");
                    return false;
                }
                return true;

            case "SPAREPARTS":
                // Spare Part Manager can only access /spareparts, /procurement, /supplier-products
                if (path.startsWith("/admin") || path.startsWith("/reports") || path.startsWith("/inventory") || path.startsWith("/reorder") || path.startsWith("/update")) {
                    session.setAttribute("sessionErrorMessage", "Privacy Restriction: Spare Part accounts cannot access Warehouse Inventory.");
                    response.sendRedirect(contextPath + "/spareparts");
                    return false;
                }
                if (path.startsWith("/customer") || path.startsWith("/store")) {
                    session.setAttribute("sessionErrorMessage", "Privacy Restriction: Please log out to browse as a customer.");
                    response.sendRedirect(contextPath + "/spareparts");
                    return false;
                }
                return true;

            case "SALES":
                // Sales Manager can access /sales, /account
                if (path.startsWith("/admin") || path.startsWith("/reports") || path.startsWith("/inventory") || path.startsWith("/reorder") || path.startsWith("/update")
                        || path.startsWith("/spareparts") || path.startsWith("/procurement") || path.startsWith("/supplier-products")
                        || path.startsWith("/customer") || path.startsWith("/store")) {
                    session.setAttribute("sessionErrorMessage", "Privacy Restriction: Sales Manager accounts can only access Sales Order Management.");
                    response.sendRedirect(contextPath + "/sales");
                    return false;
                }
                return true;

            case "SUPPLIER":
                // Supplier can access /supplier, /account
                if (path.startsWith("/admin") || path.startsWith("/reports") || path.startsWith("/inventory") || path.startsWith("/reorder") || path.startsWith("/update")
                        || path.startsWith("/spareparts") || path.startsWith("/procurement")
                        || path.startsWith("/customer") || path.startsWith("/store")
                        || path.startsWith("/sales")) {
                    session.setAttribute("sessionErrorMessage", "Privacy Restriction: Supplier accounts can only access the Supplier Portal.");
                    response.sendRedirect(contextPath + "/supplier");
                    return false;
                }
                return true;

            case "CUSTOMER":
                // Customer can only access /customer, /store
                if (path.startsWith("/admin") || path.startsWith("/reports") || path.startsWith("/inventory") || path.startsWith("/reorder") || path.startsWith("/update")
                        || path.startsWith("/spareparts") || path.startsWith("/procurement") || path.startsWith("/supplier-products")
                        || path.startsWith("/sales") || path.startsWith("/supplier")) {
                    session.setAttribute("sessionErrorMessage", "Privacy Restriction: Customer accounts cannot access internal staff management modules.");
                    response.sendRedirect(contextPath + "/customer");
                    return false;
                }
                return true;

            default:
                response.sendRedirect(contextPath + "/login");
                return false;
        }
    }

    private boolean isPublicPath(String path) {
        return path.equals("/")
                || path.equals("/login")
                || path.equals("/logout")
                || path.equals("/signup")
                || path.equals("/register")
                || path.startsWith("/css/")
                || path.startsWith("/js/")
                || path.startsWith("/images/")
                || path.startsWith("/webjars/")
                || path.startsWith("/error")
                || path.equals("/favicon.ico");
    }
}


