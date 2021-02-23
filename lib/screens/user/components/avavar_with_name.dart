import 'package:flutter/material.dart';
import 'package:gegeengii_app/constants.dart';
import 'package:gegeengii_app/models/user.dart';
import 'package:gegeengii_app/utils/shared_preference.dart';

class AvatarWithName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return FutureBuilder(
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
              return Column(
                children: <Widget>[
                  Stack(
                    children: [
                      Positioned(
                        right: 20,
                        child: IconButton(
                          iconSize: 24,
                          onPressed: () {
                            Navigator.pushNamed(context, "/user-settings");
                          },
                          icon: Icon(
                            Icons.settings,
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                      if (snapshot.data.image == null ||
                          snapshot.data.image == "")
                        Center(
                          child: Container(
                            padding: EdgeInsets.only(top: 20, bottom: 5),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: AssetImage('assets/images/child3.png'),
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      if (snapshot.data.image != null &&
                          snapshot.data.image != "")
                        Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 5),
                            child: ClipOval(
                              child: Image.network(
                                snapshot.data.image,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (snapshot.hasData)
                    Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Text(
                        snapshot.data.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                        ),
                      ),
                    ),
                ],
              );
            }
          // return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
