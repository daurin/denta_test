import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:denty_cloud_test/constants.dart';
import 'package:denty_cloud_test/modules/appointments/domain/entities/appointment.entity.dart';
import 'package:denty_cloud_test/modules/appointments/infrastructure/datasources/appointments.datasource.dart';
import 'package:denty_cloud_test/services/local_storage/local_storage.service.dart';

class AppointmentsDataSourceImpl implements AppointmentsDataSource {

  Map<String, String> _getAuthHeaders({Map<String, String>? extraHeaders}) {
    final token = localStorageService.getValue<String>('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?extraHeaders,
    };
  }

  final LocalStorageService localStorageService;
  AppointmentsDataSourceImpl({required this.localStorageService});

  @override
  Future<List<AppointmentEntity>> getAll() async {
    final url = Uri.parse('$kBaseApiUrl/api/citas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map(
            (item) => AppointmentEntity.fromMap(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('Error al obtener citas: ${response.statusCode}');
    }
  }

  @override
  Future<List<AppointmentEntity>> getPaginated({
    int page = 1,
    int items = 20,
  }) async {
    final url = Uri.parse('$kBaseApiUrl/api/citas/paginated/$page/$items');
    final response = await http.get(url, headers: _getAuthHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['items'];
      return data
          .map(
            (item) => AppointmentEntity.fromMap(item as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception(
        'Error al obtener citas paginadas: ${response.statusCode}',
      );
    }
  }

  @override
  Future<AppointmentEntity> getById(String id) async {
    final url = Uri.parse('$kBaseApiUrl/api/citas/$id');
    final response = await http.get(url, headers: _getAuthHeaders());

    if (response.statusCode == 200) {
      final bodyDecoded = jsonDecode(response.body);
      final data = bodyDecoded['item'];
      return AppointmentEntity.fromMap(data as Map<String, dynamic>);
    } else {
      throw Exception('Error al obtener cita: ${response.statusCode}');
    }
  }

  @override
  Future<void> add(AppointmentEntity appointment) async {
    final url = Uri.parse('$kBaseApiUrl/api/citas');
    final response = await http.post(
      url,
      headers: _getAuthHeaders(),
      body: jsonEncode(appointment.toMap()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear cita: ${response.statusCode}');
    }
  }

  @override
  Future<void> update(AppointmentEntity appointment) async {
    final url = Uri.parse('$kBaseApiUrl/api/citas');
    final response = await http.put(
      url,
      headers: _getAuthHeaders(),
      body: jsonEncode(appointment.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar cita: ${response.statusCode}');
    }
  }

  @override
  Future<void> delete(String id) async {
    final url = Uri.parse('$kBaseApiUrl/api/citas/$id');
    final response = await http.delete(url, headers: _getAuthHeaders());

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar cita: ${response.statusCode}');
    }
  }
}
