import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';

class Tuesday extends StatelessWidget {
  final List<Map<String, String>> foodData = [
    {
      "title": "Өглөөний хоол",
      "text":
          "Та цэвэрлэгээний долоо хоногт өглөө бүр дархлаагаа дэмжиж, шидэт ундаа хийж ууна. Шидэт ундааны жорыг заавраас харна уу.",
      "image": "assets/images/img2.png",
      "subtitle": "Шидэт ундаа",
      "list": "100гр жүрж,50гр синамон,10гр сахар,10гр яншуй"
    },
    {
      "title": "Өдрийн хоол",
      "text":
          "Хоолыг 1 ширхэг лууванг маш сайн зажилж идэж эхлүүлнэ. Үүний дараа Ид шидийн шөлийг зооглоно. Ислэгээр баялаг хоол хүнс хэрэглэх нь ходоод гэдсийг эрүүл байлгаж, өтгөнийг биеэс гадагшлуулж цэвэрлэх үүрэг гүйцэтгэдэг.",
      "image": "assets/images/img3.png",
      "subtitle": "Ид шидийн шөл",
      "list": "100гр жүрж,50гр синамон,10гр сахар,10гр яншуй"
    },
    {
      "title": "Оройн смүүдий",
      "text":
          "Навчит ногоон ногоонууд нь бүдүүн гэдэсний орчинг хэвийн байлгахад ихээхэн үүрэг гүйцэтгэдэг. Хлорфиплээр (хлорфипл нь фотосинтезд зайлшгүй шаардлагатай пигмент) баялга бөгөөд ходоод гэдэсний замыг цэвэрлэж улмаар бүдүүн гэдсийг тайвшруулна.",
      "image": "assets/images/img4.png",
      "subtitle": "Смүүдий",
      "list": "100гр жүрж,50гр синамон,10гр сахар,10гр яншуй"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/images/img1.png',
              width: 210,
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: List.generate(
                foodData.length, (index) => _buildContent(index: index)),
          ),
          SizedBox(height: 50),
        ],
      ),
    );
  }

  Widget _buildContent({int index}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              foodData[index]['title'],
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child:
                Text(foodData[index]['text'], style: TextStyle(fontSize: 12)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[300].withOpacity(0.8),
                        blurRadius: 6,
                        offset: Offset(0, 7),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 5, right: 10),
                  child: Image.asset(foodData[index]['image']),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                          top: 0, left: 0, right: 10, bottom: 10),
                      child: Text(
                        foodData[index]['subtitle'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: kPrimaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Text(
                      foodData[index]['list'].split(",")[0],
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      foodData[index]['list'].split(",")[1],
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      foodData[index]['list'].split(",")[2],
                      style: TextStyle(fontSize: 13),
                    ),
                    Text(
                      foodData[index]['list'].split(",")[3],
                      style: TextStyle(fontSize: 13),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 20, top: 10),
                      child: SizedBox(
                        width: double.infinity,
                        height: 20,
                        child: FlatButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: kPrimaryColor,
                          onPressed: () {
                            print("onPressed!");
                          },
                          child: Text('Дэлгэрэнгүй үзэх',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
