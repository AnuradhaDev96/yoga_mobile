class CreateAccountModel {
  final String email;
  final String password;
  final String username;
  final String gender;
  final String? age;

  CreateAccountModel({
    required this.email,
    required this.password,
    required this.username,
    required this.gender,
    this.age,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'username': username,
      'gender': gender,
      'age': age,
    };
  }
}
