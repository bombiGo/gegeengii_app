import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'components/body.dart';
import 'package:gegeengii_app/utils/global.dart' as global;
import 'package:gegeengii_app/models/user_calendar.dart';
import 'package:flushbar/flushbar.dart';

class UserScreen extends StatefulWidget {
  static String routeName = "/user";

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Future<void> futureData;

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("token") ?? null);

    if (token != null) {
      final response =
          await http.get(AppUrl.baseURL + "/user/calendar", headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        List<dynamic> body = json.decode(response.body);
        List<UserCalendar> listData =
            body.map((dynamic item) => UserCalendar.fromJson(item)).toList();
        return listData;
      } else if (response.statusCode == 401) {
        UserPreferences().removeUser();
        Future.delayed(Duration(milliseconds: 0)).then((_) {
          Navigator.pushReplacementNamed(context, '/home');
          Flushbar(
            title: "Анхааруулга",
            message: "Та нэвтрэх хэрэгтэй",
            duration: Duration(seconds: 5),
          )..show(context);
        });
      } else {
        UserPreferences().removeUser();
        Future.delayed(Duration(milliseconds: 0)).then((_) {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    } else {
      UserPreferences().removeUser();
      Future.delayed(Duration(milliseconds: 0)).then((_) {
        Navigator.pushReplacementNamed(context, '/home');
        Flushbar(
          title: "Анхааруулга",
          message: "Та нэвтрэх хэрэгтэй",
          duration: Duration(seconds: 5),
        )..show(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Миний профайл"),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.length > 0) {
                List<UserCalendar> calendars = snapshot.data;
                global.calendars = List<UserCalendar>();
                calendars.forEach((element) {
                  global.calendars.add(element);
                });
              }
              return Builder(
                builder: (BuildContext context) {
                  return Body(ctx: context);
                },
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            );
            // return ShimmerLoader();
          },
        ),
      ),
    );
  }
}
