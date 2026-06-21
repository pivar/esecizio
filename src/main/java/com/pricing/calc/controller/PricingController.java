package com.pricing.calc.controller;

import com.pricing.calc.dto.OrderRequest;
import com.pricing.calc.dto.PricingResponse;
import com.pricing.calc.entity.OrderSimulation;
import com.pricing.calc.service.OrderSimulationService;
import com.pricing.calc.service.PricingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/pricing")
public class PricingController {

    @Autowired
    private PricingService pricingService;

    @Autowired
    private OrderSimulationService orderSimulationService;

    @GetMapping("/sample")
    public ResponseEntity<String> sample(){
    	return ResponseEntity.status(HttpStatus.FAILED_DEPENDENCY).body("Ciao Italia!!!");
    }
    
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
