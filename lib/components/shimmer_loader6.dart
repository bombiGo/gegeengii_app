import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
      width: double.infinity,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 4,
          itemBuilder: (_, index) => Column(
            children: <Widget>[
              Container(
                width: 120.0,
                height: 40.0,
                margin: EdgeInsets.only(right: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Color(0xFFF2F2F2),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
