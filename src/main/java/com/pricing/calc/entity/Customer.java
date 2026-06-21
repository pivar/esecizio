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
