import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/component/ForgotPassword.dart';
import 'package:lcss_mobile_app/component/LoginButton.dart';
import 'package:lcss_mobile_app/component/LoginForm.dart';
import 'package:lcss_mobile_app/component/Logo.dart';
import 'package:lcss_mobile_app/model/login_model.dart';
import 'package:lcss_mobile_app/screen/Login/loginAnimation.dart';
import 'package:lcss_mobile_app/screen/Login/styles.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String username;
  String password;
  AnimationController _loginButtonController;
  var animationStatus = 0;
  LoginRequestModel loginRequestModel;
  bool validating;
  bool isApiCallProcess;

  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text('Are you sure?'),
              actions: <Widget>[
                new TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new TextButton(
                  onPressed: () =>
                      Navigator.pushReplacementNamed(context, "/login"),
                  child: new Text('Yes'),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  void initState() {
    super.initState();
    username = "";
    password = "";
    _loginButtonController = new AnimationController(
      duration: new Duration(milliseconds: 3000),
      vsync: this,
    );
    loginRequestModel = new LoginRequestModel();
  }

  @override
  void dispose() {
    super.dispose();
    _loginButtonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: new Scaffold(
        body: new Container(
          decoration: new BoxDecoration(
            image: backgroundImage,
          ),
          child: new Container(
            decoration: new BoxDecoration(
              gradient: new LinearGradient(
                colors: <Color>[
                  const Color.fromRGBO(162, 146, 199, 0.8),
                  const Color.fromRGBO(51, 51, 63, 0.9),
                ],
                stops: [0.2, 1.0],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.0, 1.0),
              ),
            ),
            child: new ListView(
              padding: const EdgeInsets.all(0.0),
              children: <Widget>[
                new Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Logo(),
                        new LoginFormContainer(
                            initUsername: username,
                            initPassword: password,
                            callback: (u, p) {
                              setState(() {
                                username = u;
                                password = p;
                                loginRequestModel.username = u;
                                loginRequestModel.password = p;
                              });
                            }),
                        new ForgotPassword(),
                      ],
                    ),
                    // animation status = 0 : init
                    // animation status = 1 : success
                    // animation status = 2 : failed
                    animationStatus == 0
                        ? new Padding(
                            padding: const EdgeInsets.only(bottom: 50.0),
                            child: InkWell(
                              onTap: () {
                                // if validating success
                                APIService apiService = new APIService();
                                apiService
                                    .login(loginRequestModel)
                                    .then((value) {
                                  if (value != null) {
                                    if (value.role == 'student') {
                                      // ok
                                      setState(() {
                                        animationStatus = 1;
                                        _playAnimation();
                                      });
                                    }
                                  } else if (value == null) {
                                    setState(() {
                                      animationStatus = 2;
                                      _playAnimation();
                                    });
                                  }
                                });
                              },
                              child: new LogInButton(),
                            ),
                          )
                        : animationStatus == 1
                            ? new StaggerAnimation(
                                buttonController: _loginButtonController.view,
                                dataValid: true,
                              )
                            : new StaggerAnimation(
                                buttonController: _loginButtonController.view,
                                dataValid: false,
                              ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
