import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../controllers/user_controller.dart';
import '../../services/permission_manager.dart';
import '../settings_page.dart';
import 'add_user_page.dart';
import 'update_user_page.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    final PermissionManager permissionManager = Get.find<PermissionManager>();

    // Fetch the users when the page is first built
    userController.fetchUsers();

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
            topLeft: Radius.circular(50),
            topRight: Radius.circular(50),
          ),
        ),
        child: Obx(
          () {
            if (userController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16),
                itemCount: userController.users.length,
                itemBuilder: (context, index) {
                  final user = userController.users[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(user.image),
                            radius: 30,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${user.firstName} ${user.lastName}',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    user.companyEmail,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      overflow: TextOverflow.ellipsis,
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
                          ),
                          Row(
                            children: [
                              if (permissionManager.hasPermission('EDIT_USER'))
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: () async {
                                      // Navigate to the UpdateUserPage
                                      final userData = {
                                        "first_name": user.firstName,
                                        "middle_name": user.middleName,
                                        "last_name": user.lastName,
                                        "personal_email": user.personalEmail,
                                        "company_email": user.companyEmail,
                                        "phone": user.phone,
                                        "marital_status": user.maritalStatus,
                                        "receives_emails": user.receivesEmails,
                                        "email_frequency":
                                            user.emailFrequencyHours,
                                        "address": user.address,
                                        "image": user.image,
                                      };

                                      // Pass the current user data to the UpdateUserPage
                                      Get.to(
                                        () => UpdateUserPage(
                                          userData: userData,
                                          onUpdate: (updatedUserData) async {
                                            // Call the updateUser method from the controller
                                            await userController.updateUser(
                                                user.id, updatedUserData);
                                          },
                                          title: 'Update User Data',
                                          buttonText: 'Update',
                                        ),
                                      );
                                    },
                                    icon: SvgPicture.asset(
                                      'assets/icons/edit.svg',
                                      width: 17,
                                      height: 17,
                                    ),
                                    tooltip: "Edit User",
                                  ),
                                ),
                              const SizedBox(width: 5),
                              if (permissionManager
                                  .hasPermission('DELETE_USER'))
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: IconButton(
                                    onPressed: () =>
                                        userController.deleteUser(user.id),
                                    icon: SvgPicture.asset(
                                      'assets/icons/delete.svg',
                                      width: 17,
                                      height: 17,
                                    ),
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
            );
          },
        ),
      ),
      floatingActionButton: permissionManager.hasPermission('ADD_USER')
          ? FloatingActionButton(
              backgroundColor: const Color(0xFF00A1D3),
              onPressed: () {
                Get.to(
                  () => AddUserPage(
                    title: "Add New User",
                    buttonText: "Add User",
                    onSave: (userData) async {
                      await userController.addUser(userData);
                    },
                  ),
                );
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            )
          : null,
    );
  }
}
