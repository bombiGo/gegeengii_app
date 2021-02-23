import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Text(
        'Хоолны жор',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }
}
