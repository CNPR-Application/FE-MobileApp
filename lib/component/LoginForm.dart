import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Component/InputField.dart';

class LoginFormContainer extends StatelessWidget {
  FocusNode _focusNodeUsername = new FocusNode();
  FocusNode _focusNodePassword = new FocusNode();
  TextEditingController _controllerUsername = new TextEditingController();
  TextEditingController _controllerPassword = new TextEditingController();

  String initUsername;
  String initPassword;

  LoginFormContainer({
    this.callback,
    this.initUsername,
    this.initPassword,
  });

  Function(String, String) callback;

  void _onLostFocusUsername() {
    if (!_focusNodeUsername.hasFocus)
      callback(_controllerUsername.text, _controllerPassword.text);
  }

  void _onLostFocusPassword() {
    if (!_focusNodePassword.hasFocus)
      callback(_controllerUsername.text, _controllerPassword.text);
  }

  @override
  Widget build(BuildContext context) {
    _focusNodeUsername.addListener(_onLostFocusUsername);
    _focusNodePassword.addListener(_onLostFocusPassword);
    _controllerUsername.text = initUsername;
    _controllerPassword.text = initPassword;
    return Container(
      margin: new EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new InputFieldArea(
                  focusNode: _focusNodeUsername,
                  controller: _controllerUsername,
                  hint: "Tài khoản",
                  obscure: false,
                  icon: Icons.person_outline,
                ),
                new InputFieldArea(
                  focusNode: _focusNodePassword,
                  controller: _controllerPassword,
                  hint: "Mật khẩu",
                  obscure: true,
                  icon: Icons.lock_outline,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
