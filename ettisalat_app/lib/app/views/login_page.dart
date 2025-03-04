import 'package:ettisalat_app/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController controller = Get.find();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50),
                      const Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 50),
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      TextField(
                        onChanged: (value) => controller.email.value = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(232, 240, 254, 1),
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Password',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      TextField(
                        onChanged: (value) => controller.password.value = value,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Color.fromRGBO(232, 240, 254, 1),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () => _showForgotPasswordDialog(),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: primaryColr),
                          ),
                        ),
                      ),

                      // Forgot password dialog
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: const ButtonStyle(
                          shape: WidgetStatePropertyAll<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          backgroundColor: WidgetStatePropertyAll<Color>(
                            primaryColr,
                          ),
                        ),
                        onPressed: controller.login,
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Center(
                        child: Image(
                            image: AssetImage('assets/images/jawwalLogo.png')),
                      ),
                    ],
                  ),
                ),
              ),
              controller.loginIndicator.value
                  ? Container(
                      color: Colors.white
                          .withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.transparent,
                        ),
                      ),
                    )
                  : Container(),
            ],
          ),
        );
      },
    );
  }

  void _showForgotPasswordDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text("Enter your email to reset the password"),
        content: TextField(
          onChanged: (value) => controller.email.value = value,
          decoration: const InputDecoration(
            hintText: "example@xyz.com",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            style: const ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(primaryColr),
            ),
            onPressed: () {
              if (controller.email.value.isEmpty) {
                Get.snackbar(
                  'Error',
                  'Please enter your email',
                  icon: const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                );
              } else if (!RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(controller.email.value)) {
                Get.snackbar(
                  'Error',
                  'Please enter a valid email address',
                  icon: const Icon(
                    Icons.warning,
                    color: Colors.red,
                  ),
                );
              } else {
                controller.forgetPassword();
                Get.back();
              }
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}
