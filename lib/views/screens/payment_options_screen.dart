import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class PaymentOptionsScreen extends StatefulWidget {
  final double totalAmount;
  const PaymentOptionsScreen({super.key, required this.totalAmount});

  @override
  State<PaymentOptionsScreen> createState() => _PaymentOptionsScreenState();
}

class _PaymentOptionsScreenState extends State<PaymentOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.secondaryColor, AppColors.primaryColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Stack(children: []),
      ),
    );
  }
}
