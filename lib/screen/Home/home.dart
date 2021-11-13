import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/Util/data/gallery_options.dart';
import 'package:lcss_mobile_app/Util/oval-right-clipper.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/main.dart';
import 'package:lcss_mobile_app/model/booking_model.dart';
import 'package:lcss_mobile_app/model/class_model.dart';
import 'package:lcss_mobile_app/model/notification_model.dart';
import 'package:lcss_mobile_app/model/schedule_model.dart';
import 'package:lcss_mobile_app/model/subject_model.dart';
import 'package:lcss_mobile_app/model/user_model.dart';
import 'package:lcss_mobile_app/screen/Edit/edit_profile_v2.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:lcss_mobile_app/screen/reply/app.dart' as reply;
import 'package:lcss_mobile_app/screen/reply/routes.dart' as reply_routes;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  bool _isLoading = true;
  String username;
  int branchId;

  Future<ClassResponseModel> classDataFuture;
  ClassResponseModel classModel;
  List<ClassModel> listClasses;

  Future<SubjectResponseModel> subjectDataFuture;
  SubjectResponseModel subjectModel;
  List<SubjectModel> listSubjects;

  Future<BookingResponseModel> bookingDataFuture;
  BookingResponseModel bookingModel;
  List<BookingModel> listBookings;

  Future<NotificationResponseModel> notificationDataFuture;
  NotificationResponseModel notificationModel;
  List<NotificationModel> listNotifications;

  Future<ScheduleResponseModel> scheduleDataFuture;
  ScheduleResponseModel scheduleModel;

  UserResponseModel userModel;

  bool notTurnBack;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      callLoad();
      _isLoading = false;
      _listUserFuture = userData();
      _listClassFuture = classData();
      _listSubjectFuture = subjectData();
      _listBookingFuture = bookingData();
      _listNotificationFuture = notificationData();
      _listScheduleFuture = scheduleData();
    });
  }

  @override
  void initState() {
    super.initState();
    pushFCMToken();
    notTurnBack = true;
    _firebaseConfig();

    setState(() {
      callLoad();
      _isLoading = false;
    });
    _listUserFuture = userData();
    _listClassFuture = classData();
    _listSubjectFuture = subjectData();
    _listBookingFuture = bookingData();
    _listNotificationFuture = notificationData();
    _listScheduleFuture = scheduleData();
  }

  void pushFCMToken() async {
    String token = await messaging.getToken();
    print('The token is: ' + token);
  }

  void _firebaseConfig() {
    var androiInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    var iosInit = IOSInitializationSettings();
    var initSetting = InitializationSettings(android: androiInit, iOS: iosInit);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: _onSelectNotification);

    var androidDetails =
        AndroidNotificationDetails('1', 'channelName', 'channelDescription');

    var iosDetails = IOSNotificationDetails();

    var generalNotificationDetails =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        // RemoteNotification notification = message.notification;
        // AndroidNotification android = message.notification?.android;

        // if (notification != null && android != null) {
        //   flutterLocalNotificationsPlugin.show(
        //       notification.hashCode,
        //       notification.title,
        //       notification.body,
        //       NotificationDetails(
        //         android: AndroidNotificationDetails(
        //           channel.id,
        //           channel.name,
        //           channel.description,
        //           // TODO add a proper drawable resource to android, for now using
        //           //      one that already exists in example app.
        //           icon: 'launch_background',
        //         ),
        //       ));
        // }
        // if (!notTurnBack) {
        //   Navigator.pushNamed(
        //     context,
        //     '/login',
        //   );
        //   notTurnBack = true;
        // }
        print("Hello Notification");
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new StudyWrapper(
              study: reply.ReplyApp(
                listNotification: listNotifications,
                loadingData: true,
              ),
              hasBottomNavBar: false,
            ),
          ),
        );
      }
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        RemoteNotification notification = message.notification;
        AndroidNotification android = message.notification?.android;

        if (notification != null && android != null) {
          flutterLocalNotificationsPlugin.show(
              notification.hashCode,
              notification.title,
              notification.body,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  channel.id,
                  channel.name,
                  channel.description,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'launch_background',
                ),
              ));
        }
        print("Oh yeah we got it");

        // Navigator.push(
        //   context,
        //   new MaterialPageRoute(
        //     builder: (context) => new StudyWrapper(
        //       study: reply.ReplyApp(
        //         listNotification: listNotifications,
        //         loadingData: true,
        //       ),
        //       hasBottomNavBar: false,
        //     ),
        //   ),
        // );
      });
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        // RemoteNotification notification = message.notification;
        // AndroidNotification android = message.notification?.android;

        // if (notification != null && android != null) {
        //   flutterLocalNotificationsPlugin.show(
        //       notification.hashCode,
        //       notification.title,
        //       notification.body,
        //       NotificationDetails(
        //         android: AndroidNotificationDetails(
        //           channel.id,
        //           channel.name,
        //           channel.description,
        //           // TODO add a proper drawable resource to android, for now using
        //           //      one that already exists in example app.
        //           icon: 'launch_background',
        //         ),
        //       ));
        // }
        notTurnBack = false;
        print('A new onMessageOpenedApp event was published!');
        // Navigator.pushNamed(
        //   context,
        //   '/home',
        // );
        print("Hello Adakama");
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new StudyWrapper(
              study: reply.ReplyApp(
                listNotification: listNotifications,
                loadingData: true,
              ),
              hasBottomNavBar: false,
            ),
          ),
        );
      });
    });
  }

  Future _onSelectNotification(String payload) async {
    this.build(context);
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) => new StudyWrapper(
          study: reply.ReplyApp(
            listNotification: listNotifications,
            loadingData: true,
          ),
          hasBottomNavBar: false,
        ),
      ),
    );
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
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

  saveBranchId(int branchIdInput) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("branchId", branchIdInput);
    // APIService apiService = new APIService();
    // userData = apiService.getUserData(username);
  }

  Future<UserResponseModel> userDataFuture;

  Future<UserResponseModel> userData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    APIService apiService = new APIService();
    userDataFuture = apiService.getUserData(username);
    return userDataFuture;
  }

  Future<ClassResponseModel> classData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    branchId = prefs.getInt("branchId");
    APIService apiService = new APIService();
    print(branchId.toString() + "Hello");
    classDataFuture = apiService.getAllWaitingClass(1, 20, branchId);
    return classDataFuture;
  }

  Future<SubjectResponseModel> subjectData() async {
    APIService apiService = new APIService();
    subjectDataFuture = apiService.getAllSubjectData(1, 1000);
    return subjectDataFuture;
  }

  Future<BookingResponseModel> bookingData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    APIService apiService = new APIService();
    bookingDataFuture = apiService.getAllBookingOfStudent(1, 1000, username);
    return bookingDataFuture;
  }

  Future<NotificationResponseModel> notificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    print("Preference working username: " + username);
    APIService apiService = new APIService();
    notificationDataFuture =
        apiService.getAllNotificationOfStudent(1, 1000, username);
    return notificationDataFuture;
  }

  Future<ScheduleResponseModel> scheduleData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    APIService apiService = new APIService();
    String formattedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    print("The Time right now is: " + formattedDate);
    scheduleDataFuture = apiService.getScheduleData(username, formattedDate);
    return scheduleDataFuture;
  }

  Future<UserResponseModel> _listUserFuture;
  Future<ClassResponseModel> _listClassFuture;
  Future<SubjectResponseModel> _listSubjectFuture;
  Future<BookingResponseModel> _listBookingFuture;
  Future<NotificationResponseModel> _listNotificationFuture;
  Future<ScheduleResponseModel> _listScheduleFuture;

  Future<void> refreshData() {
    setState(() {
      _isLoading = true;
    });
    return loadDataOnRefresh().then((value) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future loadDataOnRefresh() async {
    setState(() {
      _listUserFuture = userData();
      _listClassFuture = classData();
      _listSubjectFuture = subjectData();
      _listBookingFuture = bookingData();
      _listNotificationFuture = notificationData();
      _listScheduleFuture = scheduleData();
    });
    await userData();
    await classData();
    await subjectData();
    await bookingData();
    await notificationData();
    await scheduleData();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _listUserFuture,
        _listClassFuture,
        _listSubjectFuture,
        _listBookingFuture,
        _listNotificationFuture,
        _listScheduleFuture,
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          userModel = snapshot.data[0];
          classModel = snapshot.data[1];
          subjectModel = snapshot.data[2];
          bookingModel = snapshot.data[3];
          notificationModel = snapshot.data[4];
          scheduleModel = snapshot.data[5];
          listClasses = classModel.listClasses;
          listSubjects = subjectModel.listSubject;
          listBookings = bookingModel.listBooking;
          listNotifications = notificationModel.listNotification;
          saveBranchId(userModel.branchModels.elementAt(0).branchId);
          return WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              backgroundColor: Colors.white,
              body: _isLoading
                  ? Center(
                      child: Intro10(Colors.white),
                    )
                  : Center(
                      child: _selectedIndex == 2
                          ? ProfileEightPage(
                              userData: userDataFuture,
                            )
                          : _selectedIndex == 0
                              ? Schedule(
                                  schedule: scheduleModel,
                                  branchName: userModel.branchModels
                                      .elementAt(0)
                                      .branchName)
                              : new RefreshIndicator(
                                  child: _isLoading == true
                                      ? Intro10(Colors.white)
                                      : Home(
                                          userData: userDataFuture,
                                          username: username,
                                          image: userModel.image,
                                          email: userModel.email,
                                          listClassesInput: listClasses,
                                          listSubjectsInput: listSubjects,
                                          listBookingsInput: listBookings,
                                          listNotificationsInput:
                                              listNotifications,
                                        ),
                                  onRefresh: refreshData,
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
                            text: 'Thời khóa biểu',
                          ),
                          GButton(
                            icon: Icons.home_outlined,
                            text: 'Trang chủ',
                          ),
                          GButton(
                            icon: Icons.account_circle_outlined,
                            text: 'Hồ sơ',
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
          return Intro5(Colors.white);
      },
    );
  }
}

// HOME START

TextStyle priceTextStyle =
    TextStyle(color: Colors.blue, fontSize: 20, fontWeight: FontWeight.bold);

class Home extends StatelessWidget {
  Home(
      {Key key,
      this.userData,
      this.username,
      this.image,
      this.email,
      this.listClassesInput,
      this.listSubjectsInput,
      this.listBookingsInput,
      this.listNotificationsInput})
      : super(key: key);

  Future<UserResponseModel> userData;
  List<ClassModel> listClassesInput;
  List<SubjectModel> listSubjectsInput;
  List<BookingModel> listBookingsInput;
  List<NotificationModel> listNotificationsInput;
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();
  String username;
  String image;
  String email;
  final Color primary = Colors.white;
  final Color active = Colors.grey.shade800;
  final Color divider = Colors.grey.shade600;

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
        title: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            border: Border.all(
                width: 1, color: Theme.of(context).scaffoldBackgroundColor),
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: ExactAssetImage('assets/images/cnpr_logo.png'),
            ),
          ),
        ),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          IconButton(
              onPressed: () {
                // Navigator.pushNamed(context, reply_routes.homeRoute);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new StudyWrapper(
                      study: reply.ReplyApp(
                        listNotification: listNotificationsInput,
                        loadingData: false,
                      ),
                      hasBottomNavBar: false,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.notifications_none_outlined,
                color: AppColor.greenTheme,
              )),
        ],
      ),
      drawer: _buildDrawer(image, context),
      backgroundColor: Colors.grey.shade200,
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: Row(
              children: [
                Text(
                  "Môn học bạn có thể thích",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/searchSubject");
                  },
                  child: Text("Xem tất cả"),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: 150,
            margin: EdgeInsets.only(top: 30),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  listSubjectsInput.length < 8 ? listSubjectsInput.length : 8,
              itemBuilder: (BuildContext context, int index) {
                return _categoryList(context, index);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 15, left: 10, right: 10),
            child: Row(
              children: [
                Text(
                  "Lớp học sắp khai giảng",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/searchClass");
                  },
                  child: Text("Xem tất cả"),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: double.infinity,
            height: 150,
            margin: EdgeInsets.only(top: 15),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: listClassesInput.length == 0
                  ? 0
                  : listClassesInput.length == 1
                      ? 1
                      : listClassesInput.length == 2
                          ? 2
                          : listClassesInput.length == 3
                              ? 3
                              : listClassesInput.length == 4
                                  ? 4
                                  : 5,
              itemBuilder: (BuildContext context, int index) {
                return _featuredProduct(context, index);
              },
            ),
          ),
          Container(
            width: double.infinity,
            // color: Colors.grey.shade300,
            height: 60.0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: <Widget>[
                  Text(
                    "Lịch sử đăng ký",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, "/bookingHistory");
                      print("hello");
                    },
                    child: Text("Xem tất cả"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4.0),
          ...listBookingsInput.map((item) {
            return ProductListItem(
              onPressed: () {},
              subjectName: item.subjectName,
              subjectPrice: item.payingPrice,
              image: item.image,
            );
          }),
          const SizedBox(height: 10.0),
        ],
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
              color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
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
                      onPressed: () {},
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
                    username,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    email,
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
                      showBadge: true),
                  _buildDivider(),
                  _buildRow(context, Icons.email, "Đánh giá lớp học"),
                  _buildDivider(),
                  _buildRow(context, Icons.info_outline, "Cần giúp đỡ"),
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
          if (title == 'Thông báo') {
            Navigator.push(
              context,
              new MaterialPageRoute(
                builder: (context) => new StudyWrapper(
                  study: reply.ReplyApp(
                    listNotification: listNotificationsInput,
                    loadingData: false,
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

  // Chỗ này sẽ update data truyền vào (lấy từ API)
  Widget _featuredProduct(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, "/searchClass");
      },
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey,
              image: DecorationImage(
                // image: NetworkImage(
                //     // 'https://firebasestorage.googleapis.com/v0/b/dl-flutter-ui-challenges.appspot.com/o/img%2F1.jpg?alt=media'
                //     'https://blog.coursify.me/wp-content/uploads/2016/04/online-classes-coursifyme.jpg'),
                image: AssetImage("assets/images/classroom_close_opening.jpg"),
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
                listClassesInput[index].className,
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

  Widget _categoryList(BuildContext context, int index) {
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
    for (var i = 0; i < listSubjectsInput.length; i++) {
      listSubjectsInput[i].image = imageUrl[i % 10];
    }
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.black12,
                image: DecorationImage(
                    image: NetworkImage(listSubjectsInput[index].image),
                    fit: BoxFit.cover)),
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20),
            width: 100,
            height: 100,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            listSubjectsInput[index].subjectName,
            maxLines: 2,
          )
        ],
      ),
    );
  }
}

// Ở đây trong tương lai cũng sẽ truyền data vào (Data từ API)
class ProductListItem extends StatelessWidget {
  final Function onPressed;
  const ProductListItem(
      {Key key,
      this.onPressed,
      this.subjectName,
      this.subjectPrice,
      this.image})
      : super(key: key);

  final String subjectName;
  final double subjectPrice;
  final String image;

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
              height: 90,
              width: 90,
              decoration: BoxDecoration(
                color: Colors.black,
                image: DecorationImage(
                  image: NetworkImage(image),
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
                            Text(subjectName),
                            SizedBox(
                              height: 5,
                            ),
                            Text(subjectPrice.toInt().toString() + "₫",
                                style: priceTextStyle)
                          ],
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.arrow_right_alt_rounded,
                      //     size: 22,
                      //   ),
                      //   onPressed: () {
                      //     print('tapped');
                      //   },
                      // )
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

class Schedule extends StatefulWidget {
  const Schedule({
    Key key,
    this.schedule,
    this.branchName,
  }) : super(key: key);

  final ScheduleResponseModel schedule;
  final String branchName;

  @override
  _ScheduleState createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  String dayOfWeek;
  String month;
  String year;
  int dayOfToday;
  int dayOfMonday;
  int dayOfTuesday;
  int dayOfWednesday;
  int dayOfThursday;
  int dayOfFriday;
  int dayOfSaturday;
  int dayOfSunday;
  DateFormat formatterInit = new DateFormat('dd');
  bool isSelectedMonday = false;
  bool isSelectedTuesday = false;
  bool isSelectedWednesday = false;
  bool isSelectedThursday = false;
  bool isSelectedFriday = false;
  bool isSelectedSaturday = false;
  bool isSelectedSunday = false;
  List<SessionModel> listSession;

  String selectedMonth;
  bool isLoadingDataFromPickingDate;

  String username;
  Future<ScheduleResponseModel> scheduleDataFuture;

  ScheduleResponseModel scheduleDataPicked;

  bool isToday;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isToday = true;
    isLoadingDataFromPickingDate = false;
    dayOfWeek = DateFormat("EEEE").format(DateTime.now());
    scheduleDataPicked = widget.schedule;
    switch (dayOfWeek) {
      case "Monday":
        isSelectedMonday = true;
        listSession = widget.schedule.monday.listSession;
        break;
      case "Tuesday":
        isSelectedTuesday = true;
        listSession = widget.schedule.tuesday.listSession;
        break;
      case "Wednesday":
        isSelectedWednesday = true;
        listSession = widget.schedule.wednesday.listSession;
        break;
      case "Thursday":
        isSelectedThursday = true;
        listSession = widget.schedule.thursday.listSession;
        break;
      case "Friday":
        isSelectedFriday = true;
        listSession = widget.schedule.friday.listSession;
        break;
      case "Saturday":
        isSelectedSaturday = true;
        listSession = widget.schedule.saturday.listSession;
        break;
      case "Sunday":
        isSelectedSunday = true;
        listSession = widget.schedule.sunday.listSession;
        break;
      default:
    }
    year = DateFormat("yyyy").format(DateTime.now());
    selectedMonth = DateFormat("MM").format(DateTime.now());
    switch (selectedMonth) {
      case "01":
        month = "Tháng 1";
        break;
      case "02":
        month = "Tháng 2";
        break;
      case "03":
        month = "Tháng 3";
        break;
      case "04":
        month = "Tháng 4";
        break;
      case "05":
        month = "Tháng 5";
        break;
      case "06":
        month = "Tháng 6";
        break;
      case "07":
        month = "Tháng 7";
        break;
      case "08":
        month = "Tháng 8";
        break;
      case "09":
        month = "Tháng 9";
        break;
      case "10":
        month = "Tháng 10";
        break;
      case "11":
        month = "Tháng 11";
        break;
      case "12":
        month = "Tháng 12";
        break;
    }
    dayOfToday = int.parse(DateFormat("dd").format(DateTime.now()));

    dayOfMonday = int.parse(
        formatterInit.format(DateTime.parse(widget.schedule.monday.datetime)));

    dayOfTuesday = int.parse(
        formatterInit.format(DateTime.parse(widget.schedule.tuesday.datetime)));

    dayOfWednesday = int.parse(formatterInit
        .format(DateTime.parse(widget.schedule.wednesday.datetime)));

    dayOfThursday = int.parse(formatterInit
        .format(DateTime.parse(widget.schedule.thursday.datetime)));

    dayOfFriday = int.parse(
        formatterInit.format(DateTime.parse(widget.schedule.friday.datetime)));

    dayOfSaturday = int.parse(formatterInit
        .format(DateTime.parse(widget.schedule.saturday.datetime)));

    dayOfSunday = int.parse(
        formatterInit.format(DateTime.parse(widget.schedule.sunday.datetime)));
  }

  _selectedDate(BuildContext context) async {
    DateTime selectedDate = DateTime.now();

    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      setState(() {
        isLoadingDataFromPickingDate = true;
      });
      scheduleDataPicked =
          await scheduleData(DateFormat("yyyy-MM-dd").format(selectedDate));
      setState(() {
        year = DateFormat("yyyy").format(selectedDate);
        selectedMonth = DateFormat("MM").format(selectedDate);
        switch (selectedMonth) {
          case "01":
            month = "Tháng 1";
            break;
          case "02":
            month = "Tháng 2";
            break;
          case "03":
            month = "Tháng 3";
            break;
          case "04":
            month = "Tháng 4";
            break;
          case "05":
            month = "Tháng 5";
            break;
          case "06":
            month = "Tháng 6";
            break;
          case "07":
            month = "Tháng 7";
            break;
          case "08":
            month = "Tháng 8";
            break;
          case "09":
            month = "Tháng 9";
            break;
          case "10":
            month = "Tháng 10";
            break;
          case "11":
            month = "Tháng 11";
            break;
          case "12":
            month = "Tháng 12";
            break;
        }
      });
      dayOfToday = int.parse(DateFormat("dd").format(selectedDate));

      dayOfMonday = int.parse(formatterInit
          .format(DateTime.parse(scheduleDataPicked.monday.datetime)));

      dayOfTuesday = int.parse(formatterInit
          .format(DateTime.parse(scheduleDataPicked.tuesday.datetime)));

      dayOfWednesday = int.parse(formatterInit
          .format(DateTime.parse(scheduleDataPicked.wednesday.datetime)));

      dayOfThursday = int.parse(formatterInit
          .format(DateTime.parse(scheduleDataPicked.thursday.datetime)));

      dayOfFriday = int.parse(formatterInit
          .format(DateTime.parse(scheduleDataPicked.friday.datetime)));

      dayOfSaturday = int.parse(formatterInit
          .format(DateTime.parse(scheduleDataPicked.saturday.datetime)));

      dayOfSunday = int.parse(formatterInit
          .format(DateTime.parse(scheduleDataPicked.sunday.datetime)));

      switch (DateFormat("EEEE").format(selectedDate)) {
        case "Monday":
          isSelectedMonday = true;
          isSelectedTuesday = false;
          isSelectedWednesday = false;
          isSelectedThursday = false;
          isSelectedFriday = false;
          isSelectedSaturday = false;
          isSelectedSunday = false;
          // We set list session of selected day here
          listSession = scheduleDataPicked.monday.listSession;
          break;
        case "Tuesday":
          isSelectedMonday = false;
          isSelectedTuesday = true;
          isSelectedWednesday = false;
          isSelectedThursday = false;
          isSelectedFriday = false;
          isSelectedSaturday = false;
          isSelectedSunday = false;
          // We set list session of selected day here
          listSession = scheduleDataPicked.tuesday.listSession;
          break;
        case "Wednesday":
          isSelectedMonday = false;
          isSelectedTuesday = false;
          isSelectedWednesday = true;
          isSelectedThursday = false;
          isSelectedFriday = false;
          isSelectedSaturday = false;
          isSelectedSunday = false;
          // We set list session of selected day here
          listSession = scheduleDataPicked.wednesday.listSession;
          break;
        case "Thursday":
          isSelectedMonday = false;
          isSelectedTuesday = false;
          isSelectedWednesday = false;
          isSelectedThursday = true;
          isSelectedFriday = false;
          isSelectedSaturday = false;
          isSelectedSunday = false;
          // We set list session of selected day here
          listSession = scheduleDataPicked.thursday.listSession;
          break;
        case "Friday":
          isSelectedMonday = false;
          isSelectedTuesday = false;
          isSelectedWednesday = false;
          isSelectedThursday = false;
          isSelectedFriday = true;
          isSelectedSaturday = false;
          isSelectedSunday = false;
          // We set list session of selected day here
          listSession = scheduleDataPicked.friday.listSession;
          break;
        case "Saturday":
          isSelectedMonday = false;
          isSelectedTuesday = false;
          isSelectedWednesday = false;
          isSelectedThursday = false;
          isSelectedFriday = false;
          isSelectedSaturday = true;
          isSelectedSunday = false;
          // We set list session of selected day here
          listSession = scheduleDataPicked.saturday.listSession;
          break;
        case "Sunday":
          isSelectedMonday = false;
          isSelectedTuesday = false;
          isSelectedWednesday = false;
          isSelectedThursday = false;
          isSelectedFriday = false;
          isSelectedSaturday = false;
          isSelectedSunday = true;
          // We set list session of selected day here
          listSession = scheduleDataPicked.sunday.listSession;
          break;
        default:
      }
      print("selectedDate: " + selectedDate.toString());
      print("Today: " + DateTime.now().toString());

      if (DateFormat("yyyy-MM-dd").format(selectedDate) !=
          DateFormat("yyyy-MM-dd").format(DateTime.now())) {
        isToday = false;
      } else {
        isToday = true;
      }
      isLoadingDataFromPickingDate = false;
    }
  }

  Future<ScheduleResponseModel> scheduleData(String pickedDate) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    APIService apiService = new APIService();
    scheduleDataFuture = apiService.getScheduleData(username, pickedDate);
    return scheduleDataFuture;
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingDataFromPickingDate
        ? Center(
            child: Intro10(Colors.white),
          )
        : Stack(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                alignment: Alignment.topCenter,
                color: Color(0xFFF0F0F0),
                height: MediaQuery.of(context).size.height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.calendar_today),
                      hoverColor: AppColor.orange,
                      focusColor: AppColor.orange,
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 40),
                      onPressed: () {
                        _selectedDate(context);
                      },
                    ),
                    Row(
                      children: [
                        // Icon(Icons.calendar_today),
                        SizedBox(
                          width: 15,
                        ),
                        RichText(
                          text: TextSpan(
                              text: month,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0XFF263064),
                                fontSize: 22,
                              ),
                              children: [
                                TextSpan(
                                  text: " " + year,
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16,
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                    Text(
                      isToday ? "Today" : "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0XFF3E3993),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                top: 100,
                child: Container(
                  height: MediaQuery.of(context).size.height - 160,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 30),
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            buildDateColumn(
                                "T2", dayOfMonday, isSelectedMonday, "Monday"),
                            buildDateColumn("T3", dayOfTuesday,
                                isSelectedTuesday, "Tuesday"),
                            buildDateColumn("T4", dayOfWednesday,
                                isSelectedWednesday, "Wednesday"),
                            buildDateColumn("T5", dayOfThursday,
                                isSelectedThursday, "Thursday"),
                            buildDateColumn(
                                "T6", dayOfFriday, isSelectedFriday, "Friday"),
                            buildDateColumn("T7", dayOfSaturday,
                                isSelectedSaturday, "Saturday"),
                            buildDateColumn(
                                "CN", dayOfSunday, isSelectedSunday, "Sunday"),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          // physics: ScrollPhysics(),
                          child: Column(
                            children: [
                              ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: listSession.isNotEmpty
                                      ? listSession.length
                                      : 1,
                                  itemBuilder: (context, index) {
                                    return listSession.isNotEmpty
                                        ? buildTaskListItem(context, index,
                                            listSession, widget.branchName)
                                        // : Container(
                                        //     alignment: Alignment.center,
                                        //     child: Text(
                                        //         "Thời gian này không có lớp nào diễn ra trong ngày"),
                                        //   );
                                        : Column(
                                            children: [
                                              Container(
                                                alignment: Alignment.center,
                                                constraints: BoxConstraints(
                                                    maxHeight: 150,
                                                    maxWidth: 150),
                                                child: Intro8(Colors.white),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.only(
                                                  left: 30,
                                                  right: 30,
                                                ),
                                                child: Text(
                                                  "Thời gian này không có lớp nào diễn ra trong ngày",
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          );
                                  }),
                              // buildTaskListItem(context),
                              // buildTaskListItem(context),
                              // buildTaskListItem(context),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          );
  }

  Container buildTaskListItem(BuildContext context, int index,
      List<SessionModel> listSession, String branchName) {
    DateTime dt = DateTime.parse(listSession[index].startTime);
    String dtStartFormat = DateFormat("kk:mm").format(dt);
    int hour = int.parse(DateFormat("kk").format(dt));
    return Container(
      margin: EdgeInsets.only(bottom: 25),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 15,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.horizontal(
                      right: Radius.circular(5),
                    )),
              ),
              SizedBox(
                width: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                          // Start Time Here
                          text: dtStartFormat,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: hour >= 0 && hour < 12 ? " AM" : " PM",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            )
                          ]),
                    ),
                    // Process this later

                    // Text(
                    //   "1 h 45 min",
                    //   style: TextStyle(
                    //     color: Colors.grey,
                    //   ),
                    // )
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            height: 185,
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(width: 1, color: Colors.grey[300]),
                borderRadius: BorderRadius.circular(20)),
            margin: EdgeInsets.only(right: 10, left: 30),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Subject Name here
                  listSession[index].subjectName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(
                  // Class Name here
                  listSession[index].className,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 9,
                      backgroundImage: NetworkImage(
                          // Image of Teacher here
                          listSession[index].teacherImage),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // Teacher Name here
                          listSession[index].teacherName,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // Later if we need phone number of teacher, we'll put the parameter phone number here

                        Text(
                          listSession[index].teacherPhone,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // Branch Name here
                          // "Chi nhánh trung tâm AB " +
                          branchName,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        // Room Name here
                        Text(
                          "Room " + listSession[index].roomName,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Stack buildDateColumn(
      String weekDay, int date, bool isActive, String selectedDay) {
    return Stack(children: [
      AnimatedOpacity(
        duration: const Duration(milliseconds: 500),
        opacity: isActive ? 1.0 : 0.0,
        child: Container(
          decoration: isActive
              ? BoxDecoration(
                  color: AppColor.orange,
                  borderRadius: BorderRadius.circular(10))
              : BoxDecoration(),
          height: 55,
          width: 35,
        ),
      ),
      Container(
        decoration: BoxDecoration(),
        height: 55,
        width: 35,
        child: InkWell(
          onTap: () {
            setState(() {
              switch (selectedDay) {
                case "Monday":
                  isSelectedMonday = true;
                  isSelectedTuesday = false;
                  isSelectedWednesday = false;
                  isSelectedThursday = false;
                  isSelectedFriday = false;
                  isSelectedSaturday = false;
                  isSelectedSunday = false;
                  // We set list session of selected day here
                  listSession = scheduleDataPicked.monday.listSession;
                  break;
                case "Tuesday":
                  isSelectedMonday = false;
                  isSelectedTuesday = true;
                  isSelectedWednesday = false;
                  isSelectedThursday = false;
                  isSelectedFriday = false;
                  isSelectedSaturday = false;
                  isSelectedSunday = false;
                  // We set list session of selected day here
                  listSession = scheduleDataPicked.tuesday.listSession;
                  break;
                case "Wednesday":
                  isSelectedMonday = false;
                  isSelectedTuesday = false;
                  isSelectedWednesday = true;
                  isSelectedThursday = false;
                  isSelectedFriday = false;
                  isSelectedSaturday = false;
                  isSelectedSunday = false;
                  // We set list session of selected day here
                  listSession = scheduleDataPicked.wednesday.listSession;
                  break;
                case "Thursday":
                  isSelectedMonday = false;
                  isSelectedTuesday = false;
                  isSelectedWednesday = false;
                  isSelectedThursday = true;
                  isSelectedFriday = false;
                  isSelectedSaturday = false;
                  isSelectedSunday = false;
                  // We set list session of selected day here
                  listSession = scheduleDataPicked.thursday.listSession;
                  break;
                case "Friday":
                  isSelectedMonday = false;
                  isSelectedTuesday = false;
                  isSelectedWednesday = false;
                  isSelectedThursday = false;
                  isSelectedFriday = true;
                  isSelectedSaturday = false;
                  isSelectedSunday = false;
                  // We set list session of selected day here
                  listSession = scheduleDataPicked.friday.listSession;
                  break;
                case "Saturday":
                  isSelectedMonday = false;
                  isSelectedTuesday = false;
                  isSelectedWednesday = false;
                  isSelectedThursday = false;
                  isSelectedFriday = false;
                  isSelectedSaturday = true;
                  isSelectedSunday = false;
                  // We set list session of selected day here
                  listSession = scheduleDataPicked.saturday.listSession;
                  break;
                case "Sunday":
                  isSelectedMonday = false;
                  isSelectedTuesday = false;
                  isSelectedWednesday = false;
                  isSelectedThursday = false;
                  isSelectedFriday = false;
                  isSelectedSaturday = false;
                  isSelectedSunday = true;
                  // We set list session of selected day here
                  listSession = scheduleDataPicked.sunday.listSession;
                  break;
                default:
              }
            });
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                weekDay,
                style: TextStyle(
                    color: isActive ? Colors.white : Colors.grey, fontSize: 11),
              ),
              Text(
                date.toString(),
                style: TextStyle(
                    color: isActive ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    ]);
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
                                  subtitle: Text(
                                      snapshot.data.parentPhone.isNotEmpty
                                          ? snapshot.data.parentPhone
                                          : "Chưa cập nhật"),
                                ),
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text("Tên phụ huynh"),
                                  subtitle: Text(
                                      snapshot.data.parentName.isNotEmpty
                                          ? snapshot.data.parentName
                                          : "Chưa cập nhật"),
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
                style: Theme.of(context).textTheme.headline6,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.subtitle1,
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

/// Wrap the studies with this to display a back button and allow the user to
/// exit them at any time.
class StudyWrapper extends StatefulWidget {
  const StudyWrapper({
    Key key,
    this.study,
    this.alignment = AlignmentDirectional.bottomStart,
    this.hasBottomNavBar = false,
  }) : super(key: key);

  final Widget study;
  final bool hasBottomNavBar;
  final AlignmentDirectional alignment;

  @override
  _StudyWrapperState createState() => _StudyWrapperState();
}

class _StudyWrapperState extends State<StudyWrapper> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Semantics(
          sortKey: const OrdinalSortKey(1),
          child: RestorationScope(
            restorationId: 'study_wrapper',
            child: widget.study,
          ),
        ),
        SafeArea(
          child: Align(
            alignment: widget.alignment,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: widget.hasBottomNavBar
                      ? kBottomNavigationBarHeight + 16.0
                      : 16.0),
              child: Semantics(
                sortKey: const OrdinalSortKey(0),
                button: true,
                enabled: true,
                excludeSemantics: true,
                child: FloatingActionButton.extended(
                  backgroundColor: AppColor.blueForText,
                  heroTag: _BackButtonHeroTag(),
                  key: const ValueKey('Trở về'),
                  onPressed: () {
                    Navigator.of(context)
                        .popUntil((route) => route.settings.name == '/home');
                  },
                  icon: IconTheme(
                    data: IconThemeData(color: colorScheme.onPrimary),
                    child: const BackButtonIcon(),
                  ),
                  label: Text(
                    "Trở về",
                    style: textTheme.button.apply(color: colorScheme.onPrimary),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BackButtonHeroTag {}
