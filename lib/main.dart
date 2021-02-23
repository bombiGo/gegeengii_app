import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './routes.dart';
import './screens/splash/splash_screen.dart';

// All Providers
import 'package:gegeengii_app/providers/bottom_nav_bar.dart';
import 'package:gegeengii_app/providers/auth_provider.dart';
import 'package:gegeengii_app/providers/user_provider.dart';
import 'package:gegeengii_app/providers/search_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => BottomNavBar(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => SearchProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Gegeengii App',
        initialRoute: SplashScreen.routeName,
        routes: routes,
        theme: ThemeData(
          primaryColor: Color(0xFF23B89B),
          fontFamily: 'Nunito',
        ),
      ),
    );
  }
}
