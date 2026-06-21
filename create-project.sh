#!/bin/bash

echo "Creating Order Pricing Service project without Lombok..."

# Create directory structure
mkdir -p src/main/java/com/pricing/calc/config
mkdir -p src/main/java/com/pricing/calc/controller
mkdir -p src/main/java/com/pricing/calc/dto
mkdir -p src/main/java/com/pricing/calc/entity
mkdir -p src/main/java/com/pricing/calc/enums
mkdir -p src/main/java/com/pricing/calc/exception
mkdir -p src/main/java/com/pricing/calc/repository
mkdir -p src/main/java/com/pricing/calc/service
mkdir -p src/main/java/com/pricing/calc/util
mkdir -p src/main/resources
mkdir -p src/test/java/com/pricing/calc

# Create Application Main Class
cat > src/main/java/com/pricing/calc/CalcApplication.java << 'EOF'
package com.pricing.calc;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class CalcApplication {
    public static void main(String[] args) {
        SpringApplication.run(CalcApplication.class, args);
    }
}
EOF

# Create Enums
cat > src/main/java/com/pricing/calc/enums/CustomerType.java << 'EOF'
package com.pricing.calc.enums;

public enum CustomerType {
    REGULAR,
    PREMIUM,
    VIP
}
EOF

cat > src/main/java/com/pricing/calc/enums/ProductCategory.java << 'EOF'
package com.pricing.calc.enums;

public enum ProductCategory {
    STANDARD,
    FOOD,
    LUXURY,
    DIGITAL
}
EOF

cat > src/main/java/com/pricing/calc/enums/CouponType.java << 'EOF'
package com.pricing.calc.enums;

public enum CouponType {
    SAVE10,
    FLAT200,
    FREESHIP
}
EOF

cat > src/main/java/com/pricing/calc/enums/ShippingRegion.java << 'EOF'
package com.pricing.calc.enums;

public enum ShippingRegion {
    ITALY,
    EUROPE,
    EXTRA_EUROPE
}
EOF

# Create Entities (without Lombok)
cat > src/main/java/com/pricing/calc/entity/OrderSimulation.java << 'EOF'
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
EOF

cat > src/main/java/com/pricing/calc/entity/OrderLine.java << 'EOF'
package com.pricing.calc.entity;

import com.pricing.calc.enums.ProductCategory;
import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "order_lines")
public class OrderLine {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String productCode;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ProductCategory category;

    @Column(nullable = false)
    private Integer quantity;

    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal unitPrice;

    @Column(precision = 19, scale = 2)
    private BigDecimal lineTotal;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "order_simulation_id")
    private OrderSimulation orderSimulation;

    public OrderLine() {}

    public OrderLine(Long id, String productCode, ProductCategory category, Integer quantity,
                     BigDecimal unitPrice, BigDecimal lineTotal, OrderSimulation orderSimulation) {
        this.id = id;
        this.productCode = productCode;
        this.category = category;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
        this.lineTotal = lineTotal;
        this.orderSimulation = orderSimulation;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getProductCode() { return productCode; }
    public void setProductCode(String productCode) { this.productCode = productCode; }

    public ProductCategory getCategory() { return category; }
    public void setCategory(ProductCategory category) { this.category = category; }

    public Integer getQuantity() { return quantity; }
    public void setQuantity(Integer quantity) { this.quantity = quantity; }

    public BigDecimal getUnitPrice() { return unitPrice; }
    public void setUnitPrice(BigDecimal unitPrice) { this.unitPrice = unitPrice; }

    public BigDecimal getLineTotal() { return lineTotal; }
    public void setLineTotal(BigDecimal lineTotal) { this.lineTotal = lineTotal; }

    public OrderSimulation getOrderSimulation() { return orderSimulation; }
    public void setOrderSimulation(OrderSimulation orderSimulation) { this.orderSimulation = orderSimulation; }

    @PrePersist
    @PreUpdate
    private void calculateLineTotal() {
        if (quantity != null && unitPrice != null) {
            this.lineTotal = unitPrice.multiply(BigDecimal.valueOf(quantity));
        }
    }
}
EOF

cat > src/main/java/com/pricing/calc/entity/Product.java << 'EOF'
package com.pricing.calc.entity;

import com.pricing.calc.enums.ProductCategory;
import jakarta.persistence.*;
import java.math.BigDecimal;

@Entity
@Table(name = "products")
public class Product {

    @Id
    @Column(nullable = false, unique = true)
    private String code;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ProductCategory category;

    @Column(nullable = false, precision = 19, scale = 2)
    private BigDecimal price;

    @Column(columnDefinition = "TEXT")
    private String description;

    public Product() {}

    public Product(String code, String name, ProductCategory category, BigDecimal price, String description) {
        this.code = code;
        this.name = name;
        this.category = category;
        this.price = price;
        this.description = description;
    }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public ProductCategory getCategory() { return category; }
    public void setCategory(ProductCategory category) { this.category = category; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
EOF

cat > src/main/java/com/pricing/calc/entity/Customer.java << 'EOF'
package com.pricing.calc.entity;

import com.pricing.calc.enums.CustomerType;
import jakarta.persistence.*;

@Entity
@Table(name = "customers")
public class Customer {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    @Column(nullable = false)
    private String name;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private CustomerType type;

    @Column(nullable = false)
    private String country;

    public Customer() {}

    public Customer(Long id, String email, String name, CustomerType type, String country) {
        this.id = id;
        this.email = email;
        this.name = name;
        this.type = type;
        this.country = country;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public CustomerType getType() { return type; }
    public void setType(CustomerType type) { this.type = type; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }
}
EOF

# Create Repositories
cat > src/main/java/com/pricing/calc/repository/OrderSimulationRepository.java << 'EOF'
package com.pricing.calc.repository;

import com.pricing.calc.entity.OrderSimulation;
import com.pricing.calc.enums.CustomerType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface OrderSimulationRepository extends JpaRepository<OrderSimulation, Long> {
    List<OrderSimulation> findByCustomerType(CustomerType customerType);
    List<OrderSimulation> findByCalculatedAtBetween(LocalDateTime start, LocalDateTime end);
    List<OrderSimulation> findByDestinationCountry(String country);
}
EOF

cat > src/main/java/com/pricing/calc/repository/OrderLineRepository.java << 'EOF'
package com.pricing.calc.repository;

import com.pricing.calc.entity.OrderLine;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface OrderLineRepository extends JpaRepository<OrderLine, Long> {
    List<OrderLine> findByOrderSimulationId(Long orderSimulationId);
}
EOF

cat > src/main/java/com/pricing/calc/repository/ProductRepository.java << 'EOF'
package com.pricing.calc.repository;

import com.pricing.calc.entity.Product;
import com.pricing.calc.enums.ProductCategory;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProductRepository extends JpaRepository<Product, String> {
    List<Product> findByCategory(ProductCategory category);
}
EOF

cat > src/main/java/com/pricing/calc/repository/CustomerRepository.java << 'EOF'
package com.pricing.calc.repository;

import com.pricing.calc.entity.Customer;
import com.pricing.calc.enums.CustomerType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;
import java.util.Optional;

@Repository
public interface CustomerRepository extends JpaRepository<Customer, Long> {
    Optional<Customer> findByEmail(String email);
    List<Customer> findByType(CustomerType type);
}
EOF

# Create DTOs (without Lombok)
cat > src/main/java/com/pricing/calc/dto/OrderRequest.java << 'EOF'
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
EOF

cat > src/main/java/com/pricing/calc/dto/OrderLineRequest.java << 'EOF'
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
EOF

cat > src/main/java/com/pricing/calc/dto/DiscountDetail.java << 'EOF'
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
EOF

cat > src/main/java/com/pricing/calc/dto/OrderLineResponse.java << 'EOF'
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
EOF

cat > src/main/java/com/pricing/calc/dto/PricingResponse.java << 'EOF'
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
EOF

# Create Exceptions
cat > src/main/java/com/pricing/calc/exception/PricingException.java << 'EOF'
package com.pricing.calc.exception;

public class PricingException extends RuntimeException {
    private String errorCode;
    private String details;

    public PricingException(String message) {
        super(message);
        this.errorCode = "PRICING_ERROR";
        this.details = null;
    }

    public PricingException(String message, String errorCode) {
        super(message);
        this.errorCode = errorCode;
        this.details = null;
    }

    public PricingException(String message, String errorCode, String details) {
        super(message);
        this.errorCode = errorCode;
        this.details = details;
    }

    public String getErrorCode() { return errorCode; }
    public void setErrorCode(String errorCode) { this.errorCode = errorCode; }

    public String getDetails() { return details; }
    public void setDetails(String details) { this.details = details; }
}
EOF

cat > src/main/java/com/pricing/calc/exception/GlobalExceptionHandler.java << 'EOF'
package com.pricing.calc.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(PricingException.class)
    public ResponseEntity<Map<String, Object>> handlePricingException(PricingException ex) {
        Map<String, Object> body = new HashMap<>();
        body.put("timestamp", LocalDateTime.now());
        body.put("errorCode", ex.getErrorCode());
        body.put("message", ex.getMessage());
        body.put("details", ex.getDetails());
        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(body);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<Map<String, String>> handleGenericException(Exception ex) {
        Map<String, String> error = new HashMap<>();
        error.put("message", "An unexpected error occurred");
        error.put("details", ex.getMessage());
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
EOF

# Create Services (without Lombok)
cat > src/main/java/com/pricing/calc/service/OrderSimulationService.java << 'EOF'
package com.pricing.calc.service;

import com.pricing.calc.entity.OrderSimulation;
import com.pricing.calc.exception.PricingException;
import com.pricing.calc.repository.OrderSimulationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class OrderSimulationService {

    @Autowired
    private OrderSimulationRepository orderSimulationRepository;

    @Transactional
    public OrderSimulation saveSimulation(OrderSimulation simulation) {
        return orderSimulationRepository.save(simulation);
    }

    @Transactional(readOnly = true)
    public OrderSimulation getSimulation(Long id) {
        return orderSimulationRepository.findById(id)
                .orElseThrow(() -> new PricingException(
                        "Simulation not found with id: " + id,
                        "SIMULATION_NOT_FOUND"
                ));
    }

    @Transactional(readOnly = true)
    public List<OrderSimulation> getAllSimulations() {
        return orderSimulationRepository.findAll();
    }

    @Transactional
    public void deleteSimulation(Long id) {
        if (!orderSimulationRepository.existsById(id)) {
            throw new PricingException("Simulation not found with id: " + id, "SIMULATION_NOT_FOUND");
        }
        orderSimulationRepository.deleteById(id);
    }
}
EOF

cat > src/main/java/com/pricing/calc/service/PricingService.java << 'EOF'
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
EOF

# Create Controller
cat > src/main/java/com/pricing/calc/controller/PricingController.java << 'EOF'
package com.pricing.calc.controller;

import com.pricing.calc.dto.OrderRequest;
import com.pricing.calc.dto.PricingResponse;
import com.pricing.calc.entity.OrderSimulation;
import com.pricing.calc.service.OrderSimulationService;
import com.pricing.calc.service.PricingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/api/pricing")
public class PricingController {

    @Autowired
    private PricingService pricingService;

    @Autowired
    private OrderSimulationService orderSimulationService;

    @PostMapping("/calculate")
    public ResponseEntity<PricingResponse> calculatePrice(@RequestBody OrderRequest request) {
        PricingResponse response = pricingService.calculatePrice(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/{id}")
    public ResponseEntity<PricingResponse> getSimulation(@PathVariable Long id) {
        OrderSimulation simulation = orderSimulationService.getSimulation(id);
        PricingResponse response = new PricingResponse();
        response.setSimulationId(simulation.getId());
        response.setSubtotal(simulation.getSubtotal());
        response.setShippingCost(simulation.getShippingCost());
        response.setTaxes(simulation.getTaxes());
        response.setFinalTotal(simulation.getFinalTotal());
        response.setCalculationDetails(simulation.getCalculationDetails());
        return ResponseEntity.ok(response);
    }

    @GetMapping("/simulations")
    public ResponseEntity<List<OrderSimulation>> getAllSimulations() {
        return ResponseEntity.ok(orderSimulationService.getAllSimulations());
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSimulation(@PathVariable Long id) {
        orderSimulationService.deleteSimulation(id);
        return ResponseEntity.noContent().build();
    }
}
EOF

# Create application.yml
cat > src/main/resources/application.yml << 'EOF'
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/ecom_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
    driver-class-name: com.mysql.cj.jdbc.Driver
    username: root
    password: your_password
  jpa:
    hibernate:
      ddl-auto: create-drop
    show-sql: true
    properties:
      hibernate:
        format_sql: true
        dialect: org.hibernate.dialect.MySQL8Dialect
  sql:
    init:
      mode: always

server:
  port: 8080

logging:
  level:
    org.springframework: INFO
    org.hibernate: INFO
EOF

# Create data.sql
cat > src/main/resources/data.sql << 'EOF'
INSERT IGNORE INTO products (code, name, category, price, description) VALUES 
('P001', 'Laptop', 'STANDARD', 999.99, 'High-performance laptop with 16GB RAM'),
('P002', 'Organic Apples', 'FOOD', 4.99, 'Fresh organic apples - 1kg'),
('P003', 'Diamond Ring', 'LUXURY', 2999.99, '24K diamond ring with sapphire'),
('P004', 'E-Book Reader', 'DIGITAL', 129.99, 'Digital e-book reader'),
('P005', 'Smartphone', 'STANDARD', 799.99, 'Latest 5G smartphone'),
('P006', 'Wine Collection', 'FOOD', 29.99, 'Premium wine bottle collection'),
('P007', 'Leather Handbag', 'LUXURY', 499.99, 'Designer leather handbag'),
('P008', 'Software License', 'DIGITAL', 199.99, 'Annual software license');

INSERT IGNORE INTO customers (email, name, type, country) VALUES
('john.doe@email.com', 'John Doe', 'REGULAR', 'ITALY'),
('jane.smith@email.com', 'Jane Smith', 'PREMIUM', 'FRANCE'),
('bob.johnson@email.com', 'Bob Johnson', 'VIP', 'USA'),
('alice.williams@email.com', 'Alice Williams', 'REGULAR', 'GERMANY'),
('charlie.brown@email.com', 'Charlie Brown', 'PREMIUM', 'UK');
EOF
