import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/components/shimmer_widgets/payments_list_shimmer.dart';
import '/controllers/payment_controller.dart';
import '/models/payment.dart';
import '/theme/app_metrices.dart';
import '/constants/app_brand.dart';
import '/theme/app_colors.dart';

class PaymentHistoryScreen extends StatefulWidget {
  const PaymentHistoryScreen({super.key});

  @override
  State<PaymentHistoryScreen> createState() => PaymentHistoryScreenState();
}

class PaymentHistoryScreenState extends State<PaymentHistoryScreen> {
  final paymentController = Get.put(PaymentController());

  @override
  void initState() {
    super.initState();

    _loadInitialData();
  }

  void _loadInitialData() {
    paymentController.paymentsFuture = paymentController.getPaymentHistory();
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    await Future.wait([paymentController.paymentsFuture!]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppColors.secondaryColor,
      backgroundColor: Colors.white,
      child: Scaffold(
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

                    Text(
                      "Payments History".tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// 🔽 COURSES + LEVEL FILTER
                    FutureBuilder<List<Payment>>(
                      future: paymentController.paymentsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const PaymentsListShimmer();
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: Get.height / 4),
                            child: Center(
                              child: Text(
                                "No Payment".tr,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }

                        final payments = snapshot.data!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: payments.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: .85,
                                  ),
                              itemBuilder: (context, index) {
                                return Container();
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            appBrand(context: context, hasBackButton: true),
          ],
        ),
      ),
    );
  }
}
