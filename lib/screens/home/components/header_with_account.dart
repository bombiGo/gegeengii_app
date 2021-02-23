import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gegeengii_app/models/user.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';
import '../../../constants.dart';

class HeaderWithAccount extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Padding(
      padding: EdgeInsets.only(top: statusBarHeight),
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.all(15),
        child: FutureBuilder(
          future: getUserData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CircularProgressIndicator(strokeWidth: 2);
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  if (snapshot.hasData) {
                    return _buildUserData(context, snapshot.data);
                  }
                }
                return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserData(BuildContext context, User user) {
    return Row(
      children: <Widget>[
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, "/calendar");
            },
            child: SvgPicture.asset(
              "assets/icons/calendar.svg",
              color: kPrimaryColor.withOpacity(0.9),
              width: 28,
            ),
          ),
        ),
        Spacer(),
        Column(
          children: <Widget>[
            if (user.name != null)
              Container(
                constraints: BoxConstraints(maxWidth: 100),
                margin: EdgeInsets.only(right: 10),
                child: Text(
                  "${user.name}",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                ),
              ),
            if (user.name == null || user.name == "")
              Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  'Танд энэ өдрийн \n мэнд хүргэе',
                  style: TextStyle(
                    fontSize: 12,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
          ],
        ),
        InkWell(
          onTap: () {
            if (user.name != null) {
              Navigator.pushNamed(context, '/user');
            } else {
              Navigator.pushNamed(context, '/login');
            }
          },
          child: Row(
            children: <Widget>[
              if (user.image == null || user.image == "")
                Image.asset(
                  'assets/images/user.png',
                  width: 42,
                ),
              if (user.image != null && user.image != "")
                ClipOval(
                  child: Image.network(
                    user.image,
                    width: 42,
                    height: 42,
                    fit: BoxFit.cover,
                  ),
                ),
              // Image.asset(
              //   "assets/images/user.png",
              //   width: 42,
              // ),
            ],
          ),
        ),
      ],
    );
  }
}
