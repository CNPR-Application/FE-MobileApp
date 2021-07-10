class BookingResponseModel {
  int pageNo;
  int pageSize;
  int totalPage;
  List<BookingModel> listBooking;

  BookingResponseModel({
    this.pageNo,
    this.pageSize,
    this.totalPage,
    this.listBooking,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['bookingSearchResponseDtoList'] as List;
    print(list.runtimeType);
    List<BookingModel> bookDtos =
        list.map((i) => BookingModel.fromJson(i)).toList();

    return BookingResponseModel(
      pageNo: json['pageNo'] != null ? json['pageNo'] : 1,
      pageSize: json['pageSize'] != null ? json['pageSize'] : 2,
      totalPage: json['totalPage'] != null ? json['totalPage'] : 2,
      listBooking: bookDtos,
    );
  }
}

class BookingModel {
  int bookingId;
  String payingDate;
  int subjectId;
  String subjectName;
  int shiftId;
  String shiftDescription;
  int studentId;
  String studentName;
  String image;
  String status;
  int branchId;
  String branchName;
  double payingPrice;
  String desription;

  BookingModel({
    this.bookingId,
    this.payingDate,
    this.subjectId,
    this.subjectName,
    this.shiftId,
    this.shiftDescription,
    this.studentId,
    this.studentName,
    this.image,
    this.status,
    this.branchId,
    this.branchName,
    this.payingPrice,
    this.desription,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['bookingId'] != null ? json['bookingId'] : 0,
      payingDate: json['payingDate'] != null ? json['payingDate'] : "",
      subjectId: json['subjectId'] != null ? json['subjectId'] : 0,
      subjectName: json['subjectName'] != null ? json['subjectName'] : "",
      shiftId: json['shiftId'] != null ? json['shiftId'] : 0,
      shiftDescription:
          json['shiftDescription'] != null ? json['shiftDescription'] : "",
      studentId: json['studentId'] != null ? json['subjstudentIdectName'] : 0,
      studentName: json['studentName'] != null ? json['studentName'] : "",
      image: json['image'] != null ? json['image'] : "",
      status: json['status'] != null ? json['status'] : "",
      branchId: json['branchId'] != null ? json['branchId'] : 0,
      branchName: json['branchName'] != null ? json['branchName'] : "",
      payingPrice: json['payingPrice'] != null ? json['payingPrice'] : 0.0,
      desription: json['desription'] != null ? json['desription'] : "",
    );
  }
}
