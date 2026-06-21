package com.pricing.calc.entity;

import com.pricing.calc.enums.CouponType;
import com.pricing.calc.enums.CustomerType;
import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "order_simulations")
public class OrderSimulation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CustomerType customerType;

    @Column(nullable = false)
    private String destinationCountry;

    @Column(nullable = false)
    private String shippingRegion;

    @Column(nullable = false)
    private Boolean expeditedShipping;

    @Enumerated(EnumType.STRING)
    private CouponType coupon;

    @OneToMany(mappedBy = "orderSimulation", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    private List<OrderLine> orderLines = new ArrayList<>();

    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal subtotal;

    @Column(precision = 19, scale = 2)
    private BigDecimal customerDiscount;

    @Column(precision = 19, scale = 2)
    private BigDecimal vipStandardBonusDiscount;

    @Column(precision = 19, scale = 2)
    private BigDecimal couponDiscount;

    @Column(precision = 19, scale = 2)
    private BigDecimal shippingCost;

    @Column(precision = 19, scale = 2)
    private BigDecimal taxes;

    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal finalTotal;

    @Column(nullable = false)
    private LocalDateTime calculatedAt;

    @Column(columnDefinition = "TEXT")
    private String calculationDetails;

    // Constructors
    public OrderSimulation() {}

    public OrderSimulation(Long id, CustomerType customerType, String destinationCountry, 
                          String shippingRegion, Boolean expeditedShipping, CouponType coupon,
                          List<OrderLine> orderLines, BigDecimal subtotal, BigDecimal customerDiscount,
                          BigDecimal vipStandardBonusDiscount, BigDecimal couponDiscount,
                          BigDecimal shippingCost, BigDecimal taxes, BigDecimal finalTotal,
                          LocalDateTime calculatedAt, String calculationDetails) {
        this.id = id;
        this.customerType = customerType;
        this.destinationCountry = destinationCountry;
        this.shippingRegion = shippingRegion;
        this.expeditedShipping = expeditedShipping;
        this.coupon = coupon;
        this.orderLines = orderLines;
        this.subtotal = subtotal;
        this.customerDiscount = customerDiscount;
        this.vipStandardBonusDiscount = vipStandardBonusDiscount;
        this.couponDiscount = couponDiscount;
        this.shippingCost = shippingCost;
        this.taxes = taxes;
        this.finalTotal = finalTotal;
        this.calculatedAt = calculatedAt;
        this.calculationDetails = calculationDetails;
    }

    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public CustomerType getCustomerType() { return customerType; }
    public void setCustomerType(CustomerType customerType) { this.customerType = customerType; }

    public String getDestinationCountry() { return destinationCountry; }
    public void setDestinationCountry(String destinationCountry) { this.destinationCountry = destinationCountry; }

    public String getShippingRegion() { return shippingRegion; }
    public void setShippingRegion(String shippingRegion) { this.shippingRegion = shippingRegion; }

    public Boolean getExpeditedShipping() { return expeditedShipping; }
    public void setExpeditedShipping(Boolean expeditedShipping) { this.expeditedShipping = expeditedShipping; }

    public CouponType getCoupon() { return coupon; }
    public void setCoupon(CouponType coupon) { this.coupon = coupon; }

    public List<OrderLine> getOrderLines() { return orderLines; }
    public void setOrderLines(List<OrderLine> orderLines) { this.orderLines = orderLines; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public BigDecimal getCustomerDiscount() { return customerDiscount; }
    public void setCustomerDiscount(BigDecimal customerDiscount) { this.customerDiscount = customerDiscount; }

    public BigDecimal getVipStandardBonusDiscount() { return vipStandardBonusDiscount; }
    public void setVipStandardBonusDiscount(BigDecimal vipStandardBonusDiscount) { this.vipStandardBonusDiscount = vipStandardBonusDiscount; }

    public BigDecimal getCouponDiscount() { return couponDiscount; }
    public void setCouponDiscount(BigDecimal couponDiscount) { this.couponDiscount = couponDiscount; }

    public BigDecimal getShippingCost() { return shippingCost; }
    public void setShippingCost(BigDecimal shippingCost) { this.shippingCost = shippingCost; }

    public BigDecimal getTaxes() { return taxes; }
    public void setTaxes(BigDecimal taxes) { this.taxes = taxes; }

    public BigDecimal getFinalTotal() { return finalTotal; }
    public void setFinalTotal(BigDecimal finalTotal) { this.finalTotal = finalTotal; }

    public LocalDateTime getCalculatedAt() { return calculatedAt; }
    public void setCalculatedAt(LocalDateTime calculatedAt) { this.calculatedAt = calculatedAt; }

    public String getCalculationDetails() { return calculationDetails; }
    public void setCalculationDetails(String calculationDetails) { this.calculationDetails = calculationDetails; }

    public void addOrderLine(OrderLine orderLine) {
        orderLines.add(orderLine);
        orderLine.setOrderSimulation(this);
    }
}
