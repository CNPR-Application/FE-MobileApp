import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:intl/intl.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/api/api_service.dart';
import 'package:lcss_mobile_app/bloc/feedback_class_bloc.dart';
import 'package:lcss_mobile_app/component/ImagePlaceHolder.dart';
import 'package:lcss_mobile_app/model/feedback_class_model..dart';
import 'package:lcss_mobile_app/model/feedback_data_model.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class FeedbackListPage extends StatefulWidget {
  const FeedbackListPage({Key key}) : super(key: key);

  @override
  _FeedbackListPageState createState() => _FeedbackListPageState();
}

class _FeedbackListPageState extends State<FeedbackListPage> {
  final feedbackClassBloc = new FeedbackClassBloc();

  @override
  Widget build(BuildContext context) {
    DateFormat formatter = new DateFormat('dd-MM-yyyy');
    feedbackClassBloc.getFeedbackClassData();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Đánh giá lớp học"),
        centerTitle: true,
        backgroundColor: AppColor.greenTheme,
      ),
      body: StreamBuilder<FeedbackClassResponseModel>(
          stream: feedbackClassBloc.feedbackClassData,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error);
            } else if (snapshot.hasData) {
              if (snapshot.data.listClasses.isEmpty) {
                return Center(
                  child: Text(
                    "Hiện tại chưa có lớp kết thúc để đánh giá",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 20,
                    ),
                  ),
                );
              }
              List<FeedbackClassModel> listFeedbackClass =
                  snapshot.data.listClasses;
              return ListView.separated(
                itemCount: listFeedbackClass.length,
                itemBuilder: (context, index) {
                  return _buildList(listFeedbackClass, index, formatter);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    thickness: 3,
                    color: Color(0xffF3F3F3),
                  );
                },
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          }),
    );
  }

  ListTile _buildList(List<FeedbackClassModel> listFeedbackClass, int index,
      DateFormat formatter) {
    final popup = BeautifulPopup.customize(
      context: context,
      build: (options) => MyTemplate(options),
    );
    return ListTile(
      onTap: () {
        print("Hello");
        // Create Form data to sending START
        FeedbackDataModel feedbackSendingData = new FeedbackDataModel();
        bool isRatingSubject = false;
        bool isRatingTeacher = false;
        feedbackSendingData.studentInClassId =
            listFeedbackClass[index].studentInClassId;
        feedbackSendingData.subjectId = listFeedbackClass[index].subjectId;
        feedbackSendingData.teacherId = listFeedbackClass[index].teacherId;
        APIService apiService = new APIService();
        // Create Form data to sending END
        popup.show(
          title: listFeedbackClass[index].className,
          content: Align(
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Chất lượng môn học",
                    style: TextStyle(color: AppColor.blueForText, fontSize: 20),
                  ),
                ),
                SmoothStarRating(
                  color: AppColor.greenTheme,
                  borderColor: AppColor.greenTheme,
                  size: 30,
                  onRated: (subjectRating) {
                    feedbackSendingData.subjectRating = subjectRating.toInt();
                    isRatingSubject = true;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Chất lượng giảng viên",
                    style: TextStyle(color: AppColor.blueForText, fontSize: 20),
                  ),
                ),
                SmoothStarRating(
                  color: AppColor.greenTheme,
                  borderColor: AppColor.greenTheme,
                  size: 30,
                  onRated: (teacherRating) {
                    feedbackSendingData.teacherRating = teacherRating.toInt();
                    isRatingTeacher = true;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    cursorColor: AppColor.greenTheme,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: "Ý kiến khác",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.greenTheme),
                      ),
                    ),
                    onChanged: (feedback) {
                      feedbackSendingData.feedback = feedback;
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            popup.button(
                label: 'Đánh giá',
                onPressed: () {
                  if (isRatingSubject && isRatingTeacher) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => new AlertDialog(
                        title: new Text('Bạn xác nhận gửi đánh giá ?'),
                        actions: <Widget>[
                          new TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text(
                              'Không',
                              style: TextStyle(
                                color: AppColor.greenTheme,
                              ),
                            ),
                          ),
                          new TextButton(
                            child: new Text(
                              'Vâng',
                              style: TextStyle(
                                color: AppColor.greenTheme,
                              ),
                            ),
                            onPressed: () => {
                              FutureBuilder(
                                future: apiService
                                    .sendFeedbackData(feedbackSendingData),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  } else if (snapshot.hasData) {
                                    // Future Callback
                                    print(snapshot.data);
                                    return Container();
                                  } else
                                    return Center(
                                        child: CircularProgressIndicator());
                                },
                              ),
                              popup.show(
                                title: 'Bạn đã gửi đánh giá thành công',
                                content: '',
                                actions: [
                                  popup.button(
                                    label: 'Close',
                                    onPressed: () => {
                                      Navigator.of(context).pop(false),
                                      Navigator.of(context).pop(false),
                                      Navigator.of(context).pop(false),
                                      Navigator.pushReplacementNamed(
                                          context, "/checkFeedback"),
                                    },
                                  ),
                                ],
                              ),
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => new AlertDialog(
                        title: new Text('Bạn chưa đánh giá hết chất lượng'),
                        actions: <Widget>[
                          new TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: new Text(
                              'Vâng',
                              style: TextStyle(
                                color: AppColor.greenTheme,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
          ],
        );
      },
      contentPadding: const EdgeInsetsDirectional.all(12),
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: SizedBox(
          width: 60.0,
          height: 60.0,
          child: _DestinationImage(
            imageAspectRatio: 1,
          ),
        ),
      ),
      title: Text(
        listFeedbackClass[index].className,
        style:
            TextStyle(color: AppColor.blueForText, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        "Ngày mở: " +
            formatter
                .format(DateTime.parse(listFeedbackClass[index].openingDate)),
        style: TextStyle(
          color: AppColor.blueForText,
        ),
      ),
    );
  }
}

class MyTemplate extends BeautifulPopupTemplate {
  final BeautifulPopup options;
  MyTemplate(this.options) : super(options);

  @override
  final illustrationKey = 'assets/images/rocket_green.png';
  @override
  Color get primaryColor =>
      AppColor.greenTheme ??
      Color(
          0xff000000); // The default primary color of the template is Colors.black.
  @override
  final maxWidth =
      400; // In most situations, the value is the illustration size.
  @override
  final maxHeight = 600;
  @override
  final bodyMargin = 10;

  // You need to adjust the layout to fit into your illustration.
  @override
  get layout {
    return [
      Positioned(
        child: background,
      ),
      Positioned(
        top: percentH(34),
        child: title,
      ),
      Positioned(
        top: percentH(42),
        height: percentH(actions == null ? 32 : 44),
        left: percentW(10),
        right: percentW(10),
        child: content,
      ),
      Positioned(
        bottom: percentW(10),
        left: percentW(10),
        right: percentW(10),
        child: actions ?? Container(),
      ),
    ];
  }
}

class _DestinationImage extends StatelessWidget {
  final String assetSemanticLabel;
  final String urlImage;
  final double imageAspectRatio;

  const _DestinationImage(
      {this.assetSemanticLabel, this.urlImage, this.imageAspectRatio});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Hahaha",
      child: ExcludeSemantics(
        child: FadeInImagePlaceholder(
          image: Image.asset("assets/images/feedback_sample.jpg").image,
          fit: BoxFit.cover,
          width: 60,
          height: 60,
          placeholder: LayoutBuilder(builder: (context, constraints) {
            return Container(
              color: Colors.black.withOpacity(0.1),
              width: constraints.maxWidth,
              height: constraints.maxWidth / this.imageAspectRatio,
            );
          }),
        ),
      ),
    );
  }
}
