import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'settings_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
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
      body: const Center(
        child: Text('Users Page Content'),
      ),
    );
  }
}
