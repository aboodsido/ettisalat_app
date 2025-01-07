import 'package:ettisalat_app/app/views/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Navigate to Login screen after 3 seconds
    Future.delayed(Duration(seconds: 3), () {
      Get.off(() => LoginPage()); // Replaces Splash Screen with Login
    });

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/spBg.png',
            fit: BoxFit.cover,
          ),
          // App Logo
          Center(
            child: Image.asset(
              'assets/images/spLogo.png',
              width: 150,
              height: 150,
            ),
          ),
        ],
      ),
    );
  }
}
