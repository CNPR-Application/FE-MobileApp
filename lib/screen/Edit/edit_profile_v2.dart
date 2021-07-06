/**
 * Author: Aparna Dulal
 * profile: https://github.com/ambikadulal
  */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/user_model.dart';

typedef StringValue = String Function(String);

class EditPage extends StatefulWidget {
  EditPage({Key key, this.username}) : super(key: key);
  Function callback;

  Future<UserResponseModel> userData;
  String username;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool showPassword = false;

  String username;
  String nameSaved;
  String addressSaved;
  String emailSaved;
  String birthdaySaved;
  String phoneSaved;
  int branchId;
  String parentPhoneSaved;
  String parentNameSaved;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIService apiService = new APIService();
    widget.userData = apiService.getUserData(widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserResponseModel>(
      future: widget.userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          branchId = snapshot.data.branchModels.elementAt(0).branchId;
          username = snapshot.data.username;
          DateTime dt = DateTime.parse(snapshot.data.birthday);
          DateFormat formatter = new DateFormat('dd-MM-yyyy');
          APIService apiService = new APIService();
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              elevation: 1,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: AppColor.greenTheme,
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              actions: [
                IconButton(
                  icon: Icon(
                    Icons.notifications,
                    color: AppColor.greenTheme,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            body: Container(
              padding: EdgeInsets.only(left: 16, top: 25, right: 16),
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: ListView(
                  children: [
                    Text(
                      "Chỉnh sửa thông tin",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      snapshot.data.image,
                                    ))),
                          ),
                          Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  color: AppColor.greenTheme,
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    buildTextField("Họ và tên", snapshot.data.name, false,
                        callback: (value) => nameSaved = value),
                    buildTextField("E-mail", snapshot.data.email, false,
                        callback: (value) => emailSaved = value),
                    buildTextField("Số điện thoại", snapshot.data.phone, false,
                        callback: (value) {
                      print(value);
                      return phoneSaved = value;
                    }),
                    buildDateField("Ngày sinh", formatter.format(dt), false,
                        callback: (value) {
                      print(value);
                      return birthdaySaved = value;
                    }),
                    buildTextField("Địa chỉ", snapshot.data.address, false,
                        callback: (value) => addressSaved = value),
                    buildTextField("Số điện thoại phụ huynh",
                        snapshot.data.parentPhone, false,
                        callback: (value) => parentPhoneSaved = value),
                    buildTextField(
                        "Tên phụ huynh", snapshot.data.parentName, false,
                        callback: (value) => parentNameSaved = value),
                    SizedBox(
                      height: 35,
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () {},
                    child: Text("CANCEL",
                        style: TextStyle(
                            fontSize: 14,
                            letterSpacing: 2.2,
                            color: Colors.black)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (nameSaved != null &&
                          addressSaved != null &&
                          emailSaved != null &&
                          birthdaySaved != null &&
                          phoneSaved != null &&
                          branchId != null &&
                          parentPhoneSaved != null &&
                          parentNameSaved != null) {
                        setState(() {
                          var response = apiService.updateUserData(
                              username,
                              nameSaved,
                              addressSaved,
                              emailSaved,
                              birthdaySaved,
                              phoneSaved,
                              branchId,
                              parentPhoneSaved,
                              parentNameSaved);
                          print(response.toString());
                          widget.userData = apiService.getUserData(username);
                        });
                        showDialog(
                          context: context,
                          builder: (context) {
                            return new AlertDialog(
                              title: new Text('Thông tin đã được chỉnh sửa!'),
                              actions: <Widget>[
                                new TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: new Text('Xác nhận'),
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return new AlertDialog(
                              title: new Text(
                                  'Xin vui lòng điền hết thông tin để cập nhật'),
                              actions: <Widget>[
                                new TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: new Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: AppColor.greenTheme,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        } else
          return CircularProgressIndicator();
      },
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField,
      {StringValue callback}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onChanged: (String value) {
          callback(value);
        },
      ),
    );
  }

  Widget buildDateField(
      String labelText, String placeholder, bool isPasswordTextField,
      {StringValue callback}) {
    TextEditingController controller = new TextEditingController();
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.grey,
                  ),
                )
              : null,
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        onChanged: (String value) {
          callback(value);
        },
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2022))
              .then((value) {
            DateFormat formatter = new DateFormat('yyyy-MM-dd');
            controller.text = formatter.format(value);
            callback(formatter.format(value));
          });
        },
      ),
    );
  }
}
