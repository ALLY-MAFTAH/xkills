import 'dart:async';

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
  bool _hasNavigated = false;
  Timer? _fallbackTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    
    // Start audio as soon as the screen initializes
    _playSplashSound();

    // If Lottie never completes (asset/load issue), still leave splash
    _fallbackTimer = Timer(const Duration(seconds: 12), _tryNavigateAfterSplash);

    // Listen for animation completion to trigger navigation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _tryNavigateAfterSplash();
      }
    });
  }

  void _tryNavigateAfterSplash() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    _fallbackTimer?.cancel();
    checkIfSignedIn();
  }

  Future<void> _playSplashSound() async {
    try {
      // Replace with your actual audio path
      await _audioPlayer.play(AssetSource('audios/intro_sound.mp3'));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
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
        return;
      }
      // Load cached profile before using Auth().user (always null on cold start otherwise).
      await Auth().loadAuthUser();
      if (Auth().user == null) {
        storage.remove("userToken");
        Get.off(() => const SwipeScreen());
        return;
      }
      await authController.getUserData();
      Get.off(() => const TabsScreen());
    } catch (e) {
      errorToast(e.toString());
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
            'assets/lotties/renew_xkills.json', 
            controller: _controller,
            onLoaded: (composition) {
              // Configure the controller duration to match the Lottie file
              _controller.duration = composition.duration;
              if (composition.duration == Duration.zero) {
                _tryNavigateAfterSplash();
              } else {
                _controller.forward();
              }
            },
            errorBuilder: (_, __, ___) {
              _tryNavigateAfterSplash();
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}