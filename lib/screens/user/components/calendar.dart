import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../constants.dart';
import 'package:gegeengii_app/utils/global.dart' as global;

typedef void StringCallback(String val);

class Calendar extends StatefulWidget {
  final String statusType;
  final Function callback;

  Calendar({
    this.statusType,
    this.callback,
  });

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final _scrollController = ScrollController();
  List<Map<String, dynamic>> daysOfMonth = [];
  final List<String> months = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];

  String _selectedYear = DateTime.now().year.toString();
  String _selectedMonth = '1';
  int _selectedIndex = 0;

  String getShortWeekNameOfDay(DateTime date) {
    dynamic dayData =
        '{ "1" : "Дав", "2" : "Мяг", "3" : "Лха", "4" : "Пүр", "5" : "Баа", "6" : "Бям", "7" : "Ням" }';
    return jsonDecode(dayData)['${date.weekday}'].toString();
  }

  String getMonthNameOfDay(DateTime date) {
    dynamic dayData =
        '{"1" : "Нэгдүгээр", "2" : "Хоёрдугаар", "3" : "Гурван", "4" : "Дөрвөн", "5" : "Таван", "6" : "Зургаан", "7" : "Долоон", "8" : "Найман", "9" : "Есөн", "10" : "Арван", "11" : "Арван нэгэн", "12" : "Арван хоёр"}';
    return jsonDecode(dayData)['${date.month}'].toString();
  }

  void updateMonth(int month) {
    daysOfMonth = [];
    DateTime now = DateTime.now();
    int lastDay = DateTime(now.year, month + 1, 0).day;

    for (var i = 1; i <= lastDay; i++) {
      String _value = "";
      String _fullDay =
          DateTime(now.year, month, i).toString().substring(0, 10);

      var findData = global.calendars
          .firstWhere((data) => data.full_day == _fullDay, orElse: () => null);

      if (findData != null) {
        if (widget.statusType == "1") {
          _value = findData.mood;
        } else if (widget.statusType == "2") {
          _value = findData.weight;
        } else if (widget.statusType == "3") {
          _value = findData.sympton;
        } else if (widget.statusType == "4") {
          _value = findData.note;
        }
      }

      daysOfMonth.add(
        {
          "week_name":
              getShortWeekNameOfDay(DateTime(now.year, month, i)).toString(),
          "day": i,
          "value": _value,
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    updateMonth(now.month);

    _selectedIndex = now.day - 1;
    _selectedMonth = now.month.toString();

    if (now.day > 4) {
      Timer(Duration(seconds: 0), () {
        _scrollController.jumpTo(now.day.toDouble() * 60);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButton<String>(
          value: _selectedMonth,
          items: months.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text("${value.toString()} сар"),
            );
          }).toList(),
          onChanged: (val) {
            setState(() {
              _selectedMonth = val;
              _selectedIndex = 0;
              _scrollController.jumpTo(0);
              String nowDate = DateTime(int.parse(_selectedYear),
                      int.parse(_selectedMonth), _selectedIndex + 1)
                  .toString()
                  .substring(0, 10);
              widget.callback(nowDate);

              updateMonth(int.parse(val));
            });
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 15),
          height: 64,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: daysOfMonth.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                  String nowDate = DateTime(int.parse(_selectedYear),
                          int.parse(_selectedMonth), _selectedIndex + 1)
                      .toString()
                      .substring(0, 10);
                  widget.callback(nowDate);
                });
              },
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
                      SizedBox(height: 3),
                      // if (_selectedIndex == index)
                      // _buildStatusIcon(widget.changedData),
                      _buildStatusIcon(daysOfMonth[index]['value']),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusIcon(String value) {
    if (widget.statusType == "1") {
      if (value == "1") {
        return Image.asset("assets/images/emoji1.png", width: 15);
      } else if (value == "2") {
        return Image.asset("assets/images/emoji2.png", width: 15);
      } else if (value == "3") {
        return Image.asset("assets/images/emoji3.png", width: 15);
      } else if (value == "4") {
        return Image.asset("assets/images/emoji4.png", width: 15);
      } else if (value == "5") {
        return Image.asset("assets/images/emoji5.png", width: 15);
      } else {
        return SizedBox();
      }
    } else if (widget.statusType == "2") {
      if (value == "" || value == null) {
        return SizedBox();
      } else {
        return Text(
          double.parse(value).toStringAsFixed(1),
          style: TextStyle(
            color: Colors.orange.withOpacity(0.9),
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        );
      }
    } else if (widget.statusType == "3") {
      if (value == "1") {
        return Image.asset("assets/images/symptom1.png", width: 20);
      } else if (value == "2") {
        return Image.asset("assets/images/symptom2.png", width: 20);
      } else if (value == "3") {
        return Image.asset("assets/images/symptom3.png", width: 20);
      } else if (value == "4") {
        return Image.asset("assets/images/symptom4.png", width: 20);
      } else if (value == "5") {
        return Image.asset("assets/images/symptom5.png", width: 20);
      } else {
        return SizedBox();
      }
    } else {
      return SizedBox();
    }
  }
}
