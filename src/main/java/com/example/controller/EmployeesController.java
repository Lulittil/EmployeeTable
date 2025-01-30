package com.example.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

import com.example.model.Employees;
import com.example.repository.EmployeesRepository;

import java.util.List;

@Controller
public class EmployeesController {

    @Autowired
    private EmployeesRepository employeesRepository;

    @GetMapping("/")
    public String index(Model model, @RequestParam(defaultValue = "1") int page) {
        int pageSize = 10;
        Pageable pageable = PageRequest.of(page, pageSize);
        Page<Employees> employeesPage = employeesRepository.findAll(pageable);

        model.addAttribute("employees", employeesPage.getContent());
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", employeesPage.getTotalPages());

        return "index";
    }

    @PostMapping("/add")
    @ResponseBody
    public String addEmployee(@RequestParam String name, @RequestParam String contractDate, @RequestParam double salary) {
        Employees employee = new Employees();
        employee.setName(name);
        employee.setContractDate(java.sql.Date.valueOf(contractDate));
        employee.setSalary(salary);
        employeesRepository.save(employee);
        return "Сотрудник успешно добавлен";
    }

    // Метод обновления сотрудника
    @PostMapping("/update")
    @ResponseBody
    public String updateEmployee(@RequestParam int id, @RequestParam String name, @RequestParam String contractDate, @RequestParam double salary) {
        Employees employee = employeesRepository.findById(id).orElseThrow(() -> new RuntimeException("Employee not found"));
        employee.setName(name);
        employee.setContractDate(java.sql.Date.valueOf(contractDate));
        employee.setSalary(salary);
        employeesRepository.save(employee);
        return "Сотрудник успешно обновлен";
    }

    // Метод удаления
    @PostMapping("/delete")
    @ResponseBody
    public String deleteEmployee(@RequestParam int id) {
        employeesRepository.deleteById(id);
        return "Сотрудник успешно удален";
    }

    // Метод для осуществления поиска
    @GetMapping("/search")
    @ResponseBody
    public List<Employees> searchEmployees(@RequestParam String name) {
        return employeesRepository.findByNameContainingIgnoreCase(name);
    }

    // Фильтрация по дате
    @GetMapping("/filter")
    @ResponseBody
    public List<Employees> filterEmployees(@RequestParam String startDate, @RequestParam String endDate) {
        return employeesRepository.findByContractDateBetween(java.sql.Date.valueOf(startDate), java.sql.Date.valueOf(endDate));
    }

    // Сортировка по столбцам
    @GetMapping("/sort")
    @ResponseBody
    public List<Employees> sortEmployees(@RequestParam String sortBy, @RequestParam String order) {
        switch (sortBy) {
            case "id":
                return order.equals("asc") ? employeesRepository.findAllByOrderByIdAsc() : employeesRepository.findAllByOrderByIdDesc();
            case "name":
                return order.equals("asc") ? employeesRepository.findAllByOrderByNameAsc() : employeesRepository.findAllByOrderByNameDesc();
            case "contractDate":
                return order.equals("asc") ? employeesRepository.findAllByOrderByContractDateAsc() : employeesRepository.findAllByOrderByContractDateDesc();
            case "salary":
                return order.equals("asc") ? employeesRepository.findAllByOrderBySalaryAsc() : employeesRepository.findAllByOrderBySalaryDesc();
            default:
                return employeesRepository.findAll();
        }
    }
}