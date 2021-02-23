import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';

class CategorySlide extends StatelessWidget {
  final categoryData = [
    {"id": 1, "title": "Хүнсний ногоо"},
    {"id": 2, "title": "Мах"},
    {"id": 3, "title": "Амттан"},
    {"id": 4, "title": "Түргэн хоол"},
    {"id": 5, "title": "Гамбургер"},
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15),
      height: 25,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categoryData.length,
        itemBuilder: (_, index) => Container(
          margin: EdgeInsets.only(right: 10),
          alignment: Alignment.center,
          child: InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  border: index == 0
                      ? Border(
                          bottom: BorderSide(
                            width: 1.5,
                            color: kPrimaryColor,
                          ),
                        )
                      : null,
                ),
                child: Text(
                  categoryData[index]['title'],
                  style: TextStyle(
                    color: index == 0 ? Colors.black : Color(0xFF6c757d),
                    fontSize: index == 0 ? 15 : 12,
                    fontWeight:
                        index == 0 ? FontWeight.w500 : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
