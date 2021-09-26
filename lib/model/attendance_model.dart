class AttendanceResponseModel {
  int pageNo;
  int pageSize;
  int totalPage;
  List<AttendanceModel> listAttendance;

  AttendanceResponseModel({
    this.pageNo,
    this.pageSize,
    this.totalPage,
    this.listAttendance,
  });

  factory AttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['attendanceList'] as List;
    print(list.runtimeType);
    List<AttendanceModel> attendanceDtos =
        list.map((i) => AttendanceModel.fromJson(i)).toList();

    return AttendanceResponseModel(
      pageNo: json['pageNo'] != null ? json['pageNo'] : 1,
      pageSize: json['pageSize'] != null ? json['pageSize'] : 2,
      totalPage: json['totalPage'] != null ? json['totalPage'] : 2,
      listAttendance: attendanceDtos,
    );
  }
}

class AttendanceModel {
  int attendanceId;
  int sessionId;
  String status;
  String checkingDate;
  int studentInClassId;

  AttendanceModel({
    this.attendanceId,
    this.sessionId,
    this.status,
    this.checkingDate,
    this.studentInClassId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attendanceId: json['attendanceId'] != null ? json['attendanceId'] : 0,
      sessionId: json['sessionId'] != null ? json['sessionId'] : 0,
      status: json['status'] != null ? json['status'] : "",
      checkingDate: json['checkingDate'] != null ? json['checkingDate'] : "",
      studentInClassId:
          json['studentInClassId'] != null ? json['studentInClassId'] : 0,
    );
  }
}
