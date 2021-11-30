import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/component/CustomSurfixIcon.dart';
import 'package:lcss_mobile_app/component/FormError.dart';
import 'package:lcss_mobile_app/helper/keyboard.dart';

import 'package:lcss_mobile_app/component/DefaultButton.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/model/login_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../size_config.dart';

class SignForm extends StatefulWidget {
  const SignForm({Key key, this.prefs}) : super(key: key);

  @override
  _SignFormState createState() => _SignFormState();

  final SharedPreferences prefs;
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  String username;
  String password;
  bool remember = false;
  final List<String> errors = [];
  LoginRequestModel loginRequestModel;
  bool _isLoading = false;
  SharedPreferences prefs;
  bool firstLogin = true;

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loadUsernameFromPref();
      // loadRememberPassword();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      loadUsernameFromPref();
      // loadRememberPassword();
    });
  }

  // not use this anymore due to security
  // void loadRememberPassword() {
  //   if (prefs.getString("password") != null) {
  //     setState(() {
  //       password = prefs.getString("password");
  //       print(password);
  //     });
  //   }
  // }

  void loadUsernameFromPref() {
    if (widget.prefs != null) {
      if (!firstLogin) {
        if (widget.prefs.getString("username") != null) {
          setState(() {
            username = prefs.getString("username");
            print(username);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildUsernameFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              Text("Nhớ mật khẩu"),
              Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, "/forgotPassword"),
                child: Text(
                  "Quên mật khẩu",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Đăng nhập",
            textLoading: "Xin vui lòng chờ",
            loading: _isLoading,
            press: () async {
              if (_formKey.currentState.validate()) {
                _formKey.currentState.save();
                removeError(error: kAccountWrongError);
                setState(() {
                  _isLoading = true;
                });
                loginRequestModel = new LoginRequestModel();
                loginRequestModel.username = username;
                loginRequestModel.password = password;
                APIService apiService = new APIService();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                apiService.login(loginRequestModel, remember).then((value) {
                  if (value != null) {
                    prefs.setString("jwt", value.jwt);
                    prefs.setInt("branchId", value.branchId);
                    apiService.setTokenLogin(value.jwt);
                    if (value.role == 'student') {
                      // ok
                      setState(() {
                        _isLoading = false;
                      });
                      firstLogin = false;
                      // if all are valid then go to success screen
                      KeyboardUtil.hideKeyboard(context);
                      Navigator.pushNamed(context, "/onboarding");
                    }
                  } else {
                    addError(error: kAccountWrongError);
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 6) {
          removeError(error: kShortPassError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 6) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Mật khẩu",
        hintText: "Mật khẩu",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      keyboardType: TextInputType.name,
      initialValue: username != null ? username : "",
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kUsernameNullError);
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: kUsernameNullError);
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Tài khoản",
        hintText: "Tài khoản",
        // If  you are using latest version of flutter then lable text and hint text shown like this
        // if you r using flutter less then 1.20.* then maybe this is not working properly
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }
}
