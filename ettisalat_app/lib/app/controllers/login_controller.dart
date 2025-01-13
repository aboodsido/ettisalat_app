import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  final storage = FlutterSecureStorage();

  // Define the login API URL
  final String loginUrl =
      'http://monitoring.ocean-it.net/api/auth/login'; // Update with your actual API URL

  void login() async {
    if (email.isNotEmpty && password.isNotEmpty) {
      // Create the body of the request
      Map<String, String> body = {
        'email': email.value,
        'password': password.value,
      };

      try {
        // Make the API request
        var response = await http.post(
          Uri.parse(loginUrl),
          body: body,
        );

        // Check if the request was successful
        if (response.statusCode == 200) {
          var data = json.decode(response.body);

          // Extract the token from the response
          String token = data['data']['token'];

          // Store the token securely
          await storage.write(key: 'auth_token', value: token);

          // Optionally, store other user information if needed
          await storage.write(
              key: 'user_id', value: data['data']['user']['id'].toString());
          await storage.write(
              key: 'user_email', value: data['data']['user']['personal_email']);
          await storage.write(
              key: 'user_name',
              value:
                  '${data['data']['user']['first_name']} ${data['data']['user']['last_name']}');

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
}
