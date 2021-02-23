import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/providers/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import 'components/body.dart';
import '../course/course_screen.dart';
import '../recipe/recipe_screen.dart';
import '../trade/trade_screen.dart';
import '../audio/audio_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> pages = [
    HomeBody(),
    CourseBody(),
    RecipeScreen(),
    TradeScreen(),
    SoundScreen(),
  ];

  void onTabTapped(int index) {
    setState(() {
      Provider.of<BottomNavBar>(context).currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var bottomProvider = Provider.of<BottomNavBar>(context);

    return AudioServiceWidget(
      child: Scaffold(
        body: SafeArea(child: pages[bottomProvider.currentIndex]),
        bottomNavigationBar: SizedBox(
          height: 64,
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Color(0xFF23B89B),
            selectedFontSize: 11,
            unselectedItemColor: Colors.black.withOpacity(.30),
            unselectedFontSize: 11,
            onTap: onTabTapped,
            currentIndex: bottomProvider.currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/icon1.svg",
                  width: 21,
                  color: bottomProvider.currentIndex == 0
                      ? kPrimaryColor
                      : Colors.black.withOpacity(.30),
                ),
                title: Text('Нүүр'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/icon2.svg",
                  width: 21,
                  color: bottomProvider.currentIndex == 1
                      ? kPrimaryColor
                      : Colors.black.withOpacity(.30),
                ),
                title: Text('Хөтөлбөр'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/icon3.svg",
                  width: 21,
                  color: bottomProvider.currentIndex == 2
                      ? kPrimaryColor
                      : Colors.black.withOpacity(.30),
                ),
                title: Text('Жор'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/icon4.svg",
                  width: 21,
                  color: bottomProvider.currentIndex == 3
                      ? kPrimaryColor
                      : Colors.black.withOpacity(.30),
                ),
                title: Text('Худалдаа'),
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  "assets/icons/icon5.svg",
                  width: 21,
                  color: bottomProvider.currentIndex == 4
                      ? kPrimaryColor
                      : Colors.black.withOpacity(.30),
                ),
                title: Text('Хөгжим'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
