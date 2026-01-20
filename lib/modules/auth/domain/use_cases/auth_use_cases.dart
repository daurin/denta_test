import 'package:denty_cloud_test/core/use_cases/use_cases.dart';
import 'package:denty_cloud_test/modules/auth/domain/repositories/auth.repository.dart';

class LoginParams {
  final String email;
  final String password;
  LoginParams({required this.email, required this.password});
}

class LoginUseCase extends UseCase<void, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<void> call(LoginParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}

class ValidateTokenUseCase extends UseCase<bool, String> {
  final AuthRepository repository;
  ValidateTokenUseCase(this.repository);

  @override
  Future<bool> call(String token) {
    return repository.validateToken(token);
  }
}

class LogoutUseCase extends UseCase<void, void> {
  final AuthRepository repository;
  LogoutUseCase(this.repository);

  @override
  Future<void> call([void _]) {
    return repository.logout();
  }
}
