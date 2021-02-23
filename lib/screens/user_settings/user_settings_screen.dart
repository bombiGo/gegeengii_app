import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/models/user.dart';
import 'package:gegeengii_app/screens/user_settings/components/change_password.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flushbar/flushbar.dart';

Future<void> fetchUser() async {
  final response = await http.get(AppUrl.baseURL + "/me");
  if (response.statusCode == 200) {
    var userData = json.decode(response.body);
    return userData;
  } else {
    throw "Can't get user info";
  }
}

class UserSettingsScreen extends StatefulWidget {
  static String routeName = "/user-settings";

  @override
  _UserSettingsScreenState createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  Future<void> futureUser;
  String authToken;
  bool isSwitched = false;
  File file;

  Future<void> fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = (prefs.getString("token") ?? null);

    authToken = token;

    if (token != null) {
      final response = await http.get(AppUrl.baseURL + "/me", headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        var body = json.decode(response.body);
        return body;
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
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Тохиргоо"),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF3F5F9),
      body: FutureBuilder(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            User authUser = User.fromJson(snapshot.data);

            return SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 5),
                    child: GestureDetector(
                      onTap: () async {
                        file = await ImagePicker.pickImage(
                            source: ImageSource.gallery);

                        if (file == null) return;
                        String base64Image =
                            base64Encode(file.readAsBytesSync());
                        String fileName = file.path.split("/").last;

                        final Map<String, dynamic> formData = {
                          'image': base64Image,
                          'name': fileName,
                        };

                        var response = await http.post(
                          AppUrl.baseURL + "/user/avatar",
                          headers: {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer $authToken',
                          },
                          body: json.encode(formData),
                        );

                        if (response.statusCode == 200) {
                          var data = json.decode(response.body);

                          if (data["status"]) {
                            var prefs = await SharedPreferences.getInstance();
                            prefs.setString("image", data["image_src"]);
                            setState(() {});
                          }
                          print("data: $data");
                        } else if (response.statusCode == 401) {
                          UserPreferences().removeUser();
                          Navigator.pushNamed(context, "/home");

                          Flushbar(
                            title: "Анхааруулга",
                            message: "Та нэвтрэх хэрэгтэй",
                            duration: Duration(seconds: 5),
                          )..show(context);
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          if (authUser.image == null || authUser.image == "")
                            Image.asset(
                              'assets/images/user.png',
                              width: 100,
                            ),
                          if (authUser.image != null && authUser.image != "")
                            ClipOval(
                              child: Image.network(
                                authUser.image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/edit-icon.png',
                        // width: 100,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Нүүр зураг солих',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildMyProfile(authUser),
                  _buildMySettings(authUser),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return Center(child: CircularProgressIndicator(strokeWidth: 2.0));
        },
      ),
    );
  }

  Widget _buildMyProfile(User user) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 10),
          child: Row(
            children: <Widget>[
              Text(
                'Хувийн мэдээлэл',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.pushNamed(context, "/user-profile");
                },
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Таны нэр',
                style: TextStyle(
                  // fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              if (user.name != null)
                Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: Text(
                    user.name,
                    style: TextStyle(
                      // fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'И-мэйл хаяг',
                style: TextStyle(
                  // fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              if (user.email != null)
                Text(
                  user.email,
                  style: TextStyle(
                    // fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Утасны дугаар',
                style: TextStyle(
                  // fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              Text(
                user.phone != null ? user.phone : '',
                style: TextStyle(
                  // fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMySettings(User user) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 20, bottom: 10, left: 20, right: 20),
          child: Text(
            'Тохиргоо',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 17,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          child: Row(
            children: <Widget>[
              Image.asset('assets/images/time-icon.png'),
              SizedBox(width: 5),
              Text(
                'Ус уух сануулга авах',
                style: TextStyle(
                  // fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              Spacer(),
              Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                    print(isSwitched);
                  });
                },
                activeTrackColor: Colors.lightGreenAccent,
                activeColor: Colors.green,
              ),
            ],
          ),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20.0)), //this right here
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ChangePassword(token: user.token),
                    ),
                  );
                },
              );
            },
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Text(
                'Нууц үг солих',
                style: TextStyle(
                  // fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  content: Text('Та гарахад бэлэн үү ?'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Үгүй"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("Тийм"),
                      onPressed: () async {
                        var response = await http
                            .post(AppUrl.baseURL + "/logout", headers: {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer ${user.token}',
                        });

                        print(response.body);

                        UserPreferences().removeUser();
                        Navigator.pushNamed(context, "/home");
                      },
                    ),
                  ],
                ),
              );
              // UserPreferences().removeUser();
              // Navigator.pushNamed(context, "/home");
            },
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Text(
                'Гарах',
                style: TextStyle(
                  // fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
