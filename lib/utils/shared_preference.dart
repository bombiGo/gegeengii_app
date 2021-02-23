import 'package:gegeengii_app/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("id", user.id);
    prefs.setString("name", user.name);
    prefs.setString("email", user.email);
    prefs.setString("token", user.token);
    prefs.setString("lastname", user.lastname);
    prefs.setString("phone", user.phone);
    prefs.setString("birthday", user.birthday);
    prefs.setString("gender", user.gender);
    prefs.setString("image", user.image);

    // ignore: deprecated_member_use
    return prefs.commit();
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int id = prefs.getInt("id");
    String name = prefs.getString("name");
    String email = prefs.getString("email");
    String token = prefs.getString("token");
    String lastname = prefs.getString("lastname");
    String phone = prefs.getString("phone");
    String birthday = prefs.getString("birthday");
    String gender = prefs.getString("gender");
    String image = prefs.getString("image");

    return User(
      id: id,
      name: name,
      email: email,
      token: token,
      lastname: lastname,
      phone: phone,
      birthday: birthday,
      gender: gender,
      image: image,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("id");
    prefs.remove("name");
    prefs.remove("email");
    prefs.remove("token");
    prefs.remove("lastname");
    prefs.remove("phone");
    prefs.remove("birthday");
    prefs.remove("gender");
    prefs.remove("image");
  }

  Future<String> getToken(args) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    return token;
  }
}
