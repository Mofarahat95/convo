class UserModel {
  String id;
  String name;
  String email;
  String phone;
  int birthday; // Added birthday field

  UserModel({
    required this.email,
    required this.id,
    required this.name,
    required this.phone,
    required this.birthday, // Added birthday parameter
  });

  UserModel.formJson(Map<String, dynamic> json)
      : this(
    id: json['id'],
    name: json['name'],
    email: json['email'],
    phone: json['phonenumber'],
    birthday: json['birthday'] ?? '', // Added birthday from JSON with default empty string
  );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phonenumber": phone,
      "birthday": birthday, // Added birthday to JSON output
    };
  }
}
