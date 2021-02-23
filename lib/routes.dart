import 'package:flutter/widgets.dart';
import 'package:gegeengii_app/screens/auth/register_verify.dart';
import 'package:gegeengii_app/screens/recipe_new_detail/recipe_new_detail_screen.dart';
import 'package:gegeengii_app/screens/recipe_news/recipe_news_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/intro/intro_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/course_detail/course_detail_screen.dart';
import 'screens/user/user_screen.dart';
import 'screens/payment/payment_screen.dart';
import 'screens/recipe_category/recipe_category_screen.dart';
import 'screens/recipe_detail/recipe_detail_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/forget_password_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/info/info_screen.dart';
import 'screens/info_detail/info_detail_screen.dart';
import 'screens/info_category/info_category_screen.dart';
import 'screens/advice/advice_screen.dart';
import 'screens/advice_detail/advice_detail_screen.dart';
import 'screens/calendar/calendar_screen.dart';

// User
import 'screens/user_settings/user_settings_screen.dart';
import 'screens/user_profile/user_profile_screen.dart';
import 'screens/user_story/user_story_screen.dart';

// Workouts
import 'screens/workout/workout_screen.dart';
import 'screens/workout_detail/workout_detail_screen.dart';
import 'screens/workout_category/workout_category_screen.dart';

// All routes
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  IntroScreen.routeName: (context) => IntroScreen(),
  HomeScreen.routeName: (context) => HomeScreen(),
  CourseDetailScreen.routeName: (context) =>
      CourseDetailScreen(argument: ModalRoute.of(context).settings.arguments),
  UserScreen.routeName: (context) => UserScreen(),
  PaymentScreen.routeName: (context) => PaymentScreen(),
  // PaymentScreen.routeName: (context) =>
  //     PaymentScreen(arguments: ModalRoute.of(context).settings.arguments),
  RecipeCategoryScreen.routeName: (context) =>
      RecipeCategoryScreen(argument: ModalRoute.of(context).settings.arguments),
  RecipeDetailScreen.routeName: (context) =>
      RecipeDetailScreen(argument: ModalRoute.of(context).settings.arguments),
  LoginScreen.routeName: (context) => LoginScreen(),
  ForgetPasswordScreen.routeName: (context) => ForgetPasswordScreen(),
  RegisterScreen.routeName: (context) => RegisterScreen(),
  InfoScreen.routeName: (context) => InfoScreen(),
  InfoDetailScreen.routeName: (context) =>
      InfoDetailScreen(argument: ModalRoute.of(context).settings.arguments),
  InfoCategoryScreen.routeName: (context) =>
      InfoCategoryScreen(argument: ModalRoute.of(context).settings.arguments),
  AdviceScreen.routeName: (context) => AdviceScreen(),
  AdviceDetailScreen.routeName: (context) =>
      AdviceDetailScreen(argument: ModalRoute.of(context).settings.arguments),
  CalendarScreen.routeName: (context) => CalendarScreen(),
  RegisterVerifyScreen.routeName: (context) =>
      RegisterVerifyScreen(argument: ModalRoute.of(context).settings.arguments),
  UserSettingsScreen.routeName: (context) => UserSettingsScreen(),
  UserProfileScreen.routeName: (context) => UserProfileScreen(),
  UserStoryScreen.routeName: (context) => UserStoryScreen(),
  WorkoutScreen.routeName: (context) => WorkoutScreen(),
  WorkoutDetailScreen.routeName: (context) =>
      WorkoutDetailScreen(argument: ModalRoute.of(context).settings.arguments),
  WorkoutCategoryScreen.routeName: (context) => WorkoutCategoryScreen(
      argument: ModalRoute.of(context).settings.arguments),
  RecipeNewScreen.routeName: (context) => RecipeNewScreen(),
  RecipeNewDetailScreen.routeName: (context) => RecipeNewDetailScreen(
      argument: ModalRoute.of(context).settings.arguments),
};
