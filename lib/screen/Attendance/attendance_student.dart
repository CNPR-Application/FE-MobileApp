import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/bloc/attendance_bloc.dart';
import 'package:lcss_mobile_app/component/AttendanceBarTitle.dart';
import 'package:lcss_mobile_app/component/AttendanceCircle.dart';
import 'package:lcss_mobile_app/model/attendance_model.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';

class StudentClassAttendancePage extends StatelessWidget {
  StudentClassAttendancePage({Key key, this.classId}) : super(key: key);

  final int classId;
  List<AttendanceModel> listAttendance;
  final attendanceBloc = new AttendanceBloc();
  bool fillOverscroll = false;
  bool hasScrollBody = false;

  @override
  Widget build(BuildContext context) {
    attendanceBloc.getAttendanceData(classId);
    return StreamBuilder<AttendanceResponseModel>(
        stream: attendanceBloc.attendanceData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error);
          } else if (snapshot.hasData) {
            listAttendance = snapshot.data.listAttendance;
            return Scaffold(
              backgroundColor: Colors.white,
              body: CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    backgroundColor: Colors.white,
                    iconTheme: IconThemeData(color: AppColor.greenTheme),
                    expandedHeight: 120,
                    title: Text(
                      "ĐIỂM DANH",
                      style: TextStyle(color: AppColor.greenTheme),
                    ),
                    centerTitle: true,
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.pin,
                      centerTitle: true,
                      background: Container(
                          alignment: Alignment.bottomCenter,
                          padding: EdgeInsets.only(bottom: 10),
                          child: AttendanceBarTitle()),
                    ),
                  ),
                  listAttendance.isEmpty
                      ? SliverFillRemaining(
                          hasScrollBody: hasScrollBody,
                          fillOverscroll: fillOverscroll,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Flexible(
                                child: Center(
                                  child: Container(
                                    padding:
                                        EdgeInsets.only(left: 30, right: 20),
                                    child: Text(
                                      "Hiện tại lớp chưa khai giảng nên không có điểm danh",
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Colors.black45,
                                      ),
                                    ),
                                  ),
                                ),
                                fit: FlexFit.loose,
                              ),
                            ],
                          ),
                        )
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                      vertical: 30.0,
                                    ),
                                    child: AttendanceCircle(
                                      attendanceData: listAttendance[index],
                                    ),
                                  ),
                                  Divider(thickness: 1),
                                ],
                              );
                            },
                            childCount: listAttendance.length,
                          ),
                        ),
                ],
              ),
            );
          } else {
            return Intro5(Colors.white);
          }
        });
  }
}
