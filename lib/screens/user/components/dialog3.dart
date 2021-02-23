import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:gegeengii_app/models/user_calendar.dart';
import 'package:http/http.dart' as http;
import 'calendar.dart';
import '../../../constants.dart';
import 'package:gegeengii_app/utils/global.dart' as global;

class Dialog3 extends StatefulWidget {
  @override
  _Dialog3State createState() => _Dialog3State();
}

class _Dialog3State extends State<Dialog3> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final List<Map<String, dynamic>> emojiData = [
    {
      "id": "1",
      "text": "Нойрмог",
      "img": "assets/images/symptom1.png",
    },
    {
      "id": "2",
      "text": "Халуурах",
      "img": "assets/images/symptom2.png",
    },
    {
      "id": "3",
      "text": "Толгой",
      "img": "assets/images/symptom3.png",
    },
    {
      "id": "4",
      "text": "Жирс хийх",
      "img": "assets/images/symptom4.png",
    },
    {
      "id": "5",
      "text": "Хэвлий",
      "img": "assets/images/symptom5.png",
    },
  ];

  String _currentFullDay = DateTime.now().toString().substring(0, 10);
  String _currentSympton = "1";

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 15),
            child: Text(
              'Танд өнөөдөр ямар нэгэн шинж тэмдэг илэрсэн үү ?',
              style: TextStyle(fontSize: 15),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 20,
                runSpacing: 10,
                children: List.generate(
                  emojiData.length,
                  (index) => GestureDetector(
                    onTap: () async {
                      setState(() {
                        _currentSympton = emojiData[index]['id'];
                      });
                    },
                    child: _buildEmoji(index: index),
                  ),
                ),
              ),
            ),
          ),
          Calendar(
            statusType: "3",
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
                    "mode": "sympton",
                    "full_day": _currentFullDay,
                    "data": _currentSympton,
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
    );
  }

  Widget _buildEmoji({int index}) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: _currentSympton == emojiData[index]['id']
            ? kPrimaryColor.withOpacity(0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedPadding(
        padding:
            EdgeInsets.all(_currentSympton == emojiData[index]['id'] ? 2 : 0),
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          children: <Widget>[
            Image.asset(
              emojiData[index]['img'],
              width: 40,
            ),
            SizedBox(height: 5),
            Text(
              emojiData[index]['text'],
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
