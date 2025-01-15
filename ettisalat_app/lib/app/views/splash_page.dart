import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Navigate to Login screen after 3 seconds
    Future.delayed(const Duration(seconds: 3), () async {
      const FlutterSecureStorage storage = FlutterSecureStorage();
      String? authToken = await storage.read(key: 'auth_token');
      if (authToken != null) {
        Get.offNamed(AppRoutes.HOME); // Navigate to the Home page
      } else {
        Get.offNamed(AppRoutes.LOGIN); // Navigate to the Login page
      }
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/spBg.png',
            fit: BoxFit.cover,
          ),
          Center(
            child: Image.asset(
              'assets/images/splashLogo.png',
              width: 200,
              height: 200,
            ),
          ),
        ],
      ),
    );
  }
}
