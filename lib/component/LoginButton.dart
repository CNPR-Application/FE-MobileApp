import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/constant.dart';

class LogInButton extends StatelessWidget {
  LogInButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: AppColor.greenTheme,
        borderRadius: BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: new Text(
        "Đăng nhập",
        style: new TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
