/**
 * Author: Sudip Thapa  
 * profile: https://github.com/sudeepthapa
  */

import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/Util/oval-right-clipper.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/notification_model.dart';
import 'package:lcss_mobile_app/model/subject_model.dart';
import 'package:lcss_mobile_app/screen/Home/home.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:lcss_mobile_app/screen/Subject/subject_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lcss_mobile_app/screen/reply/app.dart' as reply;

class SearchSubject extends StatefulWidget {
  SearchSubject(
      {Key key,
      this.username,
      this.email,
      this.image,
      this.isReceivedNotification,
      this.listNotificationsInput})
      : super(key: key);
  static final String path = "lib/src/pages/lists/list2.dart";

  final String username;
  final String email;
  final String image;
  final bool isReceivedNotification;
  final List<NotificationModel> listNotificationsInput;

  _SearchSubjectState createState() => _SearchSubjectState();
}

class _SearchSubjectState extends State<SearchSubject> {
  final TextStyle dropdownMenuItem =
      TextStyle(color: Colors.black, fontSize: 18);

  // final primary = Color(0xff696b9e);
  // final secondary = Color(0xfff29a94);

  final primary = AppColor.greenTheme;
  final secondary = Color(0xfff29a94);

  bool _isSearch = false;

  Future<SubjectResponseModel> subjectDataFuture;
  SubjectResponseModel subjectModel;
  List<SubjectModel> listSubjects;
  List<SubjectModel> listSearchSubject;
  String jwt;
  SharedPreferences prefs;

  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
    _isSearch = false;
  }

  void getToken() async {
    prefs = await SharedPreferences.getInstance();
    jwt = prefs.getString('jwt');
  }

  Future<SubjectResponseModel> subjectData() async {
    prefs = await SharedPreferences.getInstance();
    APIService apiService = new APIService();
    apiService.setTokenLogin(jwt);
    subjectDataFuture = apiService.getAllSubjectData(1, 1000);
    return subjectDataFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SubjectResponseModel>(
      future: subjectData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          listSubjects = snapshot.data.listSubject;
          List<String> imageUrl = [
            'http://tiengnhatcoban.edu.vn/images/2019/01/18/bang-chu-cai-kanji.jpg',
            'https://tuhoconline.net/wp-content/uploads/cach-hoc-chu-kanji-hieu-qua-1.jpg',
            'https://career.gpo.vn/uploads/images/485568610/images/phuong-phap-hoc-tap-cua-tien-si-marty-lobdell-study-less-study-smart-phan-2-huong-nghiep-gpo(3).jpg',
            'https://www.uab.edu/reporter/images/images/japanese___stream.jpg',
            'https://i0.wp.com/lh3.googleusercontent.com/-e6n1iMn81xY/X9G6QbKcekI/AAAAAAAAM6E/rXWdJ5q8UwMAJusbvW7ZVoNH4qmiSPe1gCLcBGAsYHQ/w640-h429/image.png?ssl=1',
            'https://www.infobooks.org/wp-content/uploads/2021/01/Japanese-Books-PDF.jpg',
            'https://ih1.redbubble.net/image.1047234144.4273/farp,small,wall_texture,product,750x1000.jpg',
            'https://www.global.hokudai.ac.jp/wp-content/uploads/2012/11/nihongo.jpg',
            'https://www.japanvisitor.com/images/content_images/japanese-language-2019.jpg',
            'https://www.snowmonkeyresorts.com/wp-content/uploads/2021/05/388343_m.jpg',
          ];
          for (var i = 0; i < listSubjects.length; i++) {
            listSubjects[i].image = imageUrl[i % 10];
          }
          return Scaffold(
            backgroundColor: Color(0xfff0f0f0),
            drawer: _buildDrawer(widget.image, context),
            body: Builder(builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 145),
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        child: ListView.builder(
                            itemCount: _isSearch
                                ? listSearchSubject.length
                                : listSubjects.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildList(context, index);
                            }),
                      ),
                      Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: primary,
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              IconButton(
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                                icon: Icon(
                                  Icons.menu,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "Môn học",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 24),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.filter_list,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 110,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Material(
                                elevation: 5.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                child: TextField(
                                  // controller: TextEditingController(text: locations[0]),
                                  onChanged: (value) {
                                    setState(() {
                                      listSearchSubject =
                                          List<SubjectModel>.empty();
                                      if (value.isNotEmpty) {
                                        for (var i = 0;
                                            i < listSubjects.length;
                                            i++) {
                                          if (listSubjects[i]
                                              .subjectName
                                              .toLowerCase()
                                              .contains(value.toLowerCase())) {
                                            print(listSubjects[i].subjectName);
                                            print(i.toString());
                                            listSearchSubject = [
                                              ...listSearchSubject,
                                              listSubjects[i]
                                            ];
                                          }
                                        }
                                        _isSearch = true;
                                      } else {
                                        _isSearch = false;
                                      }
                                    });
                                  },
                                  cursorColor: Theme.of(context).primaryColor,
                                  style: dropdownMenuItem,
                                  decoration: InputDecoration(
                                      hintText: "Tìm kiếm môn học",
                                      hintStyle: TextStyle(
                                          color: Colors.black38, fontSize: 16),
                                      prefixIcon: Material(
                                        elevation: 0.0,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30)),
                                        child: Icon(Icons.search),
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 25, vertical: 13)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          );
        } else
          return Intro5(Colors.white);
      },
    );
  }

  Widget buildList(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new SubjectDetailsPage(
              subjectData:
                  _isSearch ? listSearchSubject[index] : listSubjects[index],
              subjectId: _isSearch
                  ? listSearchSubject[index].subjectId
                  : listSubjects[index].subjectId,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
        ),
        width: double.infinity,
        height: 110,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                border: Border.all(width: 3, color: secondary),
                image: DecorationImage(
                    image: NetworkImage(_isSearch
                        ? listSearchSubject[index].image
                        : listSubjects[index].image),
                    fit: BoxFit.fill),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    _isSearch
                        ? listSearchSubject[index].subjectName
                        : listSubjects[index].subjectName,
                    style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.money,
                        color: secondary,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                          _isSearch
                              ? listSearchSubject[index]
                                  .price
                                  .toInt()
                                  .toString()
                              : listSubjects[index].price.toInt().toString() +
                                  "₫",
                          style: TextStyle(
                              color: primary, fontSize: 15, letterSpacing: .3)),
                    ],
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.school,
                        color: secondary,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                          _isSearch
                              ? listSearchSubject[index].slot.toString()
                              : listSubjects[index].slot.toString() + " slot",
                          style: TextStyle(
                              color: primary, fontSize: 15, letterSpacing: .3)),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _buildDrawer(String image, BuildContext context) {
    return ClipPath(
      clipper: OvalRightBorderClipper(),
      child: Drawer(
        child: Container(
          padding: const EdgeInsets.only(left: 16.0, right: 40),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black45)]),
          width: 300,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(
                        Icons.power_settings_new,
                        color: active,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return new AlertDialog(
                              title: new Text('Are you sure to log out?'),
                              actions: <Widget>[
                                new TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: new Text('No'),
                                ),
                                new TextButton(
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.remove("jwt");
                                    Navigator.pushReplacementNamed(
                                        context, "/login");
                                  },
                                  child: new Text('Yes'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Container(
                    height: 90,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                            colors: [AppColor.greenTheme, Colors.green])),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(image),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    widget.username,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(color: active, fontSize: 16.0),
                  ),
                  SizedBox(height: 30.0),
                  _buildRow(context, Icons.home, "Trang chủ"),
                  _buildDivider(),
                  _buildRow(context, Icons.person_pin, "Lớp học"),
                  _buildDivider(),
                  _buildRow(context, Icons.message, "Lớp học sắp khai giảng",
                      showBadge: false),
                  _buildDivider(),
                  _buildRow(context, Icons.notifications, "Thông báo",
                      showBadge: widget.isReceivedNotification),
                  _buildDivider(),
                  _buildRow(context, Icons.email, "Đánh giá lớp học"),
                  _buildDivider(),
                  _buildRow(context, Icons.history, "Lịch sử đăng ký"),
                  _buildDivider(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Divider _buildDivider() {
    return Divider(
      color: divider,
    );
  }

  Widget _buildRow(BuildContext context, IconData icon, String title,
      {bool showBadge = false}) {
    final TextStyle tStyle = TextStyle(color: active, fontSize: 16.0);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: InkWell(
        onTap: () {
          print('hello');
          if (title == 'Lớp học sắp khai giảng') {
            Navigator.pushNamed(context, "/searchClass");
          }
          if (title == 'Lớp học') {
            Navigator.pushNamed(context, "/myClass");
          }
          if (title == 'Đánh giá lớp học') {
            Navigator.pushNamed(context, "/checkFeedback");
          }

          if (title == 'Lịch sử đăng ký') {
            Navigator.pushNamed(context, "/bookingHistory");
          }

          if (title == 'Thông báo') {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new StudyWrapper(
                  study: reply.ReplyApp(
                    listNotification: widget.listNotificationsInput,
                    loadingData: widget.isReceivedNotification,
                  ),
                  hasBottomNavBar: false,
                ),
              ),
            );
          }
        },
        child: Row(children: [
          Icon(
            icon,
            color: active,
          ),
          SizedBox(width: 10.0),
          Text(
            title,
            style: tStyle,
          ),
          Spacer(),
          if (showBadge)
            Material(
              color: Colors.green,
              elevation: 5.0,
              shadowColor: Colors.red,
              borderRadius: BorderRadius.circular(5.0),
              child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Text(
                  "!",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
        ]),
      ),
    );
  }
}
