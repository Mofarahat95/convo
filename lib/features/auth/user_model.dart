class UserModel {
  String id;
  String name;
  String email;
  String phone;

  UserModel(
      {required this.email,
      required this.id,
      required this.name,
      required this.phone});

  UserModel.formJson(Map<String, dynamic> json)
      : this(
            id: json['id'],
            name: json['name'],
            email: json['email'],
            phone: json['phonenumber']);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "phonenumber": phone,
    };
  }
}
