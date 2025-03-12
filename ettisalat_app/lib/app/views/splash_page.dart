import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../routes/app_routes.dart';

class SplashPage extends StatelessWidget {
  SplashPage({super.key});
  FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    Future<bool> isThereToken = storage.containsKey(key: 'auth_token');

    Future.delayed(const Duration(seconds: 5), () async {
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
          Center(
            child: Lottie.asset(
              'assets/lottie/loading_animation.json',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
              repeat: true,
              animate: true,
            ),
          ),
        ],
      ),
    );
  }
}
