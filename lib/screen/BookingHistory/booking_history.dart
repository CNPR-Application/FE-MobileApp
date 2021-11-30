import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/component/GeneralCard.dart';
import 'package:lcss_mobile_app/model/booking_model.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({Key key}) : super(key: key);

  @override
  _BookingHistoryPageState createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  Future<BookingResponseModel> bookingDataFuture;
  BookingResponseModel bookingModel;
  List<BookingModel> listBookings;

  String username;
  SharedPreferences prefs;

  Future<BookingResponseModel> bookingData() async {
    prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
    APIService apiService = new APIService();
    apiService.setTokenLogin(prefs.getString("jwt"));
    bookingDataFuture = apiService.getAllBookingOfStudent(1, 1000, username);
    return bookingDataFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BookingResponseModel>(
      future: bookingData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          listBookings = snapshot.data.listBooking;
          return Scaffold(
              appBar: AppBar(
                title: Text(
                  "Lịch sử đăng ký",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: AppColor.greenTheme,
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    maxCrossAxisExtent: 200,
                  ),
                  itemCount: listBookings.length,
                  itemBuilder: (context, index) =>
                      GeneralCard(listBookings[index]),
                ),
              ));
        } else
          return Intro5(Colors.white);
      },
    );
  }
}
