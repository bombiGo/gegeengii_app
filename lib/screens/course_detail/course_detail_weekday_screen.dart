import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:gegeengii_app/components/single_photo_view.dart';

import '../../constants.dart';
import 'course_detail_article_screen.dart';
import 'course_detail_exercise_screen.dart';

class CourseDetailWeekdayScreen extends StatelessWidget {
  final dynamic data;

  CourseDetailWeekdayScreen({this.data, Key key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data['name']),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (data['articles'].length > 0)
                Padding(
                  padding:
                      EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
                  child: Text(
                    'Таны өнөөдрийн нийтлэл',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              if (data['articles'].length > 0)
                _buildArticleCard(context, data['articles']),
              if (data['exercises'].length > 0)
                Padding(
                  padding:
                      EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
                  child: Text(
                    'Таны өнөөдрийн дасгал',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                ),
              if (data['exercises'].length > 0)
                _buildExerciseCard(context, data['exercises']),
              Container(
                padding:
                    EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 0),
                child: HtmlWidget(
                  data['content'],
                  onTapUrl: (url) {
                    print(url);
                  },
                  // render a custom widget
                  customWidgetBuilder: (element) {
                    if (element.localName == "a" &&
                        element.attributes.containsKey("href") &&
                        element.attributes['href'].contains("recipe#")) {
                      return SizedBox(
                        width: double.infinity,
                        height: 30,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          color: kPrimaryColor,
                          onPressed: () {
                            int recipeId = int.parse(
                                element.attributes['href'].substring(7));
                            Navigator.pushNamed(context, '/recipe-detail',
                                arguments: recipeId);
                          },
                          child: Text(
                            'Дэлгэрэнгүй үзэх',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }

                    if (element.localName == 'img' &&
                        element.attributes.containsKey("src")) {
                      return Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            CachedNetworkImage(
                              imageUrl: element.attributes['src'],
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: 150,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
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
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArticleCard(BuildContext context, dynamic articles) {
    return Column(
      children: List.generate(
        articles.length,
        (index) => Container(
          height: 195,
          width: double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300].withOpacity(0.8),
                blurRadius: 8,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 130,
                    child: CachedNetworkImage(
                      imageUrl: articles[index]['image'],
                      imageBuilder: (context, imageProvider) => Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
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
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: Text(
                      articles[index]['name'],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
              Positioned.fill(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailArticleScreen(
                              data: articles[index]['content']),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, dynamic exercises) {
    return Column(
      children: List.generate(
        exercises.length,
        (index) => Container(
          width: double.infinity,
          margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          // color: Colors.red,
          child: Row(
            children: <Widget>[
              SizedBox(
                height: 60,
                width: 60,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: exercises[index]['image'],
                      imageBuilder: (context, imageProvider) => Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
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
                                  image: exercises[index]['image'],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20),
              Column(
                children: <Widget>[
                  Text(
                    exercises[index]['name'],
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    exercises[index]['do_time'],
                    style: TextStyle(
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.video_collection_outlined,
                  color: kPrimaryColor,
                ),
                tooltip: 'View',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CourseDetailExerciseScreen(
                          data: exercises[index]['content']),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
