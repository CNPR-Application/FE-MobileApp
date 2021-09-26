import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/attendance_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendanceBloc {
  final _repository = Repository();
  final _attendanceFetcher = PublishSubject<AttendanceResponseModel>();

  Stream<AttendanceResponseModel> get attendanceData =>
      _attendanceFetcher.stream;

  getAttendanceData(int classId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    AttendanceResponseModel attendanceModel =
        await _repository.getAttendanceData(username, classId);
    _attendanceFetcher.sink.add(attendanceModel);
  }

  dispose() {
    _attendanceFetcher.close();
  }
}

class Repository {
  final apiService = APIService();

  Future<AttendanceResponseModel> getAttendanceData(
          String username, int classId) =>
      apiService.getAttendanceStudentByClass(1, 100, username, classId);
}
