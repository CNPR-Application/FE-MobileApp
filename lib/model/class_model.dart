class ClassResponseModel {
  int pageNo;
  int pageSize;
  int pageTotal;
  List<ClassModel> listClasses;

  ClassResponseModel({
    this.pageNo,
    this.pageSize,
    this.pageTotal,
    this.listClasses,
  });

  factory ClassResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['classList'] as List;
    print(list.runtimeType);
    List<ClassModel> classDtos =
        list.map((i) => ClassModel.fromJson(i)).toList();

    return ClassResponseModel(
      pageNo: json['pageNo'] != null ? json['pageNo'] : 1,
      pageSize: json['pageSize'] != null ? json['pageSize'] : 2,
      pageTotal: json['pageTotal'] != null ? json['pageTotal'] : 2,
      listClasses: classDtos,
    );
  }
}

class ClassModel {
  int classId;
  String className;
  String openingDate;
  String status;
  int slot;
  int subjectId;
  String subjectName;
  int branchId;
  String branchName;
  int shiftId;
  String shiftDescription;
  int teacherId;
  String teacherName;
  int roomNo;
  int numberOfStudent;

  ClassModel({
    this.classId,
    this.className,
    this.openingDate,
    this.status,
    this.slot,
    this.subjectId,
    this.subjectName,
    this.branchId,
    this.branchName,
    this.shiftId,
    this.shiftDescription,
    this.teacherId,
    this.teacherName,
    this.roomNo,
    this.numberOfStudent,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      classId: json['classId'] != null ? json['classId'] : 0,
      className: json['className'] != null ? json['className'] : "",
      openingDate: json['openingDate'] != null ? json['openingDate'] : "",
      status: json['status'] != null ? json['status'] : "",
      slot: json['slot'] != null ? json['slot'] : 0,
      subjectId: json['subjectId'] != null ? json['subjectId'] : 0,
      subjectName: json['subjectName'] != null ? json['subjectName'] : "",
      branchId: json['branchId'] != null ? json['branchId'] : 0,
      branchName: json['branchName'] != null ? json['branchName'] : "",
      shiftId: json['shiftId'] != null ? json['shiftId'] : 0,
      shiftDescription:
          json['shiftDescription'] != null ? json['shiftDescription'] : "",
      teacherId: json['teacherId'] != null ? json['teacherId'] : 0,
      teacherName: json['teacherName'] != null ? json['teacherName'] : "",
      roomNo: json['roomNo'] != null ? json['roomNo'] : 0,
      numberOfStudent:
          json['numberOfStudent'] != null ? json['numberOfStudent'] : 0,
    );
  }
}
