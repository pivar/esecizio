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
