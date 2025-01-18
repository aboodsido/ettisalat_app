import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/device_controller.dart';
import '../controllers/user_controller.dart';
import '../services/permission_manager.dart';
// import '../controllers/home_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    print("InitialBinding executed");
    Get.put<AuthController>(AuthController());
    Get.put<DeviceController>(DeviceController());
    Get.put<UserController>(UserController());
    Get.put<PermissionManager>(PermissionManager());
  }
}
