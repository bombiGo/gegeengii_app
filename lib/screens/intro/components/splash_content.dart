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
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 300
          ),
          child: Column(
            children: <Widget>[
              Image.asset(
                image,
                height: 200,
              ),
              SizedBox(height: 20),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                  color: kTextMutedColor,
                ),
              ),
            ],
          ),  
        ),
      ],
    );
  }
}
