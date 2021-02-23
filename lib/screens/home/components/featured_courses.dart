import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/components/shimmer_loader5.dart';
import 'package:gegeengii_app/screens/home/components/swipe_content.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/models/course.dart';
import 'package:gegeengii_app/providers/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

Future<List<Course>> fetchCourses() async {
  final response = await http.get(AppUrl.baseURL + "/courses");
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Course> courses =
        body.map((dynamic item) => Course.fromJson(item)).toList();
    return courses;
  } else {
    throw "Can't get courses";
  }
}

class FeaturedCourses extends StatefulWidget {
  @override
  _FeaturedCoursesState createState() => _FeaturedCoursesState();
}

class _FeaturedCoursesState extends State<FeaturedCourses> {
  Future<List<Course>> futureCourses;

  @override
  void initState() {
    super.initState();
    futureCourses = fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Text(
                'Хөтөлбөрүүд',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
              ),
              Spacer(),
              SizedBox(
                height: 24,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  color: kPrimaryColor,
                  onPressed: () {
                    Provider.of<BottomNavBar>(context).currentIndex = 1;
                  },
                  child: Text(
                    'Бүгд',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 170,
          child: FutureBuilder<List<Course>>(
            future: futureCourses,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: SwipeContent(
                        data1: snapshot.data[index * 2],
                        data2: snapshot.data.length.isEven
                            ? snapshot.data[index * 2 + 1]
                            : snapshot.data.length == index * 2 + 1
                                ? null
                                : snapshot.data[index * 2 + 1],
                      ),
                    );
                  },
                  itemCount: (snapshot.data.length / 2).ceil(),
                  loop: false,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return ShimmerLoader5();
            },
          ),
        ),
      ],
    );
  }
}
