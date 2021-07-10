import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/class_model.dart';
import 'package:lcss_mobile_app/model/shift_model.dart';
import 'package:lcss_mobile_app/model/subject_model.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchClassPage extends StatefulWidget {
  SearchClassPage({Key key}) : super(key: key);

  @override
  _SearchClassPageState createState() => _SearchClassPageState();
}

class _SearchClassPageState extends State<SearchClassPage> {
  int _selectedSubject;
  int _selectedShift;
  int branchId;
  bool searchSubject;
  bool searchShift;

  @override
  void initState() {
    super.initState();
    searchSubject = false;
    searchShift = false;
    // CALL 3 API and get in 3 models
    // callLoad();
  }

  // callLoad() async {
  // SharedPreferences prefs = await SharedPreferences.getInstance();
  // branchId = prefs.getInt("branchId");
  //   print(branchId.toString());
  //   print(branchId.toString());
  //   print(branchId.toString());
  // }

  Future<ClassResponseModel> classDataFuture;
  Future<SubjectResponseModel> subjectDataFuture;
  Future<ShiftResponseModel> shiftDataFuture;

  int subjectId;
  int shiftId;

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

  Future<ShiftResponseModel> shiftData() async {
    APIService apiService = new APIService();
    shiftDataFuture = apiService.getAllShiftData(1, 1000);
    return shiftDataFuture;
  }

  List<ClassModel> listClasses;
  List<ClassModel> listSearchBySubject;
  List<ClassModel> listSearchByShift;
  List<ClassModel> listSearchByBoth;

  List<SubjectModel> listSubject;

  final List<Map> items = [
    {
      "title": "Japanese",
      "category": "JP1402",
      "price": 5500,
      "tags": "2-4-6 08:00 đến 09:30",
      "image":
          'https://blog.coursify.me/wp-content/uploads/2016/04/online-classes-coursifyme.jpg'
    },
    {
      "title": "Japanese",
      "category": "JP1405",
      "price": 67000,
      "tags": "2-4-6 08:00 đến 09:30",
      "image":
          'https://blog.coursify.me/wp-content/uploads/2016/04/online-classes-coursifyme.jpg'
    },
    {
      "title": "English",
      "category": "ENG1001",
      "price": 67000,
      "tags": "2-4-6 08:00 đến 09:30",
      "image":
          'https://blog.coursify.me/wp-content/uploads/2016/04/online-classes-coursifyme.jpg'
    },
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([classData(), subjectData(), shiftData()]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.hasData) {
          var classData = snapshot.data[0] as ClassResponseModel;
          listClasses = classData.listClasses;
          var subjectData = snapshot.data[1] as SubjectResponseModel;
          listSubject = subjectData.listSubject;
          var shiftData = snapshot.data[2] as ShiftResponseModel;
          // List<ClassModel> listClasses = classData.listClasses;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              // actions: <Widget>[
              //   IconButton(
              //     onPressed: () {},
              //     icon: Icon(
              //       Icons.filter_list,
              //       color: Colors.grey.shade700,
              //     ),
              //   ),
              // ],
              backgroundColor: AppColor.greenTheme,
              leading: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.menu,
                    color: Colors.white,
                  )),
              title: Text(
                'Lớp học sắp khai giảng',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
              bottom:
                  _buildBottomBar(subjectData.listSubject, shiftData.listShift),
            ),
            body: SafeArea(
                child: ListView.builder(
              itemBuilder: _buildListView,
              itemCount: searchSubject && !searchShift
                  ? listSearchBySubject.length + 1
                  : searchShift && !searchSubject
                      ? listSearchByShift.length + 1
                      : searchShift && searchSubject
                          ? listSearchByBoth.length + 1
                          : classData.listClasses.length + 1,
            )),
          );
        } else
          return Intro5();
      },
    );
  }

  PreferredSize _buildBottomBar(
      List<SubjectModel> listSubject, List<ShiftModel> listShift) {
    return PreferredSize(
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Card(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  child: DropdownButton(
                    isExpanded: true,
                    value: _selectedSubject,
                    hint: Text('Môn học'),
                    items: listSubject.map(
                      (list) {
                        return DropdownMenuItem(
                          child: Text(list.subjectName),
                          value: list.subjectId,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSubject = value;
                        subjectId = value;
                        print(subjectId);
                        // Set data cho List Search
                        listSearchBySubject = List<ClassModel>.empty();
                        for (var i = 0; i < listClasses.length; i++) {
                          if (listClasses[i].subjectId == subjectId) {
                            // listSearchBySubject.add(listClasses[i]);
                            listSearchBySubject = [
                              ...listSearchBySubject,
                              listClasses[i]
                            ];
                          }
                        }
                        if (searchShift) {
                          listSearchByBoth = List<ClassModel>.empty();
                          if (listSearchByShift.isNotEmpty) {
                            for (var i = 0; i < listClasses.length; i++) {
                              if (listClasses[i].subjectId == subjectId &&
                                  listClasses[i].shiftId ==
                                      listSearchByShift[0].shiftId) {
                                // listSearchBySubject.add(listClasses[i]);
                                listSearchByBoth = [
                                  ...listSearchByBoth,
                                  listClasses[i]
                                ];
                              }
                            }
                          }
                        }
                        searchSubject = true;
                      });
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 5, 5, 5),
                  child: DropdownButton(
                    isExpanded: true,
                    value: _selectedShift,
                    hint: Text('Ca học'),
                    items: listShift.map(
                      (list) {
                        return DropdownMenuItem(
                          child: Text(
                            list.dayOfWeek +
                                " " +
                                list.timeStart +
                                " đến " +
                                list.timeEnd,
                          ),
                          value: list.shiftId,
                        );
                      },
                    ).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedShift = value;
                        shiftId = value;
                        print(shiftId);
                        listSearchByShift = List<ClassModel>.empty();
                        for (var i = 0; i < listClasses.length; i++) {
                          if (listClasses[i].shiftId == shiftId) {
                            // listSearchBySubject.add(listClasses[i]);
                            listSearchByShift = [
                              ...listSearchByShift,
                              listClasses[i]
                            ];
                          }
                        }
                        if (searchSubject) {
                          listSearchByBoth = List<ClassModel>.empty();
                          if (listSearchBySubject.isNotEmpty) {
                            for (var i = 0; i < listClasses.length; i++) {
                              if (listClasses[i].shiftId == shiftId &&
                                  listClasses[i].subjectId ==
                                      listSearchBySubject[0].subjectId) {
                                // listSearchBySubject.add(listClasses[i]);
                                listSearchByBoth = [
                                  ...listSearchByBoth,
                                  listClasses[i]
                                ];
                              }
                            }
                          }
                        }
                        searchShift = true;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      preferredSize: Size.fromHeight(150),
    );
  }

  Widget _buildListView(BuildContext context, int index) {
    if (index == 0)
      return Container(
        padding: EdgeInsets.all(20.0),
        child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // children: <Widget>[
            //   Text(
            //     "Các lớp học sắp khai giảng",
            //     style: TextStyle(fontSize: 18.0),
            //   ),
            // ],
            ),
      );
    if (searchSubject && !searchShift) {
      ClassModel item = listSearchBySubject[index - 1];
      return _buildShopItem(item);
    } else if (searchShift && !searchSubject) {
      ClassModel item = listSearchByShift[index - 1];
      return _buildShopItem(item);
    } else if (searchSubject && searchShift) {
      ClassModel item = listSearchByBoth[index - 1];
      return _buildShopItem(item);
    }
    ClassModel item = listClasses[index - 1];
    return _buildShopItem(item);
  }

  Widget _buildShopItem(ClassModel item) {
    return Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      margin: EdgeInsets.only(bottom: 20.0),
      height: 300,
      child: Row(
        children: <Widget>[
          Expanded(
              child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(
                        'https://blog.coursify.me/wp-content/uploads/2016/04/online-classes-coursifyme.jpg'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey,
                      offset: Offset(5.0, 5.0),
                      blurRadius: 10.0)
                ]),
          )),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    item.subjectName,
                    style:
                        TextStyle(fontSize: 22.0, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(item.className,
                      style: TextStyle(color: Colors.grey, fontSize: 18.0)),
                  SizedBox(
                    height: 20.0,
                  ),
                  for (var i = 0; i < listSubject.length; i++)
                    if (item.subjectId == listSubject[i].subjectId)
                      Text("₫" + listSubject[i].price.toInt().toString(),
                          style: TextStyle(
                            color: AppColor.greenTheme,
                            fontSize: 25.0,
                          )),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(item.shiftDescription,
                      style: TextStyle(
                          fontSize: 16.0, color: Colors.grey, height: 1.5)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(item.numberOfStudent.toString() + " người đăng ký",
                      style: TextStyle(
                          fontSize: 18.0, color: Colors.red, height: 1.5))
                ],
              ),
              margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey,
                        offset: Offset(5.0, 5.0),
                        blurRadius: 10.0)
                  ]),
            ),
          )
        ],
      ),
    );
  }
}
