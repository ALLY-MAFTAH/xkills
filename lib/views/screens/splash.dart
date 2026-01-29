// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../constants/auth_user.dart';
import '../../controllers/auth_controller.dart';
import '/components/toasts.dart';
import '/views/screens/tab_screen.dart';
import '/theme/app_colors.dart';
import 'swipe.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkIfSignedIn();
    super.initState();
  }

  void checkIfSignedIn() {
    Future.delayed(const Duration(seconds: 3), () async {
      var navigator = Navigator.of(context);
      final GetStorage storage = GetStorage();
      final userToken = storage.read("userToken");
      try {
        if (userToken == null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const SwipeScreen()),
          );
        } else {
          final authController = Get.put(AuthController());
          await authController.getUserData();
          await Auth().loadAuthUser();

          navigator.pushReplacement(
            MaterialPageRoute(builder: (context) => const TabsScreen()),
          );
        }
      } catch (e) {
        errorToast(e.toString());
        print("Exception is $e");
      }
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
          Center(
            child: Image.asset('assets/images/horizontal_logo.png', height: 45),
          ),
        ],
      ),
    );
  }
}
