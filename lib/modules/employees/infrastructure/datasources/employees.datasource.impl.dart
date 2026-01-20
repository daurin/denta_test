import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:denty_cloud_test/constants.dart';
import 'package:denty_cloud_test/modules/employees/domain/entities/employee.entity.dart';
import 'package:denty_cloud_test/modules/employees/infrastructure/datasources/employees.datasource.dart';
import 'package:denty_cloud_test/services/local_storage/local_storage.service.dart';

class EmployeesDataSourceImpl implements EmployeesDataSource {
  final LocalStorageService localStorageService;
  EmployeesDataSourceImpl({required this.localStorageService});

  Map<String, String> _getAuthHeaders({Map<String, String>? extraHeaders}) {
    final token = localStorageService.getValue<String>('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      ...?extraHeaders,
    };
  }

  @override
  Future<List<EmployeeEntity>> getAll() async {
    final url = Uri.parse('$kBaseApiUrl/api/empleados');
    final response = await http.get(url, headers: _getAuthHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => EmployeeEntity.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Error al obtener empleados: ${response.statusCode}');
    }
  }

  @override
  Future<List<EmployeeEntity>> getPaginated({
    int page = 1,
    int items = 20,
  }) async {
    final url = Uri.parse('$kBaseApiUrl/api/empleados/paginated/$page/$items');
    final response = await http.get(url, headers: _getAuthHeaders());

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body)['items'];
      return data
          .map((item) => EmployeeEntity.fromMap(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception(
        'Error al obtener empleados paginados: ${response.statusCode}',
      );
    }
  }

  @override
  Future<void> add(EmployeeEntity employee) async {
    final url = Uri.parse('$kBaseApiUrl/api/empleados');
    final response = await http.post(
      url,
      headers: _getAuthHeaders(),
      body: jsonEncode(employee.toMap()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al crear empleado: ${response.statusCode}');
    }
  }

  @override
  Future<void> update(EmployeeEntity employee) async {
    final url = Uri.parse('$kBaseApiUrl/api/empleados');
    final response = await http.put(
      url,
      headers: _getAuthHeaders(),
      body: jsonEncode(employee.toMap()),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar empleado: ${response.statusCode}');
    }
  }

  @override
  Future<void> delete(EmployeeEntity employee) async {
    final url = Uri.parse('$kBaseApiUrl/api/empleados/${employee.id}');
    final response = await http.delete(url, headers: _getAuthHeaders());

    if (response.statusCode != 204) {
      throw Exception('Error al eliminar empleado: ${response.statusCode}');
    }
  }
}
