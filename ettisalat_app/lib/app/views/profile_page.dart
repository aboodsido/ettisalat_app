import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../controllers/user_controller.dart';
import 'settings_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with TickerProviderStateMixin {
  late TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          child: Column(
            children: [
              TabBar(
                dividerHeight: 0,
                controller: _controller,
                indicator: const BoxDecoration(),
                tabs: [
                  Tab(
                    child: _buildTab(
                      label: 'General',
                      tabIndex: 0,
                    ),
                  ),
                  Tab(
                    child: _buildTab(
                      label: 'Change Password',
                      tabIndex: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: TabBarView(
                  controller: _controller,
                  children: const [
                    UserDataTab(),
                    ChangePasswordTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTab({required String label, required int tabIndex}) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: _controller.index == tabIndex
                ? primaryColr
                : Colors.transparent,
            border: Border.all(
              color: _controller.index == tabIndex
                  ? Colors.transparent
                  : primaryColr,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          width: double.infinity,
          height: 50,
          child: Text(
            label,
            style: TextStyle(
              color: _controller.index == tabIndex ? Colors.white : primaryColr,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}

class UserDataTab extends StatelessWidget {
  const UserDataTab({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.put(UserController());

    return FutureBuilder<String?>(
      future: userController.storage.read(key: 'user_id'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No user ID found'));
        }

        int userId = int.parse(snapshot.data!);
        userController.fetchProfile(userId); // Fetch profile data

        return Obx(() {
          if (userController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userController.userProfile.value == null) {
            return const Center(child: Text('Failed to load profile'));
          }

          final profile = userController.userProfile.value!;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(profile.image),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Name: ${profile.name}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                Text("Personal Email: ${profile.personalEmail}"),
                Text("Company Email: ${profile.companyEmail}"),
                Text("Phone: ${profile.phone}"),
                Text("Marital Status: ${profile.maritalStatus}"),
                Text("Role: ${profile.role}"),
              ],
            ),
          );
        });
      },
    );
  }
}

class ChangePasswordTab extends StatelessWidget {
  const ChangePasswordTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Center(
        child: Text('Password'),
      ),
    );
  }
}
