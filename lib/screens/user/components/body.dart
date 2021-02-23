import 'package:flutter/material.dart';
import 'avavar_with_name.dart';
import 'drink_with_walk.dart';
import 'list_type.dart';

class Body extends StatelessWidget {
  final BuildContext ctx;

  Body({Key key, this.ctx});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            AvatarWithName(),
            DrinkWithWalk(ctx: ctx),
            ListType(),
          ],
        ),
      ),
    );
  }
}
