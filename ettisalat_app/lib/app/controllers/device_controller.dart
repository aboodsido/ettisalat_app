import 'dart:convert';

import 'package:ettisalat_app/app/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/device_model.dart';

class DeviceController extends GetxController {
  var devices = <Device>[].obs;
  var currentPage = 1.obs;
  var totalPages = 1.obs;

  // Instance of FlutterSecureStorage to read the token
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchDevicesAPI(currentPage.value);
  }

  Future<void> fetchDevicesAPI(int page) async {
    try {
      // Get the token from secure storage
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken != null) {
        final response = await http.get(
          Uri.parse('$baseUrl/devices/list?page=$page'),
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final List<dynamic> devicesData = jsonData['data']['data'];

          // Update the pagination data
          currentPage.value = jsonData['data']['current_page'];
          totalPages.value = jsonData['data']['last_page'];

          // Update the device list
          devices.value =
              devicesData.map((device) => Device.fromJson(device)).toList();
        } else {
          Get.snackbar("Error", "Failed to fetch devices");
        }
      } else {
        Get.snackbar("Error", "No token found, please login again");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  // Method to load the next page
  void nextPage() {
    if (currentPage.value < totalPages.value) {
      currentPage.value++;
      fetchDevicesAPI(currentPage.value);
    }
  }

  // Method to load the previous page
  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchDevicesAPI(currentPage.value);
    }
  }

  Future<void> addDevice(Map<String, dynamic> newDeviceData) async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/devices/add'),
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
          body: json.encode(newDeviceData),
        );
        final responseBody = json.decode(response.body);
        final message = responseBody['message'].toString();

        if (response.statusCode == 200) {
          if (responseBody['success']) {
            Get.snackbar("Success", message);
            fetchDevicesAPI(currentPage.value);
          } else {
            Get.snackbar("Failed", message);
          }
        } else {
          Get.snackbar("Error", "Failed to add device.");
        }
      } else {
        Get.snackbar("Error", "No token found, please login again.");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    }
  }

  // New updateDevice function
  Future<void> updateDevice(
      String deviceId, Map<String, dynamic> updatedDeviceData) async {
    try {
      // Get the token from secure storage
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken != null) {
        final response = await http.post(
          Uri.parse("$baseUrl/devices/update/$deviceId"),
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
          body: json.encode(updatedDeviceData),
        );

        if (response.statusCode == 200) {
          Get.snackbar("Success", "Device updated successfully");
          // Refresh the devices list after the update
          fetchDevicesAPI(currentPage.value);
        } else {
          Get.snackbar("Error", "Failed to update device");
        }
      } else {
        Get.snackbar("Error", "No token found, please login again");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
      // Get the token from secure storage
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken != null) {
        final response = await http.delete(
          Uri.parse("$baseUrl/devices/delete/$deviceId"),
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          Get.snackbar("Success", "Device deleted successfully");
          // Refresh the devices list after deletion
          fetchDevicesAPI(currentPage.value);
        } else {
          Get.snackbar("Error", "Failed to delete device");
        }
      } else {
        Get.snackbar("Error", "No token found, please login again");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
