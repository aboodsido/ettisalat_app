import 'package:ettisalat_app/app/constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/user_controller.dart';
import 'add_user_page.dart';
import 'settings_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const SettingsPage());
            },
            icon: const Icon(Icons.settings_outlined),
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50), // Adjust radius as needed
            topRight: Radius.circular(50), // Adjust radius as needed
          ),
        ),
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: userController.users.length,
              itemBuilder: (context, index) {
                final user = userController.users[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(user.imageUrl),
                          radius: 30,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user.email,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                user.phone,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.green,
                              child: IconButton(
                                onPressed: () => userController.editUser(index),
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                                tooltip: "Edit User",
                              ),
                            ),
                            const SizedBox(
                              width: 7,
                            ),
                            CircleAvatar(
                              backgroundColor: Colors.red,
                              child: IconButton(
                                onPressed: () =>
                                    userController.deleteUser(index),
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                                tooltip: "Delete User",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColr,
        onPressed: () {
          Get.to(
            () => AddUserPage(
              title: "Add New User",
              buttonText: "Save",
              onSave: (userData) async {
                // Perform your POST request here
                // Example:
                print(userData);
                Get.snackbar("Success", "User added successfully!");
              },
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
