class UserModel {
  final String login;
  String password;
  DateTime? birthday;
  String? address;
  String? postalCode;
  String? city;

  UserModel({
    required this.login,
    required this.password,
    this.birthday,
    this.address,
    this.postalCode,
    this.city,
  });

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'password': password,
      'birthday': birthday?.toIso8601String(),
      'address': address,
      'postalCode': postalCode,
      'city': city,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      login: map['login'],
      password: map['password'],
      birthday: map['birthday'] != null ? DateTime.parse(map['birthday']) : null,
      address: map['address'],
      postalCode: map['postalCode'],
      city: map['city'],
    );
  }
}