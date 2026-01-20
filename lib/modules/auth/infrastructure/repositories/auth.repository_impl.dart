import 'package:denty_cloud_test/modules/auth/domain/repositories/auth.repository.dart';
import 'package:denty_cloud_test/modules/auth/infrastructure/datasources/auth.datasource.dart';
import 'package:denty_cloud_test/services/local_storage/local_storage.service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource dataSource;
  final LocalStorageService localStorageService;

  AuthRepositoryImpl({
    required this.dataSource,
    required this.localStorageService,
  });

  @override
  Future<void> login({required String email, required String password}) async {
    String token = await dataSource.login(email: email, password: password);
    localStorageService.setValue('auth_token', token);
  }

  @override
  Future<bool> validateToken(String token) async {
    return await dataSource.validateToken(token);
  }

  @override
  Future<void> logout() async {
    localStorageService.remove('auth_token');
  }
}
