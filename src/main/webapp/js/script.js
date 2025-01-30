$(document).ready(function() {
    let sortOrder = {};

    // Добавление сотрудника
    $('#addEmployeeBtn').click(function() {
        const name = $('#name').val();
        const contractDate = $('#contractDate').val();
        const salary = $('#salary').val();

        $.post('/add', { name: name, contractDate: contractDate, salary: salary }, function(response) {
            alert(response);
            location.reload();
        });
    });

    // Сортировка таблицы
    $('#editEmployeeModal').on('show.bs.modal', function(event) {
        const button = $(event.relatedTarget);
        const id = button.data('id');
        const name = button.data('name');
        const contractDate = button.data('contract-date');
        const salary = button.data('salary');

        $('#editId').val(id);
        $('#editName').val(name);
        $('#editContractDate').val(contractDate);
        $('#editSalary').val(salary);
    });

    // Редактирование сотрудника
    $('#editEmployeeBtn').click(function() {
        const id = $('#editId').val();
        const name = $('#editName').val();
        const contractDate = $('#editContractDate').val();
        const salary = $('#editSalary').val();

        $.post('/update', { id: id, name: name, contractDate: contractDate, salary: salary }, function(response) {
            alert(response);
            location.reload();
        });
    });

    // Удаление сотрудника
    $(document).on('click', '.delete-btn', function() {
        const id = $(this).data('id');
        if (confirm('Are you sure you want to delete this employee?')) {
            $.post('/delete', { id: id }, function(response) {
                alert(response);
                location.reload();
            });
        }
    });

    // Поиск по имени (без учета регистра)
    $('#searchName').on('input', function() {
        const name = $(this).val();
        $.get('/search', { name: name }, function(data) {
            populateTable(data);
        });
    });

    // Фильтр по дате
    $('#startDate, #endDate').change(function() {
        const startDate = $('#startDate').val();
        const endDate = $('#endDate').val();
        if (startDate && endDate) {
            $.get('/filter', { startDate: startDate, endDate: endDate }, function(data) {
                populateTable(data);
            });
        }
    });

    // Сортировка
    $(document).on('click', '.sort-btn', function() {
        const sortBy = $(this).data('id');
        if (!sortOrder[sortBy]) {
            sortOrder[sortBy] = 'asc';
        } else {
            sortOrder[sortBy] = sortOrder[sortBy] === 'asc' ? 'desc' : 'asc';
        }
        $.get('/sort', { sortBy: sortBy, order: sortOrder[sortBy] }, function(data) {
            populateTable(data);
        });
    });

    // Обновление таблицы
    function populateTable(data) {
        let rows = '';
        data.forEach(employee => {
            rows += `<tr>
                        <td>${employee.id}</td>
                        <td>${employee.name}</td>
                        <td>${employee.contractDate}</td>
                        <td>${employee.salary}</td>
                        <td>
                            <button class="btn btn-warning btn-sm" data-toggle="modal" data-target="#editEmployeeModal"
                                    data-id="${employee.id}"
                                    data-name="${employee.name}"
                                    data-contract-date="${employee.contractDate}"
                                    data-salary="${employee.salary}">Изменить</button>
                            <button class="btn btn-danger btn-sm delete-btn" data-id="${employee.id}">Удалить</button>
                        </td>
                    </tr>`;
        });
        $('#employeeTable').html(rows);
    }

    $(document).on('click', '.page-link', function(event) {
        event.preventDefault();
        const page = $(this).attr('href').split('page=')[1];
        $.get('/', { page: page }, function(data) {
            $('#employeeTable').html($(data).find('#employeeTable').html());
            $('.pagination').html($(data).find('.pagination').html());
        });
    });

});