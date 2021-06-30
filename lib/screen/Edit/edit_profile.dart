import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/constant.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin cá nhân'),
        backgroundColor: AppColor.greenTheme,
      ),
      body: Container(),
    );
  }
}
