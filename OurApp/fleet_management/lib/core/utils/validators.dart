// validators.dart
class Validators {
  static bool isValidEmail(String email) => email.contains("@");
  static bool isNotEmpty(String text) => text.trim().isNotEmpty;
}
