import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/size_config.dart';

class AppColor {
  static const Color greenTheme = Color(0xff3DD598);
  static Color greenTheme2 = Color(0xff3ED598);
  static const Color blueForText = Color(0xff62707F);
  static const Color grayDisable = Color(0xfff6f6f8);
  static const Color orange = Color(0xffff7648);
}

// height of the 'Gallery' header
const double galleryHeaderHeight = 64;

// The font size delta for headline4 font.
const double desktopDisplay1FontDelta = 16;

// The width of the settingsDesktop.
const double desktopSettingsWidth = 520;

// Sentinel value for the system text scale factor option.
const double systemTextScaleFactorOption = -1;

// The splash page animation duration.
const splashPageAnimationDurationInMilliseconds = 300;

// The desktop top padding for a page's first header (e.g. Gallery, Settings)
const firstHeaderDesktopTopPadding = 5.0;

const kPrimaryColor = Color(0xff3DD598);
const kPrimaryLightColor = Color(0xff3DD598);
const kPrimaryGradientColor = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFA53E), Color(0xFFFF7643)],
);
const kSecondaryColor = Color(0xFF979797);
const kTextColor = Color(0xFF757575);

const kAnimationDuration = Duration(milliseconds: 200);

final headingStyle = TextStyle(
  fontSize: getProportionateScreenWidth(28),
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

const defaultDuration = Duration(milliseconds: 250);

// Form Error
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String kEmailNullError = "Please Enter your email";
const String kUsernameNullError = "Xin vui lòng nhập tài khoản";
const String kInvalidEmailError = "Please Enter Valid Email";
const String kPassNullError = "Xin vui lòng nhập mật khẩu";
const String kShortPassError = "Mật khẩu quá ngắn (lớn hơn 5 ký tự)";
const String kMatchPassError = "Passwords don't match";
const String kNamelNullError = "Please Enter your name";
const String kPhoneNumberNullError = "Please Enter your phone number";
const String kAddressNullError = "Please Enter your address";
const String kAccountWrongError = "Tài khoản hoặc mật khẩu không hợp lệ";
const String kUsernameWrongError = "Tài khoản không hợp lệ";
final otpInputDecoration = InputDecoration(
  contentPadding:
      EdgeInsets.symmetric(vertical: getProportionateScreenWidth(15)),
  border: outlineInputBorder(),
  focusedBorder: outlineInputBorder(),
  enabledBorder: outlineInputBorder(),
);

OutlineInputBorder outlineInputBorder() {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(getProportionateScreenWidth(15)),
    borderSide: BorderSide(color: kTextColor),
  );
}
