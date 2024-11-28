import 'package:get/get.dart';

import '../controllers/login_controller.dart';
// import '../controllers/home_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    // Get.lazyPut<HomeController>(() => HomeController());
  }
}
