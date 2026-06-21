package com.pricing.calc.dto;

import com.pricing.calc.enums.CouponType;
import com.pricing.calc.enums.CustomerType;
import java.util.List;

public class OrderRequest {
    private CustomerType customerType;
    private String destinationCountry;
    private Boolean expeditedShipping;
    private CouponType coupon;
    private List<OrderLineRequest> products;

    public OrderRequest() {}

    public OrderRequest(CustomerType customerType, String destinationCountry, Boolean expeditedShipping,
                        CouponType coupon, List<OrderLineRequest> products) {
        this.customerType = customerType;
        this.destinationCountry = destinationCountry;
        this.expeditedShipping = expeditedShipping;
        this.coupon = coupon;
        this.products = products;
    }

    public CustomerType getCustomerType() { return customerType; }
    public void setCustomerType(CustomerType customerType) { this.customerType = customerType; }

    public String getDestinationCountry() { return destinationCountry; }
    public void setDestinationCountry(String destinationCountry) { this.destinationCountry = destinationCountry; }

    public Boolean getExpeditedShipping() { return expeditedShipping; }
    public void setExpeditedShipping(Boolean expeditedShipping) { this.expeditedShipping = expeditedShipping; }

    public CouponType getCoupon() { return coupon; }
    public void setCoupon(CouponType coupon) { this.coupon = coupon; }

    public List<OrderLineRequest> getProducts() { return products; }
    public void setProducts(List<OrderLineRequest> products) { this.products = products; }
}
