import 'package:ettisalat_app/app/controllers/device_controller.dart';
import 'package:ettisalat_app/app/routes/app_routes.dart';
import 'package:ettisalat_app/app/services/body_top_edge.dart';
import 'package:ettisalat_app/app/services/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/dashboard_card.dart';

class DashboardPage extends StatelessWidget {
  DashboardPage({super.key});

  final DeviceController deviceController = Get.find();

  // Reactive list to control the visibility of each card
  final RxList<bool> cardVisibility = [false, false, false, false].obs;

  void animateCards() {
    Future.delayed(const Duration(milliseconds: 300), () {
      cardVisibility[0] = true;
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      cardVisibility[1] = true;
    });
    Future.delayed(const Duration(milliseconds: 900), () {
      cardVisibility[2] = true;
    });
    Future.delayed(const Duration(milliseconds: 1200), () {
      cardVisibility[3] = true;
    });
  }

  /// Navigate to DevicesPage with an optional filter.
  void navigateToDevices(String? status) {
    // Reset pagination and update the filter in the controller
    deviceController.currentPage.value = 1;
    deviceController.fetchDevicesAPI(status: status);
    // Navigate and pass the filter argument.
    Get.toNamed(AppRoutes.DEVICES, arguments: {'status': status});
  }

  @override
  Widget build(BuildContext context) {
    deviceController.fetchDevicesAPI();
    animateCards(); // Start animation when the widget builds

    return Scaffold(
      appBar: customAppBar(title: 'Dashboard'),
      body: Container(
        decoration: bodyTopEdge(),
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
            children: [
              AnimatedOpacity(
                opacity: cardVisibility[0] ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: GestureDetector(
                  onTap: () {
                    navigateToDevices(null);
                  },
                  child: buildCard(
                    title: "DEVICES",
                    number: "${deviceController.totalDevices}",
                    icon: Icons.wifi,
                    color: const Color(0xFFD8ECF7),
                    circleColor: const Color(0xFF00A1D3),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedOpacity(
                opacity: cardVisibility[1] ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: GestureDetector(
                  onTap: () {
                    navigateToDevices('1');
                  },
                  child: buildCard(
                    title: "OPERATIONAL",
                    number: "${deviceController.onlineDeviceCount}",
                    icon: Icons.wifi,
                    color: const Color(0xFFE0F8E0),
                    circleColor: const Color(0xFF3CD653),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedOpacity(
                opacity: cardVisibility[2] ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: GestureDetector(
                  onTap: () {
                    navigateToDevices('2');
                  },
                  child: buildCard(
                    title: "OFFLINE SHORT TERM",
                    number: "${deviceController.offlineShortDeviceCount}",
                    icon: Icons.wifi,
                    color: const Color(0xFFFFEBE4),
                    circleColor: const Color(0xFFFC9375),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedOpacity(
                opacity: cardVisibility[3] ? 1 : 0,
                duration: const Duration(milliseconds: 500),
                child: GestureDetector(
                  onTap: () {
                    navigateToDevices('3');
                  },
                  child: buildCard(
                    title: "OFFLINE LONG TERM",
                    number: "${deviceController.offlineLongDeviceCount}",
                    icon: Icons.wifi,
                    color: const Color(0xFFFFE0E5),
                    circleColor: const Color(0xFFF95979),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
