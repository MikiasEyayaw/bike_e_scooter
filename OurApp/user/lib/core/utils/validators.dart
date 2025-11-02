class Validators {
  static String? email(String? value) =>
      (value == null || !value.contains('@')) ? 'Invalid email' : null;
}
