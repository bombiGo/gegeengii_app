import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:gegeengii_app/components/shimmer_loader3.dart';
import 'package:gegeengii_app/components/single_photo_view.dart';
import 'package:gegeengii_app/models/recipe_new.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';

Future<RecipeNew> fetchAdvice(int id) async {
  final response = await http.get(AppUrl.baseURL + "/recipe-news/$id");

  if (response.statusCode == 200) {
    return RecipeNew.fromJson(json.decode(response.body));
  } else {
    throw 'Failed to load recipe new';
  }
}

class RecipeNewDetailScreen extends StatefulWidget {
  static String routeName = "/recipe-news-detail";
  final argument;

  RecipeNewDetailScreen({Key key, this.argument}) : super(key: key);

  @override
  _RecipeNewDetailScreenState createState() => _RecipeNewDetailScreenState();
}

class _RecipeNewDetailScreenState extends State<RecipeNewDetailScreen>
    with SingleTickerProviderStateMixin {
  Future<RecipeNew> futureAdvice;
  ScrollController _scrollBottomBarController = ScrollController();
  bool isScrollingDown = false;
  bool _isAppBar = false;

  @override
  void initState() {
    super.initState();
    futureAdvice = fetchAdvice(widget.argument);
    myScroll();
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_scrollBottomBarController.position.pixels > 220 &&
            !isScrollingDown) {
          isScrollingDown = true;
          this.setState(() {
            _isAppBar = true;
          });
        }
      }

      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (_scrollBottomBarController.position.pixels < 220 &&
            isScrollingDown) {
          isScrollingDown = false;
          this.setState(() {
            _isAppBar = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RecipeNew>(
      future: futureAdvice,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          RecipeNew info = snapshot.data;
          return Scaffold(
            body: SingleChildScrollView(
              controller: _scrollBottomBarController,
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    height: 180,
                    child: Stack(
                      children: <Widget>[
                        CachedNetworkImage(
                          imageUrl: info.image,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 180,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              ),
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
                                    builder: (context) =>
                                        SinglePhotoView(image: info.image),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      info.title,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _buildEditorContent(info: info),
                ],
              ),
            ),
            extendBodyBehindAppBar: true,
            appBar: _isAppBar
                ? AppBar(
                    title: Text(info.title),
                    backgroundColor: Colors.white,
                  )
                : AppBar(
                    title: null,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return Scaffold(
          body: SafeArea(
            child: ShimmerLoader3(),
          ),
        );
      },
    );
  }

  Widget _buildEditorContent({RecipeNew info}) {
    return Container(
      padding: EdgeInsets.all(15),
      child: HtmlWidget(
        info.content,
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
                  errorWidget: (context, url, error) => Icon(Icons.error),
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
    );
  }
}
