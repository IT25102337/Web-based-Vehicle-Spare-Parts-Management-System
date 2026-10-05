package com.sparepartmanagementsystem.sales;

// DESIGN PATTERN: Decorator Pattern (Structural) - Abstract Decorator wrapping an OrderPriceComponent
public abstract class OrderPricingDecorator implements OrderPriceComponent {

    // Protected reference to wrapped component
    protected final OrderPriceComponent wrappedOrder;

    // Parameterized constructor wrapping the target component
    public OrderPricingDecorator(OrderPriceComponent wrappedOrder) {
        this.wrappedOrder = wrappedOrder;
    }

    @Override
    public double calculatePrice() {
        return wrappedOrder.calculatePrice();
    }

    @Override
    public String getDescription() {
        return wrappedOrder.getDescription();
    }
}

// DESIGN PATTERN: Decorator Pattern - Concrete Base Component receiving dynamic additions
class BaseOrderPricing implements OrderPriceComponent {
    private final double basePrice;

    public BaseOrderPricing(double basePrice) {
        this.basePrice = basePrice;
    }

    @Override
    public double calculatePrice() {
        return basePrice;
    }

    @Override
    public String getDescription() {
        return "Standard Order";
    }
}

// DESIGN PATTERN: Decorator Pattern - Concrete Decorator adding Express Delivery surcharge
class ExpressShippingDecorator extends OrderPricingDecorator {
    public ExpressShippingDecorator(OrderPriceComponent wrappedOrder) {
        super(wrappedOrder);
    }

    @Override
    public double calculatePrice() {
        return wrappedOrder.calculatePrice() + 500.0;
    }

    @Override
    public String getDescription() {
        return wrappedOrder.getDescription() + " + Express Delivery (Rs. 500)";
    }
}

// DESIGN PATTERN: Decorator Pattern - Concrete Decorator adding 10% Extended Warranty surcharge
class ExtendedWarrantyDecorator extends OrderPricingDecorator {
    public ExtendedWarrantyDecorator(OrderPriceComponent wrappedOrder) {
        super(wrappedOrder);
    }

    @Override
    public double calculatePrice() {
        return wrappedOrder.calculatePrice() * 1.10;
    }

    @Override
    public String getDescription() {
        return wrappedOrder.getDescription() + " + 1-Year Extended Warranty (10%)";
    }
}
