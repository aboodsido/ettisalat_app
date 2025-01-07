import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/dashboard_card.dart';
import 'settings_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
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
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        padding: const EdgeInsets.all(16), // Padding around the column
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            buildCard(
              title: "HOSTS",
              number: "250",
              icon: Icons.wifi,
              color: const Color(0xFFD8ECF7), // First card color
              circleColor: const Color(0xFF00A1D3),
            ),
            buildCard(
              title: "OPERATIONAL",
              number: "221",
              icon: Icons.wifi,
              color: const Color(0xFFE0F8E0), // Second card color

              circleColor: const Color(0xFF3CD653),
            ),
            buildCard(
              title: "OFFLINE SHORT TERM",
              number: "25",
              icon: Icons.wifi,
              color: const Color(0xFFFFEBE4), // Third card color
              circleColor: const Color(0xFFFC9375),
            ),
            buildCard(
              title: "OFFLINE LONG TERM",
              number: "4",
              icon: Icons.wifi,
              color: const Color(0xFFFFE0E5),
              circleColor: const Color(0xFFF95979),
            ),
          ],
        ),
      ),
    );
  }
}
