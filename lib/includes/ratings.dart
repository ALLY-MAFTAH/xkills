import 'package:flutter/material.dart';

Widget buildRatingStars(double rating, {double fontSize = 12}) {
  List<Widget> stars = [];
  int fullStars = rating.floor();
  double fractionalPart = rating - fullStars;

  for (int i = 0; i < 5; i++) {
    IconData icon;
    Color color = Colors.amber;

    if (i < fullStars) {
      icon = Icons.star;
    } else if (i == fullStars && fractionalPart > 0) {
      icon = Icons.star_half;
    } else {
      icon = Icons.star_border;
      color = Colors.white70;
    }

    stars.add(Icon(icon, color: color, size: fontSize));
  }
  stars.add(
    Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        rating.toStringAsFixed(1),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  return Row(children: stars);
}