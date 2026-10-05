package com.sparepartmanagementsystem.core;

// DESIGN PATTERN: Singleton Pattern (Creational) - Centralized global configuration manager
public class AppConfigManager {

    // DESIGN PATTERN: Singleton Pattern - Private static instance variable
    private static AppConfigManager instance;

    // Global application configuration settings
    private String systemName = "Spare Part Management Depot";
    private int maxWarehouseCapacity = 1000;
    private double standardVatRate = 0.12;

    // DESIGN PATTERN: Singleton Pattern - Private constructor prevents direct instantiation
    private AppConfigManager() {}

    // DESIGN PATTERN: Singleton Pattern - Public static getInstance() provides global access point
    public static synchronized AppConfigManager getInstance() {
        if (instance == null) {
            instance = new AppConfigManager();
        }
        return instance;
    }

    public String getSystemName() { return systemName; }
    public void setSystemName(String systemName) { this.systemName = systemName; }
    public int getMaxWarehouseCapacity() { return maxWarehouseCapacity; }
    public void setMaxWarehouseCapacity(int maxWarehouseCapacity) { this.maxWarehouseCapacity = maxWarehouseCapacity; }
    public double getStandardVatRate() { return standardVatRate; }
    public void setStandardVatRate(double standardVatRate) { this.standardVatRate = standardVatRate; }
}
