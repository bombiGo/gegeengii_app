import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({
    Key key,
    this.text,
    this.image,
  }) : super(key: key);

  final String text, image;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Spacer(
          flex: 3,
        ),
        Text(
          'ГЭГЭЭНГИЙ',
          style: TextStyle(
            fontSize: 20,
            color: kPrimaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 22,
              color: kTextMutedColor,
            ),
          ),
        ),
        Spacer(flex: 2),
        Image.asset(
          image,
          height: 150,
        ),
      ],
    );
  }
}
