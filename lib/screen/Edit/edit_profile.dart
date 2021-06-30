import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/component/ProfileWidget.dart';
import 'package:lcss_mobile_app/component/TextFieldWidget.dart';
import 'package:lcss_mobile_app/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key key, this.userData}) : super(key: key);

  final Future<UserResponseModel> userData;

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String username,
      nameUpdate,
      addressUpdate,
      emailUpdate,
      birthdayUpdate,
      phoneUpdate,
      parentPhoneUpdate,
      parentNameUpdate;
  int branchIdUpdate;

  @override
  void initState() {
    super.initState();
    callLoad();
  }

  callLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    print(username);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chỉnh sửa thông tin cá nhân'),
        backgroundColor: AppColor.greenTheme,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath:
                'https://images.unsplash.com/photo-1558898479-33c0057a5d12?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
            isEdit: true,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Tên',
            text: 'Quang',
            onChanged: (name) => nameUpdate = name,
            number: false,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Email',
            text: 'quanghnse140846@fpt.edu.vn',
            onChanged: (email) => emailUpdate = email,
            number: false,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Ngày tháng năm sinh',
            text: '29/10/2000',
            onChanged: (birthday) => birthdayUpdate = birthday,
            number: false,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Số điện thoại',
            text: '0778181918',
            onChanged: (phone) => phoneUpdate = phone,
            number: false,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Số điện thoại phụ huynh',
            text: '0962564872',
            onChanged: (parentPhone) => parentPhoneUpdate = parentPhone,
            number: false,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Tên phụ huynh',
            text: 'Example',
            onChanged: (parentName) => parentNameUpdate = parentName,
            number: false,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Mã chi nhánh',
            text: '7',
            onChanged: (branchId) => branchIdUpdate = branchId as int,
            number: true,
          ),
          const SizedBox(height: 24),
          TextFieldWidget(
            label: 'Địa chỉ',
            text: 'Địa chỉ nhà',
            maxLines: 5,
            onChanged: (address) => addressUpdate = address,
            number: false,
          ),
          const SizedBox(height: 24),
          InkWell(
            onTap: () {
              // save data
              APIService apiService = new APIService();
              apiService.updateUserData(
                  username,
                  nameUpdate,
                  addressUpdate,
                  emailUpdate,
                  birthdayUpdate,
                  phoneUpdate,
                  branchIdUpdate,
                  parentPhoneUpdate,
                  parentNameUpdate);
            },
            child: Container(
              width: 100,
              height: 45,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: AppColor.greenTheme,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
