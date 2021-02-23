import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:gegeengii_app/components/shimmer_loader3.dart';
import 'package:gegeengii_app/components/single_photo_view.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/models/recipe.dart';

final List<Map<String, dynamic>> allData = [
  {
    "img_src": "assets/images/img5.png",
    "txt":
        "Хулууны шөл нь амттай бөгөөд маш тэжээллэг кальци, төмөр, кали, уураг, эслэг ихтэй. Мөн илчлэг бага шөл хийхэд хялбар, хурдан байдаг.",
  },
  {
    "title": "Орц",
    "img_src": "assets/images/img6.png",
    "list":
        "2 жижиг хулуу,1 сонгино,1 лууван,1 аяга ногоон вандуй,1 аяга ногоон урт вандуй,1 аяга ногоон вандуй,1 хоолны халбага укроп",
  },
  {
    "txt":
        "Луувангаа үрүүлээр үрж, сонгиноо жижиглэн, хулуугаа хүссэн хэлбэрээр хэрчинэ.",
    "img_src": "assets/images/img7.png",
  },
  {
    "txt":
        "Ногоонуудаа бүгдийг буцалж буй усанд хийнэ. 20 орчим минут өндөр хэмд буцалгана.",
    "img_src": "assets/images/img8.png",
  },
  {
    "txt": "Укропоо хийж 5 минут буцалгаад хоол бэлэн.",
    "img_src": "assets/images/img9.png",
  },
];

Future<Recipe> fetchRecipe(int id) async {
  final response = await http.get(AppUrl.baseURL + "/recipes/$id");

  if (response.statusCode == 200) {
    return Recipe.fromJson(json.decode(response.body));
  } else {
    throw 'Failed to load recipe';
  }
}

class RecipeDetailScreen extends StatefulWidget {
  static String routeName = "/recipe-detail";
  final argument;

  RecipeDetailScreen({Key key, this.argument}) : super(key: key);

  @override
  _RecipeDetailScreenState createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Future<Recipe> futureRecipe;

  @override
  void initState() {
    super.initState();
    futureRecipe = fetchRecipe(widget.argument);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Recipe>(
      future: futureRecipe,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Recipe recipe = snapshot.data;
          return Scaffold(
            appBar: _buildAppBar(title: recipe.title),
            body: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  padding:
                      EdgeInsets.only(top: 5, left: 15, right: 15, bottom: 15),
                  child: HtmlWidget(
                    recipe.content,
                    customWidgetBuilder: (element) {
                      if (element.localName == 'img' &&
                          element.attributes.containsKey("src")) {
                        return Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: element.attributes['src'],
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SinglePhotoView(
                                          image: element.attributes['src'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        return Scaffold(
          body: SafeArea(child: ShimmerLoader3()),
        );
      },
    );
  }

  Widget _buildAppBar({String title}) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      bottomOpacity: 0.0,
      elevation: 0.0,
    );
  }
}
