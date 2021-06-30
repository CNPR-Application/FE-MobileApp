class LoginRequestModel {
  String username;
  String password;

  LoginRequestModel({
    this.username,
    this.password,
  });

  Map<String, dynamic> toJson() => {
        'username': username.trim(),
        'password': password.trim(),
      };
}

class LoginResponseModel {
  final String role;

  LoginResponseModel({
    this.role,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(role: json["role"] != null ? json["role"] : "");
  }
}
