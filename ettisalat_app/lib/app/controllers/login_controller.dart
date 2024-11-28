import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  void login() {
    //Logic of login !

    if (email.isNotEmpty && password.isNotEmpty) {
      Get.offNamed('/home');
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
