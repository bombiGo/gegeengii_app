import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:gegeengii_app/components/shimmer_loader3.dart';
import 'package:gegeengii_app/components/single_photo_view.dart';
import 'package:gegeengii_app/models/course.dart';
import 'package:gegeengii_app/providers/bottom_nav_bar.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components/week_day.dart';

Future<Course> fetchCourse(int id) async {
  final response = await http.get(AppUrl.baseURL + "/courses/$id");

  if (response.statusCode == 200) {
    return Course.fromJson(json.decode(response.body));
  } else {
    throw 'Failed to load course';
  }
}

class CourseDetailScreen extends StatefulWidget {
  static String routeName = "/course-detail";
  final argument;

  CourseDetailScreen({Key key, this.argument}) : super(key: key);

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  Future<Course> futureCourse;
  ScrollController _scrollBottomBarController = ScrollController();
  TextEditingController _searchController = TextEditingController();
  ValueNotifier<List> commentsData = ValueNotifier<List>([]);
  ValueNotifier<double> _percent = ValueNotifier<double>(0.0);
  double _progress = 0;

  bool isScrollingDown = false;
  bool _toggleBuyButton = false;
  final formKey = new GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    futureCourse = fetchCourse(widget.argument);
    myScroll();
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  void startTimer() {
    _percent.value = 0.0;
    Timer.periodic(Duration(milliseconds: 1000), (Timer timer) {
      if (timer.tick <= 5) {
        print("timer: ${timer.tick}");
        _percent.value += 0.2;
      } else {
        timer.cancel();
      }
    });
  }

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      // print(_scrollBottomBarController.position.pixels);

      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_scrollBottomBarController.position.pixels > 220 &&
            !isScrollingDown) {
          isScrollingDown = true;
          this.setState(() {
            _toggleBuyButton = true;
          });
        }
      }

      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_scrollBottomBarController.position.pixels < 220 &&
            isScrollingDown) {
          isScrollingDown = false;
          this.setState(() {
            _toggleBuyButton = false;
          });
        }
      }
    });
  }

  void logout() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text('Та дахин нэвтрэх оролдлого хийнэ үү!'),
        actions: [
          FlatButton(
            child: Text("OK"),
            onPressed: () async {
              UserPreferences().removeUser();
              Provider.of<BottomNavBar>(context).currentIndex = 0;
              Navigator.pushNamed(context, "/home");
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("courseDetail mounted!");

    return FutureBuilder<Course>(
      future: futureCourse,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Course course = snapshot.data;
          commentsData.value = course.comments;

          return Scaffold(
            body: SingleChildScrollView(
              controller: _scrollBottomBarController,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    height: 180,
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: course.image,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          placeholder: (context, url) => Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.5,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(10),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SinglePhotoView(image: course.image),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      course.title,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: 0, bottom: 20, left: 10, right: 10),
                    child: SizedBox(
                      width: double.infinity,
                      height: 42,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(21),
                        ),
                        color: kPrimaryColor,
                        onPressed: () {
                          Navigator.pushNamed(context, "/payment", arguments: {
                            "course_title": course.title,
                            "course_price": course.price,
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Image.asset(
                                'assets/images/icon_buy.png',
                                width: 32,
                              ),
                            ),
                            Text(
                              'Худалдаж авах',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (course.notifyMsg != null)
                    Container(
                      width: double.infinity,
                      margin: EdgeInsets.only(
                          top: 0, left: 10, right: 10, bottom: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey[300].withOpacity(0.8),
                            blurRadius: 6,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        course.notifyMsg,
                        style: TextStyle(
                          fontSize: 12,
                          color: kPrimaryColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  _buildEditorContent(course: course),
                  if (course.days.length > 0 && course.days[0]["mode"] != "365")
                    WeekDay(course: course),
                  // FlatButton(
                  //   onPressed: () {
                  //     print("onPressed");
                  //     startTimer();
                  //   },
                  //   child: Text('Start'),
                  // ),
                  _buildCommentContent(),
                  SizedBox(height: 60),
                ],
              ),
            ),
            extendBodyBehindAppBar: true,
            appBar: _toggleBuyButton
                ? AppBar(
                    title: Text(course.title),
                    backgroundColor: Colors.white,
                  )
                : AppBar(
                    title: null,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
            floatingActionButton: Visibility(
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[300].withOpacity(0.8),
                      blurRadius: 6,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(21),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    Navigator.pushNamed(context, "/payment", arguments: {
                      "course_title": course.title,
                      "course_price": course.price.toString(),
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/images/icon_buy.png',
                          width: 28,
                        ),
                      ),
                      Text(
                        'Худалдаж авах',
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              visible: _toggleBuyButton, // set it to false
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Scaffold(
          body: SafeArea(child: ShimmerLoader3()),
        );
      },
    );
  }

  Widget _buildEditorContent({Course course}) {
    return Container(
      padding: EdgeInsets.all(15),
      child: HtmlWidget(
        course.content,
        customWidgetBuilder: (element) {
          if (element.localName == 'img' &&
              element.attributes.containsKey("src")) {
            return Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: element.attributes['src'],
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 1.5,
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Positioned.fill(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SinglePhotoView(
                              image: element.attributes['src'],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCommentContent() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        children: <Widget>[
          newComment(),
          SizedBox(height: 15),
          ValueListenableBuilder(
            valueListenable: commentsData,
            builder: (context, value, _) {
              return Column(
                children: List.generate(
                  value.length,
                  (index) => cardComment(value[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget newComment() {
    return Stack(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            controller: _searchController,
            validator: (value) {
              if (value.isEmpty) {
                return 'Сэтгэгдлээ оруулна уу';
              }
              return null;
            },
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(top: 0, bottom: 0, left: 15, right: 0),
              labelText: "Cэтгэгдэл үлдээх",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10.0),
                ),
              ),
            ),
          ),
        ),
        // Positioned(
        //   top: 12,
        //   right: 12,
        //   child: ValueListenableBuilder(
        //     valueListenable: _percent,
        //     builder: (context, value, _) {
        //       return SizedBox(
        //         width: 25,
        //         height: 25,
        //         child: CircularProgressIndicator(
        //           value: _percent.value,
        //           strokeWidth: 3.0,
        //           valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
        //           backgroundColor: Colors.grey.withOpacity(0.2),
        //         ),
        //       );
        //     },
        //   ),
        // ),
        Positioned(
          top: 12,
          right: 12,
          child: InkWell(
            onTap: () async {
              final form = formKey.currentState;

              if (form.validate()) {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();

                String token = prefs.get('token');

                if (token != null) {
                  final Map<String, dynamic> formData = {
                    'comment': _searchController.text,
                  };

                  var response = await http.post(
                    AppUrl.baseURL + "/courses/${widget.argument}/comment",
                    headers: {
                      'Authorization': 'Bearer $token',
                      'Content-Type': 'application/json',
                      'Accept': 'application/json',
                    },
                    body: json.encode(formData),
                  );

                  if (response.statusCode == 200) {
                    if (jsonDecode(response.body)['success']) {
                      print(response.body);
                      commentsData.value
                          .insert(0, jsonDecode(response.body)['new_comment']);
                      FocusScope.of(context).unfocus();
                      _searchController.clear();
                    }
                  } else if (response.statusCode == 401) {
                    logout();
                  }

                  _searchController.clear();
                } else {
                  logout();
                }
              }
            },
            child: Icon(Icons.send),
          ),
        ),
      ],
    );
  }

  Widget cardComment(dynamic data) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.topLeft,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage("assets/images/avatar2.png"),
              ),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              constraints: BoxConstraints(
                minHeight: 45,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(data['comment']),
            ),
          ),
        ],
      ),
    );
  }
}

class ScreenArguments {
  final String title;
  final String message;

  ScreenArguments(this.title, this.message);
}
