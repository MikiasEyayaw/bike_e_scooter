// local_storage.dart
class LocalStorage {
  final Map<String, String> _storage = {};
  void save(String key, String value) => _storage[key] = value;
  String? read(String key) => _storage[key];
}
