package com.pricing.calc.dto;

import java.math.BigDecimal;
import java.util.List;

public class PricingResponse {
    private Long simulationId;
    private BigDecimal subtotal;
    private List<DiscountDetail> discounts;
    private BigDecimal shippingCost;
    private BigDecimal taxes;
    private BigDecimal finalTotal;
    private String calculationDetails;
    private List<OrderLineResponse> orderLines;

    public PricingResponse() {}

    public PricingResponse(Long simulationId, BigDecimal subtotal, List<DiscountDetail> discounts,
                           BigDecimal shippingCost, BigDecimal taxes, BigDecimal finalTotal,
                           String calculationDetails, List<OrderLineResponse> orderLines) {
        this.simulationId = simulationId;
        this.subtotal = subtotal;
        this.discounts = discounts;
        this.shippingCost = shippingCost;
        this.taxes = taxes;
        this.finalTotal = finalTotal;
        this.calculationDetails = calculationDetails;
        this.orderLines = orderLines;
    }

    public Long getSimulationId() { return simulationId; }
    public void setSimulationId(Long simulationId) { this.simulationId = simulationId; }

    public BigDecimal getSubtotal() { return subtotal; }
    public void setSubtotal(BigDecimal subtotal) { this.subtotal = subtotal; }

    public List<DiscountDetail> getDiscounts() { return discounts; }
    public void setDiscounts(List<DiscountDetail> discounts) { this.discounts = discounts; }

    public BigDecimal getShippingCost() { return shippingCost; }
    public void setShippingCost(BigDecimal shippingCost) { this.shippingCost = shippingCost; }

    public BigDecimal getTaxes() { return taxes; }
    public void setTaxes(BigDecimal taxes) { this.taxes = taxes; }

    public BigDecimal getFinalTotal() { return finalTotal; }
    public void setFinalTotal(BigDecimal finalTotal) { this.finalTotal = finalTotal; }

    public String getCalculationDetails() { return calculationDetails; }
    public void setCalculationDetails(String calculationDetails) { this.calculationDetails = calculationDetails; }

    public List<OrderLineResponse> getOrderLines() { return orderLines; }
    public void setOrderLines(List<OrderLineResponse> orderLines) { this.orderLines = orderLines; }
}
