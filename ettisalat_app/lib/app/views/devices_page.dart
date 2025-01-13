import 'package:ettisalat_app/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';
import 'settings_page.dart';

class DevicesPage extends StatelessWidget {
  final DeviceController deviceController = Get.put(DeviceController());
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;

  DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
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
              child: Row(
                children: [
                  buildCountCard('300', Colors.green),
                  buildCountCard('50', Colors.orangeAccent),
                  buildCountCard('0', Colors.red),
                ],
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

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  itemCount: filteredDevices.length,
                  itemBuilder: (context, index) {
                    final device = filteredDevices[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 10),
                      color: const Color.fromARGB(228, 243, 243, 249),
                      child: ListTile(
                        leading: buildDeviceIdBadge(device.id),
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
                                style: const TextStyle(color: Colors.black54),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          "${device.lineCode}      Group: ${device.deviceType}",
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: buildTrailingActions(device.id),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColr,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          // Navigate to the device addition page
        },
      ),
    );
  }

  Widget buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Search devices...',
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

  Widget buildDeviceIdBadge(int id) {
    return CircleAvatar(
      backgroundColor: Colors.blue.shade100,
      child: Text(
        id.toString(),
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
    );
  }

  Widget buildTrailingActions(int id) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Edit Device',
          icon: SvgPicture.asset(
            'assets/icons/edit.svg',
            width: 15,
            height: 15,
          ),
          onPressed: () {
            // Edit device logic here
          },
        ),
        IconButton(
          tooltip: 'Delete Device',
          icon: SvgPicture.asset(
            'assets/icons/delete.svg',
            width: 15,
            height: 15,
          ),
          onPressed: () {
            // deviceController.deleteDeviceAPI(id);
          },
        ),
      ],
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
              Text('$count hosts'),
            ],
          ),
        ),
      ),
    );
  }
}
