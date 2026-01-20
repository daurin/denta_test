import 'package:denty_cloud_test/modules/employees/presentation/dialogs/employee_selection_dialog.dart';
import 'package:flutter/material.dart';
import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';
import 'package:denty_cloud_test/modules/employees/domain/use_cases/employees_use_cases.dart';
import 'package:denty_cloud_test/injector.dart';

mixin EmployeeSelectionDialogController on State<EmployeeSelectionDialog> {
  final _employees = ValueNotifier<List<EmployeeEntity>?>(null);
  final _filteredEmployees = ValueNotifier<List<EmployeeEntity>?>([]);
  final _isLoading = ValueNotifier<bool>(false);
  final _searchController = TextEditingController();

  ValueNotifier<List<EmployeeEntity>?> get employees => _employees;
  ValueNotifier<List<EmployeeEntity>?> get filteredEmployees => _filteredEmployees;
  ValueNotifier<bool> get isLoading => _isLoading;
  TextEditingController get searchController => _searchController;

  @override
  void initState() {
    super.initState();
    _loadEmployeeData();
    _searchController.addListener(_filterEmployees);
  }

  Future<void> _loadEmployeeData() async {
    _isLoading.value = true;
    try {
      final useCase = getIt<GetAllEmployeesUseCase>();
      final employeesList = await useCase(null);
      _employees.value = employeesList;
      _filteredEmployees.value = employeesList;
    } catch (e) {
      _employees.value = [];
      _filteredEmployees.value = [];
    } finally {
      _isLoading.value = false;
    }
  }

  void _filterEmployees() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredEmployees.value = _employees.value;
    } else {
      _filteredEmployees.value = _employees.value
          ?.where((employee) => employee.fullName.toLowerCase().contains(query))
          .toList();
    }
  }

  @override
  void dispose() {
    _employees.dispose();
    _filteredEmployees.dispose();
    _isLoading.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
