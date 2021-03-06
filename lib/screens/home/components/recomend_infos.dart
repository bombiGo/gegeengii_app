import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gegeengii_app/components/shimmer_loader2.dart';
import 'package:gegeengii_app/utils/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:gegeengii_app/models/advice.dart';

import '../../../constants.dart';

Future<List<Advice>> fetchInfos() async {
  final response = await http.get(AppUrl.baseURL + "/tips");
  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    List<Advice> infos =
        body.map((dynamic item) => Advice.fromJson(item)).toList();
    return infos;
  } else {
    throw "Can't get tips";
  }
}

class RecomendInfos extends StatefulWidget {
  @override
  _RecomendInfosState createState() => _RecomendInfosState();
}

class _RecomendInfosState extends State<RecomendInfos> {
  Future<List<Advice>> futureInfos;

  @override
  void initState() {
    super.initState();
    futureInfos = fetchInfos();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Text(
                  'Танд хэрэгтэй зөвлөмж',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                Spacer(),
                SizedBox(
                  height: 24,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    color: kPrimaryColor,
                    onPressed: () {
                      Navigator.pushNamed(context, "/advice");
                    },
                    child: Text(
                      'Бүгд',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 105,
            child: FutureBuilder<List<Advice>>(
              future: futureInfos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return _buildInfoCard(snapshot.data[index]);
                    },
                    itemCount: snapshot.data.length,
                    loop: false,
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return ShimmerLoader2();
                // return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(Advice advice) {
    return Container(
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
      child: Stack(
        children: [
          Positioned.fill(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 30,
                  child: Container(
                    height: 90,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: advice.image,
                      imageBuilder: (context, imageProvider) => Container(
                        height: 90,
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
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: Container(
                    padding:
                        EdgeInsets.only(left: 5, top: 5, right: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(bottom: 5),
                          child: Text(
                            advice.title,
                            style: TextStyle(fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Container(
                          child: Text(
                            advice.subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: kTextMutedColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        ),
                      ],
                    ),
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
                  Navigator.pushNamed(context, "/advice-detail",
                      arguments: advice.id);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
