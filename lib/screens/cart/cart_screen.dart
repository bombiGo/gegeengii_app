import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gegeengii_app/constants.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "name": "Улаан лооль - Зэрлэг байгалийн бүтээгдэхүүн",
      "image": "assets/images/product1.png",
      "price": "12,500",
    },
    {
      "name": "Хулуу - Монголын хөрсөн тарьж ургуулсан",
      "image": "assets/images/product2.png",
      "price": "32,000",
    },
    {
      "name": "Слова цагаан будаа - Япон улсад үйлдвэрлэгдэв",
      "image": "assets/images/product3.png",
      "price": "25,000",
    },
    {
      "name": "Дээж сүү - Цэвэр монгол үнээний сүү",
      "image": "assets/images/product4.png",
      "price": "6000",
    },
  ];

  final String minusIcon = 'assets/icons/minus.svg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Миний сагс (${products.length})"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              products.length,
              (index) => cartProduct(products[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget cartProduct(dynamic product) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300],
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Image.asset(
              product['image'],
              width: 80,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  product['name'],
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 26,
                            height: 20,
                            child: RawMaterialButton(
                              onPressed: () {},
                              elevation: 1.0,
                              fillColor: kPrimaryColor,
                              child: SvgPicture.asset(
                                minusIcon,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              '1',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 26,
                            height: 20,
                            child: RawMaterialButton(
                              onPressed: () {},
                              elevation: 1.0,
                              fillColor: kPrimaryColor,
                              child: Icon(
                                Icons.add,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Text(
                      product['price'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: kPrimaryColor,
                      ),
                    ),
                    SizedBox(width: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
