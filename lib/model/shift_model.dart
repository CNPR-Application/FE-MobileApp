class ShiftResponseModel {
  int pageNo;
  int pageSize;
  int totalPage;
  List<ShiftModel> listShift;

  ShiftResponseModel({
    this.pageNo,
    this.pageSize,
    this.totalPage,
    this.listShift,
  });

  factory ShiftResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['shiftDtos'] as List;
    print(list.runtimeType);
    List<ShiftModel> shiftDtos =
        list.map((i) => ShiftModel.fromJson(i)).toList();

    return ShiftResponseModel(
      pageNo: json['pageNo'] != null ? json['pageNo'] : 1,
      pageSize: json['pageSize'] != null ? json['pageSize'] : 2,
      totalPage: json['totalPage'] != null ? json['totalPage'] : 2,
      listShift: shiftDtos,
    );
  }
}

class ShiftModel {
  int shiftId;
  String timeStart;
  String timeEnd;
  String dayOfWeek;
  int duration;
  bool available;

  ShiftModel(
      {this.shiftId,
      this.timeStart,
      this.timeEnd,
      this.dayOfWeek,
      this.duration,
      this.available});

  factory ShiftModel.fromJson(Map<String, dynamic> json) {
    return ShiftModel(
      shiftId: json['shiftId'] != null ? json['shiftId'] : 0,
      timeStart: json['timeStart'] != null ? json['timeStart'] : "",
      timeEnd: json['timeEnd'] != null ? json['timeEnd'] : "",
      dayOfWeek: json['dayOfWeek'] != null ? json['dayOfWeek'] : "",
      duration: json['duration'] != null ? json['duration'] : 0,
      available: json['available'] != null ? json['available'] : false,
    );
  }
}
