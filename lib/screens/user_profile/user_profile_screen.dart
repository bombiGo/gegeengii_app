import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/models/user.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:gegeengii_app/providers/user_provider.dart';

class UserProfileScreen extends StatefulWidget {
  static String routeName = "/user-profile";

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

enum GenderCharacter { men, women }

class _UserProfileScreenState extends State<UserProfileScreen> {
  GenderCharacter _gender = GenderCharacter.men;
  DateTime selectedDate = DateTime.now();
  bool _isCheckedGender = false;
  bool _isSelectedBirthday = false;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1920, 1),
        lastDate: DateTime(selectedDate.year.toInt() + 1));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        _isSelectedBirthday = true;
      });
  }

  final formKey = new GlobalKey<FormState>();
  TextEditingController _firstnameController = TextEditingController();
  TextEditingController _lastnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);
    return regExp.hasMatch(em);
  }

  @override
  void initState() {
    super.initState();
    _firstnameController.text = '';
    _lastnameController.text = '';
    _emailController.text = '';
    _phoneController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return Scaffold(
      appBar: AppBar(
        title: Text("Хувийн мэдээлэл"),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF3F5F9),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator(strokeWidth: 2);
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.hasData) {
                    _firstnameController.text = snapshot.data.name;
                    _lastnameController.text = snapshot.data.lastname;
                    _phoneController.text = snapshot.data.phone;
                    _emailController.text = snapshot.data.email;

                    if (!_isCheckedGender) {
                      if (snapshot.data.gender != null) {
                        _gender = snapshot.data.gender == 'women'
                            ? GenderCharacter.women
                            : GenderCharacter.men;
                      }
                    }

                    if (!_isSelectedBirthday) {
                      if (snapshot.data.birthday != null) {
                        selectedDate = DateTime.parse(snapshot.data.birthday);
                      }
                    }

                    return Form(
                      key: formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: _firstnameController,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Таны нэр хоосон байна!';
                                    }
                                    return null;
                                  },
                                  decoration:
                                      InputDecoration(labelText: 'Таны нэр'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: _lastnameController,
                                  decoration:
                                      InputDecoration(labelText: 'Таны овог'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  controller: _phoneController,
                                  decoration: InputDecoration(
                                      labelText: 'Утасны дугаар'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                TextFormField(
                                  validator: (value) {
                                    if (value.isEmpty || !isEmail(value)) {
                                      return 'Мэйл хаягаа зөв оруулна уу!';
                                    }
                                    return null;
                                  },
                                  controller: _emailController,
                                  decoration:
                                      InputDecoration(labelText: 'И-мэйл хаяг'),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                top: 15, bottom: 0, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Хүйс'),
                                Row(
                                  children: <Widget>[
                                    Radio(
                                      value: GenderCharacter.men,
                                      groupValue: _gender,
                                      onChanged: (GenderCharacter value) {
                                        setState(() {
                                          _isCheckedGender = true;
                                          _gender = value;
                                        });
                                      },
                                    ),
                                    Text('Эрэгтэй'),
                                    Radio(
                                      value: GenderCharacter.women,
                                      groupValue: _gender,
                                      onChanged: (GenderCharacter value) {
                                        setState(() {
                                          _isCheckedGender = true;
                                          _gender = value;
                                        });
                                      },
                                    ),
                                    Text('Эмэгтэй'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                top: 5, bottom: 0, left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text('Төрсөн он сар өдөр'),
                                OutlineButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text("${selectedDate.toLocal()}"
                                      .split(' ')[0]),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: 150,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                              textColor: Colors.white,
                              color: Color(0xFF23B89B),
                              onPressed: () => saveForm(snapshot.data.token),
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
                          // _buildMyProfile(snapshot.data),
                        ],
                      ),
                    );
                  }
                }
                return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<void> saveForm(String token) async {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();

      final Map<String, dynamic> formData = {
        'name': _firstnameController.text,
        'lastname': _lastnameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'gender': _gender.index == 0 ? 'men' : 'women',
        'birthday': selectedDate.toLocal().toString().split(' ')[0],
      };

      var response = await http.post(
        AppUrl.baseURL + "/update-user",
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(formData),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status']) {
          var userData = {
            "id": responseData["user"]["id"],
            "name": responseData["user"]["name"],
            "email": responseData["user"]["email"],
            "token": token,
            "lastname": responseData["user"]["lastname"],
            "phone": responseData["user"]["phone"],
            "birthday": responseData["user"]["birthday"],
            "gender": responseData["user"]["gender"],
          };
          User authUser = User.fromJson(userData);
          UserPreferences().saveUser(authUser);
          Provider.of<UserProvider>(context, listen: false).setUser(authUser);
          Navigator.pushNamed(context, '/user-settings');
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
    }
  }
}
