# Pricing Calculator

A RESTful pricing engine built with **Spring Boot** and **Java 17** for e-commerce order simulations.

Calculates discounts (REGULAR/PREMIUM/VIP tiers), coupon application (SAVE10/FLAT200/FREESHIP), shipping costs (IT/EU/extra-EU regions), and blended tax rates for mixed-category orders.


## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| `POST` | `/pricing/calculate` | Calculate price for an order |
| `GET` | `/pricing/{id}` | Retrieve a saved simulation |
| `GET` | `/pricing/simulations` | List all simulations |

See `POST /pricing/calculate` for full pricing logic — send an `OrderRequest` JSON body with customer type, destination, coupons, and product lines.
