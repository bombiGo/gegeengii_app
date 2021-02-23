import 'package:flutter/material.dart';
import 'package:gegeengii_app/models/recipe.dart';
import 'recipe_card.dart';

class SwipeContent extends StatelessWidget {
  final Recipe data1;
  final Recipe data2;

  SwipeContent({
    @required this.data1,
    @required this.data2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 2, bottom: 20),
      child: Row(
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
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              margin: EdgeInsets.only(left: 10, right: 5),
              child: RecipeCard(data: data1),
            ),
          ),
          _toggleCard(),
        ],
      ),
    );
  }

  Widget _toggleCard() {
    if (data2 != null) {
      return Expanded(
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
          child: RecipeCard(data: data2),
        ),
      );
    } else {
      return Expanded(
        child: SizedBox(),
      );
    }
  }
}
