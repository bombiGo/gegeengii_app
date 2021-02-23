import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/models/user.dart';
import 'package:gegeengii_app/providers/auth_provider.dart';
import 'package:gegeengii_app/providers/user_provider.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'custom_web_view.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = new GlobalKey<FormState>();

  String _username, _password;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    var loading = Container(
      margin: EdgeInsets.only(top: 10),
      child: AbsorbPointer(
        absorbing: true, // by default is true
        child: RaisedButton(
          onPressed: () {},
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          child: Text("Loading ..."),
        ),
      ),
    );

    final submitButton = Container(
      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
      width: double.infinity,
      height: 50,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: kPrimaryColor,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        color: Colors.white,
        onPressed: () {
          final form = formKey.currentState;

          if (form.validate()) {
            form.save();
            final Future<Map<String, dynamic>> successfullMessage =
                auth.login(_username, _password);

            successfullMessage.then((response) {
              if (response['status']) {
                User user = response['user'];
                Provider.of<UserProvider>(context, listen: false).setUser(user);
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                _showErrorDialog();
              }
            });
          } else {
            print("form is invalid");
          }
        },
        child: Text(
          'Нэвтрэх',
          style: TextStyle(
            fontSize: 16,
            color: kPrimaryColor,
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Нэвтрэх'),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top + kToolbarHeight),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/child2.png'),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15),
                        child: TextFormField(
                          onSaved: (value) => _username = value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(90),
                              ),
                            ),
                            filled: true,
                            hintText: "Мэйл хаяг",
                            contentPadding: EdgeInsets.only(
                                left: 15, right: 15, top: 0, bottom: 0),
                            fillColor: Colors.white70,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey[400], width: 1),
                              borderRadius: BorderRadius.circular(90),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey[300], width: 1),
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                        child: TextFormField(
                          obscureText: true,
                          onSaved: (value) => _password = value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(90),
                              ),
                            ),
                            filled: true,
                            hintText: "Нууц үг",
                            contentPadding: EdgeInsets.only(
                                left: 15, right: 15, top: 0, bottom: 0),
                            fillColor: Colors.white70,
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey[400], width: 1),
                              borderRadius: BorderRadius.circular(90),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey[300], width: 1),
                              borderRadius: BorderRadius.circular(90),
                            ),
                          ),
                        ),
                      ),
                      auth.loggedInStatus == Status.Authenticating
                          ? loading
                          : submitButton,
                      Container(
                        margin: EdgeInsets.only(top: 15, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/forget-password");
                          },
                          child: Text(
                            'Нууц үг мартсан ?',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/register");
                          },
                          child: Text(
                            'Бүртгүүлэх',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        String callbackUrl = "https://gegeengii.mn/api/google/";
                        String result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CustomWebView(selectedUrl: callbackUrl),
                            maintainState: true,
                          ),
                        );

                        if (result != null) {
                          print(result);
                          var responseData = json.decode(result);

                          if (responseData.length > 1) {
                            var userData = {
                              "id": int.parse(responseData[3]),
                              "name": responseData[1],
                              "email": responseData[2],
                              "token": responseData[0]
                            };

                            User authUser = User.fromJson(userData);
                            UserPreferences().saveUser(authUser);
                            Provider.of<UserProvider>(context, listen: false)
                                .setUser(authUser);
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Мэдэгдэл"),
                                  content: Text(responseData[0]),
                                );
                              },
                            );
                          }
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/icons/google-plus.svg',
                        width: 36,
                      ),
                    ),
                    SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async {
                        String callbackUrl =
                            "https://gegeengii.mn/api/facebook/";
                        String result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CustomWebView(selectedUrl: callbackUrl),
                            maintainState: true,
                          ),
                        );

                        if (result != null) {
                          print(result);
                          var responseData = json.decode(result);

                          if (responseData.length > 1) {
                            var userData = {
                              "id": int.parse(responseData[3]),
                              "name": responseData[1],
                              "email": responseData[2],
                              "token": responseData[0]
                            };

                            User authUser = User.fromJson(userData);
                            UserPreferences().saveUser(authUser);
                            Provider.of<UserProvider>(context, listen: false)
                                .setUser(authUser);
                            Navigator.pushReplacementNamed(context, '/home');
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Мэдэгдэл"),
                                  content: Text(responseData[0]),
                                );
                              },
                            );
                          }
                        }
                      },
                      child: SvgPicture.asset(
                        'assets/icons/facebook.svg',
                        width: 36,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showErrorDialog() {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: SizedBox(
          height: 100,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Таны оруулсан нууц үг буруу байна. Та дахин оруулна уу,',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              SizedBox(
                width: 100,
                height: 32,
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32)),
                  textColor: kPrimaryColor,
                  borderSide: BorderSide(color: kPrimaryColor),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        elevation: 24.0,
        backgroundColor: Colors.white,
      ),
    );
  }
}
