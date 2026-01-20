enum AppointmentStatus {
  pending(1),
  confirmed(2),
  cancelled(3),
  completed(4);

  final int value;
  const AppointmentStatus(this.value);

  static AppointmentStatus fromValue(int value) {
    return AppointmentStatus.values.firstWhere((e) => e.value == value);
  }
}

class AppointmentEntity {
  final String? id;
  final int patientId;
  final int employeeId;
  final DateTime startDate;
  final DateTime endDate;
  final AppointmentStatus status;

  AppointmentEntity({
    this.id,
    required this.patientId,
    required this.employeeId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory AppointmentEntity.fromMap(Map<String, dynamic> json) {
    return AppointmentEntity(
      patientId: json['pacienteId'] as int,
      employeeId: json['empleadoId'] as int,
      startDate: DateTime.parse(json['fechaInicio'] as String),
      endDate: DateTime.parse(json['fechaFin'] as String),
      status: AppointmentStatus.fromValue(json['estadoCita'] as int),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'pacienteId': patientId,
      'empleadoId': employeeId,
      'fechaInicio': startDate.toIso8601String(),
      'fechaFin': endDate.toIso8601String(),
      'estadoCita': status.value,
    };
  }
}
