// ignore_for_file: deprecated_member_use
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/map_devices_model.dart';
import 'map_settings_controller.dart';

class MapApiController extends GetxController {
  var devices = <MapDevice>[].obs;
  var markers = <Marker>{}.obs;
  var isLoading = false.obs;
  final MapSettingsController mapSettingsController =
      Get.put(MapSettingsController());

  Map<String, BitmapDescriptor> markerIcons = {};

  Future<BitmapDescriptor> getResizedMarker(
      String assetPath, int targetWidth) async {
    // Load the image from assets
    ByteData data = await rootBundle.load(assetPath);
    Uint8List bytes = data.buffer.asUint8List();

    // Decode image and resize it
    ui.Codec codec =
        await ui.instantiateImageCodec(bytes, targetWidth: targetWidth);
    ui.FrameInfo frameInfo = await codec.getNextFrame();

    // Convert to bytes
    ByteData? byteData =
        await frameInfo.image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List resizedBytes = byteData!.buffer.asUint8List();

    // Convert to BitmapDescriptor
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  Future<void> loadCustomIcons() async {
    markerIcons["online"] =
        await getResizedMarker('assets/images/online.png', 64); // Adjust size
    markerIcons["offline_short_term"] =
        await getResizedMarker('assets/images/offline_short_term.png', 64);
    markerIcons["offline_long_term"] =
        await getResizedMarker('assets/images/offline_long_term.png', 64);

    update(); // Notify GetX to refresh UI
  }

  @override
  void onInit() {
    super.onInit();
    fetchDevices();

    // Listen to changes in deviceStatus and update markers accordingly.
    ever(mapSettingsController.deviceStatus, (_) {
      _createMarkers();
    });
  }

  Future<void> fetchDevices() async {
    try {
      String? authToken =
          await const FlutterSecureStorage().read(key: 'auth_token');
      if (authToken == null) {
        // Get.snackbar("Error", "No token found, please login again");
        return;
      }
      isLoading.value = true;
      final url = Uri.parse('$baseUrl/map/list');
      final headers = {
        "Authorization": "Bearer $authToken",
        'Accept-Encoding': 'gzip, deflate, br',
        "Content-Type": "application/json",
      };
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          var dataList = jsonResponse['data']['data'] as List;
          devices.value =
              dataList.map((json) => MapDevice.fromJson(json)).toList();
          _createMarkers();
          print(devices.length);
        } else {
          Get.snackbar(
              'Error', 'Failed to load devices: ${jsonResponse['message']}');
        }
      } else {
        Get.snackbar('Error', 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _createMarkers() {
    markers.clear();
    String selectedStatus = mapSettingsController.deviceStatus.value;
    for (var device in devices) {
      // If the selected status is not "all", only add devices with matching status.
      if (selectedStatus != 'all' && device.status != selectedStatus) {
        continue;
      }
      double? lat = double.tryParse(device.latitude.toString());
      double? lng = double.tryParse(device.longitude.toString());

      if (lat != null && lng != null) {
        BitmapDescriptor icon =
            markerIcons[device.status] ?? BitmapDescriptor.defaultMarker;
        markers.add(
          Marker(
            markerId: MarkerId(device.id.toString()),
            position: LatLng(lat, lng),
            infoWindow: InfoWindow(
              title: device.name,
              snippet: '${device.deviceType} • ${device.status}',
            ),
            icon: icon,
          ),
        );
      }
    }
    // Refresh the markers observable so that any Obx widgets update.
    markers.refresh();
  }
}
