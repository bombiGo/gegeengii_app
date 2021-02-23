import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/models/workout_category.dart';
import 'components/category_card.dart';
import 'package:gegeengii_app/components/shimmer_loader.dart';

Future<WorkoutCategory> fetchCategory(int id) async {
  final response = await http.get(AppUrl.baseURL + "/workout-categories/$id");
  if (response.statusCode == 200) {
    return WorkoutCategory.fromJson(json.decode(response.body));
  } else {
    throw "Can't get workout category";
  }
}

class WorkoutCategoryScreen extends StatefulWidget {
  static String routeName = "/workout-category";
  final argument;

  WorkoutCategoryScreen({Key key, this.argument}) : super(key: key);

  @override
  _WorkoutCategoryScreenState createState() => _WorkoutCategoryScreenState();
}

class _WorkoutCategoryScreenState extends State<WorkoutCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategory(widget.argument),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List workouts = snapshot.data.workouts;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(snapshot.data.name),
              centerTitle: true,
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Wrap(
                    children: List.generate(
                      workouts.length,
                      (index) {
                        return CategoryCard(
                          index: index,
                          info: workouts[index],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text('Ангилал'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: ShimmerLoader(),
          ),
        );
      },
    );
  }
}
