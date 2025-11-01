import 'dart:io';

import 'package:flutter/material.dart';

import '../../constants/app_brand.dart';
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
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    final double topPadding =
        Platform.isAndroid ? statusBarHeight + 15 : statusBarHeight;
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
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 80.0,
                  collapsedHeight: 0.0,
                  toolbarHeight: 0.0,
                  floating: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  flexibleSpace:
                      Container(), // Empty container to satisfy the requirement
                ),
              ],
            ),
            Positioned(
              top: topPadding,
              left: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),

            // App Brand
            Positioned(top: topPadding, left: 0, right: 0, child: appBrand()),
          ],
        ),
      ),
    );
  }
}
