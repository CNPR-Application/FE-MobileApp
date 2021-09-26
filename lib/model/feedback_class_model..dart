class FeedbackClassResponseModel {
  List<FeedbackClassModel> listClasses;

  FeedbackClassResponseModel({
    this.listClasses,
  });

  factory FeedbackClassResponseModel.fromJson(List<dynamic> json) {
    List<FeedbackClassModel> classDtos = <FeedbackClassModel>[];
    classDtos = json.map((i) => FeedbackClassModel.fromJson(i)).toList();

    return new FeedbackClassResponseModel(
      listClasses: classDtos,
    );
  }
}

class FeedbackClassModel {
  int classId;
  String className;
  String openingDate;
  String status;
  int slot;
  int subjectId;
  int branchId;
  int teacherId;
  int studentInClassId;

  FeedbackClassModel({
    this.classId,
    this.className,
    this.openingDate,
    this.status,
    this.slot,
    this.subjectId,
    this.branchId,
    this.teacherId,
    this.studentInClassId,
  });

  factory FeedbackClassModel.fromJson(Map<String, dynamic> json) {
    return FeedbackClassModel(
      classId: json['classId'] != null ? json['classId'] : 0,
      className: json['className'] != null ? json['className'] : "",
      openingDate:
          json['classOpeningDate'] != null ? json['classOpeningDate'] : "",
      status: json['classStatus'] != null ? json['status'] : "",
      slot: json['classSlot'] != null ? json['slot'] : 0,
      subjectId: json['subjectId'] != null ? json['subjectId'] : 0,
      branchId: json['branchId'] != null ? json['branchId'] : 0,
      teacherId: json['teacherId'] != null ? json['teacherId'] : 0,
      studentInClassId:
          json['studentInClassId'] != null ? json['studentInClassId'] : 0,
    );
  }
}
