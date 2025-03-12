import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/device_controller.dart';

class paginationWidget extends StatelessWidget {
  const paginationWidget({
    super.key,
    required this.deviceController,
  });

  final DeviceController deviceController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: primaryColr,
            ),
            onPressed: () {
              deviceController.previousPage();
            },
          ),
          Obx(() {
            return Text(
              'Page ${deviceController.currentPage.value} - ${deviceController.lastPage.value}',
              style: const TextStyle(
                fontSize: 16,
                color: primaryColr,
              ),
            );
          }),
          IconButton(
            icon: const Icon(
              Icons.arrow_forward,
              color: primaryColr,
            ),
            onPressed: () {
              deviceController.nextPage();
            },
          ),
        ],
      ),
    );
  }
}
