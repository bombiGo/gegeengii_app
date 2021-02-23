import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class CourseDetailArticleScreen extends StatefulWidget {
  final dynamic data;
  CourseDetailArticleScreen({this.data, Key key});

  @override
  _CourseDetailArticleScreenState createState() =>
      _CourseDetailArticleScreenState();
}

class _CourseDetailArticleScreenState extends State<CourseDetailArticleScreen>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollBottomBarController = ScrollController();
  bool isScrollingDown = false;
  bool _isAppBar = false;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Таны нийтлэл'),
        backgroundColor: Colors.transparent,
        bottomOpacity: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollBottomBarController,
          child: Container(
            padding: EdgeInsets.all(15),
            child: HtmlWidget(widget.data),
          ),
        ),
      ),
    );
  }
}
