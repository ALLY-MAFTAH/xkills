import 'package:flutter/material.dart';

// --- Placeholder for the next screen ---
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF071919),
      appBar: null, // Full screen effect
      body: Center(
        child: Text(
          'SUCCESS! Welcome to the Next Page! 🎉',
          style: TextStyle(fontSize: 24, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}