import 'dart:math';

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:skillsbank/theme/app_colors.dart';

Widget appBrand({VoidCallback? onCardPressed}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset('assets/images/horizontal_logo.png', height: 35),
      //  if(onCardPressed != null)
      LiquidGlassLayer(
        settings: const LiquidGlassSettings(
          thickness: 20,
          blur: 3,
          glassColor: Color.fromARGB(33, 158, 158, 158),
          lightAngle: 0.5 * pi,
          chromaticAberration: 1,
        ),
        child: LiquidGlass(
          shape: LiquidRoundedSuperellipse(borderRadius: 50),
          child: const SizedBox(
            height: 35,
            width: 35,
            child: Center(
              child: Icon(
                Icons.shopping_cart_checkout_rounded,
                color: Color.fromARGB(255, 66, 200, 135),
                size: 22,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

String appName() {
  return "SkillsBank";
}
