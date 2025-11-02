// permission_service.dart
class PermissionService {
  Future<bool> requestLocationPermission() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return true;
  }
}
