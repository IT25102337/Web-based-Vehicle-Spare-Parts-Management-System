package com.it25101530.spareparts.dto;

public class DashboardSummary {
    private boolean isDataAvailable;
    private int totalSales;
    private int stockItems;
    private int pendingOrders;
    private int supplierDeliveries;

    // Getters and Setters
    public boolean isDataAvailable() { return isDataAvailable; }
    public void setDataAvailable(boolean dataAvailable) { isDataAvailable = dataAvailable; }
    public int getTotalSales() { return totalSales; }
    public void setTotalSales(int totalSales) { this.totalSales = totalSales; }
    public int getStockItems() { return stockItems; }
    public void setStockItems(int stockItems) { this.stockItems = stockItems; }
    public int getPendingOrders() { return pendingOrders; }
    public void setPendingOrders(int pendingOrders) { this.pendingOrders = pendingOrders; }
    public int getSupplierDeliveries() { return supplierDeliveries; }
    public void setSupplierDeliveries(int supplierDeliveries) { this.supplierDeliveries = supplierDeliveries; }
}