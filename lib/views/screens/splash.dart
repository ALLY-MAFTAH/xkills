import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:audioplayers/audioplayers.dart';

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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final authController = Get.put(AuthController());
  late final AnimationController _controller;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    
    // Start audio as soon as the screen initializes
    _playSplashSound();

    // Listen for animation completion to trigger navigation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        checkIfSignedIn();
      }
    });
  }

  Future<void> _playSplashSound() async {
    try {
      // Replace with your actual audio path
      await _audioPlayer.play(AssetSource('audios/intro_sound.wav'));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void checkIfSignedIn() async {
    final GetStorage storage = GetStorage();
    final userToken = storage.read("userToken");
    
    try {
      if (userToken == null) {
        Get.off(() => const SwipeScreen());
      } else {
        if (Auth().user != null) {
          await authController.getUserData();
        }
        await Auth().loadAuthUser();
        Get.off(() => const TabsScreen());
      }
    } catch (e) {
      errorToast(e.toString());
      // Fallback: if data fetch fails, still go to main screen or stay on splash
      Get.off(() => const SwipeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondaryColor, AppColors.primaryColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Lottie.asset(
            'assets/lotties/simple_anima.json', 
            controller: _controller,
            onLoaded: (composition) {
              // Configure the controller duration to match the Lottie file
              _controller
                ..duration = composition.duration
                ..forward();
            },
          ),
        ),
      ),
    );
  }
}