class UserModel {
  final String name;
  final String email;
  final String phone;
  final String imageUrl;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.imageUrl,
  });

  // Factory constructor to create a UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }
}
