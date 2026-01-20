import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';
import 'package:denty_cloud_test/modules/employees/domain/repositories/employees.repository.dart';
import 'package:denty_cloud_test/modules/employees/infrastructure/datasources/employees.datasource.dart';

class EmployeesRepositoryImpl implements EmployeesRepository {
  final EmployeesDataSource dataSource;
  EmployeesRepositoryImpl({required this.dataSource});

  @override
  Future<List<EmployeeEntity>> getAll() {
    return dataSource.getAll();
  }

  @override
  Future<List<EmployeeEntity>> getPaginated({int page = 1, int items = 20}) {
    return dataSource.getPaginated(page: page, items: items);
  }

  @override
  Future<void> add(EmployeeEntity employee) {
    return dataSource.add(employee);
  }

  @override
  Future<void> update(EmployeeEntity employee) {
    return dataSource.update(employee);
  }

  @override
  Future<void> delete(EmployeeEntity employee) {
    return dataSource.delete(employee);
  }
}
