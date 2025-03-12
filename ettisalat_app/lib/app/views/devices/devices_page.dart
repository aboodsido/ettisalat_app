import 'package:ettisalat_app/app/services/body_top_edge.dart';
import 'package:ettisalat_app/app/services/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../constants.dart';
import '../../controllers/device_controller.dart';
import '../../services/device_counter_card.dart';
import '../../services/pagination_widget.dart';
import '../../services/permission_manager.dart';
import '../../services/search_bar_widget.dart';
import 'add_device_page.dart';
import 'update_device_page.dart';

class DevicesPage extends StatefulWidget {
  DevicesPage({super.key});

  @override
  State<DevicesPage> createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  final DeviceController deviceController = Get.find();

  final TextEditingController searchController = TextEditingController();

  final RxString searchQuery = ''.obs;

  final PermissionManager permissionManager = Get.find<PermissionManager>();

  @override
  void initState() {
    super.initState();
    // Check if a status filter was passed via Get.arguments.
    final args = Get.arguments;
    String? status;
    if (args != null && args['status'] != null) {
      status = args['status'];
    }
    // If a status is provided, fetch with that filter; otherwise, fetch all devices.
    if (status != null) {
      deviceController.fetchDevicesAPI(status: status);
    } else {
      deviceController.refreshDevices();
    }
  }

  @override
  void dispose() {
    // Reset the filter when exiting the DevicesPage.
    deviceController.currentFilter.value = null;
    // Optionally, refresh devices without filter if needed.
    deviceController.refreshDevices();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // deviceController.refreshDevices();
    // deviceController.fetchDevicesAPI();

    return Scaffold(
      appBar: customAppBar(title: 'Devices'),
      body: Container(
        decoration: bodyTopEdge(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: SearchBarWidget(
                  searchController: searchController, searchQuery: searchQuery),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
              child: Obx(
                () => Row(
                  children: [
                    buildCountCard(
                        '${deviceController.onlineDeviceCount} ', Colors.green),
                    buildCountCard(
                        '${deviceController.offlineShortDeviceCount} ',
                        Colors.orangeAccent),
                    buildCountCard(
                        '${deviceController.offlineLongDeviceCount} ',
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
                  color: primaryColr,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Obx(
                () {
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
                      : RefreshIndicator(
                          onRefresh: () async {
                            deviceController.refreshDevices();
                          },
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
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
                                      Flexible(
                                        child: Text(
                                          device.name,
                                          style: const TextStyle(
                                              color: primaryColr,
                                              fontWeight: FontWeight.w600),
                                          overflow: TextOverflow.ellipsis,
                                        ),
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
                          ),
                        );
                },
              ),
            ),
            // Pagination controls
            paginationWidget(deviceController: deviceController),
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
}
