import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart'; // Assuming you have primaryColr in constants.

class AddUserPage extends StatefulWidget {
  final String title;
  final String buttonText;
  final Function(Map<String, String>) onSave;

  const AddUserPage({
    super.key,
    required this.title,
    required this.buttonText,
    required this.onSave,
  });

  @override
  State<AddUserPage> createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? uploadedImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Upload Picture Section
              Center(
                child: GestureDetector(
                  onTap: () async {
                    // Placeholder for image upload logic
                    setState(() {
                      uploadedImageUrl =
                          "https://via.placeholder.com/150"; // Replace with actual image upload logic
                    });
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: uploadedImageUrl != null
                        ? NetworkImage(uploadedImageUrl!)
                        : null,
                    child: uploadedImageUrl == null
                        ? const Icon(
                            Icons.add_a_photo,
                            color: Colors.white,
                            size: 30,
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildLabel("User Name"),
              _buildTextField(
                  nameController, TextInputType.text, "Enter user name"),
              const SizedBox(height: 15),
              _buildLabel("Email"),
              _buildTextField(
                  emailController, TextInputType.emailAddress, "Enter email"),
              const SizedBox(height: 15),
              _buildLabel("Phone Number"),
              _buildTextField(
                  phoneController, TextInputType.number, "Enter phone number"),
              const SizedBox(height: 15),
              _buildLabel("Address"),
              _buildTextField(addressController, TextInputType.streetAddress,
                  "Enter address"),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateFields()) {
                      final userData = {
                        "name": nameController.text,
                        "email": emailController.text,
                        "phone": phoneController.text,
                        "address": addressController.text,
                        "image": uploadedImageUrl ?? "",
                      };
                      widget.onSave(userData);
                      Get.back();
                    } else {
                      Get.snackbar(
                        "Validation Error",
                        "Please fill all fields correctly.",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColr,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: Text(
                    widget.buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
      textAlign: TextAlign.left,
    );
  }

  Widget _buildTextField(TextEditingController controller,
      TextInputType keyboardType, String hint) {
    return TextField(
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color.fromRGBO(232, 240, 254, 1),
      ),
    );
  }

  bool _validateFields() {
    return nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        addressController.text.isNotEmpty;
  }
}
