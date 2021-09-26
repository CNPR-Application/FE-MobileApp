import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/subject_model.dart';
import 'package:rxdart/subjects.dart';
import 'package:rxdart/rxdart.dart';

class SubjectBloc {
  final _repository = Repository();
  final _subjectFetcher = PublishSubject<SubjectResponseModel>();

  Stream<SubjectResponseModel> get subjectData => _subjectFetcher.stream;

  getSubjectData() async {
    SubjectResponseModel subjectModel = await _repository.getSubjectData();
    _subjectFetcher.sink.add(subjectModel);
  }

  dispose() {
    _subjectFetcher.close();
  }
}

class Repository {
  final apiService = APIService();

  Future<SubjectResponseModel> getSubjectData() =>
      apiService.getAllSubjectData(1, 100);
}
