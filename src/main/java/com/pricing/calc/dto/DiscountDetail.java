package com.pricing.calc.dto;

import java.math.BigDecimal;

public class DiscountDetail {
    private String type;
    private BigDecimal amount;
    private String description;
    private Boolean applied;
    private BigDecimal percentage;

    public DiscountDetail() {}

    public DiscountDetail(String type, BigDecimal amount, String description, Boolean applied, BigDecimal percentage) {
        this.type = type;
        this.amount = amount;
        this.description = description;
        this.applied = applied;
        this.percentage = percentage;
    }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Boolean getApplied() { return applied; }
    public void setApplied(Boolean applied) { this.applied = applied; }

    public BigDecimal getPercentage() { return percentage; }
    public void setPercentage(BigDecimal percentage) { this.percentage = percentage; }
}
