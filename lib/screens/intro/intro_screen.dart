import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/splash_content.dart';

class IntroScreen extends StatefulWidget {
  static String routeName = "/intro";

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  PageController _pageController =
      PageController(initialPage: 0, keepPage: false);
  int currentPage = 0;
  List<Map<String, dynamic>> splashData = [
    {
      "text": "Эрүүл зөв амьдрахыг хүссэн хүн бүхэнд нээлттэй",
      "image": "assets/images/splash1.png"
    },
    {
      "text": "Та амьдралын зөв хэв маягийг манай аппаас мэдэж авах боломжтой",
      "image": "assets/images/splash2.png"
    },
    {
      "text": "Зөв дасгал хөдөлгөөн хийснээр та урт удаан наслах болно",
      "image": "assets/images/splash3.png"
    },
    {
      "text": "Цар тахлаас хамтдаа сэргийлж гараа тогтмол угаагаарай",
      "image": "assets/images/splash4.png"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                splashData.length,
                (index) => buildDot(index: index),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                        textColor: Colors.white,
                        color: Color(0xFF23B89B),
                        onPressed: () {
                          Navigator.pushNamed(context, "/register");
                        },
                        child: Text(
                          'Бүртгүүлэх',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlineButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28)),
                        textColor: Color(0xFF23B89B),
                        borderSide: BorderSide(
                          color: Color(0xFF23B89B),
                          width: 2,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        child: Text(
                          'Нэвтрэх',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    FlatButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/home");
                      },
                      child: Text(
                        "Алгасах",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          'assets/icons/google-plus.svg',
                          width: 36,
                        ),
                        SizedBox(width: 10),
                        SvgPicture.asset(
                          'assets/icons/facebook.svg',
                          width: 36,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
        color: currentPage == index ? Color(0xFF23B89B) : Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
