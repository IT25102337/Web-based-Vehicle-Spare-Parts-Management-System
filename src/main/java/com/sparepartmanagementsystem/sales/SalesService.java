package com.sparepartmanagementsystem.sales;

import java.util.List;
import java.util.Map;

/**
 * OOP CONCEPT: Interface (Service Layer Contract)
 * Defines business logic contracts for sales order operations, reporting, and fulfillment.
 */
public interface SalesService {

    // Initializes database tables and schemas for sales order tracking
    void initializeSalesSystem();

    // Retrieves all sales orders currently registered in the system
    List<SalesOrder> getAllSalesOrders();

    // Retrieves structured dashboard data including KPIs and order listings
    Map<String, Object> getSalesDashboardData();

    // Transitions a pending order into processing status with audit notes
    void processOrder(int orderId, String notes);

    // Marks an active order as completed and recognizes earned revenue
    void completeOrder(int orderId);

    // Cancels an existing order in the sales queue
    void cancelOrder(int orderId);

    // Permanently removes an order and its associated line items
    void deleteOrder(int orderId);

    // Records a new sales order with child line items placed by a customer
    void recordNewOrder(String customerName, double totalAmount, String notes, List<Map<String, Object>> cartItems);

    // Compiles an official commercial sales audit report and submits it to Administrator
    void generateAndSubmitSalesReport(String reportTitle, String fromDate, String toDate, String reportScope, String managerNotes, String author);

    // DESIGN PATTERN: Decorator Pattern - Computes dynamic order pricing with optional add-on decorators
    OrderPriceComponent calculateDecoratedOrderTotal(double baseAmount, boolean expressDelivery, boolean extendedWarranty);
}
