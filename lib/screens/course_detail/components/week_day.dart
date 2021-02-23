import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/models/course.dart';
import 'package:gegeengii_app/screens/course_detail/course_detail_weekday_screen.dart';

class WeekDay extends StatefulWidget {
  final Course course;

  WeekDay({this.course, Key key});

  @override
  _WeekDayState createState() => _WeekDayState();
}

class _WeekDayState extends State<WeekDay> {
  @override
  Widget build(BuildContext context) {
    print("courseDays: ${widget.course.days.length}");

    return Container(
      margin: EdgeInsets.only(bottom: 0),
      child: Align(
        alignment: Alignment.topLeft,
        child: Wrap(
          children: List.generate(
            widget.course.days.length,
            (index) => _buildContent(index: index, context: context),
          ),
        ),
      ),
    );
  }

  Widget _buildContent({int index, BuildContext context}) {
    Color bgColor = Colors.white;
    Color textColor = kPrimaryColor;

    if (int.parse(widget.course.days[index]['expensive'].toString()) == 1) {
      bgColor = Colors.grey[400].withOpacity(0.4);
      textColor = Colors.white;
    }

    return Container(
      // width: MediaQuery.of(context).size.width * 0.50 - 10,
      width: 200.0,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300].withOpacity(0.8),
              blurRadius: 10,
              offset: Offset(4, 4),
            )
          ],
        ),
        child: InkWell(
          onTap: () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) =>
            //         CourseDetailWeekdayScreen(data: widget.course.days[index]),
            //   ),
            // );

            print(
                "exp: ${int.parse(widget.course.days[index]['expensive'].toString())}");

            if (int.parse(widget.course.days[index]['expensive'].toString()) ==
                0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CourseDetailWeekdayScreen(
                      data: widget.course.days[index]),
                ),
              );
            } else {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(
                    widget.course.days[index]['name'],
                    textAlign: TextAlign.center,
                  ),
                  content: Text(
                    'Та энэ өдрийн мэдээллийг харахын тулд худалдаж авна уу!',
                  ),
                  elevation: 24.0,
                  backgroundColor: Colors.white,
                  // shape: CircleBorder(),
                ),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Text(
              widget.course.days[index]['name'],
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
