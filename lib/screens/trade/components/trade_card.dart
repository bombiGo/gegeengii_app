import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';

class TradeCard extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "id": 1,
      "title": "Улаан лооль",
      "company_name": "Дэвшил трейд ХХК",
      "price": "7,500 ₮",
      "img_src": "assets/images/product1.png"
    },
    {
      "id": 2,
      "title": "Хаш",
      "company_name": "Дэвшил трейд ХХК",
      "price": "4,500 ₮",
      "img_src": "assets/images/product2.png"
    },
    {
      "id": 1,
      "title": "Цагаан будаа",
      "company_name": "Дэвшил трейд ХХК",
      "price": "8,600 ₮",
      "img_src": "assets/images/product3.png"
    },
    {
      "id": 1,
      "title": "Монгол сүү",
      "company_name": "Сүү ХХК",
      "price": "3,700 ₮",
      "img_src": "assets/images/product4.png"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60),
      child: Wrap(
        children: List.generate(
          products.length,
          (index) => _buildContent(index: index, context: context),
        ),
      ),
    );
  }

  Widget _buildContent({int index, BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5 - 10,
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Color(0xFFF2F2F2),
          borderRadius: BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey[300].withOpacity(0.8),
              blurRadius: 10,
              offset: Offset(4, 4),
            )
          ],
        ),
        child: Container(
          height: 185,
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Image.asset(
                  products[index]['img_src'],
                  width: 100,
                  // fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                child: Text(
                  products[index]['title'],
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              Text(
                products[index]['company_name'],
                style: TextStyle(fontSize: 11, color: kTextMutedColor),
              ),
              SizedBox(height: 9),
              Text(
                products[index]['price'],
                style: TextStyle(
                    fontSize: 18,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
