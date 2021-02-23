import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:pedometer/pedometer.dart';

import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:gegeengii_app/models/user_calendar.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/utils/global.dart' as global;
import 'package:flushbar/flushbar.dart';

String formatDate(DateTime d) {
  return d.toString().substring(0, 19);
}

class DrinkWithWalk extends StatefulWidget {
  final BuildContext ctx;

  DrinkWithWalk({Key key, this.ctx});

  @override
  _DrinkWithWalkState createState() => _DrinkWithWalkState();
}

class _DrinkWithWalkState extends State<DrinkWithWalk> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Stream<StepCount> _stepCountStream;
  Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  int waterCounter = 0;

  final List<Map<String, dynamic>> drinkWaters = [
    {"id": 1, "isFull": false},
    {"id": 2, "isFull": false},
    {"id": 3, "isFull": false},
    {"id": 4, "isFull": false},
    {"id": 5, "isFull": false},
    {"id": 6, "isFull": false},
    {"id": 7, "isFull": false},
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();

    DateTime now = DateTime.now();
    String _nowDay =
        DateTime(now.year, now.month, now.day).toString().substring(0, 10);

    var findData = global.calendars
        .firstWhere((data) => data.full_day == _nowDay, orElse: () => null);

    if (findData != null) {
      if (findData.drink_count.isNotEmpty) {
        waterCounter = int.parse(findData.drink_count);
        print("length: $waterCounter");

        for (var i = 1; i <= int.parse(findData.drink_count); i++) {
          drinkWaters[i - 1]['isFull'] = true;
        }
      }
    }
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  void initPlatformState() {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;
  }

  void saveWater() async {
    SharedPreferences prefs = await _prefs;
    String token = (prefs.getString("token") ?? null);

    DateTime now = DateTime.now();
    String _nowDay =
        DateTime(now.year, now.month, now.day).toString().substring(0, 10);

    if (token != null) {
      final Map<String, dynamic> formData = {
        "mode": "water",
        "full_day": _nowDay,
        "data": waterCounter.toString(),
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

          if (json.decode(response.body)['action'] == "add") {
            global.calendars.add(userCalender);
          } else {
            var findData = global.calendars.firstWhere(
                (data) => data.full_day == _nowDay,
                orElse: () => null);

            if (findData != null) {
              global.calendars[global.calendars
                      .indexWhere((element) => element.full_day == _nowDay)] =
                  userCalender;
            }
          }

          Flushbar(
            // title: "Анхааруулга",
            message: "Амжилттай хадгалагдлаа",
            duration: Duration(seconds: 4),
          )..show(widget.ctx);
        }
      } else if (response.statusCode == 401) {
        UserPreferences().removeUser();
        Navigator.pushNamed(context, "/home");
      }
    } else {
      UserPreferences().removeUser();
      Navigator.pop(context);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('Та дахин нэвтрэх оролдлого хийнэ үү!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 10, right: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300].withOpacity(0.8),
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  )
                ],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Уух ус',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            print("clicked");
                            Flushbar(
                              title: "Анхааруулга",
                              icon: Icon(
                                Icons.info_outline,
                                size: 28.0,
                                color: Colors.blue[300],
                              ),
                              message: "1 аяга ус - 250 грамм",
                              duration: Duration(seconds: 4),
                            )..show(widget.ctx);
                          },
                          child: Image.asset(
                            'assets/images/water.png',
                            width: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 116,
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 8,
                        children: List.generate(
                          drinkWaters.length,
                          (index) {
                            if (drinkWaters[index]['isFull'] == false) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    waterCounter += 1;
                                    drinkWaters[index]['isFull'] = true;
                                    saveWater();
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/water2.png',
                                  width: 24,
                                ),
                              );
                            } else {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    drinkWaters[index]['isFull'] = false;
                                    waterCounter -= 1;
                                    saveWater();
                                    // showDialog(
                                    //   context: context,
                                    //   builder: (_) => AlertDialog(
                                    //     content: Text(
                                    //         'Та дахин нэвтрэх оролдлого хийнэ үү!'),
                                    //   ),
                                    // );
                                  });
                                },
                                child: Image.asset(
                                  'assets/images/water3.png',
                                  width: 24,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left: 5, right: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[300].withOpacity(0.8),
                    blurRadius: 10,
                    offset: Offset(4, 4),
                  )
                ],
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: 10, bottom: 10, left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Алхалт',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Image.asset(
                          'assets/images/walk.png',
                          width: 22,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 7),
                  Container(
                    width: 90,
                    height: 90,
                    // color: Colors.red,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 5, color: kPrimaryColor),
                    ),
                    child: Center(
                      child: Text(
                        '$_steps\nалхам',
                        style: TextStyle(fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: 19),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
