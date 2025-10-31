class AuthService {
  Future<bool> login(String email, String password) async => email.isNotEmpty;
  Future<bool> signup(String name, String email, String password) async => true;
}
