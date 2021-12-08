import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/component/EnergyRateClipper.dart';
import 'package:lcss_mobile_app/model/booking_model.dart';
import 'package:lcss_mobile_app/screen/BookingHistory/booking_history_detail.dart';

class GeneralCard extends StatefulWidget {
  final BookingModel bookingData;

  GeneralCard(this.bookingData);
  @override
  _GeneralCardState createState() => new _GeneralCardState();
}

class _GeneralCardState extends State<GeneralCard> {
  DateTime dt;
  DateFormat formatter;
  String payingDate;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dt = DateTime.parse(widget.bookingData.payingDate);
    formatter = new DateFormat('dd-MM-yyyy');
    payingDate = formatter.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new BookingDetailPage(
              bookingData: widget.bookingData,
            ),
          ),
        );
      },
      child: Stack(
        children: <Widget>[
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 2,
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF2FA375),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              "${widget.bookingData.branchName}",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "${widget.bookingData.payingPrice.toInt()}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                  Text(
                                    " vn₫",
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "${widget.bookingData.className}",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          payingDate,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 75.0,
                  child: ClipPath(
                    clipper: EnergyRateClipper(),
                    child: Container(
                      height: 70.0,
                      decoration: BoxDecoration(
                        color: AppColor.greenTheme,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0.0,
                  right: 0.0,
                  bottom: 70.0,
                  child: ClipPath(
                    clipper: EnergyRateClipper(),
                    child: Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
