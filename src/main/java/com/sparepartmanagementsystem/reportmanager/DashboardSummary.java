package com.sparepartmanagementsystem.reportmanager;

/**
 * OOP CONCEPT: Encapsulation
 * Represents consolidated system-wide operational metrics for executive report manager review.
 */
public class DashboardSummary {
    private boolean isDataAvailable;
    private int totalSales;
    private int stockItems;
    private int pendingOrders;
    private int supplierDeliveries;
    private double totalValuation;
    private int activeSKUs;
    private int lowStockCount;

    // Default Constructor for frameworks
    public DashboardSummary() {}

    // Parameterized Constructor initializing complete system-wide summary metrics for executive reporting
    public DashboardSummary(boolean isDataAvailable, int totalSales, int stockItems, int pendingOrders, 
                            int supplierDeliveries, double totalValuation, int activeSKUs, int lowStockCount) {
        this.isDataAvailable = isDataAvailable;
        this.totalSales = totalSales;
        this.stockItems = stockItems;
        this.pendingOrders = pendingOrders;
        this.supplierDeliveries = supplierDeliveries;
        this.totalValuation = totalValuation;
        this.activeSKUs = activeSKUs;
        this.lowStockCount = lowStockCount;
    }

    // Indicates whether live database metrics were successfully retrieved
    public boolean isDataAvailable() { return isDataAvailable; }

    // Sets whether live database metrics were successfully retrieved
    public void setDataAvailable(boolean dataAvailable) { isDataAvailable = dataAvailable; }

    // Retrieves total completed sales count
    public int getTotalSales() { return totalSales; }

    // Sets total completed sales count
    public void setTotalSales(int totalSales) { this.totalSales = totalSales; }

    // Retrieves total physical stock units in warehouse
    public int getStockItems() { return stockItems; }

    // Sets total physical stock units in warehouse
    public void setStockItems(int stockItems) { this.stockItems = stockItems; }

    // Retrieves count of pending restock and sales requests
    public int getPendingOrders() { return pendingOrders; }

    // Sets count of pending restock and sales requests
    public void setPendingOrders(int pendingOrders) { this.pendingOrders = pendingOrders; }

    // Retrieves incoming supplier delivery shipments count
    public int getSupplierDeliveries() { return supplierDeliveries; }

    // Sets incoming supplier delivery shipments count
    public void setSupplierDeliveries(int supplierDeliveries) { this.supplierDeliveries = supplierDeliveries; }

    // Retrieves total gross monetary valuation of inventory
    public double getTotalValuation() { return totalValuation; }

    // Sets total gross monetary valuation of inventory
    public void setTotalValuation(double totalValuation) { this.totalValuation = totalValuation; }

    // Retrieves total unique registered spare part SKUs
    public int getActiveSKUs() { return activeSKUs; }

    // Sets total unique registered spare part SKUs
    public void setActiveSKUs(int activeSKUs) { this.activeSKUs = activeSKUs; }

    // Retrieves count of parts at or below their minimum reorder point
    public int getLowStockCount() { return lowStockCount; }

    // Sets count of parts at or below their minimum reorder point
    public void setLowStockCount(int lowStockCount) { this.lowStockCount = lowStockCount; }

    // Compatibility getter for total registered product SKUs
    public int getTotalProducts() { return activeSKUs; }

    // Compatibility setter for total registered product SKUs
    public void setTotalProducts(int totalProducts) { this.activeSKUs = totalProducts; }

    // Compatibility getter for total physical warehouse stock units
    public int getTotalStockUnits() { return stockItems; }

    // Compatibility setter for total physical warehouse stock units
    public void setTotalStockUnits(int totalStockUnits) { this.stockItems = totalStockUnits; }

    // Compatibility getter for total monetary sales revenue
    public double getTotalSalesRevenue() { return totalValuation; }

    // Compatibility setter for total monetary sales revenue
    public void setTotalSalesRevenue(double totalSalesRevenue) { this.totalValuation = totalSalesRevenue; }
}
