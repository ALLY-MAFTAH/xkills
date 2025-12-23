import 'dart:io';

import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:skillsbank/views/screens/cart_screen.dart';

Widget appBrand({
  VoidCallback? onCardPressed,
  BuildContext? context,
  bool hasBackButton = false,
  bool showCartButton = true,
}) {
  return Positioned(
    top:
        Platform.isAndroid
            ? MediaQuery.of(context!).padding.top + 15
            : MediaQuery.of(context!).padding.top,
    left: hasBackButton ? 10 : 3,
    right: 10,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (hasBackButton)
          InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: LiquidGlassLayer(
              settings: const LiquidGlassSettings(
                thickness: 20,
                blur: 0,
                glassColor: Color.fromARGB(33, 158, 158, 158),
                lightAngle: 0.8 * 3.14,
              ),
              child: LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: 100),
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Image.asset('assets/images/horizontal_logo.png', height: 38),
        if (showCartButton)
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CartScreen()),
            );
          },
          child: LiquidGlassLayer(
            settings: const LiquidGlassSettings(
              thickness: 20,
              blur: 5,
              glassColor: Color.fromARGB(33, 158, 158, 158),
              lightAngle: 0.8 * 3.14,
            ),
            child: LiquidGlass(
              shape: LiquidRoundedSuperellipse(borderRadius: 50),
              child: const SizedBox(
                height: 40,
                width: 40,
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
        )else
        SizedBox(width: 40),
      ],
    ),
  );
}

String appName() {
  return "SkillsBank";
}
