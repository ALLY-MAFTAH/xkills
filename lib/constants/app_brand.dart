import 'package:flutter/material.dart';
import 'package:skillsbank/theme/app_colors.dart';

Widget appBrand({VoidCallback? onCardPressed}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      SizedBox(width: 50,),
      Image.asset('assets/images/horizontal_logo.png', height: 40),
    //  if(onCardPressed != null)
      IconButton(
        onPressed: onCardPressed,
        icon: Icon(
          Icons.shopping_cart_checkout_rounded,
          color: AppColors.tertiaryColor,
        ),
      ),
    ],
  );
}

String appName() {
  return "SkillsBank";
}
