abstract class AuthRepository {
  Future<void> login({required String email, required String password});

  Future<bool> validateToken(String token);

  Future<void> logout();
}
