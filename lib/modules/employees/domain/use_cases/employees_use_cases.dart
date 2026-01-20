import 'package:denty_cloud_test/core/use_cases/use_cases.dart';
import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';
import 'package:denty_cloud_test/modules/employees/domain/repositories/employees.repository.dart';

class GetPaginatedEmployeesParams {
  final int page;
  final int items;
  GetPaginatedEmployeesParams({this.page = 1, this.items = 20});
}

class GetPaginatedEmployeesUseCase
    extends UseCase<List<EmployeeEntity>, GetPaginatedEmployeesParams> {
  final EmployeesRepository repository;
  GetPaginatedEmployeesUseCase(this.repository);

  @override
  Future<List<EmployeeEntity>> call(GetPaginatedEmployeesParams params) {
    return repository.getPaginated(page: params.page, items: params.items);
  }
}

class GetAllEmployeesUseCase extends UseCase<List<EmployeeEntity>, void> {
  final EmployeesRepository repository;
  GetAllEmployeesUseCase(this.repository);

  @override
  Future<List<EmployeeEntity>> call(void params) {
    return repository.getAll();
  }
}

class AddEmployeeParams {
  final String fullName;
  AddEmployeeParams(this.fullName);
}

class AddEmployeeUseCase extends UseCase<void, AddEmployeeParams> {
  final EmployeesRepository repository;
  AddEmployeeUseCase(this.repository);

  @override
  Future<void> call(AddEmployeeParams params) {
    final employee = EmployeeEntity(fullName: params.fullName);
    return repository.add(employee);
  }
}

class UpdateEmployeeParams {
  final int id;
  final String fullName;
  UpdateEmployeeParams({required this.id, required this.fullName});
}

class UpdateEmployeeUseCase extends UseCase<void, UpdateEmployeeParams> {
  final EmployeesRepository repository;
  UpdateEmployeeUseCase(this.repository);

  @override
  Future<void> call(UpdateEmployeeParams params) {
    final employee = EmployeeEntity(id: params.id, fullName: params.fullName);
    return repository.update(employee);
  }
}

class DeleteEmployeeParams {
  final EmployeeEntity employee;
  DeleteEmployeeParams(this.employee);
}

class DeleteEmployeeUseCase extends UseCase<void, DeleteEmployeeParams> {
  final EmployeesRepository repository;
  DeleteEmployeeUseCase(this.repository);

  @override
  Future<void> call(DeleteEmployeeParams params) {
    return repository.delete(params.employee);
  }
}
