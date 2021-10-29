/**
 * Author: Sudip Thapa  
 * profile: https://github.com/sudeepthapa
  */

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/subject_detail_model.dart';
import 'package:lcss_mobile_app/model/subject_model.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:lcss_mobile_app/screen/Subject/subject_detail.dart';

class SearchSubject extends StatefulWidget {
  SearchSubject({Key key}) : super(key: key);
  static final String path = "lib/src/pages/lists/list2.dart";

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isSearch = false;
  }

  final List<Map> schoolLists = [
    {
      "name": "Edgewick Scchol",
      "location": "572 Statan NY, 12483",
      "type": "Higher Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_960_720.png"
    },
    {
      "name": "Xaviers International",
      "location": "234 Road Kathmandu, Nepal",
      "type": "Higher Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2017/01/31/13/14/animal-2023924_960_720.png"
    },
    {
      "name": "Kinder Garden",
      "location": "572 Statan NY, 12483",
      "type": "Play Group School",
      "logoText":
          "https://cdn.pixabay.com/photo/2016/06/09/18/36/logo-1446293_960_720.png"
    },
    {
      "name": "WilingTon Cambridge",
      "location": "Kasai Pantan NY, 12483",
      "type": "Lower Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2017/01/13/01/22/rocket-1976107_960_720.png"
    },
    {
      "name": "Fredik Panlon",
      "location": "572 Statan NY, 12483",
      "type": "Higher Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2017/03/16/21/18/logo-2150297_960_720.png"
    },
    {
      "name": "Whitehouse International",
      "location": "234 Road Kathmandu, Nepal",
      "type": "Higher Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2017/01/31/13/14/animal-2023924_960_720.png"
    },
    {
      "name": "Haward Play",
      "location": "572 Statan NY, 12483",
      "type": "Play Group School",
      "logoText":
          "https://cdn.pixabay.com/photo/2016/06/09/18/36/logo-1446293_960_720.png"
    },
    {
      "name": "Campare Handeson",
      "location": "Kasai Pantan NY, 12483",
      "type": "Lower Secondary School",
      "logoText":
          "https://cdn.pixabay.com/photo/2017/01/13/01/22/rocket-1976107_960_720.png"
    },
  ];

  Future<SubjectResponseModel> subjectData() async {
    APIService apiService = new APIService();
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
          return Scaffold(
            backgroundColor: Color(0xfff0f0f0),
            body: SingleChildScrollView(
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
                              onPressed: () {},
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Môn học",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 24),
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
                                            .contains(value)) {
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
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
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
            ),
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
}
