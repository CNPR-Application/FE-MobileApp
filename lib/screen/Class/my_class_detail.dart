/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/model/attendance_model.dart';
import 'package:lcss_mobile_app/model/myclass_model.dart';
import 'package:lcss_mobile_app/model/shift_model.dart';
import 'package:lcss_mobile_app/model/subject_model.dart';
import 'package:lcss_mobile_app/screen/Attendance/attendance_student.dart';
import 'package:lcss_mobile_app/screen/Subject/subject_detail.dart';

class MyClassDetailsPage extends StatelessWidget {
  MyClassDetailsPage({
    Key key,
    this.classData,
    this.subjectData,
  }) : super(key: key);
  Function callback;

  final ClassModel classData;
  final SubjectModel subjectData;

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(classData.openingDate);
    DateFormat formatter = new DateFormat('dd-MM-yyyy');
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            foregroundDecoration: BoxDecoration(color: Colors.black38),
            height: 400,
            child: Image.network(
              subjectData.image,
              fit: BoxFit.cover,
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 160),
                Row(
                  children: <Widget>[
                    const SizedBox(width: 16.0),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      color: Colors.white,
                      icon: Icon(Icons.favorite_border),
                      onPressed: () {},
                    )
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(32.0),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Divider(
                            color: Color(0xffD6A129),
                            thickness: 6,
                            height: 30,
                          ),
                          Center(
                            child: Text(
                              classData.className.toUpperCase(),
                              style: TextStyle(
                                  color: AppColor.greenTheme,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22.0),
                            ),
                          ),
                          Divider(
                            color: Color(0xffD6A129),
                            thickness: 6,
                            height: 30,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Text(
                            "Môn học".toUpperCase(),
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16.0),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(
                                  builder: (context) => new SubjectDetailsPage(
                                      subjectData: subjectData,
                                      subjectId: subjectData.subjectId),
                                ),
                              );
                            },
                            child: Text("Xem chi tiết"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        subjectData.subjectName,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 16.0),
                      ),
                      const SizedBox(height: 20.0),
                      const SizedBox(height: 10.0),
                      Text(
                        "Giáo viên".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        classData.teacherName,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 16.0),
                      ),
                      const SizedBox(height: 20.0),
                      const SizedBox(height: 10.0),
                      Text(
                        "Phòng học".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        classData.roomName.toString(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 16.0),
                      ),
                      const SizedBox(height: 20.0),
                      const SizedBox(height: 10.0),
                      Text(
                        "Ca học".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        classData.shiftDescription,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 16.0),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        "Tổng buổi học".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        classData.slot.toString(),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 16.0),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        "Ngày khai giảng".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        formatter.format(dt),
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 16.0),
                      ),
                      const SizedBox(height: 30.0),
                      Text(
                        "Chi nhánh".toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16.0),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        classData.branchName,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                            fontWeight: FontWeight.w300, fontSize: 16.0),
                      ),
                      const SizedBox(height: 30.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            primary: AppColor.greenTheme,
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal: 32.0,
                            ),
                          ),
                          child: Text(
                            "ĐIỂM DANH",
                            style: TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 16),
                          ),
                          onPressed: () {
                            print("hello");
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => StudentClassAttendancePage(
                                          classId: classData.classId,
                                        )));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: Text(
                "THÔNG TIN CHI TIẾT",
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.normal),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
