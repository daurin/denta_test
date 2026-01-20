import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';

abstract class PatientsDataSource {
  Future<List<PatientEntity>> getAll();
  Future<List<PatientEntity>> getPaginated({int page = 1, int items = 20});
  Future<void> add(PatientEntity patient);
  Future<void> update(PatientEntity patient);
  Future<void> delete(PatientEntity patient);
}
