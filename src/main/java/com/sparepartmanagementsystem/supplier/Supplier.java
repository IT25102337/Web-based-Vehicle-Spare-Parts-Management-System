package com.sparepartmanagementsystem.supplier;

/**
 * OOP CONCEPT: Encapsulation
 * Represents an automotive spare parts supplier/vendor in the procurement network.
 */
public class Supplier {
    private int supplierId;
    private String supplierName;
    private String contactPerson;
    private String email;
    private String phone;
    private String category;
    private String address;
    private String status;
    private String createdAt;

    // OOP CONCEPT: Default Constructor
    // Initializes an empty supplier entity instance
    public Supplier() {}

    // OOP CONCEPT: Parameterized Constructor
    // Initializes a complete supplier record with business contact details
    public Supplier(int supplierId, String supplierName, String contactPerson, 
                    String email, String phone, String category, 
                    String address, String status, String createdAt) {
        this.supplierId = supplierId;
        this.supplierName = supplierName;
        this.contactPerson = contactPerson;
        this.email = email;
        this.phone = phone;
        this.category = category;
        this.address = address;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Retrieves unique supplier database identifier
    public int getSupplierId() { return supplierId; }

    // Sets unique supplier database identifier
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    // Retrieves legal company name of the supplier
    public String getSupplierName() { return supplierName; }

    // Sets legal company name of the supplier
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    // Retrieves primary point of contact person
    public String getContactPerson() { return contactPerson; }

    // Sets primary point of contact person
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    // Retrieves corporate email address
    public String getEmail() { return email; }

    // Sets corporate email address
    public void setEmail(String email) { this.email = email; }

    // Retrieves contact telephone number
    public String getPhone() { return phone; }

    // Sets contact telephone number
    public void setPhone(String phone) { this.phone = phone; }

    // Retrieves parts specialization category
    public String getCategory() { return category; }

    // Sets parts specialization category
    public void setCategory(String category) { this.category = category; }

    // Retrieves physical warehouse or office address
    public String getAddress() { return address; }

    // Sets physical warehouse or office address
    public void setAddress(String address) { this.address = address; }

    // Retrieves vendor operating status (ACTIVE / INACTIVE)
    public String getStatus() { return status; }

    // Sets vendor operating status
    public void setStatus(String status) { this.status = status; }

    // Retrieves registration creation date
    public String getCreatedAt() { return createdAt; }

    // Sets registration creation date
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    // Verifies if the vendor is currently active in the procurement network
    public boolean isActive() {
        return "ACTIVE".equalsIgnoreCase(this.status);
    }
}
