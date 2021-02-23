import 'package:flutter/material.dart';
import 'package:gegeengii_app/screens/cart/cart_screen.dart';

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Text(
            'Худалдаа',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(),
                ),
              );
            },
            child: Image.asset('assets/images/cart1.png', width: 55),
          ),
        ],
      ),
    );
  }
}
