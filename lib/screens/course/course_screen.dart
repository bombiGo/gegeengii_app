import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/models/course.dart';
import 'components/course_card2.dart';
import 'package:gegeengii_app/components/shimmer_loader.dart';

Future<List<Course>> fetchInfos() async {
  final response = await http.get(AppUrl.baseURL + "/courses");
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Course> infos =
        body.map((dynamic item) => Course.fromJson(item)).toList();
    return infos;
  } else {
    throw "Can't get courses";
  }
}

class CourseBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 20, left: 20, right: 20, bottom: 10),
            child: Text(
              'Хөтөлбөрүүд',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          FutureBuilder(
            future: fetchInfos(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Course> courses = snapshot.data;
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Wrap(
                    children: List.generate(
                      courses.length,
                      (index) {
                        return CourseCard2(
                          index: index,
                          course: courses[index],
                        );
                      },
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return ShimmerLoader();
            },
          ),
        ],
      ),
    );
  }
}
