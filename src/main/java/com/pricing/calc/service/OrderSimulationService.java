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
