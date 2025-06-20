class UserModel {
  String id;
  String name;
  String email;
  String phone;
  String token;
  String profilePic;
  int birthday; // Added birthday field

  UserModel(
      {required this.email,
      required this.id,
      required this.name,
      required this.phone,
        required this.token,
      required this.birthday,
      required this.profilePic // Added birthday parameter
      });

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'] ?? '',
          name: json['name'] ?? '',
          email: json['email'] ?? '',
          phone: json['phonenumber'] ?? '',
          token: json['token'] ?? '',
          birthday: json['birthday'] ?? 0,
          profilePic: json[
              'profilePic'], // Added birthday from JSON with default empty string
        );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phonenumber": phone,
      "token": token,
      "birthday": birthday,
      "profilePic": profilePic // Added birthday to JSON output
    };
  }
}
