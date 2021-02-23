import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/components/shimmer_loader6.dart';
import 'package:gegeengii_app/models/workout_category.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;

Future<List<WorkoutCategory>> fetchCategories() async {
  final response = await http.get(AppUrl.baseURL + "/workout-categories");
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<WorkoutCategory> data =
        body.map((dynamic item) => WorkoutCategory.fromJson(item)).toList();
    return data;
  } else {
    throw "Can't get workout category";
  }
}

class CategorySlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<WorkoutCategory> categories = snapshot.data;
          return SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              margin: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              height: 32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) =>
                    categoryCard(context, index, categories[index]),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return ShimmerLoader6();
      },
    );
  }

  Widget categoryCard(BuildContext context, index, WorkoutCategory category) {
    final List<Color> catColors = [
      Color(0xFFff5f58).withOpacity(0.8),
      Color(0xFF9396e7).withOpacity(0.8),
      Color(0xFF4aa9d0).withOpacity(0.8),
      Color(0xFF59cab4).withOpacity(0.8)
    ];

    return Container(
      height: 32,
      margin: EdgeInsets.only(right: 10),
      child: FlatButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        color: catColors[index % 4],
        onPressed: () {
          Navigator.pushNamed(context, "/workout-category",
              arguments: category.id);
        },
        child: Text(
          category.name,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
