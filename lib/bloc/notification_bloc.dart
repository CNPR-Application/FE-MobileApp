import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/notification_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationBloc {
  final _repository = Repository();
  final _myNotificationFetcher = PublishSubject<NotificationResponseModel>();

  Stream<NotificationResponseModel> get notificationData =>
      _myNotificationFetcher.stream;

  getAllNotificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    NotificationResponseModel notificationModel =
        await _repository.getAllNotificationData(username);
    _myNotificationFetcher.sink.add(notificationModel);
  }

  dispose() {
    _myNotificationFetcher.close();
  }
}

class Repository {
  final apiService = APIService();

  Future<NotificationResponseModel> getAllNotificationData(
      String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");
    apiService.setTokenLogin(jwt);
    return apiService.getAllNotificationOfStudent(1, 100, username);
  }
}
