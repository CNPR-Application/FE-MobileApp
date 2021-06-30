class UserResponseModel {
  String username;
  String name;
  String address;
  String email;
  String birthday;
  String phone;
  String role;
  String createDate;
  int branchId;
  String branchName;
  String parentPhone;
  String parentName;
  String experience;
  String rating;

  UserResponseModel({
    this.username,
    this.name,
    this.address,
    this.email,
    this.birthday,
    this.phone,
    this.role,
    this.createDate,
    this.branchId,
    this.branchName,
    this.parentPhone,
    this.parentName,
    this.experience,
    this.rating,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      username: json["username"] != null ? json["username"] : "",
      name: json["name"] != null ? json["name"] : "",
      address: json["address"] != null ? json["address"] : "",
      email: json["email"] != null ? json["email"] : "",
      birthday: json["birthday"] != null ? json["birthday"] : "",
      phone: json["phone"] != null ? json["phone"] : "",
      role: json["role"] != null ? json["role"] : "",
      createDate: json["createDate"] != null ? json["createDate"] : "",
      branchId: json["branchId"] != null ? json["branchId"] : "",
      branchName: json["branchName"] != null ? json["branchName"] : "",
      parentPhone: json["parentPhone"] != null ? json["parentPhone"] : "",
      parentName: json["parentName"] != null ? json["parentName"] : "",
      experience: json["experience"] != null ? json["experience"] : "",
      rating: json["rating"] != null ? json["rating"] : "",
    );
  }
}
