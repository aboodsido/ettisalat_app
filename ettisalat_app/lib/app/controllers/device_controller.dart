import 'dart:convert';

import 'package:ettisalat_app/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/device_model.dart';

class DeviceController extends GetxController {
  var devices = <Device>[].obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var perPage = 10.obs;
  var isLoading = false.obs;
  var totalDevices = 0.obs;
  var onlineDeviceCount = 0.obs;
  var offlineShortDeviceCount = 0.obs;
  var offlineLongDeviceCount = 0.obs;

  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> fetchDevicesAPI({bool isRefreshing = false}) async {
    if (isLoading.value) return; // Prevent multiple requests

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isLoading.value = true;
    });

    try {
      String? authToken = await storage.read(key: 'auth_token');
      if (authToken == null) {
        // Get.snackbar("Error", "No token found, please login again");
        return;
      }

      final url = Uri.parse('$baseUrl/devices/list?page=${currentPage.value}');
      final headers = {
        "Authorization": "Bearer $authToken",
        'Accept-Encoding': 'gzip, deflate, br',
        "Content-Type": "application/json",
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final devicesData = jsonData['data']['data'];

        if (isRefreshing) {
          devices.clear(); // Clear only when refreshing
        }

        devices.addAll(devicesData
            .map((device) => Device.fromJson(device))
            .toList()
            .cast<Device>());

        totalDevices.value = jsonData['data']['total_records'];

        fetchDeviceCountByStatus('1');
        fetchDeviceCountByStatus('2');
        fetchDeviceCountByStatus('3');

        // Update pagination details
        currentPage.value = jsonData['data']['current_page'];
        lastPage.value =
            (jsonData['data']['total_records'] / perPage.value).round();
      } else {
        Get.snackbar("Error", "Failed to fetch devices");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void nextPage() {
    if (currentPage.value < lastPage.value) {
      currentPage.value++;
      fetchDevicesAPI(isRefreshing: true);
    }
  }

  void previousPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchDevicesAPI(isRefreshing: true);
    }
  }

  void refreshDevices() {
    currentPage.value = 1;
    fetchDevicesAPI(isRefreshing: true);
  }

  Future<void> fetchDeviceCountByStatus(String status) async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken == null) {
        // Get.snackbar("Error", "No token found, please login again");
        return;
      }

      final url = Uri.parse('$baseUrl/devices/list?status=$status');
      final headers = {
        "Authorization": "Bearer $authToken",
        'Accept-Encoding': 'gzip, deflate, br',
        "Content-Type": "application/json",
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        int totalRecords = jsonData['data']['total_records'];

        if (status == '1') {
          onlineDeviceCount.value = totalRecords;
        } else if (status == '2') {
          offlineShortDeviceCount.value = totalRecords;
        } else if (status == '3') {
          offlineLongDeviceCount.value = totalRecords;
        }
      } else {
        Get.snackbar(
            "Error", "Failed to fetch device count for status: $status");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred: $e");
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
            fetchDevicesAPI(isRefreshing: true);
          } else {
            Get.snackbar("Failed", message);
          }
        } else {
          Get.snackbar("Error", "Failed to add device.");
        }
      } else {
        // Get.snackbar("Error", "No token found, please login again.");
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
          fetchDevicesAPI(isRefreshing: true);
        } else {
          Get.snackbar("Error", "Failed to update device");
        }
      } else {
        // Get.snackbar("Error", "No token found, please login again");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  Future<void> deleteDevice(String deviceId) async {
    try {
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
          fetchDevicesAPI(isRefreshing: true);
        } else {
          Get.snackbar("Error", "Failed to delete device");
        }
      } else {
        // Get.snackbar("Error", "No token found, please login again");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
