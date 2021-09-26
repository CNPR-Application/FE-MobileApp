class SubjectDetailResponseModel {
  int pageNo;
  int pageSize;
  int pageTotal;
  List<SubjectDetailModel> listSubjectDetail;

  SubjectDetailResponseModel({
    this.pageNo,
    this.pageSize,
    this.pageTotal,
    this.listSubjectDetail,
  });

  factory SubjectDetailResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['subjectDetailDtoList'] as List;
    print(list.runtimeType);
    List<SubjectDetailModel> subjectDetailDtos =
        list.map((i) => SubjectDetailModel.fromJson(i)).toList();

    return SubjectDetailResponseModel(
      pageNo: json['pageNo'] != null ? json['pageNo'] : 1,
      pageSize: json['pageSize'] != null ? json['pageSize'] : 2,
      pageTotal: json['pageTotal'] != null ? json['pageTotal'] : 2,
      listSubjectDetail: subjectDetailDtos,
    );
  }
}

class SubjectDetailModel {
  int subjectDetailId;
  int weekNum;
  String weekDescription;
  bool isAvaiable;
  String learningOutcome;

  SubjectDetailModel({
    this.subjectDetailId,
    this.weekNum,
    this.weekDescription,
    this.isAvaiable,
    this.learningOutcome,
  });

  factory SubjectDetailModel.fromJson(Map<String, dynamic> json) {
    return SubjectDetailModel(
      subjectDetailId:
          json['subjectDetailId'] != null ? json['subjectDetailId'] : 0,
      weekNum: json['weekNum'] != null ? json['weekNum'] : 0,
      weekDescription:
          json['weekDescription'] != null ? json['weekDescription'] : "",
      isAvaiable: json['isAvaiable'] != null ? json['isAvaiable'] : false,
      learningOutcome:
          json['learningOutcome'] != null ? json['learningOutcome'] : "",
    );
  }
}
