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

class Dialog4 extends StatefulWidget {
  @override
  _Dialog4State createState() => _Dialog4State();
}

class _Dialog4State extends State<Dialog4> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController _noteController = TextEditingController(text: '');
  String _currentFullDay = DateTime.now().toString().substring(0, 10);

  @override
  void initState() {
    super.initState();

    DateTime now = DateTime.now();
    String _nowDay =
        DateTime(now.year, now.month, now.day).toString().substring(0, 10);

    var findData = global.calendars
        .firstWhere((data) => data.full_day == _nowDay, orElse: () => null);

    if (findData != null) {
      _noteController.text = findData.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
              child: Text(
                'Таны өнөөдрийн сэтгэл санаа болон биеийн байдлын талаар тэмдэглэлээ хийгээрэй ?',
                style: TextStyle(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                controller: _noteController,
                maxLength: 200,
                minLines: 3,
                maxLines: 5,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: '',
                  filled: true,
                  fillColor: Color(0xFFDBEDFF),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
            Calendar(
              statusType: "4",
              callback: (date) {
                _currentFullDay = date;

                var findData = global.calendars.firstWhere(
                    (data) => data.full_day == _currentFullDay,
                    orElse: () => null);

                if (findData != null) {
                  _noteController.text = findData.note;
                }
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
                      "mode": "note",
                      "full_day": _currentFullDay,
                      "data": _noteController.text,
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

                    _noteController.text = "";
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
}
