package com.saas.garage.repository;

import com.saas.garage.entity.Car;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.UUID;

public interface CarRepository extends CrudRepository<Car, UUID> {
}
