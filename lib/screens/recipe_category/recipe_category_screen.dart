import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/models/recipe_category.dart';
import 'components/category_card.dart';
import 'package:gegeengii_app/components/shimmer_loader.dart';

Future<RecipeCategory> fetchCategory(int id) async {
  final response = await http.get(AppUrl.baseURL + "/recipe-categories/$id");
  if (response.statusCode == 200) {
    return RecipeCategory.fromJson(json.decode(response.body));
  } else {
    throw "Can't get recipe category";
  }
}

class RecipeCategoryScreen extends StatefulWidget {
  static String routeName = "/recipe-category";
  final argument;

  RecipeCategoryScreen({Key key, this.argument}) : super(key: key);

  @override
  _RecipeCategoryScreenState createState() => _RecipeCategoryScreenState();
}

class _RecipeCategoryScreenState extends State<RecipeCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategory(widget.argument),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List recipes = snapshot.data.recipes;
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
                      recipes.length,
                      (index) {
                        return CategoryCard(
                          index: index,
                          recipe: recipes[index],
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
