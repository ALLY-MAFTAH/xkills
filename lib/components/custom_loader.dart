import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customLoader({Color color = Colors.white}) {
  return CupertinoActivityIndicator(radius: 12, color: color);
}
