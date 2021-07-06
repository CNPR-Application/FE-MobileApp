import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/user_model.dart';
import 'package:lcss_mobile_app/screen/Edit/edit_profile.dart';
import 'package:lcss_mobile_app/screen/Edit/edit_profile_v2.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  bool _isLoading = true;
  String username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      callLoad();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      callLoad();
      _isLoading = false;
    });
  }

  Future<bool> _onWillPop() {
    return showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text('Are you sure to log out?'),
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

  callLoad() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    // APIService apiService = new APIService();
    // userData = apiService.getUserData(username);
    print(username);
    // print(userData);
  }

  Future<UserResponseModel> userDataFuture;

  Future<UserResponseModel> userData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    APIService apiService = new APIService();
    userDataFuture = apiService.getUserData(username);
    return userDataFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserResponseModel>(
      future: userData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(
                      child: _selectedIndex == 2
                          ? ProfileEightPage(
                              userData: userDataFuture,
                            )
                          : _selectedIndex == 0
                              ? Schedule()
                              : Home(
                                  userData: userDataFuture,
                                  username: username,
                                ),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15.0, vertical: 8),
                    child: GNav(
                        rippleColor: Colors.grey[300],
                        hoverColor: Colors.grey[100],
                        gap: 8,
                        activeColor: AppColor.greenTheme2,
                        iconSize: 24,
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        duration: Duration(milliseconds: 400),
                        tabBackgroundColor:
                            AppColor.greenTheme.withOpacity(0.1),
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
            ),
          );
        } else
          return Intro5();
      },
    );
  }
}

// HOME START

TextStyle priceTextStyle =
    TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold);

class Home extends StatelessWidget {
  Home({
    Key key,
    this.userData,
    this.username,
  }) : super(key: key);

  Future<UserResponseModel> userData;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  String username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: _key,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.grey.shade200,
        centerTitle: true,
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          "Welcome" + " " + username,
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.menu),
          color: Colors.black,
          onPressed: () {
            _key.currentState.openDrawer();
          },
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_none_outlined,
                color: AppColor.greenTheme,
              )),
        ],
      ),
      // drawer: _buildDrawer(),
      backgroundColor: Colors.grey.shade200,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: Text(
              "Khóa học bạn có thể thích",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Container(
            width: double.infinity,
            height: 150,
            margin: EdgeInsets.only(top: 15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 8,
              itemBuilder: (BuildContext context, int index) {
                return _categoryList(context);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: Text(
              "Lớp học hiện có",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 150,
            margin: EdgeInsets.only(top: 15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return _featuredProduct(context);
              },
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.grey.shade300,
            height: 60.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Text(
                    "Lịch sử đăng ký",
                    style: Theme.of(context).textTheme.title,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      print("hello");
                    },
                    child: Text("View all"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          ...[1, 2, 3, 4, 5].map(
            (product) => ProductListItem(
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 10.0),
        ],
      ),
    );
  }

  // _buildDrawer() {
  //   final String image = images[0];
  //   return ClipPath(
  //     clipper: OvalRightBorderClipper(),
  //     child: Drawer(
  //       child: Container(
  //         padding: const EdgeInsets.only(left: 16.0, right: 40),
  //         decoration: BoxDecoration(
  //             color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
  //         width: 300,
  //         child: SafeArea(
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: <Widget>[
  //                 Container(
  //                   alignment: Alignment.centerRight,
  //                   child: IconButton(
  //                     icon: Icon(
  //                       Icons.power_settings_new,
  //                       color: active,
  //                     ),
  //                     onPressed: () {},
  //                   ),
  //                 ),
  //                 Container(
  //                   height: 90,
  //                   alignment: Alignment.center,
  //                   decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       gradient: LinearGradient(
  //                           colors: [Colors.orange, Colors.deepOrange])),
  //                   child: CircleAvatar(
  //                     radius: 40,
  //                     backgroundImage: NetworkImage(image),
  //                   ),
  //                 ),
  //                 SizedBox(height: 5.0),
  //                 Text(
  //                   "erika costell",
  //                   style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 18.0,
  //                       fontWeight: FontWeight.w600),
  //                 ),
  //                 Text(
  //                   "@erika07",
  //                   style: TextStyle(color: active, fontSize: 16.0),
  //                 ),
  //                 SizedBox(height: 30.0),
  //                 _buildRow(Icons.home, "Home"),
  //                 _buildDivider(),
  //                 _buildRow(Icons.person_pin, "My profile"),
  //                 _buildDivider(),
  //                 _buildRow(Icons.message, "Messages", showBadge: true),
  //                 _buildDivider(),
  //                 _buildRow(Icons.notifications, "Notifications",
  //                     showBadge: true),
  //                 _buildDivider(),
  //                 _buildRow(Icons.settings, "Settings"),
  //                 _buildDivider(),
  //                 _buildRow(Icons.email, "Contact us"),
  //                 _buildDivider(),
  //                 _buildRow(Icons.info_outline, "Help"),
  //                 _buildDivider(),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Chỗ này sẽ update data truyền vào (lấy từ API)
  Widget _featuredProduct(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
              image: DecorationImage(
                image: NetworkImage(
                    'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 150,
            height: 150,
          ),
          Positioned(
            bottom: 0,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              color: Colors.black87,
              child: Text(
                "Sofa Set",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget _categoryList(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12,
                image: DecorationImage(
                    image: NetworkImage(
                        'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F3.jpg?alt=media'),
                    fit: BoxFit.cover)),
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 10),
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Text("Tables")
        ],
      ),
    );
  }
}

// Ở đây trong tương lai cũng sẽ truyền data vào (Data từ API)
class ProductListItem extends StatelessWidget {
  final Function onPressed;
  const ProductListItem({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: MaterialButton(
        padding: const EdgeInsets.all(0),
        elevation: 0.5,
        color: Colors.white,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        onPressed: onPressed as void Function(),
        child: Row(
          children: <Widget>[
            Ink(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(
                      'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F2.jpg?alt=media'),
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text("Nhật Ngữ N2"),
                            SizedBox(
                              height: 5,
                            ),
                            Text("1200000\$", style: priceTextStyle)
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.arrow_right_alt_rounded,
                          size: 22,
                        ),
                        onPressed: () {
                          print('tapped');
                        },
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

// HOME END

// Schedule START
final List<String> weekDays = ["S", "M", "T", "W", "T", "F", "S"];
final List<int> dates = [5, 6, 7, 8, 9, 10, 11];

class Schedule extends StatelessWidget {
  final int selected = 5;
  final TextStyle selectedText = TextStyle(
    color: Colors.deepOrange,
    fontWeight: FontWeight.bold,
  );
  final TextStyle daysText = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.grey.shade800,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Tuần lễ của tôi'),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: HeaderWidget(
        header: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(
                  "Tháng 1".toUpperCase(),
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      letterSpacing: 2.0),
                ),
              ),
              Row(
                children: weekDays.map((w) {
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: weekDays.indexOf(w) == selected
                              ? Colors.orange.shade100
                              : Colors.transparent,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30.0))),
                      padding: const EdgeInsets.only(top: 20, bottom: 8.0),
                      child: Text(
                        w,
                        style: weekDays.indexOf(w) == selected
                            ? selectedText
                            : daysText,
                      ),
                    ),
                  );
                }).toList(),
              ),
              Row(
                children: dates.map((d) {
                  return Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: dates.indexOf(d) == selected
                              ? Colors.orange.shade100
                              : Colors.transparent,
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(30.0))),
                      padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
                      child: Text("$d",
                          style: dates.indexOf(d) == selected
                              ? selectedText
                              : daysText),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10.0),
            ],
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTaskWithDate(),
              const SizedBox(height: 20.0),
              _buildTask(),
              const SizedBox(height: 20.0),
              _buildTask(),
              const SizedBox(height: 20.0),
              _buildTaskWithDate(),
              const SizedBox(height: 20.0),
              _buildTask(),
              const SizedBox(height: 20.0),
              _buildTask(),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Row _buildTaskWithDate() {
    return Row(
      children: <Widget>[
        Text(
          "JAN\n10",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
                bottomLeft: Radius.circular(20.0),
              ),
              color: Colors.white,
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "10:30 - 11:30AM",
                  style:
                      TextStyle(letterSpacing: 2.5, color: AppColor.greenTheme),
                ),
                const SizedBox(height: 5.0),
                Text(
                  "Anh Ngữ Giao Tiếp",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColor.greenTheme,
                      fontSize: 16.0),
                ),
                // const SizedBox(height: 5.0),
                Text("John Doe")
              ],
            ),
          ),
        )
      ],
    );
  }

  Container _buildTask() {
    return Container(
      padding: const EdgeInsets.only(left: 70.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "10:30 - 11:30AM",
            style: TextStyle(letterSpacing: 2.5, color: Colors.white),
          ),
          const SizedBox(height: 5.0),
          Text(
            "Anh Ngữ Giao Tiếp",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 16.0),
          ),
          Text("John Doe")
        ],
      ),
    );
  }
}

class HeaderWidget extends StatelessWidget {
  final Widget body;
  final Widget header;
  final Color headerColor;
  final Color backColor;

  const HeaderWidget(
      {Key key,
      this.body,
      this.header,
      this.headerColor = Colors.white,
      this.backColor = AppColor.greenTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildBody();
  }

  Stack _buildBody() {
    return Stack(
      children: <Widget>[
        Positioned(
          right: 0,
          top: 0,
          width: 10,
          height: 200,
          child: DecoratedBox(
            decoration: BoxDecoration(
                color: backColor,
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(20.0))),
          ),
        ),
        Positioned(
          right: 0,
          top: 100,
          width: 50,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backColor,
            ),
          ),
        ),
        Column(
          children: <Widget>[
            if (header != null)
              Container(
                  margin: const EdgeInsets.only(right: 10.0),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(20.0)),
                    color: headerColor,
                  ),
                  child: header),
            if (body != null)
              Expanded(
                child: Material(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(30.0))),
                    elevation: 0,
                    color: backColor,
                    child: body),
              ),
          ],
        ),
      ],
    );
  }
}

// Schedule END

// Profile Content START
class ProfileEightPage extends StatelessWidget {
  static final String path = "lib/src/pages/profile/profile8.dart";

  ProfileEightPage({Key key, this.userData}) : super(key: key);

  Future<UserResponseModel> userData;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserResponseModel>(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              backgroundColor: Colors.grey.shade100,
              extendBodyBehindAppBar: true,
              extendBody: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                automaticallyImplyLeading: false,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    ProfileHeader(
                      avatar: NetworkImage(snapshot.data.image),
                      coverImage: NetworkImage(snapshot.data.image),
                      title: snapshot.data.username,
                      subtitle: "Student",
                      actions: <Widget>[
                        MaterialButton(
                          color: Colors.white,
                          shape: CircleBorder(),
                          elevation: 0,
                          child: Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(
                                builder: (context) => new EditPage(
                                  userData: userData,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                    const SizedBox(height: 10.0),
                    UserInfo(
                      userData: userData,
                    ),
                    UserInfoAnother(
                      userData: userData,
                    ),
                  ],
                ),
              ));
        } else
          return CircularProgressIndicator();
      },
    );
  }
}

class UserInfo extends StatelessWidget {
  UserInfo({Key key, this.userData}) : super(key: key);

  Future<UserResponseModel> userData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserResponseModel>(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          DateTime dt = DateTime.parse(snapshot.data.birthday);
          DateFormat formatter = new DateFormat('dd-MM-yyyy');
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Thông tin người dùng",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Card(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ...ListTile.divideTiles(
                              color: Colors.grey,
                              tiles: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  leading: Icon(Icons.my_location),
                                  title: Text("Họ và tên"),
                                  subtitle: Text(snapshot.data.name),
                                ),
                                ListTile(
                                  leading: Icon(Icons.email),
                                  title: Text("Email"),
                                  subtitle: Text(snapshot.data.email),
                                ),
                                ListTile(
                                  leading: Icon(Icons.phone),
                                  title: Text("Số điện thoại"),
                                  subtitle: Text(snapshot.data.phone),
                                ),
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text("Ngày sinh"),
                                  subtitle: Text(formatter.format(dt)),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else
          return CircularProgressIndicator();
      },
    );
  }
}

class UserInfoAnother extends StatelessWidget {
  UserInfoAnother({Key key, this.userData}) : super(key: key);

  Future<UserResponseModel> userData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserResponseModel>(
      future: userData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Thông tin khác",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                Card(
                  child: Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.all(15),
                    child: Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ...ListTile.divideTiles(
                              color: Colors.grey,
                              tiles: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  leading: Icon(Icons.my_location),
                                  title: Text("Địa chỉ"),
                                  subtitle: Text(snapshot.data.address),
                                ),
                                ListTile(
                                  leading: Icon(Icons.email),
                                  title: Text("Tên chi nhánh"),
                                  subtitle: Text(snapshot.data.branchModels
                                      .elementAt(0)
                                      .branchName),
                                ),
                                ListTile(
                                  leading: Icon(Icons.phone),
                                  title: Text("Số điện thoại phụ huynh"),
                                  subtitle: Text(snapshot.data.parentPhone),
                                ),
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text("Tên phụ huynh"),
                                  subtitle: Text(snapshot.data.parentName),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else
          return CircularProgressIndicator();
      },
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String subtitle;
  final List<Widget> actions;

  const ProfileHeader(
      {Key key,
      this.coverImage,
      this.avatar,
      this.title,
      this.subtitle,
      this.actions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: coverImage as ImageProvider<Object>, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black38,
          ),
        ),
        if (actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.only(bottom: 0.0, right: 0.0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions,
            ),
          ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 40,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar(
      {Key key,
      this.image,
      this.borderColor = Colors.grey,
      this.backgroundColor,
      this.radius = 30,
      this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor != null
            ? backgroundColor
            : Theme.of(context).primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image as ImageProvider<Object>,
        ),
      ),
    );
  }
}

// Profile Content END
