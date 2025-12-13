// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/toasts.dart';
import '/theme/app_padding.dart';
import '/controllers/course_controller.dart';
import '/models/course.dart';
import '/components/grid_product_card.dart';
import '/components/shimmer_widgets/instructor_grid_shimmer.dart';
import '/theme/app_colors.dart';
import '/components/custom_search.dart';
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
        appBar: AppBar(
          leading: null,
          title: appBrand(),
          backgroundColor: Colors.transparent,
          toolbarHeight: Platform.isAndroid ? 60 : 30,
        ),
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
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppPadding.horizontal,
                  vertical: AppPadding.vertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Platform.isAndroid ? 80 : 100),
                    CustomSearch(
                      searchController: searchController,
                      onSearch: () {},
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 2),
                      child: const Text(
                        'Products',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
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

                          return ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: products.length,

                            itemBuilder: (context, index) {
                              final product = products[index];
                              return InkWell(
                                onTap: () {},
                                // () => Navigator.push(
                                // context,
                                // MaterialPageRoute(
                                //   builder:
                                // (_) => ProductDetailsScreen(
                                //   thisProduct: product,
                                // ),
                                // ),
                                // ),
                                child: GridProductCard(
                                  thisProduct: product,
                                  onBuyPressed: () {
                                    final amount =
                                        double.tryParse(
                                          product.price!.replaceAll(
                                            RegExp(r'[^0-9.]'),
                                            '',
                                          ),
                                        ) ??
                                        0.0;
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
                                                "Product removed from cart".tr,
                                              );
                                            }
                                          });
                                    } else {
                                      null;
                                    }
                                  },
                                  onDownloadPressed: () {
                                    // Handle download action
                                  },
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
