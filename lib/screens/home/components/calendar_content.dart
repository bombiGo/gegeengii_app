import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../constants.dart';

class CalendarContent extends StatefulWidget {
  List days;

  CalendarContent({
    this.days,
  });

  @override
  _CalendarContentState createState() => _CalendarContentState();
}

class _CalendarContentState extends State<CalendarContent> {
  final _scrollController = ScrollController();
  final List<Map<String, dynamic>> daysOfMonth = [];
  bool onceRendered = true;
  int _selectedIndex = 0;
  String _selectedContent = "";

  String getShortWeekNameOfDay(DateTime date) {
    dynamic dayData =
        '{ "1" : "Дав", "2" : "Мяг", "3" : "Лха", "4" : "Пүр", "5" : "Баа", "6" : "Бям", "7" : "Ням" }';
    return jsonDecode(dayData)['${date.weekday}'].toString();
  }

  String getFullWeekNameOfDay(DateTime date) {
    dynamic dayData =
        '{ "1" : "Даваа", "2" : "Мягмар", "3" : "Лхагва", "4" : "Пүрэв", "5" : "Баасан", "6" : "Бямба", "7" : "Ням" }';
    return jsonDecode(dayData)['${date.weekday}'].toString();
  }

  String getMonthNameOfDay(DateTime date) {
    dynamic dayData =
        '{"1" : "Нэгдүгээр", "2" : "Хоёрдугаар", "3" : "Гурван", "4" : "Дөрвөн", "5" : "Таван", "6" : "Зургаан", "7" : "Долоон", "8" : "Найман", "9" : "Есөн", "10" : "Арван", "11" : "Арван нэгэн", "12" : "Арван хоёр"}';
    return jsonDecode(dayData)['${date.month}'].toString();
  }

  void changeContent(int index) {
    setState(() {
      onceRendered = false;
      _selectedIndex = index;
      _selectedContent = daysOfMonth[index]['content'];
    });
  }

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    int lastDay = DateTime(now.year, now.month + 1, 0).day;

    for (var i = 1; i <= lastDay; i++) {
      bool stop = false;
      String content = "$i дахь өдрийн мэдээлэл байхгүй байна.";
      String fullDay =
          DateTime(now.year, now.month, i).toString().substring(0, 10);

      widget.days.forEach((data) {
        if (data["week_day"] == fullDay && !stop) {
          content = data["advice"] == null ? "" : data["advice"];
          _selectedIndex = i - 1;
          _selectedContent = content;
          stop = true;
        }
      });

      daysOfMonth.add({
        "week_name":
            getShortWeekNameOfDay(DateTime(now.year, now.month, i)).toString(),
        "day": i,
        "content": content,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int today = DateTime.now().day;
    double jumpPixel = 60.0 * today;

    if (onceRendered) {
      Timer(
        Duration(seconds: 0),
        () => _scrollController.jumpTo(jumpPixel),
      );
    }

    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          height: 64,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: daysOfMonth.length,
            itemBuilder: (context, index) => InkWell(
              onTap: () => changeContent(index),
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.only(
                  left: index == 0 ? 15 : 10,
                  right: index == daysOfMonth.length - 1 ? 15 : 0,
                ),
                decoration: BoxDecoration(
                  color: index == _selectedIndex
                      ? kPrimaryColor
                      : Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Container(
                  height: 64,
                  width: 36,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        daysOfMonth[index]['day'].toString(),
                        style: TextStyle(
                          color: index == _selectedIndex
                              ? Colors.white
                              : kTextColor,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        daysOfMonth[index]['week_name'].toString(),
                        style: TextStyle(
                          color: index == _selectedIndex
                              ? Colors.white
                              : kTextColor,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                'Өнөөдрийн танд санал болгох',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: kPrimaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Text(
                _selectedContent,
                style: TextStyle(
                  color: kTextMutedColor,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
