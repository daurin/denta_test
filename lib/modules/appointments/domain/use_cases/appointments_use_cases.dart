import 'package:denty_cloud_test/core/use_cases/use_cases.dart';
import 'package:denty_cloud_test/modules/appointments/domain/entities/appointment.entity.dart';
import 'package:denty_cloud_test/modules/appointments/domain/repositories/appointments.repository.dart';

class GetPaginatedAppointmentsParams {
  final int page;
  final int items;
  GetPaginatedAppointmentsParams({this.page = 1, this.items = 20});
}

class GetPaginatedAppointmentsUseCase
    extends UseCase<List<AppointmentEntity>, GetPaginatedAppointmentsParams> {
  final AppointmentsRepository repository;
  GetPaginatedAppointmentsUseCase(this.repository);

  @override
  Future<List<AppointmentEntity>> call(GetPaginatedAppointmentsParams params) {
    return repository.getPaginated(page: params.page, items: params.items);
  }
}

class GetAllAppointmentsUseCase extends UseCase<List<AppointmentEntity>, void> {
  final AppointmentsRepository repository;
  GetAllAppointmentsUseCase(this.repository);

  @override
  Future<List<AppointmentEntity>> call(void params) {
    return repository.getAll();
  }
}

class GetAppointmentByIdParams {
  final String id;
  GetAppointmentByIdParams(this.id);
}

class GetAppointmentByIdUseCase
    extends UseCase<AppointmentEntity, GetAppointmentByIdParams> {
  final AppointmentsRepository repository;
  GetAppointmentByIdUseCase(this.repository);

  @override
  Future<AppointmentEntity> call(GetAppointmentByIdParams params) {
    return repository.getById(params.id);
  }
}

class AddAppointmentParams {
  final AppointmentEntity appointment;
  AddAppointmentParams(this.appointment);
}

class AddAppointmentUseCase extends UseCase<void, AddAppointmentParams> {
  final AppointmentsRepository repository;
  AddAppointmentUseCase(this.repository);

  @override
  Future<void> call(AddAppointmentParams params) {
    return repository.add(params.appointment);
  }
}

class UpdateAppointmentParams {
  final AppointmentEntity appointment;
  UpdateAppointmentParams(this.appointment);
}

class UpdateAppointmentUseCase extends UseCase<void, UpdateAppointmentParams> {
  final AppointmentsRepository repository;
  UpdateAppointmentUseCase(this.repository);

  @override
  Future<void> call(UpdateAppointmentParams params) {
    return repository.update(params.appointment);
  }
}

class DeleteAppointmentParams {
  final String id;
  DeleteAppointmentParams(this.id);
}

class DeleteAppointmentUseCase extends UseCase<void, DeleteAppointmentParams> {
  final AppointmentsRepository repository;
  DeleteAppointmentUseCase(this.repository);

  @override
  Future<void> call(DeleteAppointmentParams params) {
    return repository.delete(params.id);
  }
}
