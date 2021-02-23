import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/models/recipe_new.dart';
import 'components/info_card.dart';
import 'package:gegeengii_app/components/shimmer_loader.dart';

Future<List<RecipeNew>> fetchInfos() async {
  final response = await http.get(AppUrl.baseURL + "/recipe-news");
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<RecipeNew> infos =
        body.map((dynamic item) => RecipeNew.fromJson(item)).toList();
    return infos;
  } else {
    throw "Can't get infos";
  }
}

class RecipeNewScreen extends StatefulWidget {
  static String routeName = "/recipe-news";
  @override
  _RecipeNewScreenState createState() => _RecipeNewScreenState();
}

class _RecipeNewScreenState extends State<RecipeNewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Танд хэрэгтэй мэдээлэл'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: fetchInfos(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<RecipeNew> infos = snapshot.data;
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Column(
                    children: [
                      if (infos.length > 0)
                        _buildLastInfo(infos[infos.length - 1]),
                      if (infos.length > 1)
                        Wrap(
                          children: List.generate(
                            infos.length,
                            (index) {
                              return InfoCard(
                                index: index,
                                info: infos[index],
                              );
                            },
                          ),
                        ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return ShimmerLoader();
          },
        ),
      ),
    );
  }

  Widget _buildLastInfo(RecipeNew info) {
    return Container(
      height: 200,
      width: double.infinity,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300].withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: info.image,
              imageBuilder: (context, imageProvider) => Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                info.title,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  Navigator.pushNamed(context, "/recipe-news-detail",
                      arguments: info.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
