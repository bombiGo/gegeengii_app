import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(46)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300].withOpacity(0.6),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        autocorrect: true,
        decoration: InputDecoration(
          hintText: 'Бараагаа оруулна уу',
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 5),
            child: Image.asset('assets/images/search2.png'),
          ),
          // hintStyle: TextStyle(color: Colors.grey),
          filled: true,
          fillColor: Color(0xFFF2F2F2),
          contentPadding: EdgeInsets.only(right: 10, bottom: 0),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(46)),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(46)),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}
