import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lcss_mobile_app/Util/constant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static List<Widget> _widgetOptions = <Widget>[
    Text(
      'Schedule',
      style: optionStyle,
    ),
    Home(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
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
  Profile({
    Key key,
  }) : super(key: key);

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
                Navigator.pushNamed(context, '/editProfile');
              },
            )
          ],
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          expandedHeight: 300,
          stretch: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: true,
            stretchModes: <StretchMode>[
              StretchMode.zoomBackground,
              StretchMode.blurBackground,
              StretchMode.fadeTitle,
            ],
            title: Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 40),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Text('Landy Carol'),
              ),
            ),
            background: new Image.asset(
              'assets/images/bg_profile.png',
              fit: BoxFit.fill,
              colorBlendMode: BlendMode.darken,
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          Container(
            height: 110,
            color: Colors.white,
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
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
                      child: Text(
                        "0215786498", // Truyen data tu login vao
                        style: TextStyle(
                          color: Color(0xff546e7a),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 150,
            color: Colors.white,
            child: Column(
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
                Column(
                  children: <Widget>[
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
                      child: Text(
                        "carol12ld@gmail.com", // truyen data tu login vao
                        style: TextStyle(
                          color: Color(0xff546e7a),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: 200,
            color: Colors.white,
            child: Column(
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
                Column(
                  children: <Widget>[
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
                      child: Text(
                        "New York City, 26SD Street, Baram Store", // truyen data tu login vao
                        style: TextStyle(
                          color: Color(0xff546e7a),
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
