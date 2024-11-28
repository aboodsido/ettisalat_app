import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/host_controller.dart';
import '../models/host_model.dart';

void showHostFormDialog(BuildContext context, {Host? host}) {
  final HostController hostController = Get.find();

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final latController = TextEditingController();
  final lonController = TextEditingController();

  if (host != null) {
    nameController.text = host.name;
    latController.text = host.latitude.toString();
    lonController.text = host.longitude.toString();
  }

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(host == null ? "Add Host" : "Edit Host"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Host Name"),
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: latController,
                decoration: const InputDecoration(labelText: "Latitude"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter latitude" : null,
              ),
              TextFormField(
                controller: lonController,
                decoration: const InputDecoration(labelText: "Longitude"),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? "Enter longitude" : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Host newHost = Host(
                  id: host?.id ?? 0,
                  name: nameController.text,
                  latitude: double.parse(latController.text),
                  longitude: double.parse(lonController.text),
                );

                if (host == null) {
                  hostController.addHostAPI(newHost);
                } else {
                  hostController.editHostAPI(host.id, newHost);
                }

                Navigator.pop(context);
              }
            },
            child: Text(host == null ? "Add" : "Save"),
          ),
        ],
      );
    },
  );
}
