import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  int branchId;

  // bool _onChanged = false;

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
          FutureBuilder<UserResponseModel>(
            future: widget.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                branchId = snapshot.data.branchModels.elementAt(0).branchId;
                return TextFieldWidget(
                  label: 'Tên',
                  text: snapshot.data.name,
                  onChanged: (name) {
                    nameUpdate = name;
                    print(name);
                    // setState(() {
                    //   _onChanged = true;
                    // });
                  },
                  number: false,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 24),
          FutureBuilder<UserResponseModel>(
            future: widget.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TextFieldWidget(
                  label: 'Email',
                  text: snapshot.data.email,
                  onChanged: (email) {
                    emailUpdate = email;
                    print(email);
                  },
                  number: false,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 24),
          FutureBuilder<UserResponseModel>(
            future: widget.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                DateTime dt = DateTime.parse(snapshot.data.birthday);
                DateFormat formatter = new DateFormat('dd-MM-yyyy');
                return TextFieldWidget(
                  label: 'Ngày tháng năm sinh',
                  text: formatter.format(dt),
                  onChanged: (birthday) {
                    print(birthday);
                    birthdayUpdate = birthday;
                  },
                  number: false,
                  date: true,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 24),
          FutureBuilder<UserResponseModel>(
            future: widget.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TextFieldWidget(
                  label: 'Số điện thoại',
                  text: snapshot.data.phone,
                  onChanged: (phone) {
                    phoneUpdate = phone;
                    print(phoneUpdate);
                  },
                  number: true,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 24),
          FutureBuilder<UserResponseModel>(
            future: widget.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TextFieldWidget(
                  label: 'Số điện thoại phụ huynh',
                  text: snapshot.data.parentPhone,
                  onChanged: (parentPhone) => parentPhoneUpdate = parentPhone,
                  number: true,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 24),
          FutureBuilder<UserResponseModel>(
            future: widget.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TextFieldWidget(
                  label: 'Tên phụ huynh',
                  text: snapshot.data.parentName,
                  onChanged: (parentName) => parentNameUpdate = parentName,
                  number: false,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 24),
          FutureBuilder<UserResponseModel>(
            future: widget.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return TextFieldWidget(
                  label: 'Địa chỉ',
                  text: snapshot.data.address,
                  maxLines: 5,
                  onChanged: (address) => addressUpdate = address,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 24),
          // _onChanged == true ?
          InkWell(
            onTap: () {
              // save data
              showDialog(
                context: context,
                builder: (context) {
                  return new AlertDialog(
                    title: new Text('Are you sure to update your profile?'),
                    actions: <Widget>[
                      new TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: new Text('No'),
                      ),
                      new TextButton(
                        onPressed: () {
                          APIService apiService = new APIService();
                          apiService.updateUserData(
                              username,
                              nameUpdate,
                              addressUpdate,
                              emailUpdate,
                              birthdayUpdate,
                              phoneUpdate,
                              branchId,
                              parentPhoneUpdate,
                              parentNameUpdate);
                          Navigator.of(context).pop(false);
                          showDialog(
                              context: context,
                              builder: (context) {
                                return new AlertDialog(
                                  title: new Text('Data Update Succesfully!'),
                                  actions: <Widget>[
                                    new TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(true),
                                      child: new Text('Done'),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: new Text('Yes'),
                      ),
                    ],
                  );
                },
              );
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
          ),
          // : Container(
          //     width: 100,
          //     height: 45,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(20)),
          //       color: Colors.blueGrey[200],
          //     ),
          //     child: Align(
          //       alignment: Alignment.center,
          //       child: Text(
          //         'Save',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
