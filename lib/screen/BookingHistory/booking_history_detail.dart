/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/component/PNetworkImage.dart';
import 'package:lcss_mobile_app/model/booking_model.dart';

class BookingDetailPage extends StatelessWidget {
  const BookingDetailPage({this.bookingData});

  final BookingModel bookingData;

  @override
  Widget build(BuildContext context) {
    DateTime dt = DateTime.parse(bookingData.payingDate);
    DateFormat formatter = new DateFormat('dd-MM-yyyy');
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
              height: double.infinity,
              child: PNetworkImage(
                "https://www.nttdata.com/vn/en/-/media/nttdataapac/ndvn/services/card-and-payment-services/services_card-and-payment-services_header_2732x1536.jpg",
                fit: BoxFit.cover,
              )),
          SafeArea(
              child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  MaterialButton(
                    padding: const EdgeInsets.all(8.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                    textColor: Colors.black,
                    minWidth: 0,
                    height: 40,
                    onPressed: () => Navigator.pop(context),
                  ),
                ]),
              ),
              Spacer(),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(height: 30.0),
                      Expanded(
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                title: Text(
                                  bookingData.subjectName,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 28.0),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.favorite_border),
                                  onPressed: () {},
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  bookingData.description.isNotEmpty
                                      ? bookingData.description
                                      : "Không có mô tả",
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ),
                              ExpansionTile(
                                title: Text(
                                  "Xem thêm thông tin",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("Ca học: " +
                                        bookingData.shiftDescription),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("Tên chi nhánh: " +
                                        bookingData.branchName),
                                  ),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text("Ngày đăng ký: " +
                                        formatter.format(dt)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(32.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(20.0)),
                          color: Colors.grey.shade900,
                        ),
                        child: Row(
                          children: <Widget>[
                            Text(
                              bookingData.payingPrice.toInt().toString() +
                                  " vn₫",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0),
                            ),
                            const SizedBox(width: 20.0),
                            Spacer(),
                            RaisedButton(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 16.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              onPressed: () {},
                              color: bookingData.status.toLowerCase() ==
                                      "processed"
                                  ? AppColor.greenTheme
                                  : bookingData.status.toLowerCase() == "paid"
                                      ? Colors.orange
                                      : Colors.red,
                              textColor: Colors.white,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text(
                                    bookingData.status.toLowerCase() ==
                                            "processed"
                                        ? "Đã khai giảng"
                                        : bookingData.status.toLowerCase() ==
                                                "paid"
                                            ? "Chờ khai giảng"
                                            : "Đã hủy",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0),
                                  ),
                                  const SizedBox(width: 10.0),
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      bookingData.status.toLowerCase() ==
                                              "processed"
                                          ? Icons.done
                                          : bookingData.status.toLowerCase() ==
                                                  "paid"
                                              ? Icons.alarm
                                              : Icons.close,
                                      color: bookingData.status.toLowerCase() ==
                                              "processed"
                                          ? AppColor.greenTheme
                                          : bookingData.status.toLowerCase() ==
                                                  "paid"
                                              ? Colors.orange
                                              : Colors.red,
                                      size: 16.0,
                                    ),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(10.0)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
