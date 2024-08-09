class UserModel {
  String id;
  String address;
  String contactNumber;
  String email;
  String name;
  String profileImageUrl;
  String regNo;

  UserModel({
    required this.id,
    required this.address,
    required this.contactNumber,
    required this.email,
    required this.name,
    required this.profileImageUrl,
    required this.regNo,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      address: data['address'] ?? '', // Provide default value if null
      contactNumber: data['contact_number'] ?? '', // Provide default value if null
      email: data['email'] ?? '', // Provide default value if null
      name: data['name'] ?? '', // Provide default value if null
      profileImageUrl: data['profile_image_url'] ?? '', // Provide default value if null
      regNo: data['regNo'] ?? '', // Provide default value if null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address,
      'contact_number': contactNumber,
      'email': email,
      'name': name,
      'profile_image_url': profileImageUrl,
      'regNo': regNo,
    };
  }
}
