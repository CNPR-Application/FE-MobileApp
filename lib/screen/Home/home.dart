import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/user_model.dart';
import 'package:lcss_mobile_app/screen/Edit/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  bool _isLoading = true;
  String username;
  Future<UserResponseModel> userData;
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Schedule',
      style: optionStyle,
    ),
    Home(),
  ];

  @override
  void initState() {
    super.initState();
    callLoad();
    setState(() {
      _isLoading = false;
    });
  }

  callLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    APIService apiService = new APIService();
    userData = apiService.getUserData(username);
    print(username);
    print(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: _selectedIndex == 2
                  ? Profile(
                      userData: userData,
                    )
                  : _widgetOptions.elementAt(_selectedIndex),
            ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
                rippleColor: Colors.grey[300],
                hoverColor: Colors.grey[100],
                gap: 8,
                activeColor: AppColor.greenTheme2,
                iconSize: 24,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: Duration(milliseconds: 400),
                tabBackgroundColor: AppColor.greenTheme.withOpacity(0.1),
                color: Colors.black,
                tabs: [
                  GButton(
                    icon: Icons.access_alarm,
                    text: 'Schedule',
                  ),
                  GButton(
                    icon: Icons.home_outlined,
                    text: 'Home',
                  ),
                  GButton(
                    icon: Icons.account_circle_outlined,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}

class Profile extends StatelessWidget {
  Profile({Key key, this.userData}) : super(key: key);

  Future<UserResponseModel> userData;

  Widget buildImage() {
    final image = NetworkImage(
        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80');

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          height: 100,
          width: 100,
          child: InkWell(),
        ),
      ),
    );
  }

  final Widget editVector =
      SvgPicture.asset('assets/vectors/edit.svg', semanticsLabel: 'vector');

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new EditProfileScreen(
                      userData: userData,
                    ),
                  ),
                );
              },
            ),
          ],
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          expandedHeight: 200,
          stretch: true,
          pinned: true,
          flexibleSpace: Stack(
            children: <Widget>[
              FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                centerTitle: true,
                stretchModes: <StretchMode>[
                  StretchMode.zoomBackground,
                  StretchMode.blurBackground,
                  StretchMode.fadeTitle,
                ],
                title: Container(
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: FutureBuilder<UserResponseModel>(
                    future: userData,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data.username);
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return CircularProgressIndicator();
                    },
                  ),
                ),
                background: new Image.network(
                  'https://images.unsplash.com/photo-1558898479-33c0057a5d12?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1000&q=80',
                  // image link se update sau
                  fit: BoxFit.fill,
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black45,
                ),
              ),
              // Center(
              //   child: Row(
              //     children: <Widget>[
              //       Spacer(),
              //       buildImage(),
              //       Spacer(),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          FutureBuilder<UserResponseModel>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.name != null &&
                  snapshot.data.name != "") {
                return Container(
                  height: 120,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 23, left: 21),
                            child: Text(
                              'Tên học sinh',
                              style: TextStyle(
                                color: Color(0xff413e55),
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 21),
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<UserResponseModel>(
                              future: userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.name,
                                    style: TextStyle(
                                      color: Color(0xff546e7a),
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else
                return Container(width: 0.0, height: 0.0);
            },
          ),
          FutureBuilder<UserResponseModel>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.phone != null &&
                  snapshot.data.phone != "") {
                return Container(
                  height: 120,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.10,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff4dc591),
                                  width: 1,
                                ),
                                color: Color(0xff4dc591),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 23, left: 21),
                            child: Text(
                              'Số điện thoại',
                              style: TextStyle(
                                color: Color(0xff413e55),
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 21),
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<UserResponseModel>(
                              future: userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.phone,
                                    style: TextStyle(
                                      color: Color(0xff546e7a),
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else
                return Container(width: 0.0, height: 0.0);
              ;
            },
          ),
          FutureBuilder<UserResponseModel>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.email != null &&
                  snapshot.data.email != "") {
                return Container(
                  height: 120,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.10,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff4dc591),
                                  width: 1,
                                ),
                                color: Color(0xff4dc591),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 23, left: 21),
                            child: Text(
                              'Email',
                              style: TextStyle(
                                color: Color(0xff413e55),
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 21),
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<UserResponseModel>(
                              future: userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.email,
                                    style: TextStyle(
                                      color: Color(0xff546e7a),
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else
                return Container(width: 0.0, height: 0.0);
              ;
            },
          ),
          FutureBuilder<UserResponseModel>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.birthday != null &&
                  snapshot.data.birthday != "") {
                return Container(
                  height: 120,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.10,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff4dc591),
                                  width: 1,
                                ),
                                color: Color(0xff4dc591),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 23, left: 21),
                            child: Text(
                              'Ngày sinh',
                              style: TextStyle(
                                color: Color(0xff413e55),
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 21),
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<UserResponseModel>(
                              future: userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  DateTime dt =
                                      DateTime.parse(snapshot.data.birthday);
                                  DateFormat formatter =
                                      new DateFormat('dd-MM-yyyy');
                                  return Text(
                                    formatter.format(dt),
                                    style: TextStyle(
                                      color: Color(0xff546e7a),
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else
                return Container(width: 0.0, height: 0.0);
              ;
            },
          ),
          FutureBuilder<UserResponseModel>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.address != null &&
                  snapshot.data.address != "") {
                return Container(
                  height: 150,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.10,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff4dc591),
                                  width: 1,
                                ),
                                color: Color(0xff4dc591),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 23, left: 21),
                            child: Text(
                              'Địa chỉ',
                              style: TextStyle(
                                color: Color(0xff413e55),
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 21),
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<UserResponseModel>(
                              future: userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.address,
                                    style: TextStyle(
                                      color: Color(0xff546e7a),
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else
                return Container(width: 0.0, height: 0.0);
              ;
            },
          ),
          FutureBuilder<UserResponseModel>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.branchModels != null &&
                  snapshot.data.branchModels.isNotEmpty) {
                return Container(
                  height: 150,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.10,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff4dc591),
                                  width: 1,
                                ),
                                color: Color(0xff4dc591),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 23, left: 21),
                            child: Text(
                              'Tên chi nhánh',
                              style: TextStyle(
                                color: Color(0xff413e55),
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 21),
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<UserResponseModel>(
                              future: userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.branchModels
                                        .elementAt(0)
                                        .branchName,
                                    style: TextStyle(
                                      color: Color(0xff546e7a),
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else
                return Container(width: 0.0, height: 0.0);
              ;
            },
          ),
          FutureBuilder<UserResponseModel>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.parentPhone != null &&
                  snapshot.data.parentPhone != "") {
                return Container(
                  height: 120,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.10,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff4dc591),
                                  width: 1,
                                ),
                                color: Color(0xff4dc591),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 23, left: 21),
                            child: Text(
                              'Số điện thoại phụ huynh',
                              style: TextStyle(
                                color: Color(0xff413e55),
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 21),
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<UserResponseModel>(
                              future: userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.parentPhone,
                                    style: TextStyle(
                                      color: Color(0xff546e7a),
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else
                return Container(width: 0.0, height: 0.0);
              ;
            },
          ),
          FutureBuilder<UserResponseModel>(
            future: userData,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data.parentName != null &&
                  snapshot.data.parentName != "") {
                return Container(
                  height: 120,
                  color: Colors.white,
                  child: Column(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.10,
                            child: Container(
                              height: 5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xff4dc591),
                                  width: 1,
                                ),
                                color: Color(0xff4dc591),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 23, left: 21),
                            child: Text(
                              'Tên phụ huynh',
                              style: TextStyle(
                                color: Color(0xff413e55),
                                fontSize: 24,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 20, left: 21),
                            alignment: Alignment.centerLeft,
                            child: FutureBuilder<UserResponseModel>(
                              future: userData,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.parentName,
                                    style: TextStyle(
                                      color: Color(0xff546e7a),
                                      fontSize: 20,
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("${snapshot.error}");
                                }
                                return CircularProgressIndicator();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else
                return Container(width: 0.0, height: 0.0);
              ;
            },
          ),
        ]))
      ],
    );
  }
}

class Home extends StatelessWidget {
  const Home({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
      child: Column(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.fromLTRB(0, 33, 0, 33),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: CircleAvatar(
                    // backgroundImage: NetworkImage(userAvatarUrl),
                    radius: 32,
                    backgroundColor: Colors.green[200],
                    child: const Text('NQ'),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 315,
            child: Text(
              "Chúc bạn một ngày tốt đẹp!",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
