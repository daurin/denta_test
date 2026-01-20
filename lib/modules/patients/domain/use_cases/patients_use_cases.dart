import 'package:denty_cloud_test/core/use_cases/use_cases.dart';
import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';
import 'package:denty_cloud_test/modules/patients/domain/repositories/patients.repository.dart';

class GetPaginatedPatientsParams {
  final int page;
  final int items;
  GetPaginatedPatientsParams({this.page = 1, this.items = 20});
}

class GetPaginatedPatientsUseCase
    extends UseCase<List<PatientEntity>, GetPaginatedPatientsParams> {
  final PatientsRepository repository;
  GetPaginatedPatientsUseCase(this.repository);

  @override
  Future<List<PatientEntity>> call(GetPaginatedPatientsParams params) {
    return repository.getPaginated(page: params.page, items: params.items);
  }
}

class GetAllPatientsUseCase extends UseCase<List<PatientEntity>, void> {
  final PatientsRepository repository;
  GetAllPatientsUseCase(this.repository);

  @override
  Future<List<PatientEntity>> call(void params) {
    return repository.getAll();
  }
}

class AddPatientParams {
  final String firstName;
  final String? lastName;
  final DateTime birthDate;
  final String gender;
  AddPatientParams({
    required this.firstName,
    this.lastName,
    required this.birthDate,
    required this.gender,
  });
}

class AddPatientUseCase extends UseCase<void, AddPatientParams> {
  final PatientsRepository repository;
  AddPatientUseCase(this.repository);

  @override
  Future<void> call(AddPatientParams params) {
    final patient = PatientEntity(
      firstName: params.firstName,
      lastName: params.lastName,
      birthDate: params.birthDate,
      gender: params.gender,
    );
    return repository.add(patient);
  }
}

class UpdatePatientParams {
  final int id;
  final String firstName;
  final String? lastName;
  final DateTime birthDate;
  final String gender;
  UpdatePatientParams({
    required this.id,
    required this.firstName,
    this.lastName,
    required this.birthDate,
    required this.gender,
  });
}

class UpdatePatientUseCase extends UseCase<void, UpdatePatientParams> {
  final PatientsRepository repository;
  UpdatePatientUseCase(this.repository);

  @override
  Future<void> call(UpdatePatientParams params) {
    final patient = PatientEntity(
      id: params.id,
      firstName: params.firstName,
      lastName: params.lastName,
      birthDate: params.birthDate,
      gender: params.gender,
    );
    return repository.update(patient);
  }
}

class DeletePatientParams {
  final PatientEntity patient;
  DeletePatientParams(this.patient);
}

class DeletePatientUseCase extends UseCase<void, DeletePatientParams> {
  final PatientsRepository repository;
  DeletePatientUseCase(this.repository);

  @override
  Future<void> call(DeletePatientParams params) {
    return repository.delete(params.patient);
  }
}
