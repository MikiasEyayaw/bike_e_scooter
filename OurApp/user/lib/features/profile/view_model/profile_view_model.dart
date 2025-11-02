class ProfileViewModel {
  String name = 'John Doe';
  String email = 'john@example.com';

  void updateProfile(String newName, String newEmail) {
    name = newName;
    email = newEmail;
  }
}
