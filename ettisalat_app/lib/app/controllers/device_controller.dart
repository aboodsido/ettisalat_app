import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/device_model.dart';

class DeviceController extends GetxController {
  var devices = <Device>[].obs;
  final String apiUrl = "http://monitoring.ocean-it.net/api/devices/list";

  // Instance of FlutterSecureStorage to read the token
  final FlutterSecureStorage storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    fetchDevicesAPI();
  }

  Future<void> fetchDevicesAPI() async {
    try {
      // Get the token from secure storage
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken != null) {
        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            "Authorization": "Bearer $authToken",
            "Content-Type": "application/json",
          },
        );

        if (response.statusCode == 200) {
          final jsonData = json.decode(response.body);
          final List<dynamic> devicesData = jsonData['data']['data'];
          devices.value = devicesData.map((device) => Device.fromJson(device)).toList();
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
}
