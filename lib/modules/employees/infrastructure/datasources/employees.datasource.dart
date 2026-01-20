import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';

abstract class EmployeesDataSource {
  Future<List<EmployeeEntity>> getAll();
  Future<List<EmployeeEntity>> getPaginated({int page = 1, int items = 20});
  Future<void> add(EmployeeEntity employee);
  Future<void> update(EmployeeEntity employee);
  Future<void> delete(EmployeeEntity employee);
}
