import 'package:get/get.dart';

class PermissionManager extends GetxService {
  final RxList<String> _permissions = <String>[].obs;

  // Initialize permissions when user logs in
  void setPermissions(List<String> permissions) {
    _permissions.assignAll(permissions);
  }

  // Check if the user has a specific permission
  bool hasPermission(String permission) {
    return _permissions.contains(permission);
  }

  // Clear permissions (e.g., when logging out)
  void clearPermissions() {
    _permissions.clear();
  }
}
