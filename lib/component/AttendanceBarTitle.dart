import 'package:flutter/material.dart';
import 'package:lcss_mobile_app/Util/constant.dart';

class AttendanceBarTitle extends StatelessWidget {
  const AttendanceBarTitle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(
            thickness: 2,
            color: AppColor.blueForText,
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Ngày học",
                style: TextStyle(
                  color: AppColor.blueForText,
                  fontSize: 20,
                ),
              ),
              SizedBox(width: 170),
              Text(
                "Điểm danh",
                style: TextStyle(
                  color: AppColor.blueForText,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          Divider(
            thickness: 2,
            color: AppColor.blueForText,
          ),
        ],
      ),
    );
  }
}
