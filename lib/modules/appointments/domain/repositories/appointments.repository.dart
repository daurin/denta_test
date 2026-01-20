import '../entities/appointment.entity.dart';

abstract class AppointmentsRepository {
  Future<List<AppointmentEntity>> getAll();
  Future<List<AppointmentEntity>> getPaginated({int page = 1, int items = 20});
  Future<AppointmentEntity> getById(String id);
  Future<void> add(AppointmentEntity appointment);
  Future<void> update(AppointmentEntity appointment);
  Future<void> delete(String id);
}
