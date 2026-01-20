import '../entities/patient.entity.dart';

abstract class PatientsRepository {
  Future<List<PatientEntity>> getAll();
  Future<List<PatientEntity>> getPaginated({int page = 1, int items = 20});
  Future<void> add(PatientEntity patient);
  Future<void> update(PatientEntity patient);
  Future<void> delete(PatientEntity patient);
}
