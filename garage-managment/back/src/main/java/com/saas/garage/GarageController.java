package com.saas.garage;

import com.saas.garage.entity.Car;
import com.saas.garage.repository.CarRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@RestController
public class GarageController {
    private final CarRepository carRepository;

    public GarageController(CarRepository carRepository) {
        this.carRepository = carRepository;
    }
    @GetMapping(value = "/car")
    @CrossOrigin
    public ResponseEntity<List<Car>> getAllCar() {
        ArrayList<Car> cars = new ArrayList<>();
        carRepository.findAll().forEach(cars::add);
        return ResponseEntity.ok(cars);
    }

    @PostMapping(value = "/car")
    @CrossOrigin
    public ResponseEntity<Car> createCar(@RequestBody Car car) {
        car.setId(UUID.randomUUID());
        return ResponseEntity.ok(carRepository.save(car));
    }

    @DeleteMapping(value = "/car/{id}")
    @CrossOrigin
    public ResponseEntity<?> deleteCar(@PathVariable("id") UUID id) {
        carRepository.deleteById(id);
        return ResponseEntity.noContent().build();
    }

    @PutMapping(value = "/car/{id}")
    @CrossOrigin
    public ResponseEntity<?> updateCar(@PathVariable("id") UUID id, @RequestBody Car car) {
        Car existingCar = carRepository.findById(id).orElseThrow();
        existingCar.setId(id);
        carRepository.save(existingCar);
        return ResponseEntity.noContent().build();
    }
}
