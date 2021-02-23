import 'package:flutter/material.dart';

import 'header_with_account.dart';
import 'calendar_with_infos.dart';
import 'featured_courses.dart';
import 'featured_infos.dart';
import 'recomend_infos.dart';
import 'featured_workouts.dart';

class HomeBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // it enable scrolling on small device
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            HeaderWithAccount(),
            CalendarWithInfos(),
            FeaturedCourses(),
            FeaturedInfos(),
            RecomendInfos(),
            FeaturedWorkouts(),
          ],
        ),
      ),
    );
  }
}
