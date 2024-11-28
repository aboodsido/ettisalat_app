import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/host_controller.dart';
import '../services/host_form_dialog.dart';

class HostsPage extends StatelessWidget {
  final HostController hostController = Get.put(HostController());

  HostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              onPressed: () => showHostFormDialog(context),
              icon: const Icon(Icons.add),
              label: const Text("Add Host"),
            ),
          ),
          Expanded(
            child: Obx(() {
              return ListView(
                children: hostController.hosts.map((host) {
                  return Card(
                    child: ListTile(
                      title: Text(host.name),
                      subtitle:
                          Text("Lat: ${host.latitude}, Lon: ${host.longitude}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                showHostFormDialog(context, host: host),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                hostController.deleteHostAPI(host.id),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            }),
          ),
        ],
      ),
    );
  }
}