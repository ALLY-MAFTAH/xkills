import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customLoader({Color color = Colors.white}) {
  return Center(child: CupertinoActivityIndicator(radius: 15, color: color));
}
