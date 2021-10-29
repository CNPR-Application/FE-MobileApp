import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/model/attendance_model.dart';

class AttendanceCircle extends StatelessWidget {
  const AttendanceCircle({Key key, this.attendanceData}) : super(key: key);

  final AttendanceModel attendanceData;

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(attendanceData.startTime);
    DateFormat formatter = new DateFormat('dd-MM-yyyy');
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              formatter.format(dt),
              style: TextStyle(fontSize: 20, color: AppColor.blueForText),
            ),
          ),
          Row(
            children: [
              AttendanceIconPresent(attendanceData: attendanceData),
              SizedBox(width: 10),
              AttendanceIconAbsent(attendanceData: attendanceData),
              SizedBox(width: 10),
              AttendanceIconNotYet(attendanceData: attendanceData),
            ],
          ),
        ],
      ),
    );
  }
}

class AttendanceIconPresent extends StatelessWidget {
  const AttendanceIconPresent({
    Key key,
    @required this.attendanceData,
  }) : super(key: key);

  final AttendanceModel attendanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(180),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: attendanceData.status == "present"
              ? [Color(0xff13bfad), Color(0xff4fe4a2)]
              : [AppColor.grayDisable, AppColor.grayDisable],
          // colors: [Color(0xff13bfad), Color(0xff4fe4a2)],
        ),
      ),
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            attendanceData.status == "present" ? "P" : "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          // Text(
          //   "P",
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 28,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class AttendanceIconAbsent extends StatelessWidget {
  const AttendanceIconAbsent({
    Key key,
    @required this.attendanceData,
  }) : super(key: key);

  final AttendanceModel attendanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(180),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: attendanceData.status == "absent"
              ? [Color(0xffe9507d), Color(0xfffb6799)]
              : [AppColor.grayDisable, AppColor.grayDisable],
          // colors: [Color(0xffe9507d), Color(0xfffb6799)],
        ),
      ),
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            attendanceData.status == "absent" ? "A" : "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
          // Text(
          //   "A",
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 28,
          //   ),
          // ),
        ],
      ),
    );
  }
}

class AttendanceIconNotYet extends StatelessWidget {
  const AttendanceIconNotYet({
    Key key,
    @required this.attendanceData,
  }) : super(key: key);

  final AttendanceModel attendanceData;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(180),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: attendanceData.status == "not yet"
              ? [Color(0xfffca264), Color(0xfff4c558)]
              : [AppColor.grayDisable, AppColor.grayDisable],
        ),
      ),
      padding: const EdgeInsets.only(
        left: 10,
        right: 10,
        top: 10,
        bottom: 10,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            attendanceData.status == "not yet" ? "N" : "",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }
}
