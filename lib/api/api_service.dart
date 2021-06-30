import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lcss_mobile_app/model/login_model.dart';

class APIService {
  var urlBase = "https://lcss.herokuapp.com/";

  Future<LoginResponseModel> login(LoginRequestModel loginRequestModel) async {
    var url = Uri.parse(urlBase + "login");

    final msg = jsonEncode(loginRequestModel);
    print(msg);
    print(msg);
    print(msg);

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: msg,
    );

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(await json.decode(response.body));
    } else {
      return null;
    }
  }
}
