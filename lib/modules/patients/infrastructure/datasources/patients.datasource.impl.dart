import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:denty_cloud_test/constants.dart';
import 'package:denty_cloud_test/modules/patients/domain/entities/patient.entity.dart';
import 'package:denty_cloud_test/modules/patients/infrastructure/datasources/patients.datasource.dart';
import 'package:denty_cloud_test/services/local_storage/local_storage.service.dart';

class PatientsDataSourceImpl implements PatientsDataSource {
  final LocalStorageService localStorageService;
  PatientsDataSourceImpl({required this.localStorageService});

  /// Obtiene los headers con el token de autenticación si existe
  Map<String, String> _getAuthHeaders({Map<String, String>? extraHeaders}) {
    final token = localStorageService.getValue<String>('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?extraHeaders,
    };
  }

  @override
  Future<List<PatientEntity>> getAll() async {
    final url = Uri.parse('$kBaseApiUrl/api/pacientes');
    final response = await http.get(url, headers: _getAuthHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => PatientEntity.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al obtener pacientes: ${response.statusCode}');
    }
  }

  @override
  Future<List<PatientEntity>> getPaginated({
    int page = 1,
    int items = 20,
  }) async {
    final url = Uri.parse('$kBaseApiUrl/api/pacientes/paginated/$page/$items');
    final response = await http.get(url, headers: _getAuthHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['items'];
      return data
          .map((item) => PatientEntity.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Error al obtener pacientes paginados: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> add(PatientEntity patient) async {
    final url = Uri.parse('$kBaseApiUrl/api/pacientes');
    final response = await http.post(
      url,
      headers: _getAuthHeaders(),
      body: jsonEncode(patient.toMap()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear paciente: ${response.statusCode}');
    }
  }

  @override
  Future<void> update(PatientEntity patient) async {
    final url = Uri.parse('$kBaseApiUrl/api/pacientes');
    final response = await http.put(
      url,
      headers: _getAuthHeaders(),
      body: jsonEncode(patient.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar paciente: ${response.statusCode}');
    }
  }

  @override
  Future<void> delete(PatientEntity patient) async {
    final url = Uri.parse('$kBaseApiUrl/api/pacientes/${patient.id}');
    final response = await http.delete(url, headers: _getAuthHeaders());

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar paciente: ${response.statusCode}');
    }
  }
}
