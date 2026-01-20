class EmployeeEntity {
  final int? id;
  final String fullName;

  EmployeeEntity({this.id, required this.fullName});

  factory EmployeeEntity.fromMap(Map<String, dynamic> json) {
    return EmployeeEntity(
      id: json['id'] as int?,
      fullName: json['nombreCompleto'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {if (id != null) 'id': id, 'nombreCompleto': fullName};
  }
}
