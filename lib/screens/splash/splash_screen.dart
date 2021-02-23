import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';
// import 'components/body.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0;

  void startTimer() {
    Timer.periodic(
      Duration(milliseconds: 1000),
      (Timer timer) => setState(() {
        if (_progress >= 1) {
          timer.cancel();
          Navigator.pushNamed(context, '/intro');
        } else {
          _progress += 0.3;
        }
      }),
    );
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg_repeat.png"),
                fit: BoxFit.none,
                repeat: ImageRepeat.repeat,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Image.asset(
                      "assets/images/child.png",
                      width: 150,
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.25,
            child: Container(
              margin: EdgeInsets.only(left: 50, right: 50),
              child: Container(
                height: 6,
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: LinearProgressIndicator(
                  value: _progress,
                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 5,
            child: Text(
              '0.0.1',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
