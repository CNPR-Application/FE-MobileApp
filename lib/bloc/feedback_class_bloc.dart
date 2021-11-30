import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/feedback_class_model..dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackClassBloc {
  final _repository = Repository();
  final _feedbackClassFetcher = PublishSubject<FeedbackClassResponseModel>();

  Stream<FeedbackClassResponseModel> get feedbackClassData =>
      _feedbackClassFetcher.stream;

  getFeedbackClassData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString("username");
    FeedbackClassResponseModel feedbackClassModel =
        await _repository.getMyClassData(username);
    _feedbackClassFetcher.sink.add(feedbackClassModel);
  }

  dispose() {
    _feedbackClassFetcher.close();
  }
}

class Repository {
  final apiService = APIService();

  Future<FeedbackClassResponseModel> getMyClassData(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jwt = prefs.getString("jwt");
    apiService.setTokenLogin(jwt);
    return apiService.getFeedBackClassByUsername(username);
  }
}
