import 'package:denty_cloud_test/modules/appointments/domain/entities/appointment.entity.dart';
import 'package:denty_cloud_test/modules/appointments/domain/repositories/appointments.repository.dart';
import 'package:denty_cloud_test/modules/appointments/infrastructure/datasources/appointments.datasource.dart';

class AppointmentsRepositoryImpl implements AppointmentsRepository {
  final AppointmentsDataSource dataSource;

  AppointmentsRepositoryImpl({required this.dataSource});

  @override
  Future<List<AppointmentEntity>> getAll() async {
    return await dataSource.getAll();
  }

  @override
  Future<List<AppointmentEntity>> getPaginated({
    int page = 1,
    int items = 20,
  }) async {
    return await dataSource.getPaginated(page: page, items: items);
  }

  @override
  Future<AppointmentEntity> getById(String id) async {
    return await dataSource.getById(id);
  }

  @override
  Future<void> add(AppointmentEntity appointment) async {
    await dataSource.add(appointment);
  }

  @override
  Future<void> update(AppointmentEntity appointment) async {
    await dataSource.update(appointment);
  }

  @override
  Future<void> delete(String id) async {
    await dataSource.delete(id);
  }
}
