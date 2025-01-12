import 'package:get/get.dart';

import '../models/user_model.dart';

class UserController extends GetxController {
  var users = <UserModel>[].obs; // Reactive list for user data
  var isLoading = false.obs; // Track loading state

  @override
  void onInit() {
    super.onInit();
    loadDummyData(); // Load dummy data initially
    // fetchUsersFromApi(); // Uncomment to load data from API
  }

  // Load dummy data for now
  void loadDummyData() {
    users.value = [
      UserModel(
        name: "Abdullah Abosido",
        email: "abdullah@example.com",
        phone: "123-456-7890",
        imageUrl: "https://via.placeholder.com/150",
      ),
      UserModel(
        name: "Taher Samara",
        email: "tsamara@example.com",
        phone: "987-654-3210",
        imageUrl: "https://via.placeholder.com/150",
      ),
    ];
  }

  // Simulate API fetching (replace this with your API logic)
  Future<void> fetchUsersFromApi() async {
    try {
      isLoading(true);
      // Simulate a delay (replace with actual API call)
      await Future.delayed(const Duration(seconds: 2));

      // Replace with the actual response from your API
      List<Map<String, dynamic>> apiResponse = [
        {
          "name": "Alice Johnson",
          "email": "alice.johnson@example.com",
          "phone": "555-123-4567",
          "imageUrl": "https://via.placeholder.com/150",
        },
        {
          "name": "Bob Williams",
          "email": "bob.williams@example.com",
          "phone": "444-987-6543",
          "imageUrl": "https://via.placeholder.com/150",
        },
      ];

      // Parse API response and update the user list
      users.value =
          apiResponse.map((json) => UserModel.fromJson(json)).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch users: $e");
    } finally {
      isLoading(false);
    }
  }

  void deleteUser(int index) {
    users.removeAt(index);
  }

  void editUser(int index) {
    Get.snackbar(
        "Edit User", "Edit functionality for user: ${users[index].name}");
  }
}
