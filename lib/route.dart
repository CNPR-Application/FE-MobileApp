import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/screen/Login/login.dart';
import 'package:lcss_mobile_app/screen/Attendance/attendance_student.dart';
import 'package:lcss_mobile_app/screen/BookingHistory/booking_history.dart';
import 'package:lcss_mobile_app/screen/Class/my_class.dart';
import 'package:lcss_mobile_app/screen/Class/search_class.dart';
import 'package:lcss_mobile_app/screen/Edit/edit_profile.dart';
import 'package:lcss_mobile_app/screen/Feedback/feedback_list.dart';
import 'package:lcss_mobile_app/screen/Home/home.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:lcss_mobile_app/screen/Subject/search_subject.dart';
import 'package:lcss_mobile_app/screen/reply/app.dart' as reply;

class Routes {
  Routes() {
    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "LCSS Mobile App",
      debugShowCheckedModeBanner: false,
      home: new LoginScreen(),
      // ignore: missing_return
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case '/login':
            return new MyCustomRoute(
              builder: (_) => new LoginScreen(),
              settings: settings,
            );
          case '/home':
            return new MyCustomRoute(
              builder: (_) => new HomeScreen(),
              settings: settings,
            );
          case '/editProfile':
            return new MyCustomRoute(
              builder: (_) => new EditProfileScreen(),
              settings: settings,
            );
          case '/searchClass':
            return new MyCustomRoute(
              builder: (_) => new SearchClassPage(),
              settings: settings,
            );
          case '/searchSubject':
            return new MyCustomRoute(
              builder: (_) => new SearchSubject(),
              settings: settings,
            );
          case '/bookingHistory':
            return new MyCustomRoute(
              builder: (_) => new BookingHistoryPage(),
              settings: settings,
            );
          case '/myClass':
            return new MyCustomRoute(
              builder: (_) => new MyClassPage(),
              settings: settings,
            );
          case '/studentAttendance':
            return new MyCustomRoute(
              builder: (_) => new StudentClassAttendancePage(),
              settings: settings,
            );
          case '/checkFeedback':
            return new MyCustomRoute(
              builder: (_) => new FeedbackListPage(),
              settings: settings,
            );
          case '/reply':
            return new MyCustomRoute(
              builder: (_) => new StudyWrapper(
                  study: reply.ReplyApp(), hasBottomNavBar: false),
              settings: settings,
            );
          case '/onboarding':
            return new MyCustomRoute(
              builder: (_) => new Intro9(Colors.white),
              settings: settings,
            );
        }
      },
    );
  }
}

class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return new FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

// Crude counter to make messages unique
int _messageCount = 0;

/// The API endpoint here accepts a raw FCM payload for demonstration purposes.
String constructFCMPayload(String token) {
  _messageCount++;
  return jsonEncode({
    'token': token,
    'data': {
      'via': 'FlutterFire Cloud Messaging!!!',
      'count': _messageCount.toString(),
    },
    'notification': {
      'title': 'Hello FlutterFire!',
      'body': 'This notification (#$_messageCount) was created via FCM!',
    },
  });
}
