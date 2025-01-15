import 'package:ettisalat_app/app/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'settings_page.dart';

class MorePage extends StatelessWidget {
  MorePage({super.key});

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const SettingsPage());
            },
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), // Adjust radius as needed
            topRight: Radius.circular(50), // Adjust radius as needed
          ),
        ),
        child: Center(
          child: ElevatedButton(
              onPressed: authController.logout, child: Text('Logout')),
        ),
      ),
    );
  }
}
