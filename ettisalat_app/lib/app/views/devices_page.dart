import 'package:ettisalat_app/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';
import '../services/permission_manager.dart';
import 'add_device_page.dart';
import 'settings_page.dart';
import 'update_device_page.dart';

class DevicesPage extends StatelessWidget {
  final DeviceController deviceController = Get.find();
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  final PermissionManager permissionManager = Get.find<PermissionManager>();

  DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    deviceController.fetchDevicesAPI(deviceController.currentPage.value);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Settings',
            onPressed: () {
              Get.to(const SettingsPage());
            },
            icon: const Icon(Icons.settings_outlined),
          ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: buildSearchField(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Obx(
                () => Row(
                  children: [
                    buildCountCard(
                        '${deviceController.devices.where((device) => device.status == '1').length}',
                        Colors.green),
                    buildCountCard(
                        '${deviceController.devices.where((device) => device.status == '2').length}',
                        Colors.orangeAccent),
                    buildCountCard(
                        '${deviceController.devices.where((device) => device.status == '3').length}',
                        Colors.red),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Devices',
                style: TextStyle(
                  color: Color.fromARGB(255, 14, 120, 155),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Obx(() {
                final filteredDevices =
                    deviceController.devices.where((device) {
                  final deviceName = device.name.toLowerCase();
                  final deviceIP = device.ipAddress.toLowerCase();
                  return deviceName.contains(searchQuery.value) ||
                      deviceIP.contains(searchQuery.value);
                }).toList();

                if (filteredDevices.isEmpty) {
                  return const Center(
                    child: Text(
                      'No devices found.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  );
                }

                return deviceController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColr,
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 12),
                        itemCount: filteredDevices.length,
                        itemBuilder: (context, index) {
                          final device = filteredDevices[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.only(bottom: 10),
                            color: const Color.fromARGB(241, 243, 243, 249),
                            child: ListTile(
                              leading: buildDeviceIdBadge(
                                device.id,
                                device.status == '1'
                                    ? Colors.green
                                    : device.status == '2'
                                        ? Colors.orangeAccent
                                        : Colors.red,
                              ),
                              title: Row(
                                children: [
                                  Text(
                                    device.name,
                                    style: const TextStyle(
                                        color: primaryColr,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(width: 10),
                                  Flexible(
                                    child: Text(
                                      'IP: ${device.ipAddress}',
                                      style: const TextStyle(
                                          color: Colors.black54),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                "${device.lineCode}      Type: ${device.deviceType}",
                                style: const TextStyle(color: Colors.grey),
                              ),
                              trailing: buildTrailingActions(device.id),
                            ),
                          );
                        },
                      );
              }),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                      'Page ${deviceController.currentPage.value} of ${deviceController.totalPages.value}',
                      style: const TextStyle(fontSize: 16, color: primaryColr),
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
            ),
          ],
        ),
      ),
      floatingActionButton: permissionManager.hasPermission('ADD_DEVICE')
          ? FloatingActionButton(
              backgroundColor: primaryColr,
              child: const Icon(Icons.add, color: Colors.white),
              onPressed: () {
                Get.to(const AddDevicePage());
              },
            )
          : null,
    );
  }

  Widget buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search devices by name or IP...',
        prefixIcon: const Icon(Icons.search, color: primaryColr),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColr),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColr),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: primaryColr, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      onChanged: (value) {
        searchQuery.value = value.toLowerCase();
      },
    );
  }

  Widget buildDeviceIdBadge(int id, Color color) {
    return CircleAvatar(
      radius: 7,
      backgroundColor: color,
    );
  }

  Widget buildTrailingActions(int id) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (permissionManager.hasPermission('EDIT_DEVICE'))
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              tooltip: 'Edit Device',
              icon: SvgPicture.asset(
                'assets/icons/edit.svg',
                width: 15,
                height: 15,
              ),
              onPressed: () {
                final device = deviceController.devices
                    .firstWhere((device) => device.id == id);
                // Navigate to the Update Device page with the selected device's data
                Get.to(UpdateDevicePage(device: device));
              },
            ),
          ),
        const SizedBox(width: 5),
        if (permissionManager.hasPermission('DELETE_DEVICE'))
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              tooltip: 'Delete Device',
              icon: SvgPicture.asset(
                'assets/icons/delete.svg',
                width: 15,
                height: 15,
              ),
              onPressed: () {
                _showDeleteConfirmationDialog(id);
              },
            ),
          ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(int deviceId) {
    Get.dialog(
      AlertDialog(
        title: const Text("Delete Confirm"),
        content: const Text("Are you sure you want to delete this device?"),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog and do nothing
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              deviceController.deleteDevice(deviceId.toString());
              Get.back();
            },
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Expanded buildCountCard(String count, Color color) {
    return Expanded(
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundColor: color,
                radius: 5,
              ),
              const SizedBox(height: 5),
              Text('$count devices'),
            ],
          ),
        ),
      ),
    );
  }
}
