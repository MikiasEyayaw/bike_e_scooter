// api_service.dart
class ApiService {
  Future<String> fetchData(String endpoint) async {
    await Future.delayed(const Duration(seconds: 1));
    return "Response from $endpoint";
  }
}
