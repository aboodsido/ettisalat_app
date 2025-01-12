import 'package:ettisalat_app/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../controllers/device_controller.dart';
import 'settings_page.dart';

class DevicesPage extends StatelessWidget {
  final DeviceController deviceController = Get.put(DeviceController());

  DevicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Devices'),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                'Hosts',
                style: TextStyle(
                    color: Color.fromARGB(255, 14, 120, 155), fontSize: 17),
              ),
            ),
            Expanded(
              child: Obx(() {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                  child: ListView(
                    children: deviceController.devices.map((device) {
                      return Card(
                        elevation: 0,
                        color: const Color.fromARGB(228, 243, 243, 249),
                        child: ListTile(
                          leading: Card(
                            elevation: 1,
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 6),
                              child: Column(
                                children: [
                                  Text('${device.id}'),
                                  const SizedBox(height: 5),
                                  const CircleAvatar(
                                    backgroundColor: Colors.green,
                                    radius: 5,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          title: Row(
                            children: [
                              Text(
                                device.name,
                                style: const TextStyle(color: primaryColr),
                              ),
                              const SizedBox(width: 20),
                              Text('  IP: ${device.deviceIP}',
                                  style: const TextStyle(color: primaryColr))
                            ],
                          ),
                          subtitle: Text(
                              "${device.lastExaminationDate}      Group: ${device.groupName}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                    icon: SvgPicture.asset(
                                      'assets/icons/edit.svg',
                                      width: 15,
                                      height: 15,
                                    ),
                                    onPressed: () {}),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: SvgPicture.asset(
                                      width: 15,
                                      height: 15,
                                      'assets/icons/delete.svg'),
                                  onPressed: () => deviceController
                                      .deleteDeviceAPI(device.id),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColr,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
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
