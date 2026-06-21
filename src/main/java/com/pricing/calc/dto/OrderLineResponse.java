package com.pricing.calc.dto;

import java.math.BigDecimal;

public class OrderLineResponse {
    private String productCode;
    private String category;
    private Integer quantity;
    private BigDecimal unitPrice;
    private BigDecimal lineTotal;
    private BigDecimal discountApplied;
    private BigDecimal discountedPrice;

    public OrderLineResponse() {}

    public OrderLineResponse(String productCode, String category, Integer quantity, BigDecimal unitPrice,
                             BigDecimal lineTotal, BigDecimal discountApplied, BigDecimal discountedPrice) {
        this.productCode = productCode;
        this.category = category;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = lineTotal;
        this.discountApplied = discountApplied;
        this.discountedPrice = discountedPrice;
    }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getLineTotal() { return lineTotal; }
    public void setLineTotal(BigDecimal lineTotal) { this.lineTotal = lineTotal; }

    public BigDecimal getDiscountApplied() { return discountApplied; }
    public void setDiscountApplied(BigDecimal discountApplied) { this.discountApplied = discountApplied; }

    public BigDecimal getDiscountedPrice() { return discountedPrice; }
    public void setDiscountedPrice(BigDecimal discountedPrice) { this.discountedPrice = discountedPrice; }
}
