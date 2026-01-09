import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '/theme/app_colors.dart';
import '/views/screens/cart_screen.dart';

import '../components/slide_animations.dart';
import '../controllers/course_controller.dart';

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
          LeftRightSlide(
            child: InkWell(
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
          ),
        TopBottomSlide(
          child: Image.asset('assets/images/horizontal_logo.png', height: 38),
        ),
        if (showCartButton)
          RightLeftSlide(
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CartScreen()),
                );
              },
              child: GetBuilder<CourseController>(
                builder: (courseController) {
                  return Stack(
                    children: [
                      LiquidGlassLayer(
                        settings: const LiquidGlassSettings(
                          thickness: 20,
                          blur: 5,
                          glassColor: Color.fromARGB(33, 158, 158, 158),
                          lightAngle: 0.8 * 3.14,
                        ),
                        child: LiquidGlass(
                          shape: LiquidRoundedSuperellipse(borderRadius: 50),
                          child: SizedBox(
                            height: 40,
                            width: 40,
                            child: Center(
                              child: Icon(
                                Icons.shopping_cart_checkout_rounded,
                                color: AppColors.brainColor,
                                size: 22,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (courseController.cartList.isNotEmpty)
                        Positioned(
                          top: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 9,
                            backgroundColor: AppColors.tertiaryColor,
                            child: Text(
                              courseController.cartList.length.toString(),
                              style: const TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          )
        else
          SizedBox(width: 40),
      ],
    ),
  );
}

String appName() {
  return "SkillsBank";
}

Widget appLogo({
  VoidCallback? onCardPressed,
  BuildContext? context,
  bool hasBackButton = false,
  bool showCartButton = true,
}) {
  return Center(
    child: TopBottomSlide(
      child: Image.asset('assets/images/horizontal_logo.png', height: 38),
    ),
  );
}
