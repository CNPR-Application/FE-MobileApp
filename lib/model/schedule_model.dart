class ScheduleResponseModel {
  ScheduleModel monday;
  ScheduleModel tuesday;
  ScheduleModel wednesday;
  ScheduleModel thursday;
  ScheduleModel friday;
  ScheduleModel saturday;
  ScheduleModel sunday;

  ScheduleResponseModel({
    this.monday,
    this.tuesday,
    this.wednesday,
    this.thursday,
    this.friday,
    this.saturday,
    this.sunday,
  });

  factory ScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleResponseModel(
      monday: ScheduleModel.fromJson(json['MONDAY']),
      tuesday: ScheduleModel.fromJson(json['TUESDAY']),
      wednesday: ScheduleModel.fromJson(json['WEDNESDAY']),
      thursday: ScheduleModel.fromJson(json['THURSDAY']),
      friday: ScheduleModel.fromJson(json['FRIDAY']),
      saturday: ScheduleModel.fromJson(json['SATURDAY']),
      sunday: ScheduleModel.fromJson(json['SUNDAY']),
    );
  }
}

class ScheduleModel {
  String datetime;
  List<SessionModel> listSession;

  ScheduleModel({
    this.datetime,
    this.listSession,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    var listSessionOfDay = json['sessionList'] as List;
    print(listSessionOfDay.runtimeType);
    List<SessionModel> sessionDtos =
        listSessionOfDay.map((i) => SessionModel.fromJson(i)).toList();

    return ScheduleModel(
      datetime: json['datetime'] != null ? json['datetime'] : "",
      listSession: sessionDtos,
    );
  }
}

class SessionModel {
  int sessionId;
  int classId;
  String className;
  int subjectId;
  String subjectName;
  int teacherId;
  String teacherName;
  String teacherImage;
  String teacherPhone;
  String roomName;
  String startTime;
  String endTime;

  SessionModel({
    this.sessionId,
    this.classId,
    this.className,
    this.subjectId,
    this.subjectName,
    this.teacherId,
    this.teacherName,
    this.teacherImage,
    this.teacherPhone,
    this.roomName,
    this.startTime,
    this.endTime,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      sessionId: json['sessionId'] != null ? json['sessionId'] : 0,
      classId: json['classId'] != null ? json['classId'] : 0,
      className: json['className'] != null ? json['className'] : "",
      subjectId: json['subjectId'] != null ? json['subjectId'] : 0,
      subjectName: json['subjectName'] != null ? json['subjectName'] : "",
      teacherId: json['teacherId'] != null ? json['teacherId'] : 0,
      teacherName: json['teacherName'] != null ? json['teacherName'] : "",
      teacherImage: json['teacherImage'] != null ? json['teacherImage'] : "",
      teacherPhone: json['teacherPhone'] != null ? json['teacherPhone'] : "",
      roomName: json['roomName'] != null ? json['roomName'] : "",
      startTime: json['startTime'] != null ? json['startTime'] : "",
      endTime: json['endTime'] != null ? json['endTime'] : "",
    );
  }
}
