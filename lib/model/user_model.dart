class UserResponseModel {
  String username;
  String name;
  String address;
  String email;
  String birthday;
  String phone;
  String role;
  String createDate;
  List<BranchModel> branchModels;
  String parentPhone;
  String parentName;
  String experience;
  String rating;
  String image;

  UserResponseModel({
    this.username,
    this.name,
    this.address,
    this.email,
    this.birthday,
    this.phone,
    this.role,
    this.createDate,
    this.branchModels,
    this.parentPhone,
    this.parentName,
    this.experience,
    this.rating,
    this.image,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['branchResponseDtoList'] as List;
    print(list.runtimeType);
    List<BranchModel> branchResponseDtoList =
        list.map((i) => BranchModel.fromJson(i)).toList();

    return UserResponseModel(
      username: json["username"] != null ? json["username"] : "",
      name: json["name"] != null ? json["name"] : "",
      address: json["address"] != null ? json["address"] : "",
      email: json["email"] != null ? json["email"] : "",
      birthday: json["birthday"] != null ? json["birthday"] : "",
      phone: json['phone'] != null ? json['phone'] : "",
      role: json["role"] != null ? json["role"] : "",
      createDate: json["createDate"] != null ? json["createDate"] : "",
      branchModels: branchResponseDtoList,
      parentPhone: json["parentPhone"] != null ? json["parentPhone"] : "",
      parentName: json["parentName"] != null ? json["parentName"] : "",
      experience: json["experience"],
      rating: json["rating"] != null ? json["rating"] : "",
      image: json["image"] != null ? json["image"] : "",
    );
  }
}

class BranchModel {
  int branchId;
  String branchName;

  BranchModel({
    this.branchId,
    this.branchName,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['branchId'] != null ? json['branchId'] : 0,
      branchName: json['branchName'] != null ? json['branchName'] : "",
    );
  }
}
