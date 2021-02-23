import 'package:flutter/material.dart';

// Dialogs
import 'dialog1.dart';
import 'dialog2.dart';
import 'dialog3.dart';
import 'dialog4.dart';
import 'dialog5.dart';

class ListType extends StatelessWidget {
  final List<Map<String, String>> listData = [
    {
      "id": "1",
      "icon": "assets/images/icon1.png",
      "text": "Сэтгэл санаа хэр байна даа?",
      "arrow": "assets/images/icon5.png",
    },
    {
      "id": "2",
      "icon": "assets/images/icon2.png",
      "text": "Биеийн жин",
      "arrow": "assets/images/icon5.png",
    },
    {
      "id": "3",
      "icon": "assets/images/icon3.png",
      "text": "Шинж тэмдэг",
      "arrow": "assets/images/icon5.png",
    },
    {
      "id": "4",
      "icon": "assets/images/icon4.png",
      "text": "Миний тэмдэглэл",
      "arrow": "assets/images/icon5.png",
    },
    {
      "id": "5",
      "icon": "assets/images/icon6.png",
      "text": "Миний түүх",
      "arrow": "assets/images/icon5.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, bottom: 20),
      child: Column(
        children: List.generate(
          listData.length,
          (index) => _buildContent(index: index, context: context),
        ),
      ),
    );
  }

  Widget _buildContent({int index, BuildContext context}) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
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
          if (index <= 3) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20.0)), //this right here
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: _buildSelectType(index),
                  ),
                );
              },
            );
          } else {
            Navigator.pushNamed(context, "/user-story");
          }
        },
        child: Row(
          children: <Widget>[
            Image.asset(listData[index]['icon'], width: 20),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(listData[index]['text']),
              ),
            ),
            Image.asset(listData[index]['arrow'], width: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectType(int index) {
    if (index == 0) {
      return Dialog1();
    } else if (index == 1) {
      return Dialog2();
    } else if (index == 2) {
      return Dialog3();
    } else {
      return Dialog4();
    }
  }
}
