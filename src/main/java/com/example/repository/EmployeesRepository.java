package com.example.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import com.example.model.Employees;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Date;
import java.util.List;

public interface EmployeesRepository extends JpaRepository<Employees, Integer> {
    Page<Employees> findAll(Pageable pageable);
    List<Employees> findByNameContainingIgnoreCase(String name);
    List<Employees> findByContractDateBetween(Date startDate, Date endDate);
    List<Employees> findAllByOrderByIdAsc();
    List<Employees> findAllByOrderByIdDesc();
    List<Employees> findAllByOrderByNameAsc();
    List<Employees> findAllByOrderByNameDesc();
    List<Employees> findAllByOrderByContractDateAsc();
    List<Employees> findAllByOrderByContractDateDesc();
    List<Employees> findAllByOrderBySalaryAsc();
    List<Employees> findAllByOrderBySalaryDesc();
}