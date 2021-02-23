import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gegeengii_app/models/recipe.dart';

import '../../constants.dart';
import 'components/header.dart';
import 'components/category_slide.dart';
import 'components/recipe_offer.dart';
import 'components/recipe_news.dart';

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  bool searching = false;
  List<Recipe> recipes = [];
  ValueNotifier<List<Recipe>> filteredData = ValueNotifier<List<Recipe>>([]);
  TextEditingController _searchController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: <Widget>[
                Header(),
                ValueListenableBuilder(
                  valueListenable: filteredData,
                  builder: (context, value, _) {
                    return _searchTextField();
                  },
                ),
                CategorySlide(),
                RecipeOffer(
                  onReadyData: (data) {
                    recipes = data;
                  },
                ),
                RecipeNews(),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: filteredData,
              builder: (context, value, _) {
                return _searchPopup(value);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchTextField() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
      height: 46,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(46)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300].withOpacity(0.6),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          TextField(
            autocorrect: true,
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Хоолны жороо оруулна уу',
              prefixIcon: Padding(
                padding: EdgeInsets.only(left: 5),
                child: searching
                    ? SizedBox()
                    : Image.asset('assets/images/search.png'),
              ),
              // hintStyle: TextStyle(color: Colors.grey),
              filled: true,
              fillColor: Color(0xFFF2F2F2),
              contentPadding: EdgeInsets.only(right: 10, bottom: 0),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(46)),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(46)),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(fontSize: 16),
            onChanged: (value) {
              if (value.length > 0) {
                searching = true;
                filteredData.value = recipes
                    .where((Recipe recipe) => recipe.title
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              } else {
                searching = false;
                filteredData.value = [];
              }
            },
          ),
          Positioned(
            top: 6,
            left: 6,
            child: searching
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Material(
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Icon(
                            Icons.close,
                            color: kPrimaryColor,
                          ),
                        ),
                        onTap: () {
                          searching = false;
                          filteredData.value = [];
                          _searchController.clear();
                          FocusScope.of(context).unfocus();
                        },
                      ),
                    ),
                  )
                : SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _searchPopup(List<Recipe> items) {
    return Visibility(
      visible: searching ? true : false,
      child: Positioned(
        top: 115,
        left: 20,
        right: 20,
        bottom: 130,
        child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(15)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300].withOpacity(0.8),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: filteredData.value.length > 0
              ? ListView.builder(
                  itemCount:
                      searching ? filteredData.value.length : recipes.length,
                  itemBuilder: (context, index) {
                    final item =
                        searching ? filteredData.value[index] : recipes[index];
                    return ListTile(
                      contentPadding: EdgeInsets.all(0),
                      leading: CachedNetworkImage(
                        imageUrl: item.image,
                        height: 40,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.5,
                          ),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      title: Text(item.title),
                      onTap: () {
                        Navigator.pushNamed(context, '/recipe-detail',
                            arguments: item.id);
                      },
                    );
                  },
                )
              : Text('Жор олдсонгүй'),
        ),
      ),
    );
  }
}
