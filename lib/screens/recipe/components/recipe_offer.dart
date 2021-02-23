import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/components/shimmer_loader5.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gegeengii_app/models/recipe.dart';
import 'swipe_content.dart';

Future<List<Recipe>> fetchRecipes() async {
  final response = await http.get(AppUrl.baseURL + "/recipes");
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Recipe> recipes =
        body.map((dynamic item) => Recipe.fromJson(item)).toList();
    return recipes;
  } else {
    throw "Can't get recipes";
  }
}

class RecipeOffer extends StatefulWidget {
  final Function onReadyData;

  RecipeOffer({
    this.onReadyData,
    Key key,
  });

  @override
  _RecipeOfferState createState() => _RecipeOfferState();
}

class _RecipeOfferState extends State<RecipeOffer> {
  Future<List<Recipe>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(15),
          child: Text(
            'Таньд санал болгох жорууд',
            style: TextStyle(fontSize: 16),
          ),
        ),
        Container(
          height: 190,
          child: FutureBuilder<List<Recipe>>(
            future: futureRecipes,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                widget.onReadyData(snapshot.data);
                return Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      child: SwipeContent(
                        data1: snapshot.data[index * 2],
                        data2: snapshot.data.length.isEven
                            ? snapshot.data[index * 2 + 1]
                            : snapshot.data.length == index * 2 + 1
                                ? null
                                : snapshot.data[index * 2 + 1],
                      ),
                    );
                  },
                  itemCount: (snapshot.data.length / 2).ceil(),
                  loop: false,
                );
              } else if (snapshot.hasError) {
                List<Recipe> recipes = [];
                widget.onReadyData(recipes);
                return Text("${snapshot.error}");
              }
              return ShimmerLoader5();
            },
          ),
        ),
      ],
    );
  }
}
