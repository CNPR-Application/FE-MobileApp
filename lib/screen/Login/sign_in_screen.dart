import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:lcss_mobile_app/size_config.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'components/body.dart';

class SignInScreen extends StatelessWidget {
  static String routeName = "/sign_in";
  DateTime currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    Future<bool> _onWillPop() {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: "Nhấn quay lại một lần nữa để thoát");
        return Future.value(false);
      }
      return exit(0);
    }

    SizeConfig().init(context);
    return WillPopScope(
      child: Scaffold(
        body: Body(),
        // body: LoginInit(),
      ),
      onWillPop: _onWillPop,
    );
  }
}
