import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class RegisterVerifyScreen extends StatefulWidget {
  static String routeName = "/register-verify";
  final argument;

  RegisterVerifyScreen({Key key, this.argument}) : super(key: key);

  @override
  _RegisterVerifyScreenState createState() => _RegisterVerifyScreenState();
}

class _RegisterVerifyScreenState extends State<RegisterVerifyScreen> {
  final formKey = new GlobalKey<FormState>();

  String _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                margin:
                    EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 15),
                child: Text(
                  'Өөрийн мэйл хаягаа \n баталгаажуулна уу',
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
                  decoration: InputDecoration(
                    filled: true,
                    hintText: "Кодоо оруулна уу",
                    contentPadding:
                        EdgeInsets.only(left: 15, right: 15, top: 0, bottom: 0),
                    fillColor: Colors.white70,
                    // focusedBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.grey[400], width: 1),
                    //   borderRadius: BorderRadius.circular(90),
                    // ),
                    // enabledBorder: OutlineInputBorder(
                    //   borderSide: BorderSide(color: Colors.grey[300], width: 1),
                    //   borderRadius: BorderRadius.circular(90),
                    // ),
                  ),
                  onSaved: (value) => _code = value,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Код буруу байна!';
                    }

                    return null;
                  },
                ),
              ),
              SizedBox(height: 20),
              OutlineButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                textColor: kPrimaryColor,
                borderSide: BorderSide(color: kPrimaryColor),
                onPressed: () async {
                  final form = formKey.currentState;

                  if (form.validate()) {
                    form.save();

                    final Map<String, dynamic> formData = {
                      'email': widget.argument,
                      'code': _code,
                    };

                    var response = await http.post(
                      'https://gegeengii.mn/api/signup',
                      headers: {'Content-Type': 'application/json'},
                      body: json.encode(formData),
                    );

                    if (response.statusCode == 200) {
                      Navigator.pushNamed(context, "/login");
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Text('Код буруу байна!'),
                        ),
                      );
                    }
                  }
                },
                child: Text(
                  'Баталгаажуулах',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Дахин \n код авах',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
