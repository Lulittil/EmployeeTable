<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.example.model.Employees" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Сотрудники</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <link href="css/styles.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <h1 class="text-center">Сотрудники</h1>
        <div class="row mb-3">
            <div class="col-md-6">
                <input type="text" id="searchName" class="form-control" placeholder="Поиск по имени">
            </div>
            <div class="col-md-3">
                <input type="date" id="startDate" class="form-control">
            </div>
            <div class="col-md-3">
                <input type="date" id="endDate" class="form-control">
            </div>
        </div>
        <div class="row mb-3">
            <div class="col-md-12">
                <button class="btn btn-secondary sort-btn" data-id="id">Сортировка по ID</button>
                <button class="btn btn-secondary sort-btn" data-id="name>">Сортировка по имени</button>
                <button class="btn btn-secondary sort-btn" data-id="contractDate">Сортировка по дате</button>
                <button class="btn btn-secondary sort-btn" data-id="salary">Сортировка по зарплате</button>
            </div>
        </div>
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>ФИО</th>
                    <th>Дата договора</th>
                    <th>Зарплата</th>
                    <th>Действия</th>
                </tr>
            </thead>
            <tbody id="employeeTable">
                <%
                    List<Employees> employees = (List<Employees>) request.getAttribute("employees");
                    if (employees != null && !employees.isEmpty()) {
                        for (Employees employee : employees) {
                %>
                    <tr>
                        <td><%= employee.getId() %></td>
                        <td><%= employee.getName() %></td>
                        <td><%= employee.getContractDate() %></td>
                        <td><%= employee.getSalary() %></td>
                        <td>
                            <button class="btn btn-warning btn-sm" data-toggle="modal" data-target="#editEmployeeModal"
                                    data-id="<%= employee.getId() %>"
                                    data-name="<%= employee.getName() %>"
                                    data-contract-date="<%= employee.getContractDate() %>"
                                    data-salary="<%= employee.getSalary() %>">Изменить</button>
                            <button class="btn btn-danger btn-sm delete-btn" data-id="<%= employee.getId() %>">Удалить</button>
                        </td>
                    </tr>
                <%
                        }
                    } else {
                %>
                    <tr>
                        <td colspan="5" class="text-center">Нет сотрудников в таблице</td>
                    </tr>
                <%
                    }
                %>
            </tbody>
        </table>
       <div class="row mt-3">
            <div class="col-md-12 text-center">
                <nav aria-label="Page navigation">
                    <ul class="pagination justify-content-center">
                        <li class="page-item <%= (Integer) request.getAttribute("currentPage") == 0 ? "disabled" : "" %>">
                            <a class="page-link" href="/?page=${currentPage - 1}">Предыдущая</a>
                        </li>
                        <%
                            int totalPages = (Integer) request.getAttribute("totalPages");
                            int currentPage = (Integer) request.getAttribute("currentPage");
                            for (int i = 0; i < totalPages; i++) {
                        %>
                            <li class="page-item <%= i == currentPage ? "active" : "" %>">
                                <a class="page-link" href="/?page=<%= i %>"><%= i + 1 %></a>
                            </li>
                        <% } %>
                        <li class="page-item <%= (Integer) request.getAttribute("currentPage") == totalPages - 1 ? "disabled" : "" %>">
                            <a class="page-link" href="/?page=${currentPage + 1}">Следующая</a>
                        </li>
                    </ul>
                </nav>
            </div>
        </div>
        <button class="btn btn-primary" data-toggle="modal" data-target="#addEmployeeModal">Добавить нового сотрудника</button>
    </div>

    <div class="modal fade" id="addEmployeeModal" tabindex="-1" aria-labelledby="addEmployeeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addEmployeeModalLabel">Добавить сотрудника</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="addEmployeeForm">
                        <div class="form-group">
                            <label for="name">Имя</label>
                            <input type="text" class="form-control" id="name" required>
                        </div>
                        <div class="form-group">
                            <label for="contractDate">Дата договора</label>
                            <input type="date" class="form-control" id="contractDate" required>
                        </div>
                        <div class="form-group">
                            <label for="salary">Зарплата</label>
                            <input type="number" class="form-control" id="salary" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Отмена</button>
                    <button type="button" class="btn btn-primary" id="addEmployeeBtn">Добавить</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="editEmployeeModal" tabindex="-1" aria-labelledby="editEmployeeModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editEmployeeModalLabel">Изменить данные сотрудника</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="editEmployeeForm">
                        <input type="hidden" id="editId">
                        <div class="form-group">
                            <label for="editName">Имя</label>
                            <input type="text" class="form-control" id="editName" required>
                        </div>
                        <div class="form-group">
                            <label for="editContractDate">Дата договора</label>
                            <input type="date" class="form-control" id="editContractDate" required>
                        </div>
                        <div class="form-group">
                            <label for="editSalary">Зарплата</label>
                            <input type="number" class="form-control" id="editSalary" required>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Отмена</button>
                    <button type="button" class="btn btn-primary" id="editEmployeeBtn">Обновить</button>
                </div>
            </div>
        </div>
    </div>

    <div class="modal fade" id="deleteConfirmationModal" tabindex="-1" aria-labelledby="deleteConfirmationModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="deleteConfirmationModalLabel">Confirm Delete</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    Вы уверены, что хотите удалить этого сотрудника?
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Отмена</button>
                    <button type="button" class="btn btn-danger" id="confirmDeleteBtn">Удалить</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
    <script src="js/script.js"></script>
</body>
</html>

