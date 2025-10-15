import 'package:flutter/material.dart';

Widget appBrand() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Image.asset('assets/icons/brain.png', width: 35, height: 35),
      const SizedBox(width: 10),
      Text(
        'Skillsbank',
        style: TextStyle(
          fontFamily: "Nunito Sans",
          fontSize: 25,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}