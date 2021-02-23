import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/models/recipe.dart';

class RecipeCard extends StatelessWidget {
  final Recipe data;

  RecipeCard({
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  image: DecorationImage(
                    image: NetworkImage(data.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 8, right: 8, left: 8, bottom: 4),
                child: Text(
                  data.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                  overflow: TextOverflow.fade,
                  softWrap: false,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 0, right: 8, left: 8, bottom: 4),
                child: Text(
                  'Өдрийн хоол, Монгол',
                  style: TextStyle(fontSize: 11, color: kTextMutedColor),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, left: 5, right: 5),
                child: _buildRating(),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.pushNamed(context, "/recipe-detail",
                    arguments: data.id);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Image.asset('assets/images/star.png'),
        SizedBox(width: 4),
        Image.asset('assets/images/star.png'),
        SizedBox(width: 4),
        Image.asset('assets/images/star.png'),
        SizedBox(width: 4),
        Image.asset('assets/images/star.png'),
        SizedBox(width: 4),
        Image.asset('assets/images/star2.png'),
        SizedBox(width: 6),
        Text(
          '4.0',
          style: TextStyle(color: kTextMutedColor, fontSize: 10),
        )
      ],
    );
  }
}
