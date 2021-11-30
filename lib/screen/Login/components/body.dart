import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/component/Logo.dart';
import 'package:lcss_mobile_app/component/SocalCard.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:lcss_mobile_app/size_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_form.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: getProportionateScreenWidth(20)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // SizedBox(height: SizeConfig.screenHeight * 0.12),
                      // Text(
                      //   "Chào mừng đến với LCSS",
                      //   style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: getProportionateScreenWidth(28),
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                      Logo(
                        image: DecorationImage(
                          image: new ExactAssetImage(
                            'assets/images/cnpr_logo2.png',
                          ),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.005),
                      Text(
                        "Nhập tài khoản và mật khẩu  \nđể đăng nhập",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: getProportionateScreenWidth(18),
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.08),
                      SignForm(prefs: snapshot.data[0]),
                      SizedBox(height: SizeConfig.screenHeight * 0.08),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     SocalCard(
                      //       icon: "assets/icons/google-icon.svg",
                      //       press: () {},
                      //     ),
                      //     SocalCard(
                      //       icon: "assets/icons/facebook-2.svg",
                      //       press: () {},
                      //     ),
                      //     SocalCard(
                      //       icon: "assets/icons/twitter.svg",
                      //       press: () {},
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: getProportionateScreenHeight(20)),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else
          return LoginInit();
      },
      future: Future.wait([
        SharedPreferences.getInstance(),
        Future.delayed(const Duration(milliseconds: 500)),
      ]),
      // future: Future.delayed(new Duration(milliseconds: 500)),
    );
  }
}
