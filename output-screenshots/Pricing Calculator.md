# Pricing Calculator — E‑Commerce Pricing Engine

A RESTful pricing calculator built with **Spring Boot 3.x + Java 17** that simulates e‑commerce price calculations with support for multiple customer tiers, product categories, coupons, shipping regions, and complex discount stacking rules.

This project was developed as a coding exercise demonstrating clean architecture, domain‑driven design patterns, and comprehensive business logic implementation.

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Quick Start](#quick-start)
- [API Endpoints](#api-endpoints)
- [Business Rules](#business-rules)
- [Request / Response Examples](#request--response-examples)
- [Database Schema](#database-schema)
- [Testing](#testing)

---

## Tech Stack

| Layer          | Technology                                          |
|----------------|------------------------------------------------------|
| Language       | Java 17                                              |
| Framework      | Spring Boot 3.x (WebMVC, Data JPA)                   |
| Database       | MySQL 8.0 (via Docker)                               |
| ORM            | Hibernate 6                                          |
| Build Tool     | Maven                                                |
| Container      | Docker & Docker Compose                              |
| Testing        | Spring Boot Test + JUnit 5                           |

---

## Architecture

The project follows a **layered architecture** with clear separation of concerns:

```
Controller  →  Service  →  Repository  →  Database
    │
    └── DTOs (Request / Response)
```

- **Controller** — REST endpoints, request validation, HTTP response handling.
- **Service** — All pricing business logic: discounts, shipping, taxes, coupon application.
- **Repository** — JPA data access layer.
- **Entity** — JPA entities mapped to MySQL tables.
- **DTO** — Immutable-ish request/response objects decoupled from persistence.

All pricing calculations are centralized in `PricingService` with each concern isolated in its own private method (`calculateCustomerDiscount`, `calculateCouponDiscount`, `calculateShippingCost`, `calculateTaxes`, etc.), making the logic easy to test and modify.

---

## Project Structure

```
src/
├── main/java/com/pricing/calc/
│   ├── CalcApplication.java
│   ├── config/
│   ├── controller/
│   │   └── PricingController.java           # REST endpoints
│   ├── dto/
│   │   ├── DiscountDetail.java              # Per-discount breakdown
│   │   ├── OrderLineRequest.java            # Product line in request
│   │   ├── OrderLineResponse.java           # Product line in response
│   │   ├── OrderRequest.java                # POST /calculate payload
│   │   └── PricingResponse.java             # Full calculation result
│   ├── entity/
│   │   ├── Customer.java                    # Seed customer data
│   │   ├── OrderLine.java                   # JPA order line
│   │   ├── OrderSimulation.java             # JPA persisted simulation
│   │   └── Product.java                     # Seed product catalog
│   ├── enums/
│   │   ├── CouponType.java                  # SAVE10, FLAT200, FREESHIP
│   │   ├── CustomerType.java                # REGULAR, PREMIUM, VIP
│   │   ├── ProductCategory.java             # STANDARD, FOOD, LUXURY, DIGITAL
│   │   └── ShippingRegion.java             # ITALY, EUROPE, EXTRA_EUROPE
│   ├── exception/
│   │   ├── PricingException.java            # Custom business exception
│   │   └── GlobalExceptionHandler.java      # @RestControllerAdvice
│   ├── repository/
│   │   ├── CustomerRepository.java
│   │   ├── OrderLineRepository.java
│   │   ├── OrderSimulationRepository.java
│   │   └── ProductRepository.java
│   ├── service/
│   │   ├── OrderSimulationService.java      # CRUD for simulations
│   │   └── PricingService.java             # Core pricing engine
│   └── util/
├── main/resources/
│   ├── application.yml                      # Spring config + DB settings
│   └── data.sql                             # Seed data (products + customers)
└── test/java/com/pricing/calc/
    └── CalcApplicationTests.java            # Context load test
```

---

## Quick Start

### Prerequisites

- Java 17+
- Docker & Docker Compose
- Maven (or use the provided `mvnw` wrapper)

### 1. Start MySQL

```bash
docker compose up -d
```

This starts a MySQL 8.0 container on port `3306` with:
- Database: `ecom_db`
- User: `root`
- Password: *(empty)*

### 2. Run the application

```bash
./mvnw spring-boot:run
```

The application starts on **http://localhost:8080**.

On startup, `data.sql` seeds the database with sample products and customers.

---

## API Endpoints

| Method | Path                           | Description                        |
|--------|--------------------------------|-------------------------------------|
| `POST` | `/pricing/calculate`           | Calculate price for an order        |
| `GET`  | `/pricing/sample`              | Health check / sample endpoint      |
| `GET`  | `/pricing/{id}`                | Retrieve a saved simulation by ID   |
| `GET`  | `/pricing/simulations`         | List all saved simulations          |
| `DELETE`| `/pricing/{id}`               | Delete a simulation                 |

### POST /pricing/calculate

Full request reference is in the [Request / Response Examples](#request--response-examples) section below.

---

## Business Rules

### Customer Discounts

| Customer Type | Discount       | Notes                                         |
|---------------|----------------|-----------------------------------------------|
| `REGULAR`     | 0%             | No discount                                   |
| `PREMIUM`     | 10% off        | Non-LUXURY products only                      |
| `VIP`         | 15% off        | Non-LUXURY products only. **Skipped** if a coupon is also provided (not stackable) |

### VIP Standard Bonus

If a **VIP** customer purchases products spanning **3 or more different categories**, they receive an additional **5% discount** on all STANDARD-category products (on top of their 15% VIP discount).

### Coupons

| Coupon       | Effect                                         | Conditions                         |
|--------------|-------------------------------------------------|-------------------------------------|
| `SAVE10`     | 10% off non-LUXURY products                     | Subtotal ≥ €100, not stackable with VIP |
| `FLAT200`    | €20 flat off (capped at eligible total)         | Subtotal ≥ €100, not stackable with VIP |
| `FREESHIP`   | Free shipping (no amount discount)              | Subtotal ≥ €100, not stackable with VIP |

> **Important:** VIP customers cannot combine their tier discount with a coupon. If a VIP submits a coupon, **both** the VIP discount and the coupon discount are skipped.

### Shipping

| Region        | Base Cost | Free Shipping Threshold |
|---------------|-----------|-------------------------|
| `ITALY`       | €5        | €200 (physical goods)   |
| `EUROPE`      | €10       | €200 (physical goods)   |
| `EXTRA_EUROPE`| €25       | Not available           |

- Expedited shipping adds **+€15** to the base cost.
- DIGITAL products are excluded from shipping eligibility calculations.
- `FREESHIP` coupon overrides all shipping costs to €0.

### Taxes

Rates are **blended** — each product category has its own rate, and the engine computes a weighted average based on the product mix.

| Category  | ITALY | EUROPE | EXTRA_EUROPE |
|-----------|-------|--------|--------------|
| STANDARD  | 22%   | 20%    | 0%           |
| FOOD      | 4%    | 4%     | 0%           |
| LUXURY    | 22%   | 20%    | 0%           |
| DIGITAL   | 30%   | 30%    | 0%           |

### Country → Region Mapping

| Region         | Recognized Countries                                                                 |
|----------------|--------------------------------------------------------------------------------------|
| `ITALY`        | `Italy`, `IT`                                                                        |
| `EUROPE`       | France, Germany, Spain, UK, United Kingdom, Netherlands, Belgium, Sweden, Denmark, Finland, Austria, Switzerland, Portugal, Greece, Ireland |
| `EXTRA_EUROPE` | Everything else                                                                      |

---

## Request / Response Examples

### 1. Basic: REGULAR customer, Italy, single STANDARD product

**Request:**
```json
{
  "customerType": "REGULAR",
  "destinationCountry": "IT",
  "expeditedShipping": false,
  "products": [
    {
      "productCode": "PROD-001",
      "category": "STANDARD",
      "quantity": 2,
      "unitPrice": 49.99
    }
  ]
}
```

**Response:**
```json
{
  "simulationId": 1,
  "subtotal": 99.98,
  "discounts": [
    {
      "type": "CUSTOMER_DISCOUNT",
      "amount": 0.00,
      "percentage": 0,
      "description": "Regular customers get 0% discount",
      "applied": false
    }
  ],
  "shippingCost": 0.00,
  "taxes": 21.99,
  "finalTotal": 121.97,
  "calculationDetails": "Regular customers get 0% discount (€0.00)",
  "orderLines": [...]
}
```

### 2. PREMIUM customer + SAVE10 coupon, Italy, mixed categories

**Request:**
```json
{
  "customerType": "PREMIUM",
  "destinationCountry": "Italy",
  "expeditedShipping": false,
  "coupon": "SAVE10",
  "products": [
    { "productCode": "LAPTOP-001", "category": "STANDARD", "quantity": 2, "unitPrice": 80.00 },
    { "productCode": "WATCH-X9",   "category": "LUXURY",   "quantity": 1, "unitPrice": 300.00 },
    { "productCode": "EBOOK-01",   "category": "DIGITAL",  "quantity": 1, "unitPrice": 50.00 }
  ]
}
```

**Calculated values:**
- Subtotal: €510.00
- PREMIUM 10% discount: –€21.00 (on non-LUXURY: €210 × 0.10)
- SAVE10 coupon: –€21.00 (on non-LUXURY: €210 × 0.10)
- Shipping: €0 (Italy, physical goods subtotal ≥ €200)
- Blended tax rate ≈ 22.78% → taxes ≈ €106.61
- **Final total: ≈ €574.61**

### 3. VIP customer, USA (EXTRA_EUROPE), all DIGITAL products

**Request:**
```json
{
  "customerType": "VIP",
  "destinationCountry": "USA",
  "expeditedShipping": false,
  "products": [
    { "productCode": "EBOOK-PYTHON", "category": "DIGITAL", "quantity": 2, "unitPrice": 29.99 },
    { "productCode": "SOFTWARE-PRO", "category": "DIGITAL", "quantity": 1, "unitPrice": 199.00 },
    { "productCode": "EBOOK-DS",     "category": "DIGITAL", "quantity": 1, "unitPrice": 45.00 },
    { "productCode": "MUSIC-ALBUM",  "category": "DIGITAL", "quantity": 3, "unitPrice": 9.99 }
  ]
}
```

**Calculated values:**
- Subtotal: €328.95
- VIP 15% discount: –€49.34 (all DIGITAL → eligible)
- VIP Standard bonus: **not applied** (only 1 category)
- Shipping: €25.00 (EXTRA_EUROPE base, no free shipping available)
- Taxes: €0 (EXTRA_EUROPE)
- **Final total: €304.61**

### 4. VIP + coupon (neither stacks)

Adding `"coupon": "SAVE10"` to the VIP request above causes **both** discounts to be skipped — result is subtotal + shipping only: **€353.95**.

### 5. FREESHIP coupon with free shipping threshold not met

**Request:**
```json
{
  "customerType": "REGULAR",
  "destinationCountry": "France",
  "expeditedShipping": true,
  "coupon": "FREESHIP",
  "products": [
    { "productCode": "BOOK-001", "category": "STANDARD", "quantity": 1, "unitPrice": 25.00 }
  ]
}
```

**Calculated values:**
- Subtotal: €25.00
- Shipping: €0 (FREESHIP overrides, even though subtotal < €200)
- Taxes: €5.00 (EUROPE, 20%)
- **Final total: €30.00**

---

## Database Schema

The database (`ecom_db`) contains four tables:

| Table                 | Purpose                                    |
|-----------------------|--------------------------------------------|
| `products`            | Seed product catalog                       |
| `customers`           | Seed customer profiles                     |
| `order_simulations`   | Persisted pricing calculations             |
| `order_lines`         | Individual product lines per simulation    |

### Seed Data

**Products** (loaded via `data.sql`):

| Code  | Name              | Category  | Price   |
|-------|-------------------|-----------|---------|
| P001  | Laptop            | STANDARD  | €999.99 |
| P002  | Organic Apples    | FOOD      | €4.99   |
| P003  | Diamond Ring      | LUXURY    | €2999.99|
| P004  | E-Book Reader     | DIGITAL   | €129.99 |
| P005  | Smartphone        | STANDARD  | €799.99 |
| P006  | Wine Collection   | FOOD      | €29.99  |
| P007  | Leather Handbag   | LUXURY    | €499.99 |
| P008  | Software License  | DIGITAL   | €199.99 |

**Customers**:

| Email                         | Name            | Type     | Country |
|-------------------------------|----------------|----------|---------|
| john.doe@email.com            | John Doe       | REGULAR  | ITALY   |
| jane.smith@email.com          | Jane Smith     | PREMIUM  | FRANCE  |
| bob.johnson@email.com         | Bob Johnson    | VIP      | USA     |
| alice.williams@email.com      | Alice Williams | REGULAR  | GERMANY |
| charlie.brown@email.com       | Charlie Brown  | PREMIUM  | UK      |

---

## Testing

Run the full test suite:

```bash
./mvnw test
```

The project includes a Spring Boot context load test in `CalcApplicationTests.java`. More tests can be added using `@WebMvcTest` for controller tests and `@DataJpaTest` for repository tests.

---

## Error Handling

The API returns structured error responses using `@RestControllerAdvice`:

**Validation Error (400):**
```json
{
  "timestamp": "2024-01-01T12:00:00",
  "errorCode": "VALIDATION_ERROR",
  "message": "Customer type is required",
  "details": null
}
```

**Not Found (404) — simulation not found:**
```json
{
  "timestamp": "2024-01-01T12:00:00",
  "errorCode": "SIMULATION_NOT_FOUND",
  "message": "Simulation not found with id: 999",
  "details": null
}
```

**Unexpected Error (500):**
```json
{
  "message": "An unexpected error occurred",
  "details": "<exception message>"
}
```

---

## Design Decisions

- **No Lombok annotations in entities** — getters/setters are explicit (many teams prefer this for JPA entities to avoid surprises with `@Data`).
- **Simulations are persisted** — every calculation is saved to MySQL so results can be retrieved later via `GET /pricing/{id}`.
- **Tax blending** — when an order contains products with different tax rates, the engine computes a weighted average rate rather than applying separate calculations per line. This matches many real-world e-commerce systems.
- **Country-to-region mapping** is handled in code with a simple string match rather than a database lookup — a deliberate choice to keep the exercise focused on the pricing logic.


## Simulations
#####################################

input:
{
  "customerType": "VIP",
  "destinationCountry": "USA",
  "expeditedShipping": false,
  "products": [
    {
      "productCode": "EBOOK-PYTHON",
      "category": "DIGITAL",
      "quantity": 2,
      "unitPrice": 29.99
    },
    {
      "productCode": "SOFTWARE-PRO",
      "category": "DIGITAL",
      "quantity": 1,
      "unitPrice": 199.00
    },
    {
      "productCode": "EBOOK-DS",
      "category": "DIGITAL",
      "quantity": 1,
      "unitPrice": 45.00
    },
    {
      "productCode": "MUSIC-ALBUM",
      "category": "DIGITAL",
      "quantity": 3,
      "unitPrice": 9.99
    }
  ]
}



Output:

{
    "calculationDetails": "VIP customer discount (15%) (€50.09), VIP standard bonus not applied (need 3+ categories, found 1)",
    "discounts": [
        {
            "amount": 50.09,
            "applied": true,
            "description": "VIP customer discount (15%)",
            "percentage": 15.00,
            "type": "CUSTOMER_DISCOUNT"
        },
        {
            "amount": 0,
            "applied": false,
            "description": "VIP standard bonus not applied (need 3+ categories, found 1)",
            "percentage": 0,
            "type": "VIP_STANDARD_BONUS"
        }
    ],
    "finalTotal": 308.86,
    "orderLines": [
        {
            "category": "DIGITAL",
            "discountApplied": null,
            "discountedPrice": null,
            "lineTotal": 59.98,
            "productCode": "EBOOK-PYTHON",
            "quantity": 2,
            "unitPrice": 29.99
        },
        {
            "category": "DIGITAL",
            "discountApplied": null,
            "discountedPrice": null,
            "lineTotal": 199.00,
            "productCode": "SOFTWARE-PRO",
            "quantity": 1,
            "unitPrice": 199.00
        },
        {
            "category": "DIGITAL",
            "discountApplied": null,
            "discountedPrice": null,
            "lineTotal": 45.00,
            "productCode": "EBOOK-DS",
            "quantity": 1,
            "unitPrice": 45.00
        },
        {
            "category": "DIGITAL",
            "discountApplied": null,
            "discountedPrice": null,
            "lineTotal": 29.97,
            "productCode": "MUSIC-ALBUM",
            "quantity": 3,
            "unitPrice": 9.99
        }
    ],
    "shippingCost": 25,
    "simulationId": 4,
    "subtotal": 333.95,
    "taxes": 0
}






SIMULATION #2
Input :

{
  "customerType": "PREMIUM",
  "destinationCountry": "Italy",
  "expeditedShipping": false,
  "coupon": "SAVE10",
  "products": [
    {
      "productCode": "LAPTOP-PRO",
      "category": "STANDARD",
      "quantity": 2,
      "unitPrice": 80.00
    },
    {
      "productCode": "DESIGNER-WATCH",
      "category": "LUXURY",
      "quantity": 1,
      "unitPrice": 300.00
    },
    {
      "productCode": "SOFTWARE-VIDEO",
      "category": "DIGITAL",
      "quantity": 1,
      "unitPrice": 50.00
    }
  ]
}


Output:
{
    "simulationId": 5,
    "subtotal": 510.00,
    "discounts": [
        {
            "type": "CUSTOMER_DISCOUNT",
            "amount": 21.00,
            "description": "PREMIUM customer discount (10%)",
            "applied": true,
            "percentage": 10.00
        },
        {
            "type": "COUPON_DISCOUNT",
            "amount": 21.00,
            "description": "Coupon SAVE10 applied",
            "applied": true,
            "percentage": null
        }
    ],
    "shippingCost": 0,
    "taxes": 106.63,
    "finalTotal": 574.63,
    "calculationDetails": "PREMIUM customer discount (10%) (€21.00), Coupon SAVE10 applied (€21.00)",
    "orderLines": [
        {
            "productCode": "LAPTOP-PRO",
            "category": "STANDARD",
            "quantity": 2,
            "unitPrice": 80.00,
            "lineTotal": 160.00,
            "discountApplied": null,
            "discountedPrice": null
        },
        {
            "productCode": "DESIGNER-WATCH",
            "category": "LUXURY",
            "quantity": 1,
            "unitPrice": 300.00,
            "lineTotal": 300.00,
            "discountApplied": null,
            "discountedPrice": null
        },
        {
            "productCode": "SOFTWARE-VIDEO",
            "category": "DIGITAL",
            "quantity": 1,
            "unitPrice": 50.00,
            "lineTotal": 50.00,
            "discountApplied": null,
            "discountedPrice": null
        }
    ]
}