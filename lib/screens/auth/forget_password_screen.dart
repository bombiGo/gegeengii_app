import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;

class ForgetPasswordScreen extends StatefulWidget {
  static String routeName = "/forget-password";

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  int currentPage = 0;

  final formKey = new GlobalKey<FormState>();
  TextEditingController _controller;
  TextEditingController _controller2;
  TextEditingController _controller3;
  TextEditingController _controller4;

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
    _controller2 = TextEditingController(text: '');
    _controller3 = TextEditingController(text: '');
    _controller4 = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Нууц үг сэргээх"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Form(
            key: formKey,
            child: PageView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              onPageChanged: (value) {
                setState(() {
                  currentPage = value;
                });
              },
              itemCount: 2,
              itemBuilder: (context, index) => Container(
                child: _buildInputContent(index: index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputContent({int index}) {
    if (index == 0) {
      return _buildStep1();
    } else if (index == 1) {
      return _buildStep2();
    }
    return Text('No step');
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(15),
          child: Text(
            'Та мэйл хаягаа оруулна уу,',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: _controller,
            validator: (value) {
              if (value.isEmpty || !isEmail(value)) {
                return 'Мэйл хаягаа зөв оруулна уу!';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
              ),
              filled: true,
              hintText: "yourmail@mail.com",
              contentPadding:
                  EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
              fillColor: Colors.white70,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Spacer(),
            FlatButton(
              padding: EdgeInsets.all(12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              textColor: Colors.white,
              color: Color(0xFF23B89B),
              onPressed: () async {
                final form = formKey.currentState;

                if (form.validate()) {
                  form.save();

                  final Map<String, dynamic> formData = {
                    'email': _controller.text,
                  };

                  var response = await http.post(
                    AppUrl.baseURL + "/password/email",
                    headers: {
                      'Content-Type': 'application/json',
                    },
                    body: json.encode(formData),
                  );

                  if (response.statusCode == 200) {
                    _pageController.animateToPage(
                      1,
                      duration: Duration(milliseconds: 400),
                      curve: Curves.ease,
                    );

                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: Text(
                            'Таны мэйл рүү нууц токен код явууллаа. Мэйлээ шалгана уу!'),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        content: Text('Та дахин оролдоно уу!'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Хаах"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  }
                }
              },
              child: Text(
                'Үргэлжлүүлэх',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  // color: kPrimaryColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(width: 15),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 15),
          child: Text('Мэйлд ирсэн токен код'),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: _controller4,
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Нууц токен код';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
              ),
              filled: true,
              hintText: "Нууц токен код",
              contentPadding:
                  EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
              fillColor: Colors.white70,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: Text('Шинэ нууц үг'),
        ),
        Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: TextFormField(
            controller: _controller2,
            obscureText: true,
            validator: (value) {
              if (value.isEmpty || value.length <= 5) {
                return 'Таны нууц багадаа 6 оронтой байна';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
              ),
              filled: true,
              hintText: "Шинэ нууц үг оруулна уу",
              contentPadding:
                  EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
              fillColor: Colors.white70,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(15),
          child: Text('Нууц үг давт'),
        ),
        Container(
          margin: EdgeInsets.only(top: 0, left: 15, right: 15),
          child: TextFormField(
            controller: _controller3,
            obscureText: true,
            validator: (value) {
              if (value.isEmpty || value != _controller2.text) {
                return 'Нууц үг тохирохгүй байна';
              }
              return null;
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(90),
                ),
              ),
              filled: true,
              hintText: "Нууц үг давт",
              contentPadding:
                  EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
              fillColor: Colors.white70,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[300], width: 1),
                borderRadius: BorderRadius.circular(90),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 10, right: 5),
          child: Row(
            children: <Widget>[
              SizedBox(width: 5),
              FlatButton(
                onPressed: () {
                  _pageController.animateToPage(
                    0,
                    duration: Duration(milliseconds: 400),
                    curve: Curves.ease,
                  );
                },
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back,
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Дахин код авах",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                textColor: Colors.white,
                color: Color(0xFF23B89B),
                onPressed: () async {
                  final form = formKey.currentState;

                  if (form.validate()) {
                    form.save();

                    final Map<String, dynamic> formData = {
                      'email': _controller.text,
                      'token': _controller4.text,
                      'password': _controller2.text,
                      'password_confirmation': _controller3.text,
                    };

                    var response = await http.post(
                      AppUrl.baseURL + "/password/reset",
                      headers: {
                        'Content-Type': 'application/json',
                      },
                      body: json.encode(formData),
                    );

                    if (response.statusCode == 200) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Text('Нууц үг амжилттай шинэчлэгдлээ'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Тийм"),
                              onPressed: () {
                                Navigator.pushNamed(context, "/home");
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Text('Нууц токен код буруу байна!'),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("Хаах"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        ),
                      );
                    }

                    // if (response.statusCode == 200) {
                    //   showDialog(
                    //     context: context,
                    //     builder: (_) => AlertDialog(
                    //       content: Text(
                    //           'Таны нууц үг амжилттай шинэчлэгдлээ'),
                    //     ),
                    //   );
                    // } else {
                    //   showDialog(
                    //     context: context,
                    //     builder: (_) => AlertDialog(
                    //       content:
                    //           Text('Жаахан байж байгаад дахин оролдоно уу!'),
                    //       actions: <Widget>[
                    //         FlatButton(
                    //           child: Text("Хаах"),
                    //           onPressed: () {
                    //             Navigator.pop(context);
                    //           },
                    //         ),
                    //       ],
                    //     ),
                    //   );
                    // }

                  }
                },
                child: Text(
                  'Шинэчлэх',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    // color: kPrimaryColor,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ),
      ],
    );
  }
}
