class NotificationResponseModel {
  int pageNo;
  int pageSize;
  int totalPage;
  List<NotificationModel> listNotification;
  NotificationResponseModel({
    this.pageNo,
    this.pageSize,
    this.totalPage,
    this.listNotification,
  });

  factory NotificationResponseModel.fromJson(Map<String, dynamic> json) {
    var list = json['notificationList'] as List;
    print(list.runtimeType);
    List<NotificationModel> notificationDtos =
        list.map((i) => NotificationModel.fromJson(i)).toList();

    return NotificationResponseModel(
      pageNo: json['pageNo'] != null ? json['pageNo'] : 1,
      pageSize: json['pageSize'] != null ? json['pageSize'] : 2,
      totalPage: json['totalPage'] != null ? json['totalPage'] : 2,
      listNotification: notificationDtos,
    );
  }
}

class NotificationModel {
  int notificationId;
  String senderUsername;
  String receiverUsername;
  String title;
  String body;
  String creatingDate;
  String lastModified;
  bool read;

  NotificationModel({
    this.notificationId,
    this.senderUsername,
    this.receiverUsername,
    this.title,
    this.body,
    this.creatingDate,
    this.lastModified,
    this.read,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId:
          json['notificationId'] != null ? json['notificationId'] : 0,
      senderUsername:
          json['senderUsername'] != null ? json['senderUsername'] : "",
      receiverUsername:
          json['receiverUsername'] != null ? json['receiverUsername'] : "",
      title: json['title'] != null ? json['title'] : "",
      body: json['body'] != null ? json['body'] : "",
      creatingDate: json['creatingDate'] != null ? json['creatingDate'] : "",
      lastModified: json['lastModified'] != null ? json['lastModified'] : "",
      read: json['read'] != null ? json['read'] : false,
    );
  }
}
