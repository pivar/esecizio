package com.pricing.calc.service;

import com.pricing.calc.dto.*;
import com.pricing.calc.entity.OrderLine;
import com.pricing.calc.entity.OrderSimulation;
import com.pricing.calc.enums.*;
import com.pricing.calc.exception.PricingException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class PricingService {

    @Autowired
    private OrderSimulationService orderSimulationService;

    private static final BigDecimal MINIMUM_ORDER_FOR_COUPON = new BigDecimal("100");
    private static final BigDecimal FREE_SHIPPING_THRESHOLD = new BigDecimal("200");

    @Transactional
    public PricingResponse calculatePrice(OrderRequest request) {
        validateRequest(request);

        BigDecimal subtotal = calculateSubtotal(request.getProducts());
        List<DiscountDetail> discounts = new ArrayList<>();
        
        BigDecimal customerDiscountAmount = calculateCustomerDiscount(request, discounts);
        BigDecimal vipBonusDiscount = calculateVipStandardBonus(request, discounts);
        BigDecimal couponDiscountAmount = calculateCouponDiscount(request, subtotal, discounts);
        BigDecimal shippingCost = calculateShippingCost(request, subtotal);
        
        BigDecimal taxableAmount = subtotal.subtract(customerDiscountAmount)
                .subtract(couponDiscountAmount).subtract(vipBonusDiscount);
        BigDecimal taxes = calculateTaxes(request, taxableAmount);
        
        BigDecimal finalTotal = subtotal.subtract(customerDiscountAmount)
                .subtract(vipBonusDiscount).subtract(couponDiscountAmount)
                .add(shippingCost).add(taxes);
        
        if (finalTotal.compareTo(BigDecimal.ZERO) < 0) {
            finalTotal = BigDecimal.ZERO;
        }

        OrderSimulation simulation = buildOrderSimulation(request, subtotal, customerDiscountAmount,
                vipBonusDiscount, couponDiscountAmount, shippingCost, taxes, finalTotal, discounts);

        simulation = orderSimulationService.saveSimulation(simulation);
        return buildResponse(simulation, discounts);
    }

    private void validateRequest(OrderRequest request) {
        if (request.getCustomerType() == null) {
            throw new PricingException("Customer type is required", "VALIDATION_ERROR");
        }
        if (request.getDestinationCountry() == null || request.getDestinationCountry().trim().isEmpty()) {
            throw new PricingException("Destination country is required", "VALIDATION_ERROR");
        }
        if (request.getProducts() == null || request.getProducts().isEmpty()) {
            throw new PricingException("Order must contain at least one product", "VALIDATION_ERROR");
        }
        if (request.getExpeditedShipping() == null) {
            request.setExpeditedShipping(false);
        }
    }

    private BigDecimal calculateSubtotal(List<OrderLineRequest> products) {
        BigDecimal subtotal = BigDecimal.ZERO;
        for (OrderLineRequest product : products) {
            BigDecimal lineTotal = product.getUnitPrice().multiply(BigDecimal.valueOf(product.getQuantity()));
            subtotal = subtotal.add(lineTotal);
        }
        return subtotal;
    }

    private BigDecimal calculateCustomerDiscount(OrderRequest request, List<DiscountDetail> discounts) {
        if (request.getCustomerType() == CustomerType.REGULAR) {
            DiscountDetail detail = new DiscountDetail();
            detail.setType("CUSTOMER_DISCOUNT");
            detail.setAmount(BigDecimal.ZERO);
            detail.setPercentage(BigDecimal.ZERO);
            detail.setDescription("Regular customers get 0% discount");
            detail.setApplied(false);
            discounts.add(detail);
            return BigDecimal.ZERO;
        }

        if (request.getCustomerType() == CustomerType.VIP && request.getCoupon() != null) {
            DiscountDetail detail = new DiscountDetail();
            detail.setType("CUSTOMER_DISCOUNT");
            detail.setAmount(BigDecimal.ZERO);
            detail.setPercentage(BigDecimal.ZERO);
            detail.setDescription("VIP discount skipped due to coupon usage (not stackable)");
            detail.setApplied(false);
            discounts.add(detail);
            return BigDecimal.ZERO;
        }

        BigDecimal discountRate;
        if (request.getCustomerType() == CustomerType.PREMIUM) {
            discountRate = new BigDecimal("0.10");
        } else if (request.getCustomerType() == CustomerType.VIP) {
            discountRate = new BigDecimal("0.15");
        } else {
            discountRate = BigDecimal.ZERO;
        }

        BigDecimal eligibleTotal = calculateEligibleTotal(request.getProducts());
        BigDecimal discountAmount = eligibleTotal.multiply(discountRate).setScale(2, RoundingMode.HALF_UP);

        DiscountDetail detail = new DiscountDetail();
        detail.setType("CUSTOMER_DISCOUNT");
        detail.setAmount(discountAmount);
        detail.setPercentage(discountRate.multiply(new BigDecimal("100")));
        detail.setDescription(request.getCustomerType() + " customer discount (" + 
                discountRate.multiply(new BigDecimal("100")).intValue() + "%)");
        detail.setApplied(discountAmount.compareTo(BigDecimal.ZERO) > 0);
        discounts.add(detail);

        return discountAmount;
    }

    private BigDecimal calculateEligibleTotal(List<OrderLineRequest> products) {
        BigDecimal total = BigDecimal.ZERO;
        for (OrderLineRequest product : products) {
            if (product.getCategory() != ProductCategory.LUXURY) {
                BigDecimal lineTotal = product.getUnitPrice().multiply(BigDecimal.valueOf(product.getQuantity()));
                total = total.add(lineTotal);
            }
        }
        return total;
    }

    private BigDecimal calculateVipStandardBonus(OrderRequest request, List<DiscountDetail> discounts) {
        if (request.getCustomerType() != CustomerType.VIP) {
            return BigDecimal.ZERO;
        }

        Set<ProductCategory> categories = new HashSet<>();
        for (OrderLineRequest product : request.getProducts()) {
            categories.add(product.getCategory());
        }

        if (categories.size() < 3) {
            DiscountDetail detail = new DiscountDetail();
            detail.setType("VIP_STANDARD_BONUS");
            detail.setAmount(BigDecimal.ZERO);
            detail.setPercentage(BigDecimal.ZERO);
            detail.setDescription("VIP standard bonus not applied (need 3+ categories, found " + categories.size() + ")");
            detail.setApplied(false);
            discounts.add(detail);
            return BigDecimal.ZERO;
        }

        BigDecimal standardTotal = BigDecimal.ZERO;
        for (OrderLineRequest product : request.getProducts()) {
            if (product.getCategory() == ProductCategory.STANDARD) {
                BigDecimal lineTotal = product.getUnitPrice().multiply(BigDecimal.valueOf(product.getQuantity()));
                standardTotal = standardTotal.add(lineTotal);
            }
        }

        BigDecimal bonusAmount = standardTotal.multiply(new BigDecimal("0.05"))
                .setScale(2, RoundingMode.HALF_UP);

        DiscountDetail detail = new DiscountDetail();
        detail.setType("VIP_STANDARD_BONUS");
        detail.setAmount(bonusAmount);
        detail.setPercentage(new BigDecimal("5"));
        detail.setDescription("VIP additional 5% discount on STANDARD products (3+ categories)");
        detail.setApplied(bonusAmount.compareTo(BigDecimal.ZERO) > 0);
        discounts.add(detail);

        return bonusAmount;
    }

    private BigDecimal calculateCouponDiscount(OrderRequest request, BigDecimal subtotal, 
                                               List<DiscountDetail> discounts) {
        if (request.getCoupon() == null) {
            return BigDecimal.ZERO;
        }

        if (subtotal.compareTo(MINIMUM_ORDER_FOR_COUPON) < 0) {
            DiscountDetail detail = new DiscountDetail();
            detail.setType("COUPON_DISCOUNT");
            detail.setAmount(BigDecimal.ZERO);
            detail.setDescription("Coupon not applied (subtotal €" + subtotal + " < €" + 
                    MINIMUM_ORDER_FOR_COUPON + ")");
            detail.setApplied(false);
            discounts.add(detail);
            return BigDecimal.ZERO;
        }

        if (request.getCustomerType() == CustomerType.VIP) {
            DiscountDetail detail = new DiscountDetail();
            detail.setType("COUPON_DISCOUNT");
            detail.setAmount(BigDecimal.ZERO);
            detail.setDescription("Coupon not applied (not stackable with VIP discount)");
            detail.setApplied(false);
            discounts.add(detail);
            return BigDecimal.ZERO;
        }

        BigDecimal eligibleAmount = calculateEligibleTotal(request.getProducts());
        BigDecimal discountAmount;

        if (request.getCoupon() == CouponType.SAVE10) {
            discountAmount = eligibleAmount.multiply(new BigDecimal("0.10")).setScale(2, RoundingMode.HALF_UP);
        } else if (request.getCoupon() == CouponType.FLAT200) {
            discountAmount = new BigDecimal("20");
            if (discountAmount.compareTo(eligibleAmount) > 0) {
                discountAmount = eligibleAmount;
            }
        } else {
            discountAmount = BigDecimal.ZERO;
        }

        if (discountAmount.compareTo(BigDecimal.ZERO) > 0) {
            DiscountDetail detail = new DiscountDetail();
            detail.setType("COUPON_DISCOUNT");
            detail.setAmount(discountAmount);
            detail.setDescription("Coupon " + request.getCoupon() + " applied");
            detail.setApplied(true);
            discounts.add(detail);
        } else {
            DiscountDetail detail = new DiscountDetail();
            detail.setType("COUPON_DISCOUNT");
            detail.setAmount(BigDecimal.ZERO);
            detail.setDescription("Coupon " + request.getCoupon() + " resulted in 0 discount");
            detail.setApplied(false);
            discounts.add(detail);
        }

        return discountAmount;
    }

    private BigDecimal calculateShippingCost(OrderRequest request, BigDecimal subtotal) {
        if (request.getCoupon() == CouponType.FREESHIP) {
            return BigDecimal.ZERO;
        }

        ShippingRegion region = getShippingRegion(request.getDestinationCountry());
        BigDecimal baseCost;

        if (region == ShippingRegion.ITALY) {
            baseCost = new BigDecimal("5");
        } else if (region == ShippingRegion.EUROPE) {
            baseCost = new BigDecimal("10");
        } else {
            baseCost = new BigDecimal("25");
        }

        BigDecimal shippingEligibleTotal = BigDecimal.ZERO;
        for (OrderLineRequest product : request.getProducts()) {
            if (product.getCategory() != ProductCategory.DIGITAL) {
                BigDecimal lineTotal = product.getUnitPrice().multiply(BigDecimal.valueOf(product.getQuantity()));
                shippingEligibleTotal = shippingEligibleTotal.add(lineTotal);
            }
        }

        if (region != ShippingRegion.EXTRA_EUROPE && 
            shippingEligibleTotal.compareTo(FREE_SHIPPING_THRESHOLD) >= 0) {
            return BigDecimal.ZERO;
        }

        if (Boolean.TRUE.equals(request.getExpeditedShipping())) {
            baseCost = baseCost.add(new BigDecimal("15"));
        }

        return baseCost;
    }

    private BigDecimal calculateTaxes(OrderRequest request, BigDecimal taxableAmount) {
        ShippingRegion region = getShippingRegion(request.getDestinationCountry());
        
        if (region == ShippingRegion.EXTRA_EUROPE) {
            return BigDecimal.ZERO;
        }

        BigDecimal totalEligible = BigDecimal.ZERO;
        for (OrderLineRequest product : request.getProducts()) {
            BigDecimal lineTotal = product.getUnitPrice().multiply(BigDecimal.valueOf(product.getQuantity()));
            totalEligible = totalEligible.add(lineTotal);
        }

        if (totalEligible.compareTo(BigDecimal.ZERO) == 0) {
            return BigDecimal.ZERO;
        }

        BigDecimal taxRate = BigDecimal.ZERO;
        for (OrderLineRequest product : request.getProducts()) {
            BigDecimal productTotal = product.getUnitPrice().multiply(BigDecimal.valueOf(product.getQuantity()));
            BigDecimal rate = getTaxRate(product.getCategory(), region);
            taxRate = taxRate.add(productTotal.multiply(rate));
        }
        taxRate = taxRate.divide(totalEligible, 10, RoundingMode.HALF_UP);

        return taxableAmount.multiply(taxRate).setScale(2, RoundingMode.HALF_UP);
    }

    private BigDecimal getTaxRate(ProductCategory category, ShippingRegion region) {
        if (region == ShippingRegion.ITALY) {
            if (category == ProductCategory.STANDARD) return new BigDecimal("0.22");
            if (category == ProductCategory.FOOD) return new BigDecimal("0.04");
            if (category == ProductCategory.DIGITAL) return new BigDecimal("0.30");
            if (category == ProductCategory.LUXURY) return new BigDecimal("0.22");
        } else if (region == ShippingRegion.EUROPE) {
            if (category == ProductCategory.STANDARD) return new BigDecimal("0.20");
            if (category == ProductCategory.FOOD) return new BigDecimal("0.04");
            if (category == ProductCategory.DIGITAL) return new BigDecimal("0.30");
            if (category == ProductCategory.LUXURY) return new BigDecimal("0.20");
        }
        return BigDecimal.ZERO;
    }

    private ShippingRegion getShippingRegion(String country) {
        String normalizedCountry = country.trim().toUpperCase();
        if (normalizedCountry.equals("ITALY") || normalizedCountry.equals("IT")) {
            return ShippingRegion.ITALY;
        }
        if (normalizedCountry.equals("FRANCE") || normalizedCountry.equals("GERMANY") ||
            normalizedCountry.equals("SPAIN") || normalizedCountry.equals("UK") ||
            normalizedCountry.equals("UNITED KINGDOM") || normalizedCountry.equals("NETHERLANDS") ||
            normalizedCountry.equals("BELGIUM") || normalizedCountry.equals("SWEDEN") ||
            normalizedCountry.equals("DENMARK") || normalizedCountry.equals("FINLAND") ||
            normalizedCountry.equals("AUSTRIA") || normalizedCountry.equals("SWITZERLAND") ||
            normalizedCountry.equals("PORTUGAL") || normalizedCountry.equals("GREECE") ||
            normalizedCountry.equals("IRELAND")) {
            return ShippingRegion.EUROPE;
        }
        return ShippingRegion.EXTRA_EUROPE;
    }

    private OrderSimulation buildOrderSimulation(OrderRequest request, BigDecimal subtotal,
                                                BigDecimal customerDiscount, BigDecimal vipBonus,
                                                BigDecimal couponDiscount, BigDecimal shippingCost,
                                                BigDecimal taxes, BigDecimal finalTotal,
                                                List<DiscountDetail> discounts) {
        OrderSimulation simulation = new OrderSimulation();
        simulation.setCustomerType(request.getCustomerType());
        simulation.setDestinationCountry(request.getDestinationCountry());
        simulation.setShippingRegion(getShippingRegion(request.getDestinationCountry()).toString());
        simulation.setExpeditedShipping(request.getExpeditedShipping());
        simulation.setCoupon(request.getCoupon());
        simulation.setSubtotal(subtotal);
        simulation.setCustomerDiscount(customerDiscount);
        simulation.setVipStandardBonusDiscount(vipBonus);
        simulation.setCouponDiscount(couponDiscount);
        simulation.setShippingCost(shippingCost);
        simulation.setTaxes(taxes);
        simulation.setFinalTotal(finalTotal);
        simulation.setCalculatedAt(LocalDateTime.now());
        simulation.setCalculationDetails(buildCalculationDetails(discounts));

        for (OrderLineRequest productRequest : request.getProducts()) {
            OrderLine orderLine = new OrderLine();
            orderLine.setProductCode(productRequest.getProductCode());
            orderLine.setCategory(productRequest.getCategory());
            orderLine.setQuantity(productRequest.getQuantity());
            orderLine.setUnitPrice(productRequest.getUnitPrice());
            simulation.addOrderLine(orderLine);
        }

        return simulation;
    }

    private String buildCalculationDetails(List<DiscountDetail> discounts) {
        StringBuilder details = new StringBuilder();
        for (int i = 0; i < discounts.size(); i++) {
            DiscountDetail d = discounts.get(i);
            if (i > 0) {
                details.append(", ");
            }
            details.append(d.getDescription());
            if (d.getApplied() != null && d.getApplied()) {
                details.append(" (€").append(d.getAmount()).append(")");
            }
        }
        return details.toString();
    }

    private PricingResponse buildResponse(OrderSimulation simulation, List<DiscountDetail> discounts) {
        List<OrderLineResponse> orderLineResponses = new ArrayList<>();
        for (OrderLine line : simulation.getOrderLines()) {
            OrderLineResponse response = new OrderLineResponse();
            response.setProductCode(line.getProductCode());
            response.setCategory(line.getCategory().toString());
            response.setQuantity(line.getQuantity());
            response.setUnitPrice(line.getUnitPrice());
            response.setLineTotal(line.getLineTotal());
            orderLineResponses.add(response);
        }

        PricingResponse response = new PricingResponse();
        response.setSimulationId(simulation.getId());
        response.setSubtotal(simulation.getSubtotal());
        response.setDiscounts(discounts);
        response.setShippingCost(simulation.getShippingCost());
        response.setTaxes(simulation.getTaxes());
        response.setFinalTotal(simulation.getFinalTotal());
        response.setCalculationDetails(simulation.getCalculationDetails());
        response.setOrderLines(orderLineResponses);
        return response;
    }
}
