import 'package:flutter/material.dart';
import 'package:gegeengii_app/components/default_button.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/screens/home/home_screen.dart';
import 'splash_content.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  int currentPage = 0;
  List<Map<String, String>> splashData = [
    {
      "text": "Эрүүл зөв амьдрахыг хүссэн хүн бүхэнд нээлттэй",
      "image": "assets/images/splash1.png"
    },
    {
      "text": "Та амьдралын зөв хэв маягийг манай аппаас мэдэж авах боломжтой",
      "image": "assets/images/splash2.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    print('value: $value');
                    currentPage = value;
                  });
                },
                itemCount: splashData.length,
                itemBuilder: (context, index) => SplashContent(
                  image: splashData[index]["image"],
                  text: splashData[index]["text"],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: <Widget>[
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        splashData.length,
                        (index) => buildDot(index: index),
                      ),
                    ),
                    Spacer(flex: 3),
                    DefaultButton(
                      text: "Үргэлжлүүлэх",
                      press: () {
                        if (currentPage < splashData.length - 1) {
                          _pageController.animateToPage(
                            1,
                            duration: Duration(milliseconds: 400),
                            curve: Curves.ease,
                          );
                        } else {
                          Navigator.pushNamed(context, HomeScreen.routeName);
                        }
                      },
                    ),
                    Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildDot({int index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      margin: EdgeInsets.only(right: 5),
      height: 8,
      width: currentPage == index ? 8 : 8,
      decoration: BoxDecoration(
        color: currentPage == index ? kPrimaryColor : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
