import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword();

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 160.0,
      ),
      child: new Text(
        "Forgot your password? Click here",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        softWrap: true,
        style: new TextStyle(
          fontWeight: FontWeight.w300,
          letterSpacing: 0.5,
          color: Colors.white,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
