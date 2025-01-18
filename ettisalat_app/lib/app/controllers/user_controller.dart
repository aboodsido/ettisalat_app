import 'package:ettisalat_app/app/constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user_model.dart';

class UserController extends GetxController {
  var users = <UserModel>[].obs; // Reactive list for user data
  var isLoading = false.obs; // Track loading state
  final storage = const FlutterSecureStorage();
  

  // Fetch users from API
  Future<void> fetchUsers() async {
    try {
      String? authToken = await storage.read(
          key: 'auth_token'); // Replace with your storage method

      if (authToken == null) {
        Get.snackbar("Error", "No token found, please login again.");
        return;
      }

      isLoading(true);

      final response = await http.get(
        Uri.parse('$baseUrl/users/list'),
        headers: {
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data']['data'] as List;
        users.value = data.map((user) => UserModel.fromJson(user)).toList();
      } else {
        Get.snackbar("Error", "Failed to load users");
      }
    } catch (e) {
      print(e);
      Get.snackbar("Error", "An error occurred: $e");
    } finally {
      isLoading(false);
    }
  }

  // Delete a user
  Future<void> deleteUser(int userId) async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken == null) {
        Get.snackbar("Error", "No token found, please login again.");
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/users/delete/$userId'),
        headers: {
          "Authorization": "Bearer $authToken",
        },
      );

      final responseBody = json.decode(response.body);
      final message = responseBody['message'].toString();

      if (response.statusCode == 200) {
        Get.snackbar("Success", message);
        fetchUsers(); // Refresh the users list after deletion
      } else {
        print(message);
        Get.snackbar("Error", message);
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar("Error", "An error occurred: $e");
    }
  }
}
