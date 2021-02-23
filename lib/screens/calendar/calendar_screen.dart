import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/models/course.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:gegeengii_app/screens/course_detail/course_detail_weekday_screen.dart';

Future<Course> fetchCalendar() async {
  final response = await http.get(AppUrl.baseURL + "/calendar");
  if (response.statusCode == 200) {
    Course course = Course.fromJson(json.decode(response.body));
    return course;
  } else {
    throw "Can't get calendars";
  }
}

class CalendarScreen extends StatefulWidget {
  static String routeName = "/calendar";

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Future<Course> futureCourse;

  final weeks = ['Да', 'Мя', 'Лх', 'Пү', 'Ба', 'Бя', 'Ня'];

  DateTime now = DateTime.now();
  final List<Map<String, dynamic>> months = [];

  String getMonthNameOfDay(int month) {
    dynamic dayData =
        '{"1" : "Нэгдүгээр сар", "2" : "Хоёрдугаар сар", "3" : "Гуравдугаар сар", "4" : "Дөрөвдүгээр сар", "5" : "Тавдугаар сар", "6" : "Зургаадугаар сар", "7" : "Долоодугаар сар", "8" : "Наймдугаар сар", "9" : "Есдүгээр сар", "10" : "Аравдугаар сар", "11" : "Арван нэгдүгээр сар", "12" : "Арван хоёрдугаар сар"}';
    return jsonDecode(dayData)['$month'].toString();
  }

  String getFullWeekNameOfDay(int weekNumber) {
    dynamic dayData =
        '{ "1" : "Даваа", "2" : "Мягмар", "3" : "Лхагва", "4" : "Пүрэв", "5" : "Баасан", "6" : "Бямба", "7" : "Ням" }';
    return jsonDecode(dayData)['$weekNumber'].toString();
  }

  @override
  void initState() {
    super.initState();
    futureCourse = fetchCalendar();

    for (var i = 1; i <= 12; i++) {
      months.add({
        'year': now.year,
        'month': i,
        'days': [],
      });
    }

    months.forEach((month) {
      int lastDay = DateTime(now.year, month['month'] + 1, 0).day;

      var days = [];
      for (var i = 1; i <= lastDay; i++) {
        days.add({
          "day": i,
          "week_day": DateTime(now.year, month['month'], i).weekday,
          "content": "",
        });
      }

      month['days'] = days;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        height: 72,
        child: Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 48,
              child: RawMaterialButton(
                elevation: 0.0,
                child: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                shape: CircleBorder(),
              ),
            ),
            Positioned.fill(
              child: Container(
                child: Center(
                  child: SizedBox(
                    height: 24,
                    child: FlatButton(
                      onPressed: null,
                      child: Text(
                        now.year.toString(),
                        style: TextStyle(color: kPrimaryColor),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: kPrimaryColor,
                          width: 1,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: fetchCalendar(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List days = [];
            if (snapshot.data.id != null) {
              days = snapshot.data.days;
            }

            return SafeArea(
              child: Column(
                children: <Widget>[
                  _buildWeeks(),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_, int index) =>
                          _buildDaysOfMonth(context, index, days),
                      itemCount: months.length,
                    ),
                  ),
                  // _buildMonths(context),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildWeeks() {
    return Container(
      // padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[500],
            width: 0.6,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(weeks.length, (index) {
          return Expanded(
            child: Container(
              padding: EdgeInsets.only(top: 6, bottom: 6),
              child: Text(
                weeks[index],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDaysOfMonth(BuildContext context, int index, List days) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[500],
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Text(
            '${getMonthNameOfDay(months[index]['month'])}',
            style: TextStyle(color: kPrimaryColor, fontSize: 13),
          ),
          SizedBox(height: 10),
          Wrap(
            alignment: WrapAlignment.start,
            children: List.generate(
              months[index]['days'].length,
              (idx) {
                return _buildDayItem(
                    index, idx, months[index]['days'][idx]['week_day'], days);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(int index, int day, int weekDay, List days) {
    double dayWidth =
        (MediaQuery.of(context).size.width / 7).floor().toDouble();

    String fullDay =
        DateTime(months[index]['year'], months[index]['month'], (day + 1))
            .toString()
            .substring(0, 10);

    days.forEach((data) {
      if (data["week_day"] == fullDay) {
        months[index]['days'][day]['content'] = data["advice"];
        months[index]['days'][day]['data'] = data;
      }
    });

    return SizedBox(
      width: day == 0 ? dayWidth * weekDay : dayWidth,
      child: Container(
        alignment: day == 0 ? Alignment.centerRight : Alignment.center,
        margin:
            day == 0 ? EdgeInsets.only(right: dayWidth / 4) : EdgeInsets.all(0),
        height: 30,
        child: SizedBox(
          width: 24,
          height: 24,
          child: ClipOval(
            child: Material(
              color: months[index]['days'][day]['content'].toString() != ""
                  ? kPrimaryColor.withOpacity(0.4)
                  : Colors.transparent,
              child: InkWell(
                splashColor: kPrimaryColor,
                onTap: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(40.0),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Container(
                      constraints: BoxConstraints(maxHeight: 150),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text(
                                '${getMonthNameOfDay(months[index]['month'])}, ',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                (day + 1).toString(),
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  '${getFullWeekNameOfDay(weekDay)}',
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 15,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                ),
                              ),
                            ],
                          ),
                          if (months[index]['days'][day]['content'] != null)
                            Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                '${months[index]['days'][day]['content']}',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 13,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                softWrap: false,
                              ),
                            ),
                          SizedBox(height: 5),
                          Row(
                            children: <Widget>[
                              Spacer(),
                              SizedBox(
                                width: 110,
                                height: 24,
                                child: FlatButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: kPrimaryColor,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CourseDetailWeekdayScreen(
                                                data: months[index]['days'][day]
                                                    ['data']),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Дэлгэрэнгүй",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                child: Center(
                  child: Text(
                    (day + 1).toString(),
                    style: TextStyle(
                      color: weekDay == 6 || weekDay == 7
                          ? Colors.red[600]
                          : Colors.grey[800],
                      fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAppBar extends PreferredSize {
  final Widget child;
  final double height;

  CustomAppBar({@required this.child, this.height = kToolbarHeight});

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      padding: EdgeInsets.only(top: statusBarHeight),
      height: preferredSize.height,
      child: child,
    );
  }
}
