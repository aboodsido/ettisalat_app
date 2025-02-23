import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../constants.dart';

class UpdateUserPage extends StatefulWidget {
  final String title;
  final String buttonText;
  final Map<String, dynamic> userData; // Existing user data to pre-fill
  final Function(Map<String, dynamic>) onUpdate;

  const UpdateUserPage({
    super.key,
    required this.title,
    required this.buttonText,
    required this.userData,
    required this.onUpdate,
  });

  @override
  State<UpdateUserPage> createState() => _UpdateUserPageState();
}

class _UpdateUserPageState extends State<UpdateUserPage> {
  // Controllers
  final controllers = {
    'firstName': TextEditingController(),
    'middleName': TextEditingController(),
    'lastName': TextEditingController(),
    'personalEmail': TextEditingController(),
    'companyEmail': TextEditingController(),
    'phone': TextEditingController(),
    'emailFrequency': TextEditingController(),
    'address': TextEditingController(),
  };

  // State Variables
  File? selectedImage;
  String? selectedMaritalStatus;
  int? selectedRoleId;
  bool? selectedReceiveEmails;

  List<Map<String, dynamic>> roles = [];
  bool isLoadingRoles = true;

  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchRoles();
    _prefillUserData(); // Pre-fill fields with existing user data
  }

  // Pre-fill fields with existing user data
  void _prefillUserData() {
    final userData = widget.userData;
    controllers['firstName']!.text = userData['first_name'] ?? '';
    controllers['middleName']!.text = userData['middle_name'] ?? '';
    controllers['lastName']!.text = userData['last_name'] ?? '';
    controllers['personalEmail']!.text = userData['personal_email'] ?? '';
    controllers['companyEmail']!.text = userData['company_email'] ?? '';
    controllers['phone']!.text = userData['phone'] ?? '';
    controllers['emailFrequency']!.text = userData['email_frequency'] ?? '';
    controllers['address']!.text = userData['address'] ?? '';
    selectedMaritalStatus = userData['marital_status'] ?? "Single";
    selectedRoleId = userData['role_id'];
    selectedReceiveEmails = userData['receives_emails'] == "true" ||
        userData['receives_emails'] == true;
  }

  Future<void> fetchRoles() async {
    try {
      String? authToken = await storage.read(key: 'auth_token');

      if (authToken == null) {
        Get.snackbar("Error", "No token found, please login again.");
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/roles/list'),
        headers: {
          "Authorization": "Bearer $authToken",
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final rolesData = responseBody['data']['data'] as List;

        setState(() {
          roles = rolesData
              .map((role) => {"id": role['id'], "name": role['name']})
              .toList();
          isLoadingRoles = false;
        });
      } else {
        Get.snackbar("Error", "Failed to load roles: ${response.statusCode}");
      }
    } catch (e) {
      Get.snackbar("Error", "An error occurred while fetching roles: $e");
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick an image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildInput("First Name", 'firstName', TextInputType.text),
              _buildInput("Middle Name", 'middleName', TextInputType.text),
              _buildInput("Last Name", 'lastName', TextInputType.text),
              _buildInput("Personal Email", 'personalEmail',
                  TextInputType.emailAddress),
              _buildInput(
                  "Company Email", 'companyEmail', TextInputType.emailAddress),
              _buildInput("Phone Number", 'phone', TextInputType.number),
              _buildDropdown("Select Marital Status", ["Single", "Married"],
                  (value) {
                setState(() {
                  selectedMaritalStatus = value;
                });
              }, selectedMaritalStatus),
              _buildRoleDropdown(),
              _buildDropdown("Receives Emails", [true, false], (value) {
                setState(() {
                  selectedReceiveEmails = value;
                });
              }, selectedReceiveEmails),
              _buildInput("Email Frequency (Hours)", 'emailFrequency',
                  TextInputType.number),
              _buildInput("Address", 'address', TextInputType.streetAddress),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInput(
      String label, String controllerKey, TextInputType inputType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        TextField(
          controller: controllers[controllerKey],
          keyboardType: inputType,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildDropdown(
    String label,
    List<dynamic> items,
    Function(dynamic) onChanged,
    dynamic value,
  ) {
    // Ensure the value exists in the items list
    if (!items.contains(value)) {
      value =
          items.isNotEmpty ? items.first : null; // Default to the first item
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        DropdownButtonFormField<dynamic>(
          value: value, // Ensure this value exists in the items list
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.toString()),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildRoleDropdown() {
    if (isLoadingRoles) {
      return const CircularProgressIndicator(); // Show a loader while roles are loading
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Select Role"),
        DropdownButtonFormField<dynamic>(
          value: selectedRoleId ?? roles.first['id'],
          items: roles
              .map((role) => DropdownMenuItem(
                    value: role['id'],
                    child: Text(role['name']),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedRoleId = value;
            });
          },
          decoration: _inputDecoration(),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
    );
  }

  InputDecoration _inputDecoration() {
    return const InputDecoration(
      filled: true,
      fillColor: Color.fromRGBO(232, 240, 254, 1),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide.none),
    );
  }

  Widget _buildImagePicker() {
    return Center(
      child: GestureDetector(
        onTap: pickImage,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              selectedImage != null ? FileImage(selectedImage!) : null,
          child: selectedImage == null
              ? const Icon(Icons.add_a_photo, color: Colors.white, size: 30)
              : null,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (_validateFields()) {
            final userData = {
              "first_name": controllers['firstName']!.text,
              "middle_name": controllers['middleName']!.text,
              "last_name": controllers['lastName']!.text,
              "personal_email": controllers['personalEmail']!.text,
              "company_email": controllers['companyEmail']!.text,
              "phone": controllers['phone']!.text,
              "marital_status": selectedMaritalStatus,
              "role_id": selectedRoleId,
              "receives_emails": selectedReceiveEmails,
              "email_frequency": controllers['emailFrequency']!.text,
              "address": controllers['address']!.text,
              "image": selectedImage?.path ?? widget.userData['image'],
            };
            widget.onUpdate(userData);
            Get.back();
          } else {
            Get.snackbar(
                "Validation Error", "Please fill all fields correctly.");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColr,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        ),
        child: Text(
          widget.buttonText,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  bool _validateFields() {
    return controllers.values
            .every((controller) => controller.text.isNotEmpty) &&
        selectedMaritalStatus != null &&
        selectedRoleId != null &&
        selectedReceiveEmails != null;
  }
}
