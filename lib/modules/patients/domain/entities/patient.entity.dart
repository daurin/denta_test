class PatientEntity {
  final int? id;
  final String firstName;
  final String? lastName;
  final DateTime birthDate;
  final String gender;

  PatientEntity({
    this.id,
    required this.firstName,
    this.lastName,
    required this.birthDate,
    required this.gender,
  });

  factory PatientEntity.fromMap(Map<String, dynamic> json) {
    return PatientEntity(
      id: json['id'] as int?,
      firstName: json['nombres'] as String,
      lastName: json['apellidos'] as String?,
      birthDate: DateTime.parse(json['fechaNacimiento'] as String),
      gender: json['sexo'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nombres': firstName,
      if (lastName != null) 'apellidos': lastName,
      'fechaNacimiento': birthDate.toIso8601String().split('T').first,
      'sexo': gender,
    };
  }

  String get fullName => lastName != null ? '$firstName $lastName' : firstName;
}
