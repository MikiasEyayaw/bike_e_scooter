class AuthBloc {
  bool loggedIn = false;

  void login() => loggedIn = true;
  void logout() => loggedIn = false;
}
