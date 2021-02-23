import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/models/user.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/utils/app_url.dart';

enum Status {
  NotLoggedIn,
  NotRegistered,
  LoggedIn,
  Registered,
  Authenticating,
  Registering,
  LoggedOut
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredStatus = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;
  Status get registeredStatus => _registeredStatus;

  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password,
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    print("loginData: $loginData");

    var response = await http.post(
      AppUrl.login,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(loginData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      var userData = {
        "id": responseData["user"]["id"],
        "name": responseData["user"]["name"],
        "email": responseData["user"]["email"],
        "token": responseData["access_token"],
        "lastname": responseData["user"]["lastname"],
        "phone": responseData["user"]["phone"],
        "birthday": responseData["user"]["birthday"],
        "gender": responseData["user"]["gender"],
      };

      User authUser = User.fromJson(userData);
      UserPreferences().saveUser(authUser);

      _loggedInStatus = Status.LoggedIn;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {
        'status': false,
        'message': json.decode(response.body)['error']
      };
    }
    return result;
  }

  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    var result;

    final Map<String, dynamic> signupData = {
      'name': name,
      'email': email,
      'password': password,
    };

    _registeredStatus = Status.Registering;
    notifyListeners();

    var response = await http.post(
      AppUrl.signup,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(signupData),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      var userData = {
        "id": responseData["user"]["id"],
        "name": responseData["user"]["name"],
        "email": responseData["user"]["email"],
        "token": responseData["access_token"],
        "lastname": responseData["user"]["lastname"],
        "phone": responseData["user"]["phone"],
        "birthday": responseData["user"]["birthday"],
        "gender": responseData["user"]["gender"],
        "qpayAccessToken": responseData["qpay_access_token"],
        "qpayRefreshToken": responseData["qpay_refresh_token"],
      };

      User authUser = User.fromJson(userData);
      UserPreferences().saveUser(authUser);

      _registeredStatus = Status.Registered;
      notifyListeners();

      result = {'status': true, 'message': 'Successful', 'user': authUser};
    } else {
      _registeredStatus = Status.NotRegistered;
      notifyListeners();
      result = {
        'status': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
    }
    return result;
  }
}
