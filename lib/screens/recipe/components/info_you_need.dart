import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';

class InfoYouNeed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
            child: Text(
              'Танд хэрэгтэй мэдээлэл',
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300].withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 30,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 75,
                      height: 75,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset('assets/images/recipe7.png',
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 5, top: 10, right: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            'Өглөөний цайг өөртөө',
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        Container(
                          child: Text(
                            'Өглөөний цай ууснаар "ходоод" дүүрэн байх мэдрэмж удаан хугацааны туршид байснаар хоногийн хоолноос авах илчлэгийн ...',
                            style: TextStyle(
                              fontSize: 11,
                              color: kTextMutedColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
