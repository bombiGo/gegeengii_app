import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(10),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          enabled: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              Container(
                width: 200,
                height: 8.0,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: 190.0,
                height: 8.0,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.0),
              ),
              Container(
                width: 220.0,
                height: 8.0,
                color: Colors.white,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0),
              ),
              _buildContent(),
              _buildContent(),
              _buildContent(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 8.0,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0),
        ),
        Container(
          width: 280.0,
          height: 8.0,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0),
        ),
        Container(
          width: 300.0,
          height: 8.0,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0),
        ),
        Container(
          width: 250.0,
          height: 8.0,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0),
        ),
        Container(
          width: 150.0,
          height: 8.0,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0),
        ),
        Container(
          width: double.infinity,
          height: 8.0,
          color: Colors.white,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0),
        ),
      ],
    );
  }
}
