package com.sparepartmanagementsystem.sales;

import java.util.List;
import java.util.Map;
import java.util.Optional;

/**
 * OOP CONCEPT: Interface & Repository Pattern
 * Contract defining database persistence for customer orders, line items, and sales audits.
 */
public interface SalesRepository {

    // Initializes database tables for sales orders and order items
    void initSchema();

    // Retrieves all sales orders ordered chronologically
    List<SalesOrder> findAllOrders();

    // Retrieves raw order map list for dashboard view rendering
    List<Map<String, Object>> findAllOrdersAsMap();

    // Retrieves individual order by its primary key
    Optional<SalesOrder> findOrderById(int orderId);

    // Retrieves composite line items belonging to a specific order
    List<OrderItem> findOrderItems(int orderId);

    // Retrieves composite line items as map list for modal rendering
    List<Map<String, Object>> findOrderItemsAsMap(int orderId);

    // Persists a newly placed sales order returning generated primary key
    int createOrder(String customerName, String orderDate, double totalAmount, String status, String notes);

    // Persists an individual item row linked to a parent sales order
    int createOrderItem(int orderId, String partId, String partName, int quantity, double unitPrice, double lineTotal);

    // Updates the workflow status and audit notes of a sales order
    int updateOrderStatus(int orderId, String status, String notes);

    // Deletes an order and its cascaded line items from the database
    int deleteOrder(int orderId);

    // Aggregates total order count matching specific status filter
    int countOrdersByStatus(String status);

    // Sums the gross monetary value of orders matching specific status
    double sumRevenueByStatus(String status);

    // Queries top selling spare parts by volume and commercial revenue
    List<Map<String, Object>> findTopSellingParts(int limit);

    // Queries sales audit reports submitted to the Administrator
    List<Map<String, Object>> findSalesReports();

    // Persists a newly compiled commercial sales report for executive review
    int saveSalesReport(String reportTitle, String startDate, String endDate, String author, String date, String content, String notes);
}
