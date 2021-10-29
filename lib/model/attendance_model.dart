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
  String startTime;
  int studentInClassId;

  AttendanceModel({
    this.attendanceId,
    this.sessionId,
    this.status,
    this.startTime,
    this.studentInClassId,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      attendanceId: json['attendanceId'] != null ? json['attendanceId'] : 0,
      sessionId: json['sessionId'] != null ? json['sessionId'] : 0,
      status: json['status'] != null ? json['status'] : "",
      startTime: json['startTime'] != null ? json['startTime'] : "",
      studentInClassId:
          json['studentInClassId'] != null ? json['studentInClassId'] : 0,
    );
  }
}
