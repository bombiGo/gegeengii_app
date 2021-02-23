import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:gegeengii_app/models/course.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/utils/app_url.dart';
import 'calendar_content.dart';

Future<Course> fetchCalendar() async {
  final response = await http.get(AppUrl.baseURL + "/calendar");
  if (response.statusCode == 200) {
    Course course = Course.fromJson(json.decode(response.body));
    return course;
  } else {
    throw "Can't get calendars";
  }
}

class CalendarWithInfos extends StatefulWidget {
  @override
  _CalendarWithInfosState createState() => _CalendarWithInfosState();
}

class _CalendarWithInfosState extends State<CalendarWithInfos> {
  Future<Course> futureCourse;

  String getMonthNameOfDay(DateTime date) {
    dynamic dayData =
        '{"1" : "Нэгдүгээр", "2" : "Хоёрдугаар", "3" : "Гурван", "4" : "Дөрвөн", "5" : "Таван", "6" : "Зургаан", "7" : "Долоон", "8" : "Найман", "9" : "Есөн", "10" : "Арван", "11" : "Арван нэгэн", "12" : "Арван хоёр"}';
    return jsonDecode(dayData)['${date.month}'].toString();
  }

  String getFullWeekNameOfDay(DateTime date) {
    dynamic dayData =
        '{ "1" : "Даваа", "2" : "Мягмар", "3" : "Лхагва", "4" : "Пүрэв", "5" : "Баасан", "6" : "Бямба", "7" : "Ням" }';
    return jsonDecode(dayData)['${date.weekday}'].toString();
  }

  @override
  void initState() {
    super.initState();
    futureCourse = fetchCalendar();

    // DateTime now = DateTime.now();
    // int lastDay = DateTime(now.year, now.month + 1, 0).day;

    // for (var i = 1; i <= lastDay; i++) {
    //   String content = "$i дахь өдрийн мэдээлэл байхгүй байна.";

    // if (i == now.day) {
    //   content =
    //       "Өдөртөө 150 калори хоол идэж, 3 алим идэх, 20 миниут дасгал хийх";
    //   _selectedIndex = i - 1;
    //   _selectedContent = content;
    // } else if (i >= now.day) {
    //   content = "Одоогоор $i дахь өдрийн мэдээлэл хараахан оруулаагүй байна.";
    // }

    // daysOfMonth.add({
    //   "week_name":
    //       getShortWeekNameOfDay(DateTime(now.year, now.month, i)).toString(),
    //   "day": i,
    //   "content": content,
    // });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCalendar(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List days = [];
          if (snapshot.data.id != null) {
            days = snapshot.data.days;
          }

          return Container(
            padding: EdgeInsets.only(top: 0, bottom: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300].withOpacity(0.5),
                  blurRadius: 6,
                  offset: Offset(0, 7),
                )
              ],
            ),
            child: Column(
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text(
                        '${getMonthNameOfDay(DateTime.now())} сар, ${DateTime.now().day}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5),
                      child: Text(
                        getFullWeekNameOfDay(DateTime.now()),
                        style: TextStyle(
                          fontSize: 12,
                          color: kTextMutedColor,
                        ),
                      ),
                    ),
                  ],
                ),
                CalendarContent(days: days),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return SizedBox(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
        );
      },
    );
  }
}
