import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/components/custom_loader.dart';
import '/views/screens/tab_screen.dart';
import '../../controllers/course_controller.dart';
import '/controllers/payment_controller.dart';
import '/theme/app_metrices.dart';
import '/constants/app_brand.dart';
import '/theme/app_colors.dart';

class PaymentCompletionScreen extends StatefulWidget {
  final String orderId;
  final Map<String, dynamic> metadata;
  const PaymentCompletionScreen({
    super.key,
    required this.orderId,
    required this.metadata,
  });

  @override
  State<PaymentCompletionScreen> createState() =>
      PaymentCompletionScreenState();
}

enum PaymentUIState { waiting, success, failed }

class PaymentCompletionScreenState extends State<PaymentCompletionScreen> {
  final paymentController = Get.put(PaymentController());
  final courseController = Get.put(CourseController());

  PaymentUIState uiState = PaymentUIState.waiting;
  bool _stopPolling = false;

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
void dispose() {
  _stopPolling = true;
  super.dispose();
}


  void _startPolling() async {
  for (int i = 0; i < 10; i++) {
    if (_stopPolling || !mounted) break;

    await Future.delayed(const Duration(seconds: 6));

    final completed = await paymentController.checkPaymentStatusZeno(
      widget.orderId,
      widget.metadata,
    );

    if (!mounted) return;

    if (completed == true) {
      setState(() {
        uiState = PaymentUIState.success;
        _stopPolling = true;
      });
      return;
    }
  }

  if (!_stopPolling && mounted) {
    setState(() => uiState = PaymentUIState.failed);
  }
}


  Widget _buildContent() {
    switch (uiState) {
      case PaymentUIState.waiting:
        return Column(
          children: [
            const SizedBox(height: 30),

            // 🌟 Animated loader card
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  customLoader(),
                  const SizedBox(height: 25),

                  const Text(
                    "Confirming your payment",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    "Please check your phone and enter your PIN to complete the payment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        );

      case PaymentUIState.success:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 90),
                  SizedBox(height: 15),
                  Text(
                    "Payment Successful!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Your courses are now unlocked 🎉",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  courseController.myCoursesFuture =
                      courseController.getMyCourses();

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TabsScreen(pageIndex: 2)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Go to My Courses",
                  style: TextStyle(
                    color: Color(0xFF071B1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );

      case PaymentUIState.failed:
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: const [
                  Icon(Icons.error, color: Colors.redAccent, size: 90),
                  SizedBox(height: 15),
                  Text(
                    "Payment not completed",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Please try again.",
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Try Again",
                  style: TextStyle(
                    color: Color(0xFF071B1A),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),

          SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(
                left: AppMetrices.horizontalPadding,
                right: AppMetrices.horizontalPadding,
                bottom: AppMetrices.verticalPadding + 25,
                top: AppMetrices.verticalPadding,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Platform.isAndroid ? 90 : 100),

                  Center(child: _buildContent()),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),

          appBrand(context: context, hasBackButton: true),
        ],
      ),
    );
  }
}
