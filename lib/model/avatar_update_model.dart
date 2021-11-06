class AvatarUpdateRequestModel {
  String keyword;
  String image;

  AvatarUpdateRequestModel({
    this.keyword = "avatar",
    this.image,
  });

  Map<String, dynamic> toJson() => {
        'keyword': keyword,
        'image': image,
      };
}

class AvatarUpdateResponseModel {
  final bool result;
  final String url;

  AvatarUpdateResponseModel({
    this.result,
    this.url,
  });

  factory AvatarUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return AvatarUpdateResponseModel(
      result: json["result"] != null ? json["result"] : false,
      url: json["url"] != null ? json["url"] : "",
    );
  }
}
