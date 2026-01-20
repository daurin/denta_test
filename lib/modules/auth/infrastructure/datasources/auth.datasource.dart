abstract class AuthDataSource {
  Future<String> login({required String email, required String password});

  Future<bool> validateToken(String token);
}
