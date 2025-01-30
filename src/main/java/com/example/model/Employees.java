package com.example.model;

import jakarta.persistence.*;
import java.sql.Date;
import java.time.LocalDate;

@Entity
public class Employees {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    // ID сотрудника (первичный ключ)
    private int id;
    // Имя сотрудника
    private String name;
    //Дата заключения договора
    private Date contractDate;
    // Зарплата
    private double salary;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public Date getContractDate() { return contractDate; }
    public void setContractDate(Date contractDate) { this.contractDate = contractDate; }
    public double getSalary() { return salary; }
    public void setSalary(double salary) { this.salary = salary; }
}