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
  final String jwt;
  final int branchId;

  LoginResponseModel({
    this.role,
    this.jwt,
    this.branchId,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      role: json["role"] != null ? json["role"] : "",
      jwt: json["jwt"] != null ? json["jwt"] : "",
      branchId: json["branchId"] != null ? json["branchId"] : 1,
    );
  }
}
