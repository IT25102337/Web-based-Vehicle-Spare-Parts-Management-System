package com.sparepartmanagementsystem.sales;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.*;

/**
 * OOP CONCEPT: Interface Implementation (Service Layer)
 * UML RELATIONSHIP: Association (SalesServiceImpl associates with SalesRepository)
 * Encapsulates commercial sales processing, KPI aggregation, and auditing rules.
 */
@Service
public class SalesServiceImpl implements SalesService {

    // UML RELATIONSHIP: Association (SalesServiceImpl associates with SalesRepository)
    @Autowired
    private SalesRepository salesRepository;

    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");

    // Initializes database tables and schemas for sales order tracking
    @Override
    public void initializeSalesSystem() {
        salesRepository.initSchema();
    }

    // Retrieves all sales orders currently registered in the system
    @Override
    public List<SalesOrder> getAllSalesOrders() {
        return salesRepository.findAllOrders();
    }

    // Retrieves structured dashboard data including KPIs and order listings
    @Override
    public Map<String, Object> getSalesDashboardData() {
        Map<String, Object> data = new HashMap<>();

        List<Map<String, Object>> orders = salesRepository.findAllOrdersAsMap();
        data.put("orders", orders);

        Map<Integer, List<Map<String, Object>>> orderItemsMap = new LinkedHashMap<>();
        for (Map<String, Object> order : orders) {
            int oid = ((Number) order.get("order_id")).intValue();
            orderItemsMap.put(oid, salesRepository.findOrderItemsAsMap(oid));
        }
        data.put("orderItemsMap", orderItemsMap);

        int totalOrders = salesRepository.countOrdersByStatus("");
        int pendingOrders = salesRepository.countOrdersByStatus("PENDING");
        int processingOrders = salesRepository.countOrdersByStatus("PROCESSING");
        int completedOrders = salesRepository.countOrdersByStatus("COMPLETED");
        int cancelledOrders = salesRepository.countOrdersByStatus("CANCELLED");

        double earnedRevenue = salesRepository.sumRevenueByStatus("COMPLETED");
        double inProcessing = salesRepository.sumRevenueByStatus("PROCESSING");
        double inPending = salesRepository.sumRevenueByStatus("PENDING");
        double totalPipeline = inProcessing + inPending;
        double grossCommercial = earnedRevenue + totalPipeline;

        data.put("totalOrders", totalOrders);
        data.put("pendingOrders", pendingOrders);
        data.put("processingOrders", processingOrders);
        data.put("completedOrders", completedOrders);
        data.put("cancelledOrders", cancelledOrders);
        data.put("totalRevenue", earnedRevenue);
        data.put("completedRevenue", earnedRevenue);
        data.put("processingRevenue", inProcessing);
        data.put("pendingRevenue", inPending);
        data.put("pipelineRevenue", totalPipeline);
        data.put("grossCommercialValue", grossCommercial);

        data.put("topSellingParts", salesRepository.findTopSellingParts(5));
        data.put("salesReports", salesRepository.findSalesReports());

        return data;
    }

    // Transitions a pending order into processing status with audit notes
    @Override
    public void processOrder(int orderId, String notes) {
        String auditNote = (notes != null && !notes.isBlank()) ? " | Note: " + notes.trim() : "";
        int rows = salesRepository.updateOrderStatus(orderId, "PROCESSING", auditNote);
        if (rows <= 0) {
            throw new SalesException("Order #" + orderId + " could not be updated (may not be in PENDING status).");
        }
    }

    // Marks an active order as completed and recognizes earned revenue
    @Override
    public void completeOrder(int orderId) {
        int rows = salesRepository.updateOrderStatus(orderId, "COMPLETED", "");
        if (rows <= 0) {
            throw new SalesException("Order #" + orderId + " cannot be completed (already completed or cancelled).");
        }
    }

    // Cancels an existing order in the sales queue
    @Override
    public void cancelOrder(int orderId) {
        int rows = salesRepository.updateOrderStatus(orderId, "CANCELLED", "");
        if (rows <= 0) {
            throw new SalesException("Order #" + orderId + " cannot be cancelled (already completed or not found).");
        }
    }

    // Permanently removes an order and its associated line items
    @Override
    @Transactional
    public void deleteOrder(int orderId) {
        int rows = salesRepository.deleteOrder(orderId);
        if (rows <= 0) {
            throw new SalesException("Order #" + orderId + " was not found.");
        }
    }

    // Records a new sales order with child line items placed by a customer
    @Override
    @Transactional
    public void recordNewOrder(String customerName, double totalAmount, String notes, List<Map<String, Object>> cartItems) {
        String orderDate = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        int orderId = salesRepository.createOrder(customerName, orderDate, totalAmount, "PENDING", notes);
        if (orderId <= 0) {
            throw new SalesException("Failed to persist sales order header.");
        }

        if (cartItems != null) {
            for (Map<String, Object> item : cartItems) {
                String partId = String.valueOf(item.getOrDefault("partId", ""));
                String partName = String.valueOf(item.getOrDefault("partName", ""));
                int qty = ((Number) item.getOrDefault("quantity", 0)).intValue();
                double unitPrice = ((Number) item.getOrDefault("unitPrice", 0.0)).doubleValue();
                double lineTotal = qty * unitPrice;

                salesRepository.createOrderItem(orderId, partId, partName, qty, unitPrice, lineTotal);
            }
        }
    }

    // Compiles an official commercial sales audit report and submits it to Administrator
    @Override
    public void generateAndSubmitSalesReport(String reportTitle, String fromDate, String toDate, String reportScope, String managerNotes, String author) {
        LocalDate now = LocalDate.now();
        String startDate = (fromDate != null && !fromDate.isBlank()) ? fromDate.trim() : now.minusDays(30).format(DATE_FORMATTER);
        String endDate = (toDate != null && !toDate.isBlank()) ? toDate.trim() : now.format(DATE_FORMATTER);
        String submitter = (author != null && !author.isBlank()) ? author.trim() : "Sales Manager";

        int totalOrders = salesRepository.countOrdersByStatus("");
        int pendingOrders = salesRepository.countOrdersByStatus("PENDING");
        int processingOrders = salesRepository.countOrdersByStatus("PROCESSING");
        int completedOrders = salesRepository.countOrdersByStatus("COMPLETED");

        double completedRev = salesRepository.sumRevenueByStatus("COMPLETED");
        double processingRev = salesRepository.sumRevenueByStatus("PROCESSING");
        double pendingRev = salesRepository.sumRevenueByStatus("PENDING");
        double grossCommercial = completedRev + processingRev + pendingRev;

        StringBuilder sb = new StringBuilder();
        sb.append(String.format("Report Title: %s\n", reportTitle.trim()));
        sb.append("Category: Commercial Sales & Income Performance\n");
        sb.append(String.format("Audit Timeframe: %s to %s\n", startDate, endDate));
        sb.append(String.format("Submitted By: Sales Manager (%s)\n", submitter));
        sb.append(String.format("Submission Date: %s\n\n", LocalDateTime.now().format(DATE_TIME_FORMATTER)));

        sb.append("COMMERCIAL FINANCIAL SUMMARY\n");
        sb.append(String.format("• Total Customer Orders: %d orders\n", totalOrders));
        sb.append(String.format("• Realized Completed Income: Rs. %,.2f (%d orders completed)\n", completedRev, completedOrders));
        sb.append(String.format("• In-Flight Processing Order Value: Rs. %,.2f (%d orders in warehouse prep)\n", processingRev, processingOrders));
        sb.append(String.format("• Awaiting Verification (Pending): Rs. %,.2f (%d orders pending)\n", pendingRev, pendingOrders));
        sb.append(String.format("• Combined Commercial Scope: Rs. %,.2f\n\n", grossCommercial));

        sb.append("SALES MANAGER AUDIT REMARKS\n");
        sb.append(String.format("%s\n", (managerNotes != null && !managerNotes.isBlank()) ? managerNotes.trim() : "Standard commercial sales performance certification."));

        String genDate = LocalDateTime.now().format(DATE_TIME_FORMATTER);
        salesRepository.saveSalesReport(reportTitle.trim(), startDate, endDate, "Sales Manager (" + submitter + ")", genDate, sb.toString(), managerNotes != null ? managerNotes.trim() : "");
    }

    // DESIGN PATTERN: Decorator Pattern - Dynamically wraps base order price with optional modifiers
    @Override
    public OrderPriceComponent calculateDecoratedOrderTotal(double baseAmount, boolean expressDelivery, boolean extendedWarranty) {
        OrderPriceComponent orderPricing = new BaseOrderPricing(baseAmount);
        if (expressDelivery) {
            orderPricing = new ExpressShippingDecorator(orderPricing);
        }
        if (extendedWarranty) {
            orderPricing = new ExtendedWarrantyDecorator(orderPricing);
        }
        return orderPricing;
    }
}
