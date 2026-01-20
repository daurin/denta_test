import 'package:denty_cloud_test/modules/appointments/domain/entities/appointment.entity.dart';

class AppointmentDto {
  final int patientId;
  final int employeeId;
  final String startDate;
  final String endDate;
  final int status;

  AppointmentDto({
    required this.patientId,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory AppointmentDto.fromJson(Map<String, dynamic> json) {
    return AppointmentDto(
      patientId: json['pacienteId'] as int,
      employeeId: json['empleadoId'] as int,
      startDate: json['fechaInicio'] as String,
      endDate: json['fechaFin'] as String,
      status: json['estadoCita'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pacienteId': patientId,
      'empleadoId': employeeId,
      'fechaInicio': startDate,
      'fechaFin': endDate,
      'estadoCita': status,
    };
  }

  AppointmentEntity toEntity() {
    return AppointmentEntity(
      patientId: patientId,
      employeeId: employeeId,
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      status: AppointmentStatus.values[status],
    );
  }
}
