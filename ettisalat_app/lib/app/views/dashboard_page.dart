import 'package:ettisalat_app/app/controllers/device_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/dashboard_card.dart';
import 'settings_page.dart';

class DashboardPage extends StatelessWidget {
  DeviceController deviceController = Get.find();

  DashboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    deviceController.fetchDevicesAPI();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.toNamed('/settings');
            },
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        padding: const EdgeInsets.all(16), // Padding around the column
        child: Obx(
          () => Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              buildCard(
                title: "DEVICES",
                number: "${deviceController.totalDevices}",
                icon: Icons.wifi,
                color: const Color(0xFFD8ECF7),
                circleColor: const Color(0xFF00A1D3),
              ),
              buildCard(
                title: "OPERATIONAL",
                number: "${deviceController.onlineDeviceCount}",
                icon: Icons.wifi,
                color: const Color(0xFFE0F8E0),
                circleColor: const Color(0xFF3CD653),
              ),
              buildCard(
                title: "OFFLINE SHORT TERM",
                number: "${deviceController.offlineShortDeviceCount}",
                icon: Icons.wifi,
                color: const Color(0xFFFFEBE4),
                circleColor: const Color(0xFFFC9375),
              ),
              buildCard(
                title: "OFFLINE LONG TERM",
                number: "${deviceController.offlineLongDeviceCount}",
                icon: Icons.wifi,
                color: const Color(0xFFFFE0E5),
                circleColor: const Color(0xFFF95979),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
