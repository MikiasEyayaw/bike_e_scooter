class AuthController {
  Future<bool> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return username == 'admin' && password == '1234';
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
