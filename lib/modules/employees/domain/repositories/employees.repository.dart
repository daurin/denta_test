import '../entities/employee.entity.dart';

abstract class EmployeesRepository {
  Future<List<EmployeeEntity>> getAll();
  Future<List<EmployeeEntity>> getPaginated({int page = 1, int items = 20});
  Future<void> add(EmployeeEntity employee);
  Future<void> update(EmployeeEntity employee);
  Future<void> delete(EmployeeEntity employee);
}
