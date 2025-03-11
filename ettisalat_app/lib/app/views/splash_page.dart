import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    Future<bool> isThereToken = storage.containsKey(key: 'auth_token');

    // Navigate to Login screen after 3 seconds
    Future.delayed(const Duration(seconds: 4), () async {
      if (!await isThereToken) {
        print('the token is invalid !');
        Get.offNamed(AppRoutes.LOGIN);
      } else {
        print('the token is valid !');
        Get.offNamed(AppRoutes.HOME);
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
