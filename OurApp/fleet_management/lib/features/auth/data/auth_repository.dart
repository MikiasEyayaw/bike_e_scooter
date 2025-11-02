class AuthRepository {
  Future<bool> authenticate(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return username == 'admin' && password == '1234';
  }
}
