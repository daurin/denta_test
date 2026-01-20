import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:denty_cloud_test/constants.dart';
import 'package:denty_cloud_test/modules/auth/infrastructure/datasources/auth.datasource.dart';

class AuthDataSourceImpl implements AuthDataSource {
  AuthDataSourceImpl();

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$kBaseApiUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['token'];
    } else {
      throw Exception('Error en el login: ${response.statusCode}');
    }
  }

  @override
  Future<bool> validateToken(String token) async {
    try {
      if (token.isEmpty) {
        return false;
      }

      // Decodificar JWT
      final parts = token.split('.');
      if (parts.length != 3) {
        return false; // Token inválido
      }

      // Decodificar JWT con padding
      String normalizeBase64(String str) {
        return str + List.filled((4 - str.length % 4) % 4, '=').join();
      }

      final payload = jsonDecode(
        utf8.decode(base64Url.decode(normalizeBase64(parts[1]))),
      );
      final exp = payload['exp'] as int;

      // Comparar con hora actual
      final expiry = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
      return DateTime.now().isBefore(expiry);
    } catch (e) {
      return false;
    }
  }
}
