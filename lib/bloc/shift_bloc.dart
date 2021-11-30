import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/shift_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShiftBloc {
  final _repository = Repository();
  final _shiftFetcher = PublishSubject<ShiftResponseModel>();

  Stream<ShiftResponseModel> get shiftData => _shiftFetcher.stream;

  getShiftData() async {
    ShiftResponseModel shiftModel = await _repository.getShiftData();
    _shiftFetcher.sink.add(shiftModel);
  }

  dispose() {
    _shiftFetcher.close();
  }
}

class Repository {
  final apiService = APIService();

  Future<ShiftResponseModel> getShiftData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");
    apiService.setTokenLogin(jwt);
    return apiService.getAllShiftData(1, 100);
  }
}
