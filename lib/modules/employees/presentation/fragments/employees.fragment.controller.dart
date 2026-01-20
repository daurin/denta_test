import 'package:denty_cloud_test/injector.dart';
import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';
import 'package:denty_cloud_test/modules/employees/domain/use_cases/employees_use_cases.dart';
import 'package:denty_cloud_test/modules/employees/presentation/fragments/employees.fragment.dart';
import 'package:denty_cloud_test/modules/employees/presentation/pages/add_employee/add_employee.page.dart';
import 'package:flutter/material.dart';

mixin EmployeesFragmentController on State<EmployeesFragment> {
  final loading = ValueNotifier<bool>(false);
  final error = ValueNotifier<String?>(null);
  final employees = ValueNotifier<List<EmployeeEntity>>([]);

  int currentPage = 1;
  bool hasMore = true;
  static const int itemsPerPage = 20;

  @override
  void initState() {
    super.initState();
    fetchEmployees();
  }

  @override
  void dispose() {
    loading.dispose();
    error.dispose();
    employees.dispose();
    super.dispose();
  }

  Future<void> fetchEmployees() async {
    if (currentPage == 1) {
      loading.value = true;
      error.value = null;
    }

    try {
      final useCase = getIt<GetPaginatedEmployeesUseCase>();
      final result = await useCase(
        GetPaginatedEmployeesParams(page: currentPage, items: itemsPerPage),
      );

      if (mounted) {
        if (currentPage == 1) {
          employees.value = result;
        } else {
          employees.value = [...employees.value, ...result];
        }

        if (result.length < itemsPerPage) {
          hasMore = false;
        } else {
          hasMore = true;
        }
      }
    } catch (e) {
      if (mounted) {
        error.value = e.toString();
      }
    } finally {
      if (mounted) {
        loading.value = false;
      }
    }
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      final metrics = notification.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent - 200) {
        if (hasMore && !loading.value) {
          currentPage++;
          fetchEmployees();
        }
      }
    }
    return false;
  }

  Future<void> onEditEmployeeTap(EmployeeEntity employee) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => AddEmployeePage(employee: employee)),
    );
    if (result == true) {
      currentPage = 1;
      fetchEmployees();
    }
  }

  Future<void> onAddEmployeeTap() async {
    final result = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const AddEmployeePage()));
    if (result == true) {
      currentPage = 1;
      fetchEmployees();
    }
  }
}
