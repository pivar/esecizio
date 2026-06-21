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
