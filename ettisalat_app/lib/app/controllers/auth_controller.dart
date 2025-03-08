import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../services/permission_manager.dart';

class AuthController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var loginIndicator = false.obs;
  final storage = const FlutterSecureStorage();
  final String loginUrl = '$baseUrl/auth/login';

  @override
  void onInit() {
    super.onInit();
    checkLoggedInStatus();
  }

  // Check if the user is already logged in
  void checkLoggedInStatus() async {
    String? token = await storage.read(key: 'auth_token');

    if (token != null) {
      // Token exists, navigate to the home screen
      Get.offNamed('/home');
    } else {
      // No token found, stay on the login screen
      print('No token found, redirecting to login.');
    }
  }

  // Login method
  void login() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      loginIndicator.value = true;

      Map<String, String> body = {
        'email': email.value,
        'password': password.value,
      };

      try {
        var response = await http.post(
          Uri.parse(loginUrl),
          body: body,
        );

        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          // Extract the token from the response
          String token = data['data']['token'];

          // Store the token securely
          await storage.write(key: 'auth_token', value: token);

          final permissions = List<String>.from(data['data']['permissions']);

          // Save permissions in the manager
          Get.find<PermissionManager>().setPermissions(permissions);
          print(permissions);

          // Optionally, store other user information if needed
          await storage.write(
              key: 'user_id', value: data['data']['user']['id'].toString());
          await storage.write(
              key: 'user_email', value: data['data']['user']['company_email']);
          await storage.write(
              key: 'first_name',
              value: '${data['data']['user']['first_name']}');
          await storage.write(
              key: 'middle_name',
              value: '${data['data']['user']['middle_name']}');
          await storage.write(
              key: 'last_name', value: '${data['data']['user']['last_name']}');
          await storage.write(
              key: 'user_image', value: '${data['data']['user']['image']}');

          // Navigate to the home screen after successful login
          Get.offNamed('/home');
        } else {
          // Show error if login fails
          Get.snackbar(
            'Error',
            'Login failed: ${response.statusCode}',
            icon: const Icon(
              Icons.warning,
              color: Colors.red,
            ),
          );
        }
      } catch (e) {
        // Handle any errors during the API request
        print(e);
        Get.snackbar(
          'Error',
          'An error occurred: $e',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      } finally {
        loginIndicator.value = false;
      }
    } else {
      Get.snackbar(
        'Error',
        'Please enter both email and password',
        icon: const Icon(
          Icons.warning,
          color: Colors.red,
        ),
      );
    }
  }

  // Logout method
  void logout() async {
    // Show confirmation dialog before logging out
    Get.dialog(
      AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              // Clear stored token and user data
              await storage.deleteAll();
              Get.find<PermissionManager>().clearPermissions();
              Get.offAllNamed('/login');

              Get.back();
            },
            child: const Text(
              "Logout",
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void forgetPassword() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/forget-password'),
        body: {'email': email.value},
      );
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          'A new password has been sent to your email.',
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to send new password: ${response.statusCode}',
          icon: const Icon(
            Icons.error,
            color: Colors.red,
          ),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred: $e',
        icon: const Icon(
          Icons.error,
          color: Colors.red,
        ),
      );
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    String? authToken = await storage.read(key: 'auth_token');

    final url = Uri.parse('$baseUrl/auth/change-password');
    final headers = {
      'Authorization': 'Bearer $authToken',
      'Content-Type': 'application/json',
    };
    final body = jsonEncode({
      'old_password': oldPassword,
      'new_password': newPassword,
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData['success']) {
        Get.snackbar('Success', jsonData['message']);
        Future.delayed(const Duration(seconds: 2)).then(
          (value) async {
            await storage.deleteAll();
            Get.find<PermissionManager>().clearPermissions();
            Get.offAllNamed('/login');
          },
        );
      } else {
        Get.snackbar('Error', jsonData['message']);
      }
    } else {
      Get.snackbar('Error', 'Error changing password');
    }
  }
}
