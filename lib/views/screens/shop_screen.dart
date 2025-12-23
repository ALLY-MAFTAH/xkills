// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/toasts.dart';
import '../../theme/app_metrices.dart';
import '/controllers/course_controller.dart';
import '/models/course.dart';
import '/components/grid_product_card.dart';
import '/components/shimmer_widgets/instructor_grid_shimmer.dart';
import '/theme/app_colors.dart';
import '/constants/app_brand.dart';
import 'dart:io';
import 'payment_options_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final TextEditingController searchController = TextEditingController();
  final courseController = Get.put(CourseController());

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    courseController.productsFuture = courseController.getProducts();
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    // Wait for the new data fetch to complete
    await Future.wait([courseController.productsFuture!]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight =
        (Platform.isAndroid ? 60 : 30) + MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double minContentHeight = screenHeight - appBarHeight;

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
            // 1. Background Gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.secondaryColor, AppColors.primaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            // 2. Main Content
            SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppMetrices.horizontalPadding,
                  vertical: AppMetrices.verticalPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: Platform.isAndroid ? 90 : 100),

                    Text(
                      'Products'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    // --- INSTRUCTOR LIST/EMPTY STATE ---
                    FutureBuilder(
                      future: courseController.productsFuture,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const ProductGridShimmer();
                        } else if (asyncSnapshot.hasError) {
                          // *** FIX 2: Ensure error message takes up space ***
                          return SizedBox(
                            height: minContentHeight * 0.5,
                            child: Center(
                              child: Text(
                                'Error loading data: ${asyncSnapshot.error}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else if (asyncSnapshot.data == null ||
                            asyncSnapshot.data!.isEmpty) {
                          // *** FIX 3: Ensure 'No product' message takes up space ***
                          // This forces the SingleChildScrollView to become scrollable
                          return SizedBox(
                            height:
                                minContentHeight *
                                0.7, // Take up a large part of the screen
                            child: const Center(
                              child: Text(
                                'No products found.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else {
                          final List<Course> products = asyncSnapshot.data!;

                          return Column(
                            children: [
                              ...products.map((product) {
                                final amount =
                                    double.tryParse(
                                      product.price!.replaceAll(
                                        RegExp(r'[^0-9.]'),
                                        '',
                                      ),
                                    ) ??
                                    0.0;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: GridProductCard(
                                    thisProduct: product,
                                    onBuyPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (_) => PaymentOptionsScreen(
                                                courseIds: [product.id!],
                                                totalAmount: amount,
                                              ),
                                        ),
                                      );
                                    },
                                    onAddToCartPressed: () {
                                      if (!courseController.isLoading) {
                                        courseController
                                            .addOrRemoveCart(product.id!)
                                            .then((status) {
                                              if (status == "added") {
                                                successToast(
                                                  "Product added to cart".tr,
                                                );
                                              } else if (status == "removed") {
                                                successToast(
                                                  "Product removed from cart"
                                                      .tr,
                                                );
                                              }
                                            });
                                      }
                                    },
                                    onDownloadPressed: () {
                                      // Handle download
                                    },
                                  ),
                                );
                              }).toList(),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            appBrand(context: context),
          ],
        ),
      ),
    );
  }
}
