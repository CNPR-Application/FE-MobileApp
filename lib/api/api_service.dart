import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lcss_mobile_app/model/attendance_model.dart';
import 'package:lcss_mobile_app/model/booking_model.dart';
import 'package:lcss_mobile_app/model/class_model.dart';
import 'package:lcss_mobile_app/model/feedback_class_model..dart';
import 'package:lcss_mobile_app/model/feedback_data_model.dart';
import 'package:lcss_mobile_app/model/login_model.dart';
import 'package:lcss_mobile_app/model/myclass_model.dart';
import 'package:lcss_mobile_app/model/notification_model.dart';
import 'package:lcss_mobile_app/model/schedule_model.dart';
import 'package:lcss_mobile_app/model/shift_model.dart';
import 'package:lcss_mobile_app/model/subject_detail_model.dart';
import 'package:lcss_mobile_app/model/subject_model.dart';
import 'package:lcss_mobile_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class APIService {
  var urlBase = "https://lcss-fa21.herokuapp.com/";

  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    var url = Uri.parse(urlBase + "login");

    final msg = jsonEncode(loginRequestModel);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: msg,
    );

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", jsonDecode(msg)['username']);
      // prefs.setInt("branchId", jsonDecode(msg)['branchId']);
      return LoginResponseModel.fromJson(await json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<UserResponseModel> getUserData(String username) async {
    var url = Uri.parse(urlBase + "accounts/" + username);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);
    print(response.body);
    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return UserResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<http.Response> updateUserData(
    String username,
    String name,
    String address,
    String email,
    String birthday,
    String phone,
    int branchId,
    String parentPhone,
    String parentName,
  ) async {
    var url = Uri.parse(urlBase + "accounts?username=" + username);

    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'address': address,
        'email': email,
        'birthday': birthday,
        'phone': phone,
        'branchId': branchId,
        'parentPhone': parentPhone,
        'parentName': parentName,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to update user data.');
    }
  }

  Future<ShiftResponseModel> getAllShiftData(int pageNo, int pageSize) async {
    var url = Uri.parse(urlBase +
        "shifts?isAvailable=1&pageNo=" +
        pageNo.toString().trim() +
        "&pageSize=" +
        pageSize.toString().trim());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return ShiftResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<SubjectResponseModel> getAllSubjectData(
      int pageNo, int pageSize) async {
    var url = Uri.parse(urlBase +
        "subjects?name=&isAvailable=True&pageNo=" +
        pageNo.toString().trim() +
        "&pageSize=" +
        pageSize.toString().trim());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return SubjectResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<ClassResponseModel> getAllWaitingClass(
      int pageNo, int pageSize, int branchId) async {
    print(branchId.toString());
    var url = Uri.parse(urlBase +
        "classes/" +
        branchId.toString().trim() +
        "/filter?" +
        "subjectId=0&shiftId=0&status=waiting&pageNo=" +
        pageNo.toString().trim() +
        "&pageSize=" +
        pageSize.toString().trim());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return ClassResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<BookingResponseModel> getAllBookingOfStudent(
      int pageNo, int pageSize, String username) async {
    var url = Uri.parse(urlBase +
        "bookings?studentUsername=" +
        username +
        "&pageNo=" +
        pageNo.toString().trim() +
        "&pageSize=" +
        pageSize.toString().trim());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return BookingResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<SubjectDetailResponseModel> getSubjectDetail(
      int pageNo, int pageSize, int subjectId) async {
    var url = Uri.parse(urlBase +
        "subjects/details?subjectId=" +
        subjectId.toString() +
        "&isAvailable=true&pageNo=" +
        pageNo.toString().trim() +
        "&pageSize=" +
        pageSize.toString().trim());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return SubjectDetailResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<MyClassResponseModel> getClassByStatus(
      int pageNo, int pageSize, String username, String status) async {
    var url = Uri.parse(urlBase +
        "student-class/" +
        username +
        "?status=" +
        status +
        "&pageNo=" +
        pageNo.toString().trim() +
        "&pageSize=" +
        pageSize.toString().trim());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return MyClassResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<AttendanceResponseModel> getAttendanceStudentByClass(
      int pageNo, int pageSize, String username, int classId) async {
    var url = Uri.parse(urlBase +
        "attendance/" +
        username +
        "/?classId=" +
        classId.toString() +
        "&pageNo=" +
        pageNo.toString().trim() +
        "&pageSize=" +
        pageSize.toString().trim());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return AttendanceResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<FeedbackClassResponseModel> getFeedBackClassByUsername(
      String username) async {
    var url = Uri.parse(urlBase + "student-feedback-class/" + username);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return FeedbackClassResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<http.Response> sendFeedbackData(FeedbackDataModel feedbackData) async {
    var url = Uri.parse(urlBase + "feedback");

    var response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, dynamic>{
        'studentInClassId': feedbackData.studentInClassId,
        'subjectId': feedbackData.subjectId,
        'teacherId': feedbackData.teacherId,
        'teacherRating': feedbackData.subjectRating,
        'subjectRating': feedbackData.subjectRating,
        'feedback': feedbackData.feedback,
      }),
    );

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to send feedback data.');
    }
  }

  Future<NotificationResponseModel> getAllNotificationOfStudent(
      int pageNo, int pageSize, String username) async {
    var url = Uri.parse(urlBase +
        "notification/" +
        username +
        "?pageNo=" +
        pageNo.toString().trim() +
        "&pageSize=" +
        pageSize.toString().trim());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return NotificationResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }

  Future<ScheduleResponseModel> getScheduleData(
      String username, String searchDate) async {
    var url = Uri.parse(urlBase +
        "schedules?studentUsername=" +
        username +
        "&srchDate=" +
        searchDate.toString().trim());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print(response.body);

    final decodeData = utf8.decode(response.bodyBytes);

    if (response.statusCode == 200) {
      return ScheduleResponseModel.fromJson(jsonDecode(decodeData));
    } else {
      return null;
    }
  }
}
