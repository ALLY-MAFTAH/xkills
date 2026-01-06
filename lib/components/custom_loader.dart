import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customLoader({Color color = Colors.white, double radius = 12.0}) {
  return CupertinoActivityIndicator(radius: radius, color: color);
}
