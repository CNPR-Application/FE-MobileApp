import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lcss_mobile_app/model/login_model.dart';
import 'package:lcss_mobile_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("username", jsonDecode(msg)['username']);
      return LoginResponseModel.fromJson(await json.decode(response.body));
    } else {
      return null;
    }
  }

  Future<UserResponseModel> getUserData(String username) async {
    var url = Uri.parse(urlBase + "accounts/" + username);

    final response = await http.get(url);

    print(response);
    print(response);
    print(response);

    if (response.statusCode == 200) {
      return UserResponseModel.fromJson(jsonDecode(response.body));
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
  ) {
    var url = Uri.parse(urlBase + "accounts?username=" + username);

    return http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
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
  }
}
