import 'package:ettisalat_app/app/constants.dart';
import 'package:flutter/material.dart';

import '../../controllers/auth_controller.dart';

class ChangePasswordTab extends StatefulWidget {
  const ChangePasswordTab({super.key});

  @override
  _ChangePasswordTabState createState() => _ChangePasswordTabState();
}

class _ChangePasswordTabState extends State<ChangePasswordTab> {
  final _formKey = GlobalKey<FormState>();
  String? _oldPassword = '';
  String? _newPassword = '';
  String? _confirmNewPassword = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Old Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your old password';
                    }
                    return null;
                  },
                  onSaved: (value) => _oldPassword = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your new password';
                    }
                    return null;
                  },
                  onChanged: (value) => _newPassword = value,
                  onSaved: (value) => _newPassword = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm New Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please confirm your new password';
                    } else if (value != _newPassword) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                  onChanged: (value) => _confirmNewPassword = value,
                  onSaved: (value) => _confirmNewPassword = value!,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(primaryColr),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      AuthController()
                          .changePassword(_oldPassword!, _newPassword!);
                    }
                  },
                  child: const Text(
                    'Change Password',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
