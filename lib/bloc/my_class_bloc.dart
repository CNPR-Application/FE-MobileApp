import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/myclass_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyClassBloc {
  final _repository = Repository();
  final _myClassFetcher = PublishSubject<MyClassResponseModel>();

  Stream<MyClassResponseModel> get classData => _myClassFetcher.stream;

  getMyClassData(String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    MyClassResponseModel classModel =
        await _repository.getMyClassData(username, status);
    _myClassFetcher.sink.add(classModel);
  }

  dispose() {
    _myClassFetcher.close();
  }
}

class Repository {
  final apiService = APIService();

  Future<MyClassResponseModel> getMyClassData(
      String username, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");
    apiService.setTokenLogin(jwt);
    return apiService.getClassByStatus(1, 100, username, status);
  }
}
