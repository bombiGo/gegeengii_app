import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/models/info_category.dart';
import 'components/category_card.dart';
import 'package:gegeengii_app/components/shimmer_loader.dart';

Future<InfoCategory> fetchCategory(int id) async {
  final response = await http.get(AppUrl.baseURL + "/info-categories/$id");
  if (response.statusCode == 200) {
    return InfoCategory.fromJson(json.decode(response.body));
  } else {
    throw "Can't get info category";
  }
}

class InfoCategoryScreen extends StatefulWidget {
  static String routeName = "/info-category";
  final argument;

  InfoCategoryScreen({Key key, this.argument}) : super(key: key);

  @override
  _InfoCategoryScreenState createState() => _InfoCategoryScreenState();
}

class _InfoCategoryScreenState extends State<InfoCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchCategory(widget.argument),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List infos = snapshot.data.infos;
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
                      infos.length,
                      (index) {
                        return CategoryCard(
                          index: index,
                          info: infos[index],
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
