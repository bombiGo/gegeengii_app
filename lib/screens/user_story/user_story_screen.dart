import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/utils/global.dart' as global;

class UserStoryScreen extends StatefulWidget {
  static String routeName = "/user-story";

  @override
  _UserStoryScreenState createState() => _UserStoryScreenState();
}

class _UserStoryScreenState extends State<UserStoryScreen> {
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
    print("calendars: ${global.calendars.length}");

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              "Миний түүх",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              "${DateTime.now().year.toString()} он",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _buildWeeks(),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, int index) =>
                    _buildDaysOfMonth(context, index),
                itemCount: months.length,
              ),
            ),
            // _buildMonths(context),
          ],
        ),
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

  Widget _buildDaysOfMonth(BuildContext context, int index) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300],
            width: 0.4,
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
                    index, idx, months[index]['days'][idx]['week_day']);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(int index, int day, int weekDay) {
    double dayWidth =
        (MediaQuery.of(context).size.width / 7).floor().toDouble();
    String nowDay =
        DateTime(months[index]['year'], months[index]['month'], (day + 1))
            .toString()
            .substring(0, 10);

    Widget content = SizedBox();
    bool stopLoop = false;

    global.calendars.forEach((calendar) {
      if (calendar.full_day == nowDay && !stopLoop) {
        content = Wrap(
          alignment: WrapAlignment.start,
          spacing: 4,
          runSpacing: 8,
          children: <Widget>[
            if (calendar.mood == "1" ||
                calendar.mood == "2" ||
                calendar.mood == "3" ||
                calendar.mood == "4" ||
                calendar.mood == "5")
              Image.asset(
                "assets/images/emoji${calendar.mood}.png",
                width: 12,
              ),
            if (calendar.sympton == "1" ||
                calendar.sympton == "2" ||
                calendar.sympton == "3" ||
                calendar.sympton == "4" ||
                calendar.sympton == "5")
              Image.asset(
                "assets/images/symptom${calendar.sympton}.png",
                width: 12,
              ),
            if (calendar.drink_count.isNotEmpty &&
                int.parse(calendar.drink_count) > 0)
              Image.asset(
                'assets/images/water2.png',
                width: 7.5,
              ),
            if (calendar.note.isNotEmpty)
              Image.asset(
                'assets/images/note.png',
                width: 12,
              ),
            if (calendar.weight.isNotEmpty)
              Image.asset(
                'assets/images/weight.png',
                width: 12,
              ),
          ],
        );
        stopLoop = true;
      }
    });

    if (day == 0) {
      return SizedBox(
        width: dayWidth * weekDay,
        child: Row(
          children: [
            Spacer(),
            Container(
              width: dayWidth - 1,
              margin: EdgeInsets.all(0.5),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.05),
                borderRadius: BorderRadius.circular(3.0),
              ),
              constraints: BoxConstraints(
                minHeight: 70,
              ),
              child: Material(
                color: months[index]['days'][day]['content'].toString() != ""
                    ? kPrimaryColor.withOpacity(0.4)
                    : Colors.transparent,
                child: InkWell(
                  splashColor: kPrimaryColor,
                  borderRadius: BorderRadius.circular(3.0),
                  onTap: () {
                    String fullDay = DateTime(DateTime.now().year,
                            months[index]['month'], (day + 1))
                        .toString()
                        .substring(0, 10);
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return _buildDetailDialog(fullDay);
                      },
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          (day + 1).toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: content,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: dayWidth,
        child: Container(
          margin: EdgeInsets.all(0.5),
          decoration: BoxDecoration(
            color: Colors.orange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(3.0),
          ),
          constraints: BoxConstraints(
            minHeight: 70,
          ),
          child: Material(
            color: months[index]['days'][day]['content'].toString() != ""
                ? kPrimaryColor.withOpacity(0.4)
                : Colors.transparent,
            child: InkWell(
              splashColor: kPrimaryColor,
              borderRadius: BorderRadius.circular(3.0),
              onTap: () {
                String fullDay = DateTime(
                        DateTime.now().year, months[index]['month'], (day + 1))
                    .toString()
                    .substring(0, 10);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return _buildDetailDialog(fullDay);
                  },
                );
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      (day + 1).toString(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(5),
                    child: content,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildDetailDialog(String fullDay) {
    var findData = global.calendars
        .firstWhere((data) => data.full_day == fullDay, orElse: () => null);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ), //this right here
      child: Container(
        padding: EdgeInsets.all(20.0),
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  '$fullDay',
                  style: TextStyle(
                    color: kPrimaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('Уусан ус'),
                  Spacer(),
                  if (findData != null && findData.drink_count.isNotEmpty)
                    Text("${int.parse(findData.drink_count)} аяга".toString()),
                  if (findData != null && findData.drink_count.isEmpty)
                    Text("0"),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('Алхсан тоо'),
                  Spacer(),
                  Text('1500'),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('Сэтгэл санаа'),
                  Spacer(),
                  if (findData != null && findData.mood.isNotEmpty)
                    Image.asset(
                      "assets/images/emoji${findData.mood}.png",
                      width: 20,
                    ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('Биеийн жин'),
                  Spacer(),
                  if (findData != null && findData.weight.isNotEmpty)
                    Text(
                        "${double.parse(findData.weight).toStringAsFixed(1)} кг"
                            .toString()),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('Шинж тэмдэг'),
                  Spacer(),
                  if (findData != null && findData.sympton.isNotEmpty)
                    Image.asset(
                      "assets/images/symptom${findData.mood}.png",
                      width: 20,
                    ),
                ],
              ),
              SizedBox(height: 10),
              Text('Тэмдэглэл'),
              if (findData != null && findData.note.isNotEmpty)
                noteContent(findData.note),
            ],
          ),
        ),
      ),
    );
  }

  Widget noteContent(String note) {
    if (note == null || note == "") {
      return SizedBox();
    } else {
      return Container(
        margin: EdgeInsets.only(top: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.orange.withOpacity(0.05),
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            note.toString(),
            style: TextStyle(
              fontSize: 13,
            ),
          ),
        ),
      );
    }
  }
}
