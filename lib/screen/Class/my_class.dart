import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lcss_mobile_app/Util/constant.dart';
import 'package:lcss_mobile_app/bloc/my_class_bloc.dart';
import 'package:lcss_mobile_app/bloc/subject_bloc.dart';
import 'package:lcss_mobile_app/component/ImagePlaceHolder.dart';
import 'package:lcss_mobile_app/model/myclass_model.dart';
import 'package:lcss_mobile_app/model/subject_model.dart';
import 'package:lcss_mobile_app/screen/Class/my_class_detail.dart';
import 'package:lcss_mobile_app/screen/Onboarding/onboarding.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class MyClassPage extends StatefulWidget {
  const MyClassPage({Key key}) : super(key: key);

  @override
  _MyClassPageState createState() => _MyClassPageState();
}

class _MyClassPageState extends State<MyClassPage> {
  List<Tab> _tabs;
  String username;
  final classBlocStudying = new MyClassBloc();
  final classBlocFinished = new MyClassBloc();
  final classBlocWaiting = new MyClassBloc();
  final subjectBloc = SubjectBloc();

  List<SubjectModel> listSubject;
  List<ClassModel> listClasses;
  SubjectModel itemSubject;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabs = [
      Tab(
        icon: FaIcon(FontAwesomeIcons.bookOpen),
        text: "Lớp đang học",
      ),
      Tab(
        icon: FaIcon(FontAwesomeIcons.bookReader),
        text: "Lớp sẽ học",
      ),
      Tab(
        icon: FaIcon(FontAwesomeIcons.history),
        text: "Lớp đã học",
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    classBlocStudying.getMyClassData('studying');
    subjectBloc.getSubjectData();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              ///背景图和title展示
              SliverAppBar(
                backgroundColor: AppColor.greenTheme,
                pinned: true, //title固定在顶部不会滑动出屏幕
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text("Lớp học"),
                  background: Image.asset(
                    "assets/images/my_classroom.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              ///tabbar展示
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                      tabs: _tabs,
                      isScrollable: false,
                      indicatorSize: TabBarIndicatorSize.label,
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: AppColor.greenTheme,
                      onTap: (tabIndex) {
                        switch (tabIndex) {
                          case 0:
                            classBlocStudying.getMyClassData('studying');
                            subjectBloc.getSubjectData();
                            break;
                          case 1:
                            classBlocWaiting.getMyClassData('waiting');
                            subjectBloc.getSubjectData();
                            break;
                          case 2:
                            classBlocFinished.getMyClassData('finished');
                            subjectBloc.getSubjectData();
                            break;
                        }
                      }),
                ),
                pinned: false,
              )
            ];
          },
          body: TabBarView(
            children: [
              StreamBuilder2<MyClassResponseModel, SubjectResponseModel>(
                  streams: Tuple2(
                      classBlocStudying.classData, subjectBloc.subjectData),
                  builder: (context, snapshot) {
                    if (snapshot.item1.hasData && snapshot.item2.hasData) {
                      if (snapshot.item1.data.listClasses.isEmpty) {
                        return Center(child: Text('Không có lớp học nào'));
                      } else {
                        List<String> imageUrl = [
                          'http://tiengnhatcoban.edu.vn/images/2019/01/18/bang-chu-cai-kanji.jpg',
                          'https://tuhoconline.net/wp-content/uploads/cach-hoc-chu-kanji-hieu-qua-1.jpg',
                          'https://www.uab.edu/reporter/images/images/japanese___stream.jpg',
                          'https://career.gpo.vn/uploads/images/485568610/images/phuong-phap-hoc-tap-cua-tien-si-marty-lobdell-study-less-study-smart-phan-2-huong-nghiep-gpo(3).jpg',
                          // 'https://i0.wp.com/lh3.googleusercontent.com/-e6n1iMn81xY/X9G6QbKcekI/AAAAAAAAM6E/rXWdJ5q8UwMAJusbvW7ZVoNH4qmiSPe1gCLcBGAsYHQ/w640-h429/image.png?ssl=1',
                          'https://examseekers.files.wordpress.com/2021/04/ee023b0.png?w=1024',
                          'https://englishclassviaskype.com/wp-content/uploads/2017/09/how-to-prepare-Cambridge-Flyers.jpg',
                          // 'https://www.infobooks.org/wp-content/uploads/2021/01/Japanese-Books-PDF.jpg',
                          'https://tiengtrung.com/wp-content/uploads/2020/09/t%E1%BB%AB-v%E1%BB%B1ng-ti%E1%BA%BFng-Trung-HSK1.jpg',
                          // 'https://ih1.redbubble.net/image.1047234144.4273/farp,small,wall_texture,product,750x1000.jpg',
                          'https://academy.duhocstudytrust.vn/wp-content/uploads/sites/2/2020/12/maxresdefault-1024x576.jpg',
                          // 'https://www.global.hokudai.ac.jp/wp-content/uploads/2012/11/nihongo.jpg',
                          'https://chinese.com.vn/wp-content/uploads/2018/10/hsk-3.jpg',
                          // 'https://www.japanvisitor.com/images/content_images/japanese-language-2019.jpg',
                          'https://tiengtrung.com/wp-content/uploads/2020/08/hsk4-l%C3%A0-g%C3%AC.jpg',
                          'https://www.snowmonkeyresorts.com/wp-content/uploads/2021/05/388343_m.jpg',
                        ];
                        return ListView.separated(
                          itemCount: snapshot.item1.data.listClasses.length,
                          itemBuilder: (context, index) {
                            // Get Subject correspond with Subject in each View START
                            listSubject = snapshot.item2.data.listSubject;
                            listClasses = snapshot.item1.data.listClasses;
                            for (var i = 0; i < listSubject.length; i++) {
                              listSubject[i].image = imageUrl[i % 10];
                            }
                            for (var i = 0; i < listSubject.length; i++) {
                              if (listSubject[i].subjectId ==
                                  listClasses[index].subjectId) {
                                itemSubject = listSubject[i];
                              }
                            }
                            // Get Subject correspond with Class in each View END
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) =>
                                        new MyClassDetailsPage(
                                      classData: listClasses[index],
                                      subjectData: itemSubject,
                                    ),
                                  ),
                                );
                              },
                              contentPadding:
                                  const EdgeInsetsDirectional.all(8),
                              leading: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(54)),
                                child: SizedBox(
                                  width: 60.0,
                                  height: 60.0,
                                  child: _DestinationImage(
                                    urlImage:
                                        "https://media.slidesgo.com/storage/13785564/conversions/37-school-backgrounds-for-virtual-classroom-thumb.jpg",
                                    imageAspectRatio: 1,
                                  ),
                                ),
                              ),
                              title: Text(listClasses[index].className,
                                  style: Theme.of(context).textTheme.subtitle1),
                              // trailing: listClasses[index].suspend
                              //     ? Text(
                              //         "Đã chuyển lớp",
                              //         style:
                              //             TextStyle(color: AppColor.greenTheme),
                              //       )
                              //     : Container(),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(thickness: 1.5);
                          },
                        );
                      }
                    } else if (snapshot.item1.hasError ||
                        snapshot.item2.hasError) {
                      return Text(snapshot.item1.hasError
                          ? snapshot.item1.error
                          : snapshot.item2.error);
                    } else
                      return Center(child: Intro10(Colors.white10));
                  }),
              StreamBuilder2<MyClassResponseModel, SubjectResponseModel>(
                  streams: Tuple2(
                      classBlocWaiting.classData, subjectBloc.subjectData),
                  builder: (context, snapshot) {
                    if (snapshot.item1.hasData && snapshot.item2.hasData) {
                      if (snapshot.item1.data.listClasses.isEmpty) {
                        return Center(child: Text('Không có lớp học nào'));
                      } else {
                        List<String> imageUrl = [
                          'http://tiengnhatcoban.edu.vn/images/2019/01/18/bang-chu-cai-kanji.jpg',
                          'https://tuhoconline.net/wp-content/uploads/cach-hoc-chu-kanji-hieu-qua-1.jpg',
                          'https://www.uab.edu/reporter/images/images/japanese___stream.jpg',
                          'https://career.gpo.vn/uploads/images/485568610/images/phuong-phap-hoc-tap-cua-tien-si-marty-lobdell-study-less-study-smart-phan-2-huong-nghiep-gpo(3).jpg',
                          // 'https://i0.wp.com/lh3.googleusercontent.com/-e6n1iMn81xY/X9G6QbKcekI/AAAAAAAAM6E/rXWdJ5q8UwMAJusbvW7ZVoNH4qmiSPe1gCLcBGAsYHQ/w640-h429/image.png?ssl=1',
                          'https://examseekers.files.wordpress.com/2021/04/ee023b0.png?w=1024',
                          'https://englishclassviaskype.com/wp-content/uploads/2017/09/how-to-prepare-Cambridge-Flyers.jpg',
                          // 'https://www.infobooks.org/wp-content/uploads/2021/01/Japanese-Books-PDF.jpg',
                          'https://tiengtrung.com/wp-content/uploads/2020/09/t%E1%BB%AB-v%E1%BB%B1ng-ti%E1%BA%BFng-Trung-HSK1.jpg',
                          // 'https://ih1.redbubble.net/image.1047234144.4273/farp,small,wall_texture,product,750x1000.jpg',
                          'https://academy.duhocstudytrust.vn/wp-content/uploads/sites/2/2020/12/maxresdefault-1024x576.jpg',
                          // 'https://www.global.hokudai.ac.jp/wp-content/uploads/2012/11/nihongo.jpg',
                          'https://chinese.com.vn/wp-content/uploads/2018/10/hsk-3.jpg',
                          // 'https://www.japanvisitor.com/images/content_images/japanese-language-2019.jpg',
                          'https://tiengtrung.com/wp-content/uploads/2020/08/hsk4-l%C3%A0-g%C3%AC.jpg',
                          'https://www.snowmonkeyresorts.com/wp-content/uploads/2021/05/388343_m.jpg',
                        ];
                        return ListView.separated(
                          itemCount: snapshot.item1.data.listClasses.length,
                          itemBuilder: (context, index) {
                            // Get Subject correspond with Subject in each View START
                            listSubject = snapshot.item2.data.listSubject;
                            listClasses = snapshot.item1.data.listClasses;
                            // Fix Image
                            for (var i = 0; i < listSubject.length; i++) {
                              listSubject[i].image = imageUrl[i % 10];
                            }
                            for (var i = 0; i < listSubject.length; i++) {
                              if (listSubject[i].subjectId ==
                                  listClasses[index].subjectId) {
                                itemSubject = listSubject[i];
                              }
                            }
                            // Get Subject correspond with Subject in each View END
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) =>
                                        new MyClassDetailsPage(
                                      classData: listClasses[index],
                                      subjectData: itemSubject,
                                    ),
                                  ),
                                );
                              },
                              contentPadding:
                                  const EdgeInsetsDirectional.all(8),
                              leading: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(54)),
                                child: SizedBox(
                                  width: 60.0,
                                  height: 60.0,
                                  child: _DestinationImage(
                                    urlImage:
                                        "https://media.slidesgo.com/storage/13785564/conversions/37-school-backgrounds-for-virtual-classroom-thumb.jpg",
                                    imageAspectRatio: 1,
                                  ),
                                ),
                              ),
                              title: Text(listClasses[index].className,
                                  style: Theme.of(context).textTheme.subtitle1),
                              // trailing: listClasses[index].suspend
                              //     ? Text(
                              //         "Đã chuyển lớp",
                              //         style:
                              //             TextStyle(color: AppColor.greenTheme),
                              //       )
                              //     : Container(),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(thickness: 1.5);
                          },
                        );
                      }
                    } else if (snapshot.item1.hasError ||
                        snapshot.item2.hasError) {
                      return Text(snapshot.item1.hasError
                          ? snapshot.item1.error
                          : snapshot.item2.error);
                    } else
                      return Center(child: Intro10(Colors.white10));
                  }),
              StreamBuilder2<MyClassResponseModel, SubjectResponseModel>(
                  streams: Tuple2(
                      classBlocFinished.classData, subjectBloc.subjectData),
                  builder: (context, snapshot) {
                    if (snapshot.item1.hasData && snapshot.item2.hasData) {
                      if (snapshot.item1.data.listClasses.isEmpty) {
                        return Center(child: Text('Không có lớp học nào'));
                      } else {
                        List<String> imageUrl = [
                          'http://tiengnhatcoban.edu.vn/images/2019/01/18/bang-chu-cai-kanji.jpg',
                          'https://tuhoconline.net/wp-content/uploads/cach-hoc-chu-kanji-hieu-qua-1.jpg',
                          'https://www.uab.edu/reporter/images/images/japanese___stream.jpg',
                          'https://career.gpo.vn/uploads/images/485568610/images/phuong-phap-hoc-tap-cua-tien-si-marty-lobdell-study-less-study-smart-phan-2-huong-nghiep-gpo(3).jpg',
                          // 'https://i0.wp.com/lh3.googleusercontent.com/-e6n1iMn81xY/X9G6QbKcekI/AAAAAAAAM6E/rXWdJ5q8UwMAJusbvW7ZVoNH4qmiSPe1gCLcBGAsYHQ/w640-h429/image.png?ssl=1',
                          'https://examseekers.files.wordpress.com/2021/04/ee023b0.png?w=1024',
                          'https://englishclassviaskype.com/wp-content/uploads/2017/09/how-to-prepare-Cambridge-Flyers.jpg',
                          // 'https://www.infobooks.org/wp-content/uploads/2021/01/Japanese-Books-PDF.jpg',
                          'https://tiengtrung.com/wp-content/uploads/2020/09/t%E1%BB%AB-v%E1%BB%B1ng-ti%E1%BA%BFng-Trung-HSK1.jpg',
                          // 'https://ih1.redbubble.net/image.1047234144.4273/farp,small,wall_texture,product,750x1000.jpg',
                          'https://academy.duhocstudytrust.vn/wp-content/uploads/sites/2/2020/12/maxresdefault-1024x576.jpg',
                          // 'https://www.global.hokudai.ac.jp/wp-content/uploads/2012/11/nihongo.jpg',
                          'https://chinese.com.vn/wp-content/uploads/2018/10/hsk-3.jpg',
                          // 'https://www.japanvisitor.com/images/content_images/japanese-language-2019.jpg',
                          'https://tiengtrung.com/wp-content/uploads/2020/08/hsk4-l%C3%A0-g%C3%AC.jpg',
                          'https://www.snowmonkeyresorts.com/wp-content/uploads/2021/05/388343_m.jpg',
                        ];
                        return ListView.separated(
                          itemCount: snapshot.item1.data.listClasses.length,
                          itemBuilder: (context, index) {
                            // Get Subject correspond with Subject in each View START
                            listSubject = snapshot.item2.data.listSubject;
                            listClasses = snapshot.item1.data.listClasses;
                            for (var i = 0; i < listSubject.length; i++) {
                              listSubject[i].image = imageUrl[i % 10];
                            }
                            for (var i = 0; i < listSubject.length; i++) {
                              if (listSubject[i].subjectId ==
                                  listClasses[index].subjectId) {
                                itemSubject = listSubject[i];
                              }
                            }
                            // Get Subject correspond with Subject in each View END
                            return ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                    builder: (context) =>
                                        new MyClassDetailsPage(
                                      classData: listClasses[index],
                                      subjectData: itemSubject,
                                    ),
                                  ),
                                );
                              },
                              contentPadding:
                                  const EdgeInsetsDirectional.all(8),
                              leading: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(54)),
                                child: SizedBox(
                                  width: 60.0,
                                  height: 60.0,
                                  child: _DestinationImage(
                                    urlImage:
                                        "https://media.slidesgo.com/storage/13785564/conversions/37-school-backgrounds-for-virtual-classroom-thumb.jpg",
                                    imageAspectRatio: 1,
                                  ),
                                ),
                              ),
                              title: Text(listClasses[index].className,
                                  style: Theme.of(context).textTheme.subtitle1),
                              // trailing: listClasses[index].suspend
                              //     ? Text(
                              //         "Đã chuyển lớp",
                              //         style:
                              //             TextStyle(color: AppColor.greenTheme),
                              //       )
                              //     : Container(),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return Divider(thickness: 1.5);
                          },
                        );
                      }
                    } else if (snapshot.item1.hasError ||
                        snapshot.item2.hasError) {
                      return Text(snapshot.item1.hasError
                          ? snapshot.item1.error
                          : snapshot.item2.error);
                    } else
                      return Center(child: Intro10(Colors.white10));
                  }),
            ],
          ),
          // body: StreamBuilder(
          //     stream: MyClassBloc().getMyClassData(username, ),
          //     builder: (context, AsyncSnapshot<MyClassResponseModel> snapshot) {
          //       if (snapshot.hasData) {
          //         return buildList(snapshot);
          //       } else if (snapshot.hasError) {
          //         return Text(snapshot.error.toString());
          //       }
          //       return Center(child: CircularProgressIndicator());
          //     }),
        ),
      ),
    );
  }

  Widget buildList(MyClassBloc classBloc, SubjectBloc subjectBloc) {
    // Call StreamBuilder to manage data when data not finish loading yet (in this case we still not have business logic in BLoC)
    return StreamBuilder2<MyClassResponseModel, SubjectResponseModel>(
        streams: Tuple2(classBloc.classData, subjectBloc.subjectData),
        builder: (context, snapshot) {
          if (snapshot.item1.hasData && snapshot.item2.hasData) {
            if (snapshot.item1.data.listClasses.isEmpty) {
              return Center(child: Text('Không có lớp học nào'));
            } else {
              return ListView.separated(
                itemCount: snapshot.item1.data.listClasses.length,
                itemBuilder: (context, index) {
                  // Get Subject correspond with Subject in each View START
                  listSubject = snapshot.item2.data.listSubject;
                  listClasses = snapshot.item1.data.listClasses;
                  for (var i = 0; i < listSubject.length; i++) {
                    if (listSubject[i].subjectId ==
                        listClasses[index].subjectId) {
                      itemSubject = listSubject[i];
                    }
                  }
                  // Get Subject correspond with Subject in each View END
                  return ListTile(
                    contentPadding: const EdgeInsetsDirectional.only(end: 8),
                    leading: ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                      child: SizedBox(
                        width: 60.0,
                        height: 60.0,
                        child: _DestinationImage(
                          urlImage: itemSubject.image,
                          imageAspectRatio: 1,
                        ),
                      ),
                    ),
                    title: Text(
                        snapshot.item1.data.listClasses[index].className,
                        style: Theme.of(context).textTheme.subtitle1),
                    // trailing: listClasses[index].suspend
                    //     ? Text(
                    //         "Đã chuyển lớp",
                    //         style: TextStyle(color: AppColor.greenTheme),
                    //       )
                    //     : Container(),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(thickness: 1);
                },
              );
            }
          } else if (snapshot.item1.hasError || snapshot.item2.hasError) {
            return Text(snapshot.item1.hasError
                ? snapshot.item1.error
                : snapshot.item2.error);
          } else
            return Center(child: CircularProgressIndicator());
        });
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
          image: NetworkImage(
            urlImage,
          ),
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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Container(
      child: tabBar,
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => tabBar.preferredSize.height;

  @override
  // TODO: implement minExtent
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return false;
  }
}
