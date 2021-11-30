import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/component/CustomSurfixIcon.dart';
import 'package:lcss_mobile_app/component/DefaultButton.dart';
import 'package:lcss_mobile_app/component/FormError.dart';
import 'package:lcss_mobile_app/size_config.dart';
import 'package:lcss_mobile_app/Util/constant.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Column(
            children: [
              SizedBox(height: SizeConfig.screenHeight * 0.04),
              Text(
                "Quên mật khẩu",
                style: TextStyle(
                  fontSize: getProportionateScreenWidth(28),
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.005),
              Text(
                "Xin vui lòng nhập tài khoản và chúng tôi sẽ \ngửi mật khẩu cho email của bạn",
                textAlign: TextAlign.center,
              ),
              SizedBox(height: SizeConfig.screenHeight * 0.1),
              ForgotPassForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class ForgotPassForm extends StatefulWidget {
  @override
  _ForgotPassFormState createState() => _ForgotPassFormState();
}

class _ForgotPassFormState extends State<ForgotPassForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> errors = [];
  String username;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            onSaved: (newValue) => username = newValue,
            onChanged: (value) {
              if (value.isNotEmpty && errors.contains(kEmailNullError)) {
                setState(() {
                  errors.remove(kUsernameNullError);
                });
              }

              return null;
            },
            validator: (value) {
              if (value.isEmpty) {
                setState(() {
                  errors.add(kUsernameNullError);
                });
              }

              return null;
            },
            decoration: InputDecoration(
              labelText: "Tài khoản",
              hintText: "Nhập tài khoản khôi phục ở đây",
              // If  you are using latest version of flutter then lable text and hint text shown like this
              // if you r using flutter less then 1.20.* then maybe this is not working properly
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(30)),
          FormError(errors: errors),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
          DefaultButton(
            text: "Khôi phục mật khẩu",
            textLoading: "Xin vui lòng chờ",
            loading: _isLoading,
            press: () async {
              setState(() {
                errors.remove(kUsernameWrongError);
              });
              setState(() {
                _isLoading = true;
              });
              if (_formKey.currentState.validate()) {
                // Do what you want to do

                APIService apiService = new APIService();
                apiService.forgotPassword(username).then((value) => {
                      if (value.body == "true")
                        {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                    "Mật khẩu đã được gửi đến mail của user"),
                              );
                            },
                          )
                        }
                      else
                        {
                          setState(() {
                            errors.add(kUsernameWrongError);
                          })
                        }
                    });
              }
              setState(() {
                _isLoading = false;
              });
            },
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1),
        ],
      ),
    );
  }
}
