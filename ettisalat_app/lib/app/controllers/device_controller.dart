import 'package:get/get.dart';
import '../models/device_model.dart';

class DeviceController extends GetxController {
  var devices = <Device>[].obs;
  final String apiUrl =
      "https://example.com/api/hosts"; // Replace with your API URL

  @override
  void onInit() {
    super.onInit();
    // fetchHosts();
    loadDummyData();
  }

  void loadDummyData() {
    devices.value = [
      Device(
        id: 1,
        name: "Device 1",
        deviceIP: '192.168.1.1',
        groupId: 101,
        groupName: "Group A",
        lastExaminationDate: "2025-01-01",
      ),
      Device(
        id: 2,
        name: "Device 2",
        deviceIP: '192.168.1.2',
        groupId: 102,
        groupName: "Group B",
        lastExaminationDate: "2025-01-02",
      ),
      Device(
        id: 3,
        name: "Device 3",
        deviceIP: '192.168.1.3',
        groupId: 103,
        groupName: "Group C",
        lastExaminationDate: "2025-01-03",
      ),
    ];
  }

  Future<void> fetchHosts() async {
    /* Uncomment and implement this when connecting to an actual API
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        devices.value = List<Device>.from(data.map((item) => Device.fromJson(item)));
      } else {
        Get.snackbar("Error", "Failed to fetch devices");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    */
    // For now, leave it unused since we're showing dummy data
  }

  Future<void> addDeviceAPI(Device device) async {
    /* Uncomment and implement this when connecting to an actual API
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(device.toJson()),
      );

      if (response.statusCode == 201) {
        devices.add(Device.fromJson(json.decode(response.body)));
      } else {
        Get.snackbar("Error", "Failed to add device");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    */
    devices.add(device);
  }

  Future<void> editDeviceAPI(int id, Device updatedDevice) async {
    /* Uncomment and implement this when connecting to an actual API
    try {
      final response = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedDevice.toJson()),
      );

      if (response.statusCode == 200) {
        int index = devices.indexWhere((device) => device.id == id);
        if (index != -1) {
          devices[index] = Device.fromJson(json.decode(response.body));
        }
      } else {
        Get.snackbar("Error", "Failed to update device");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    */
    int index = devices.indexWhere((device) => device.id == id);
    if (index != -1) {
      devices[index] = updatedDevice;
    }
  }

  Future<void> deleteDeviceAPI(int id) async {
    /* Uncomment and implement this when connecting to an actual API
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$id"));
      if (response.statusCode == 200) {
        devices.removeWhere((device) => device.id == id);
      } else {
        Get.snackbar("Error", "Failed to delete device");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    */
    devices.removeWhere((device) => device.id == id);
  }
}
