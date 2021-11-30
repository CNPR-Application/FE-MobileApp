/**
 * Author: Aparna Dulal
 * profile: https://github.com/ambikadulal
  */
import 'dart:convert';
import 'dart:io';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/avatar_update_model.dart';
import 'package:lcss_mobile_app/model/user_model.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef StringValue = String Function(String);

class EditPage extends StatefulWidget {
  EditPage({Key key, this.userData}) : super(key: key);
  Function callback;

  Future<UserResponseModel> userData;
  // String username;

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  bool showPassword = false;
  bool editedName = false;
  bool editedAddress = false;
  bool editedEmail = false;
  bool editedBirthday = false;
  bool editedPhone = false;
  bool editedParentPhone = false;
  bool editedParentName = false;

  String username;
  String nameSaved;
  String addressSaved;
  String emailSaved;
  String birthdaySaved;
  String phoneSaved;
  int branchId;
  String parentPhoneSaved;
  String parentNameSaved;

  File _imageFile;

  bool _loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // APIService apiService = new APIService();
    // widget.userData = apiService.getUserData(widget.username);
    _loading = false;
    editedName = false;
    editedAddress = false;
    editedEmail = false;
    editedBirthday = false;
    editedPhone = false;
    editedParentPhone = false;
    editedParentName = false;
  }

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imageFile = File(pickedImage.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _loading == true ? Intro10(Colors.blue) : Container(),
        Scaffold(
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
          body: FutureBuilder<UserResponseModel>(
            future: widget.userData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                branchId = snapshot.data.branchModels.elementAt(0).branchId;
                username = snapshot.data.username;

                if (!editedName) {
                  nameSaved = snapshot.data.name;
                }
                if (!editedEmail) {
                  emailSaved = snapshot.data.email;
                }
                if (!editedPhone) {
                  phoneSaved = snapshot.data.phone;
                }
                if (!editedAddress) {
                  addressSaved = snapshot.data.address;
                }
                if (!editedParentPhone) {
                  parentPhoneSaved = snapshot.data.parentPhone;
                }
                if (!editedParentName) {
                  parentNameSaved = snapshot.data.parentName;
                }

                DateTime dt = DateTime.parse(snapshot.data.birthday);
                DateFormat formatter = new DateFormat('dd-MM-yyyy');
                DateFormat formatterInit = new DateFormat('yyyy-MM-dd');
                birthdaySaved = formatterInit.format(dt);
                return Container(
                  padding: EdgeInsets.only(left: 16, top: 25, right: 16),
                  child: GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: ListView(
                      children: [
                        Text(
                          "Chỉnh sửa thông tin",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.w500),
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
                                    image: _imageFile == null
                                        ? NetworkImage(
                                            snapshot.data.image,
                                          )
                                        : FileImage(_imageFile),
                                  ),
                                ),
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
                                    child: IconButton(
                                      icon: Icon(Icons.edit),
                                      color: Colors.white,
                                      onPressed: () => pickImage(),
                                      padding: EdgeInsets.only(),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 35,
                        ),
                        buildTextField("Họ và tên", snapshot.data.name, false,
                            callback: (value) {
                          if (value.trim() != "") {
                            editedName = true;
                          } else {
                            editedName = false;
                          }
                          print(value);
                          return nameSaved = value;
                        }),
                        buildTextField("E-mail", snapshot.data.email, false,
                            callback: (value) {
                          if (value.trim() != "") {
                            editedEmail = true;
                          } else {
                            editedEmail = false;
                          }
                          return emailSaved = value;
                        }),
                        buildTextField(
                            "Số điện thoại", snapshot.data.phone, false,
                            callback: (value) {
                          print(value);
                          if (value.trim() != "") {
                            editedPhone = true;
                          } else {
                            editedPhone = false;
                          }
                          return phoneSaved = value;
                        }),
                        buildDateField("Ngày sinh", formatter.format(dt), false,
                            callback: (value) {
                          print(value);
                          if (value.trim() != "") {
                            editedBirthday = true;
                          } else {
                            editedBirthday = false;
                          }
                          return birthdaySaved = value;
                        }),
                        buildTextField("Địa chỉ", snapshot.data.address, false,
                            callback: (value) {
                          if (value.trim() != "") {
                            editedAddress = true;
                          } else {
                            editedAddress = false;
                          }
                          return addressSaved = value;
                        }),
                        buildTextField(
                            "Số điện thoại phụ huynh",
                            snapshot.data.parentPhone,
                            false, callback: (value) {
                          if (value.trim() != "") {
                            editedParentPhone = true;
                          } else {
                            editedParentPhone = false;
                          }
                          return parentPhoneSaved = value;
                        }),
                        buildTextField(
                            "Tên phụ huynh", snapshot.data.parentName, false,
                            callback: (value) {
                          if (value.trim() != "") {
                            editedParentName = true;
                          } else {
                            editedParentName = false;
                          }
                          return parentNameSaved = value;
                        }),
                        SizedBox(
                          height: 35,
                        ),
                      ],
                    ),
                  ),
                );
              } else
                return CircularProgressIndicator();
            },
          ),
          bottomNavigationBar: Container(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () {},
                  child: Text("HỦY",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.black)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (nameSaved != null &&
                        nameSaved.trim() != "" &&
                        addressSaved != null &&
                        addressSaved.trim() != "" &&
                        emailSaved != null &&
                        emailSaved.trim() != "" &&
                        birthdaySaved != null &&
                        birthdaySaved.trim() != "" &&
                        phoneSaved != null &&
                        phoneSaved.trim() != "" &&
                        parentPhoneSaved != null &&
                        parentPhoneSaved.trim() != "" &&
                        parentNameSaved != null &&
                        parentNameSaved.trim() != "") {
                      if (editedName ||
                          editedEmail ||
                          editedPhone ||
                          editedAddress ||
                          editedBirthday ||
                          editedParentName ||
                          editedParentPhone ||
                          _imageFile != null) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => new AlertDialog(
                            title: new Text('Bạn xác nhận cập nhật thông tin?'),
                            actions: <Widget>[
                              new TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: new Text(
                                  'Không',
                                  style: TextStyle(
                                    color: AppColor.greenTheme,
                                  ),
                                ),
                              ),
                              new TextButton(
                                child: new Text(
                                  'Vâng',
                                  style: TextStyle(
                                    color: AppColor.greenTheme,
                                  ),
                                ),
                                onPressed: () => {
                                  if (_imageFile == null)
                                    {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return WillPopScope(
                                            onWillPop: () =>
                                                Future.value(false),
                                            child: new AlertDialog(
                                              content: Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: 150,
                                                    maxWidth: 270),
                                                child: new Column(
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight: 100,
                                                        maxWidth: 100,
                                                      ),
                                                      child: FlareActor(
                                                        'assets/flare/book.flr',
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.scaleDown,
                                                        animation: 'Animations',
                                                        controller:
                                                            EndLoopController(
                                                                "Animations",
                                                                5.5),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 7),
                                                        child: Text(
                                                            "Đang cập nhật vui lòng chờ...")),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      setState(() {
                                        _loading = true;
                                        print("DATA IN TIME \n");
                                        print("USERNAME: " + username);
                                        print("NAME: " + nameSaved);
                                        print("ADDRESS: " + addressSaved);
                                        print("EMAIL: " + emailSaved);
                                        print("BIRTHDAY: " + birthdaySaved);
                                        print("PHONE: " + phoneSaved);
                                        print("BRANCH: " + branchId.toString());
                                        print(
                                            "PARENTPHONE: " + parentPhoneSaved);
                                        print("PARENTNAME: " + parentNameSaved);
                                      }),
                                      setState(() {
                                        APIService apiService =
                                            new APIService();
                                        apiService.setTokenLogin(
                                            prefs.getString("jwt"));
                                        var response =
                                            apiService.updateUserData(
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
                                        widget.userData =
                                            apiService.getUserData(username);
                                      }),
                                      setState(() {
                                        _loading = false;
                                      }),
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return WillPopScope(
                                            onWillPop: () =>
                                                Future.value(false),
                                            child: new AlertDialog(
                                              title: new Text(
                                                  'Thông tin đã được chỉnh sửa vui lòng cập nhật lại trang!'),
                                              actions: <Widget>[
                                                new TextButton(
                                                  onPressed: () {
                                                    // Navigator.pop(context);
                                                    Navigator.pushNamed(
                                                        context, "/home");
                                                  },
                                                  child: new Text('Xác nhận'),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    }
                                  else if (_imageFile != null)
                                    {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return WillPopScope(
                                            onWillPop: () =>
                                                Future.value(false),
                                            child: new AlertDialog(
                                              content: Container(
                                                constraints: BoxConstraints(
                                                    maxHeight: 150,
                                                    maxWidth: 270),
                                                child: new Column(
                                                  children: [
                                                    Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxHeight: 100,
                                                              maxWidth: 100),
                                                      child: FlareActor(
                                                        'assets/flare/book.flr',
                                                        alignment:
                                                            Alignment.center,
                                                        fit: BoxFit.scaleDown,
                                                        animation: 'Animations',
                                                        controller:
                                                            EndLoopController(
                                                                "Animations",
                                                                5.5),
                                                      ),
                                                    ),
                                                    Container(
                                                        margin: EdgeInsets.only(
                                                            left: 7),
                                                        constraints:
                                                            BoxConstraints(
                                                                maxHeight: 100,
                                                                maxWidth: 250),
                                                        child: Text(
                                                            "Đang cập nhật vui lòng chờ...")),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                      setState(() {
                                        _loading = true;
                                      }),
                                      updateImage().then((result) {
                                        if (result) {
                                          print("Result is True HOORAY");
                                          if (editedName ||
                                              editedEmail ||
                                              editedPhone ||
                                              editedAddress ||
                                              editedBirthday ||
                                              editedParentName ||
                                              editedParentPhone) {
                                            print(
                                                "Update Picture Success, now going to update data");
                                            print("DATA IN TIME \n");
                                            print("USERNAME: " + username);
                                            print("NAME: " + nameSaved);
                                            print("ADDRESS: " + addressSaved);
                                            print("EMAIL: " + emailSaved);
                                            print("BIRTHDAY: " + birthdaySaved);
                                            print("PHONE: " + phoneSaved);
                                            print("BRANCH: " +
                                                branchId.toString());
                                            print("PARENTPHONE: " +
                                                parentPhoneSaved);
                                            print("PARENTNAME: " +
                                                parentNameSaved);
                                            setState(() {
                                              APIService apiService =
                                                  new APIService();
                                              apiService.setTokenLogin(
                                                  prefs.getString("jwt"));
                                              var response =
                                                  apiService.updateUserData(
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
                                              widget.userData = apiService
                                                  .getUserData(username);
                                            });
                                          }

                                          setState(() {
                                            _loading = false;
                                          });
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (context) {
                                              return WillPopScope(
                                                onWillPop: () =>
                                                    Future.value(false),
                                                child: new AlertDialog(
                                                  title: new Text(
                                                      'Thông tin đã được chỉnh sửa vui lòng cập nhật lại trang!'),
                                                  actions: <Widget>[
                                                    new TextButton(
                                                      onPressed: () {
                                                        // Navigator.pop(context);
                                                        Navigator.pushNamed(
                                                            context, "/home");
                                                      },
                                                      child:
                                                          new Text('Xác nhận'),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return new AlertDialog(
                                                title: new Text(
                                                    'Có lỗi xảy ra xin vui lòng thử lại!'),
                                                actions: <Widget>[
                                                  new TextButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                        new Text('Chấp nhận'),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        }
                                      }),
                                    }
                                },
                              ),
                            ],
                          ),
                        );
                      } else
                        showDialog(
                          context: context,
                          builder: (context) {
                            return new AlertDialog(
                              title: new Text(
                                  'Xin vui lòng cập nhật thông tin mới!'),
                              actions: <Widget>[
                                new TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: new Text('Chấp nhận'),
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
                                'Xin vui lòng không để trống thông tin cập nhật'),
                            actions: <Widget>[
                              new TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: new Text('Chấp nhận'),
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
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  child: _loading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3.5,
                        )
                      : Text(
                          "LƯU",
                          style: TextStyle(
                              fontSize: 14,
                              letterSpacing: 2.2,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> updateImage() async {
    final bytes = await _imageFile.readAsBytes();
    List<int> bytesChange = bytes;
    // String base64Encode(List<int> bytes) => base64.encode(bytes);

    AvatarUpdateRequestModel avatarRequestModel =
        new AvatarUpdateRequestModel();
    APIService apiService = new APIService();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    apiService.setTokenLogin(prefs.getString("jwt"));

    print("Data base64: " + base64.encode(bytesChange));

    avatarRequestModel.image = base64.encode(bytesChange);

    print("avatarRequestModel.image: " + avatarRequestModel.image);
    print("avatarRequestModel.keyword: " + avatarRequestModel.keyword);

    AvatarUpdateResponseModel avatarResponseModel;
    avatarResponseModel =
        await apiService.updateAvatar(avatarRequestModel, username);

    return avatarResponseModel.result;
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
