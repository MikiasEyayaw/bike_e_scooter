import '../models/user_model.dart';

class UserRepository {
  Future<User> login(String username, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return User(id: 'u1', username: username, role: 'admin');
  }
}
