class AuthViewModel {
  bool isLoading = false;

  Future<void> login(String email, String password) async {
    isLoading = true;
    await Future.delayed(const Duration(seconds: 1));
    isLoading = false;
  }
}
