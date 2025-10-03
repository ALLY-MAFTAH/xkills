import 'package:flutter/cupertino.dart';

Widget customLoader(Color color) {
  return Center(
    child:  Center(
      child: CupertinoActivityIndicator(
        radius: 15,
        color: color,
      ),
    ),
  );
}