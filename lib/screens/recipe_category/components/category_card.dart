import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final int index;
  final dynamic recipe;

  CategoryCard({
    Key key,
    this.index,
    this.recipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      height: 200,
      child: Container(
        margin: EdgeInsets.only(
          top: 16,
          left: index % 2 == 1 ? 8 : 16,
          right: index % 2 == 1 ? 16 : 8,
          bottom: 0,
        ),
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
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: recipe['image'],
                    imageBuilder: (context, imageProvider) => Container(
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      recipe['title'],
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
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
                        arguments: recipe['id']);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
