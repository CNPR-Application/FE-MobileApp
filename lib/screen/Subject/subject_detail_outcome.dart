/**
 * Author: Damodar Lohani
 * profile: https://github.com/lohanidamodar
  */

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/model/subject_detail_model.dart';
import 'package:lcss_mobile_app/model/subject_model.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';

class SubjectDetailOutcomePage extends StatelessWidget {
  SubjectDetailOutcomePage(this.subjectId, this.subjectData);

  final int subjectId;
  final SubjectModel subjectData;

  Future<SubjectDetailResponseModel> subjectDetailDataFuture;
  SubjectDetailResponseModel subjectDetailModel;
  List<SubjectDetailModel> listSubjectDetails;

  Future<SubjectDetailResponseModel> subjectDetailData() async {
    APIService apiService = new APIService();
    subjectDetailDataFuture = apiService.getSubjectDetail(1, 1000, subjectId);
    return subjectDetailDataFuture;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SubjectDetailResponseModel>(
      future: subjectDetailData(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          listSubjectDetails = snapshot.data.listSubjectDetail;
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Icon(
                  Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: <Widget>[
                FlatButton.icon(
                  icon: Icon(Icons.call, color: Colors.red),
                  label: Text("Liên hệ"),
                  onPressed: () {},
                )
              ],
            ),
            body: Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(20.0),
                    children: <Widget>[
                      Text(
                        subjectData.subjectName.toUpperCase(),
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      Text(subjectData.description),
                      SizedBox(
                        height: 20.0,
                      ),
                      Container(
                        height: 30,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.calendar_today_sharp),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(listSubjectDetails.length > 1
                                      ? listSubjectDetails.length.toString() +
                                          " tuần"
                                      : listSubjectDetails.length.toString() +
                                          " tuần"),
                                ],
                              ),
                            ),
                            VerticalDivider(),
                            Expanded(
                              child: Text(
                                subjectData.subjectCode,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            VerticalDivider(),
                            Expanded(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(Icons.timer),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(subjectData.slot.toString() + " slot")
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: listSubjectDetails.length,
                        itemBuilder: (context, index) {
                          return _buildStep(context, index);
                        },
                      )
                      // SizedBox(
                      //   height: 20.0,
                      // ),
                      // _buildStep(
                      //     leadingTitle: "01",
                      //     title: "Step".toUpperCase(),
                      //     content:
                      //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent lacinia, odio ut placerat finibus, ipsum risus consectetur ligula, non mattis mi neque ac mi. Vivamus quis tellus sed erat eleifend pharetra ac non diam. Integer vitae ipsum congue, vestibulum eros quis, interdum tellus. Nunc vel dictum elit. Curabitur suscipit scelerisque."),
                      // SizedBox(
                      //   height: 30.0,
                      // ),
                      // _buildStep(
                      //     leadingTitle: "02",
                      //     title: "Step".toUpperCase(),
                      //     content:
                      //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent lacinia, odio ut placerat finibus, ipsum risus consectetur ligula, non mattis mi neque ac mi. Vivamus quis tellus sed erat eleifend pharetra ac non diam. Integer vitae ipsum congue, vestibulum eros quis, interdum tellus. Nunc vel dictum elit. Curabitur suscipit scelerisque."),
                      // SizedBox(
                      //   height: 30.0,
                      // ),
                      // _buildStep(
                      //     leadingTitle: "03",
                      //     title: "Step".toUpperCase(),
                      //     content:
                      //         "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Praesent lacinia, odio ut placerat finibus, ipsum risus consectetur ligula, non mattis mi neque ac mi. Vivamus quis tellus sed erat eleifend pharetra ac non diam. Integer vitae ipsum congue, vestibulum eros quis, interdum tellus. Nunc vel dictum elit. Curabitur suscipit scelerisque."),
                    ],
                  ),
                ),
                Material(
                  elevation: 10.0,
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: <Widget>[
                        _buildBottomImage(
                            "https://cdn.theatlantic.com/thumbor/Ai_T_zLlQakCuUJzfwkNrOmP5sY=/0x178:5436x3236/720x405/media/img/mt/2016/09/classroom/original.jpg"),
                        SizedBox(
                          width: 10.0,
                        ),
                        _buildBottomImage(
                            "https://educationbusinessuk.net/sites/default/files/styles/large/public/classroom-2093744_640_1.jpg?itok=jVSxHSfy"),
                        SizedBox(
                          width: 10.0,
                        ),
                        _buildBottomImage(
                            "https://horizonedu.vn/wp-content/uploads/2020/12/How-to-Regain-Control-of-a-Class-scaled-1.jpg"),
                        SizedBox(
                          width: 10.0,
                        ),
                        _buildBottomImage(
                            "http://toeicspeakingmsngoc.com/images/tintuc/toeic-1522972607_simple-past-tense-qua-khu-don-toeic-speaking-ms-ngoc.jpg"),
                        SizedBox(
                          width: 10.0,
                        ),
                        _buildBottomImage(
                            "https://www.verywellfamily.com/thmb/DiUobaRz8pGJVXf8i7g12svCfdI=/5120x2880/smart/filters:no_upscale()/teacher-and-students-in-classroom-during-lesson-525409809-59e9e7d50d327a001083037c.jpg"),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        } else
          return Intro5(Colors.white);
      },
    );
  }

  Container _buildBottomImage(String image) {
    return Container(
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          image:
              DecorationImage(image: NetworkImage(image), fit: BoxFit.cover)),
    );
  }

  Widget _buildStep(BuildContext context, int index) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 20.0,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
              color: Colors.red,
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Text(listSubjectDetails[index].weekNum.toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0)),
              ),
            ),
            SizedBox(
              width: 16.0,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(listSubjectDetails[index].weekDescription,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(listSubjectDetails[index].learningOutcome),
                ],
              ),
            )
          ],
        ),
      ],
    );
  }
}
