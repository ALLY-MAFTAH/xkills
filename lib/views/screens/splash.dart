// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';

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
                colors: [
                  Color(0xFF084C4D), 
                  Color(0xFF071919), 
                ],
                begin: Alignment.topCenter, 
                end: Alignment.bottomCenter, 
              ),
            ),
          ),
          Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/brain.png', width: 35, height: 35),
                SizedBox(width: 10),
                // Image.asset('assets/icons/skillsbank.png',  ),
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
            ),
          ),
        ],
      ),
    );
  }
}
