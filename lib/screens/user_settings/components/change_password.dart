import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:http/http.dart' as http;

class ChangePassword extends StatefulWidget {
  final String token;

  ChangePassword({
    Key key,
    this.token,
  }) : super(key: key);

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final formKey = new GlobalKey<FormState>();

  TextEditingController _controller;
  TextEditingController _controller2;
  TextEditingController _controller3;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '');
    _controller2 = TextEditingController(text: '');
    _controller3 = TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: 360,
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: Text('Хуучин нууц үг'),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  obscureText: true,
                  controller: _controller3,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Хуучин үг хоосон байна';
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
                    hintText: "******",
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
                padding: EdgeInsets.all(10),
                child: Text('Шинэ нууц үг'),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, right: 10),
                child: TextFormField(
                  obscureText: true,
                  controller: _controller,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Нууц үг хоосон байна';
                    }
                    if (value.length <= 5) {
                      return 'Нууц үг багадаа 6 оронтой байна!';
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
                    hintText: "******",
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
                padding: EdgeInsets.all(10),
                child: Text('Нууц үг давт'),
              ),
              Container(
                margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                child: TextFormField(
                  obscureText: true,
                  controller: _controller2,
                  validator: (value) {
                    if (_controller.text != _controller2.text) {
                      return 'Нууц үг таарахгүй байна';
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
                    hintText: "******",
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
                margin: EdgeInsets.only(top: 15, left: 10, right: 10),
                width: double.infinity,
                height: 48,
                child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                  textColor: Colors.white,
                  color: Color(0xFF23B89B),
                  onPressed: () async {
                    final form = formKey.currentState;

                    if (form.validate()) {
                      form.save();

                      if (widget.token != null) {
                        final Map<String, dynamic> formData = {
                          'old_password': _controller3.text,
                          'new_password': _controller.text,
                          'confirm_password': _controller2.text,
                        };

                        var response = await http.post(
                          AppUrl.baseURL + "/change-password",
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ${widget.token}',
                          },
                          body: json.encode(formData),
                        );

                        // print(widget.token);

                        if (response.statusCode == 200) {
                          var data = json.decode(response.body);

                          if (data['status'] == 400) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Text(data['message']),
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
                          } else {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                content: Text(data['message']),
                                actions: <Widget>[
                                  FlatButton(
                                    child: Text("Тийм"),
                                    onPressed: () {
                                      UserPreferences().removeUser();
                                      Navigator.pushNamed(context, "/home");
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
                        } else {
                          UserPreferences().removeUser();
                          Navigator.pushNamed(context, "/home");
                        }
                      } else {
                        UserPreferences().removeUser();
                        Navigator.pushNamed(context, "/home");
                      }
                    }
                  },
                  child: Text(
                    'Хадгалах',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      // color: kPrimaryColor,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
