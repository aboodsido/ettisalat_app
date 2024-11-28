import 'package:get/get.dart';

import '../models/host_model.dart';

class HostController extends GetxController {
  var hosts = <Host>[].obs;
  final String apiUrl =
      "https://example.com/api/hosts"; // Replace with your API URL

  @override
  void onInit() {
    super.onInit();
    // fetchHosts();
    loadDummyData();
  }

  void loadDummyData() {
    hosts.value = [
      Host(id: 1, name: "Host One", latitude: 31.5, longitude: 34.5),
      Host(id: 2, name: "Host Two", latitude: 32.0, longitude: 35.0),
      Host(id: 3, name: "Host Three", latitude: 33.2, longitude: 36.3),
    ];
  }

  Future<void> fetchHosts() async {
    /* try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        hosts.value = List<Host>.from(data.map((item) => Host.fromJson(item)));
      } else {
        Get.snackbar("Error", "Failed to fetch hosts");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    */

    // API call logic here if needed
    // For now, leave it unused since we're showing dummy data
  }

  Future<void> addHostAPI(Host host) async {
    /* try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(host.toJson()),
      );

      if (response.statusCode == 201) {
        hosts.add(Host.fromJson(json.decode(response.body)));
      } else {
        Get.snackbar("Error", "Failed to add host");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    */
    hosts.add(host);
  }

  Future<void> editHostAPI(int id, Host updatedHost) async {
    /*
    try {
      final response = await http.put(
        Uri.parse("$apiUrl/$id"),
        headers: {"Content-Type": "application/json"},
        body: json.encode(updatedHost.toJson()),
      );

      if (response.statusCode == 200) {
        int index = hosts.indexWhere((host) => host.id == id);
        if (index != -1) {
          hosts[index] = Host.fromJson(json.decode(response.body));
        }
      } else {
        Get.snackbar("Error", "Failed to update host");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    */
    int index = hosts.indexWhere((host) => host.id == id);
    if (index != -1) {
      hosts[index] = updatedHost;
    }
  }

  Future<void> deleteHostAPI(int id) async {
    /*
    try {
      final response = await http.delete(Uri.parse("$apiUrl/$id"));
      if (response.statusCode == 200) {
        hosts.removeWhere((host) => host.id == id);
      } else {
        Get.snackbar("Error", "Failed to delete host");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
    */
    hosts.removeWhere((host) => host.id == id);
  }
}
