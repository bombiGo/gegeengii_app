import 'dart:convert';
import 'dart:math';

import 'package:bezier_chart/bezier_chart.dart';
import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:gegeengii_app/models/user_calendar.dart';
import 'package:http/http.dart' as http;
import 'calendar.dart';
import '../../../constants.dart';
import 'package:gegeengii_app/utils/global.dart' as global;

class Dialog2 extends StatefulWidget {
  @override
  _Dialog2State createState() => _Dialog2State();
}

class _Dialog2State extends State<Dialog2> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController _weightController = TextEditingController(text: '');
  final formKey = new GlobalKey<FormState>();

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  String _currentFullDay = DateTime.now().toString().substring(0, 10);
  String _currentWeight = "0";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
              child: Text(
                'Таны өнөөдрийн биеийн жингээ оруулна уу ?',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              key: formKey,
              child: TextFormField(
                controller: _weightController,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "$_currentWeight кг",
                  hintStyle: TextStyle(fontSize: 24, color: kPrimaryColor),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                  ),
                ),
              ),
            ),
            // chartMonth(context),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'Та 20 хоногийн хугацаанд 10 кг хассан байна.',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 10),
            Calendar(
              statusType: "2",
              callback: (date) {
                _currentFullDay = date;
              },
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 120,
              height: 28,
              child: OutlineButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                textColor: kPrimaryColor,
                borderSide: BorderSide(color: kPrimaryColor),
                onPressed: () async {
                  SharedPreferences prefs = await _prefs;
                  String token = (prefs.getString("token") ?? null);

                  if (token != null) {
                    final Map<String, dynamic> formData = {
                      "mode": "weight",
                      "full_day": _currentFullDay,
                      "data": _weightController.text,
                    };

                    var response = await http.post(
                      AppUrl.baseURL + "/user/calendar",
                      headers: {
                        'Content-Type': 'application/json',
                        'Authorization': 'Bearer $token',
                      },
                      body: json.encode(formData),
                    );

                    if (response.statusCode == 200) {
                      if (json.decode(response.body)['status']) {
                        var data = json.decode(response.body)['calendar'];
                        var userCalender = UserCalendar.fromJson(data);

                        if (json.decode(response.body)['action'] == "edit") {
                          var findData = global.calendars.firstWhere(
                              (data) => data.full_day == _currentFullDay,
                              orElse: () => null);

                          if (findData != null) {
                            global.calendars[global.calendars.indexWhere(
                                    (element) =>
                                        element.full_day == _currentFullDay)] =
                                userCalender;
                          }
                        } else {
                          global.calendars.add(userCalender);
                        }
                        Navigator.pop(context);
                      }
                    } else if (response.statusCode == 401) {
                      UserPreferences().removeUser();
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Text('Та дахин нэвтрэх оролдлого хийнэ үү!'),
                        ),
                      );
                    }
                  } else {
                    UserPreferences().removeUser();
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: Text('Та дахин нэвтрэх оролдлого хийнэ үү!'),
                      ),
                    );
                  }
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget chartMonth(BuildContext context) {
    List<double> months = [];
    List<DataPoint<double>> monthValues = [];

    for (var i = 1; i <= 31; i++) {
      Random rnd = new Random();
      int randomMonth = 1 + (rnd.nextInt(31 - 1));
      int randomWeight = 35 + (rnd.nextInt(150 - 35));

      months.add(i.toDouble());
      monthValues.add(DataPoint<double>(
        value: randomMonth.toDouble(),
        xAxis: randomWeight.toDouble(),
      ));
    }

    // print(monthValues);

    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width * 1,
      child: BezierChart(
        bezierChartScale: BezierChartScale.CUSTOM,
        xAxisCustomValues: months,
        series: [
          BezierLine(
            lineColor: Colors.white,
            lineStrokeWidth: 3.0,
            label: "Weight",
            onMissingValue: (dateTime) {
              if (dateTime.month.isEven) {
                return 10.0;
              }
              return 5.0;
            },
            data: monthValues,
          ),
        ],
        config: BezierChartConfig(
          verticalIndicatorStrokeWidth: 3.0,
          verticalIndicatorColor: Colors.black26,
          showVerticalIndicator: true,
          backgroundColor: kPrimaryColor,
          snap: false,
          contentWidth: 600,
        ),
      ),
    );
  }
}
