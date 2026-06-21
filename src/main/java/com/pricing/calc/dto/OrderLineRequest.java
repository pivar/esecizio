package com.pricing.calc.dto;

import com.pricing.calc.enums.ProductCategory;
import java.math.BigDecimal;

public class OrderLineRequest {
    private String productCode;
    private ProductCategory category;
    private Integer quantity;
    private BigDecimal unitPrice;

    public OrderLineRequest() {}

    public OrderLineRequest(String productCode, ProductCategory category, Integer quantity, BigDecimal unitPrice) {
        this.productCode = productCode;
        this.category = category;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public ProductCategory getCategory() { return category; }
    public void setCategory(ProductCategory category) { this.category = category; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }
}
