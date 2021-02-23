import 'package:flutter/material.dart';

import 'components/header.dart';
import 'components/search.dart';
import 'components/category_slide.dart';
import 'components/trade_card.dart';
// import 'components/info_you_need.dart';

class TradeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Header(),
            Search(),
            CategorySlide(),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text('Одоогоор бүтээгдэхүүн оруулаагүй байна'),
            )
            // TradeCard(),
            // InfoYouNeed(),
          ],
        ),
      ),
    );
  }
}
