import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/constant.dart';

import 'components/body.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static String routeName = "/forgot_password";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quên mật khẩu"),
        backgroundColor: AppColor.greenTheme,
      ),
      body: Body(),
    );
  }
}
