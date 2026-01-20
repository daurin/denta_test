import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';
import 'package:denty_cloud_test/modules/patients/domain/repositories/patients.repository.dart';
import 'package:denty_cloud_test/modules/patients/infrastructure/datasources/patients.datasource.dart';

class PatientsRepositoryImpl implements PatientsRepository {
  final PatientsDataSource dataSource;
  PatientsRepositoryImpl({required this.dataSource});

  @override
  Future<List<PatientEntity>> getAll() {
    return dataSource.getAll();
  }

  @override
  Future<List<PatientEntity>> getPaginated({int page = 1, int items = 20}) {
    return dataSource.getPaginated(page: page, items: items);
  }

  @override
  Future<void> add(PatientEntity patient) {
    return dataSource.add(patient);
  }

  @override
  Future<void> update(PatientEntity patient) {
    return dataSource.update(patient);
  }

  @override
  Future<void> delete(PatientEntity patient) {
    return dataSource.delete(patient);
  }
}
