class SubjectResponseModel {
  int pageNo;
  int pageSize;
  int totalPage;
  List<SubjectModel> listSubject;

  SubjectResponseModel({
    this.pageNo,
    this.pageSize,
    this.totalPage,
    this.listSubject,
  });

  factory SubjectResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['subjectsResponseDto'] as List;
    print(list.runtimeType);
    List<SubjectModel> subjectDtos =
        list.map((i) => SubjectModel.fromJson(i)).toList();

    return SubjectResponseModel(
      pageNo: json['pageNo'] != null ? json['pageNo'] : 1,
      pageSize: json['pageSize'] != null ? json['pageSize'] : 2,
      totalPage: json['totalPage'] != null ? json['totalPage'] : 2,
      listSubject: subjectDtos,
    );
  }
}

class SubjectModel {
  int subjectId;
  String subjectCode;
  String subjectName;
  double price;
  String createingDate;
  String description;
  bool isAvailable;
  String image;
  int slot;
  int slotPerWeek;
  String rating;

  SubjectModel({
    this.subjectId,
    this.subjectCode,
    this.subjectName,
    this.price,
    this.createingDate,
    this.description,
    this.isAvailable,
    this.image,
    this.slot,
    this.slotPerWeek,
    this.rating,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      subjectId: json['subjectId'] != null ? json['subjectId'] : 0,
      subjectCode: json['subjectCode'] != null ? json['subjectCode'] : "",
      subjectName: json['subjectName'] != null ? json['subjectName'] : "",
      price: json['price'] != null ? json['price'] : 0,
      createingDate: json['createingDate'] != null ? json['createingDate'] : "",
      description: json['description'] != null ? json['description'] : "",
      isAvailable: json['isAvailable'] != null ? json['isAvailable'] : false,
      image: json['image'] != null ? json['image'] : "",
      slot: json['slot'] != null ? json['slot'] : 0,
      slotPerWeek: json['slotPerWeek'] != null ? json['slotPerWeek'] : 0,
      rating: json['rating'] != null ? json['rating'] : "",
    );
  }
}
