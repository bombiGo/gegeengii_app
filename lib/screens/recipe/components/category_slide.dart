import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/components/shimmer_loader4.dart';
import 'package:gegeengii_app/models/recipe_category.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;

Future<List<RecipeCategory>> fetchCategories() async {
  final response = await http.get(AppUrl.baseURL + "/recipe-categories");
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<RecipeCategory> data =
        body.map((dynamic item) => RecipeCategory.fromJson(item)).toList();
    return data;
  } else {
    throw "Can't get recipe category";
  }
}

class CategorySlide extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("category slide mounted!");

    return FutureBuilder(
      future: fetchCategories(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<RecipeCategory> categories = snapshot.data;
          return SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (_, index) =>
                    categoryCard(context, categories[index]),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return ShimmerLoader4();
      },
    );
  }

  Widget categoryCard(BuildContext context, RecipeCategory category) {
    return Container(
      width: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Material(
            child: Ink(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF2F2F2),
              ),
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, "/recipe-category",
                      arguments: category.id);
                },
                borderRadius: BorderRadius.all(Radius.circular(40)),
                child: Container(
                  width: 56,
                  height: 56,
                  padding: EdgeInsets.all(10),
                  child: Image.network(
                    category.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            category.name,
            style: TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
