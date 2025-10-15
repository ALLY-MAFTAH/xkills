// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:skillsbank/theme/app_colors.dart';

import '../../constants/app_brand.dart';
import 'tab_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    donLogin();
    super.initState();
  }

  void donLogin() {
    Future.delayed(const Duration(seconds: 3), () async {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const TabScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(child: appBrand()),
        ],
      ),
    );
  }
}
