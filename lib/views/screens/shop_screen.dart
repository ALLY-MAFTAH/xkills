// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/components/custom_search.dart';
import '/components/slide_animations.dart';
import '/models/sub_category.dart';
import '../../components/grid_pack_card.dart';
import '../../components/toasts.dart';
import '../../controllers/category_controller.dart';
import '../../theme/app_metrices.dart';
import '/controllers/course_controller.dart';
import '/models/course.dart';
import '../../components/shimmer_widgets/pack_grid_shimmer.dart';
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
  final categoryController = Get.put(CategoryController());
  final courseController = Get.put(CourseController());
  int selectedSubCategoryId = 0;
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    categoryController.subCategoriesFuture =
        categoryController.getSubCategories();
    courseController.allPacksFuture = courseController.getAllPacks();
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    // Wait for the new data fetch to complete
    await Future.wait([courseController.allPacksFuture!]);
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
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(height: Platform.isAndroid ? 90 : 100),

                    Text(
                      'Xkills Packs'.tr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),
                    CustomSearch(
                      searchController: searchController,
                      onSearch: () {},
                    ),
                    SizedBox(height: 20),
                    FutureBuilder(
                      future: categoryController.subCategoriesFuture,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        } else if (asyncSnapshot.hasError) {
                          // *** FIX 2: Ensure error message takes up space ***
                          return SizedBox(
                            height: minContentHeight * 0.5,
                            child: Center(
                              child: Text(
                                'Error: ${asyncSnapshot.error}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else if (asyncSnapshot.data == null ||
                            asyncSnapshot.data!.isEmpty) {
                          return Container();
                        } else {
                          final List<SubCategory> subCategories =
                              asyncSnapshot.data!;

                          return Wrap(
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  gradient:
                                      selectedSubCategoryId == 0
                                          ? LinearGradient(
                                            colors: [
                                              AppColors.brainColor,
                                              AppColors.primaryColor,
                                            ],
                                          )
                                          : null,
                                ),
                                child: OutlinedButton(
                                  onPressed: () {
                                    selectedSubCategoryId = 0;
                                    setState(() {});
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    side: BorderSide(
                                      color: Colors.grey,
                                      width: 0.5,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Text(
                                    "All".tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),

                              ...subCategories.map((subCategory) {
                                return Container(
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient:
                                        selectedSubCategoryId == subCategory.id
                                            ? LinearGradient(
                                              colors: [
                                                AppColors.brainColor,
                                                AppColors.primaryColor,
                                              ],
                                            )
                                            : null,
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      selectedSubCategoryId = subCategory.id!;
                                      setState(() {});
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      side: BorderSide(
                                        color: Colors.grey,
                                        width: 0.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: Text(
                                      "${subCategory.title}".tr,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    FutureBuilder(
                      future: courseController.allPacksFuture,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const PackGridShimmer();
                        } else if (asyncSnapshot.hasError) {
                          // *** FIX 2: Ensure error message takes up space ***
                          return SizedBox(
                            height: minContentHeight * 0.5,
                            child: Center(
                              child: Text(
                                'Error: ${asyncSnapshot.error}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else if (asyncSnapshot.data == null ||
                            asyncSnapshot.data!.isEmpty) {
                          return SizedBox(
                            height:
                                minContentHeight *
                                0.7, // Take up a large part of the screen
                            child: Center(
                              child: Text(
                                'No Packs'.tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else {
                          final List<Course> allPacks = asyncSnapshot.data!;

                          final List<Course> filteredPacks =
                              selectedSubCategoryId == 0
                                  ? allPacks
                                  : allPacks
                                      .where(
                                        (pack) =>
                                            pack.categoryId ==
                                            selectedSubCategoryId,
                                      )
                                      .toList();

                          if (filteredPacks.isEmpty) {
                            return SizedBox(
                              height: minContentHeight * 0.6,
                              child: Center(
                                child: Text(
                                  'No Packs in this category'.tr,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          }

                          return Column(
                            children: [
                              ...filteredPacks.map((pack) {
                                final amount = pack.priceForPayment ?? 0.0;

                                return BottomTopSlide(
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 1),
                                    child: GridPackCard(
                                      thisPack: pack,
                                      onBuyPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) => PaymentOptionsScreen(
                                                  courseIds: [pack.id!],
                                                  totalAmount: amount,
                                                ),
                                          ),
                                        );
                                      },
                                      onAddToCartPressed: () {
                                        if (!courseController.isLoading) {
                                          courseController
                                              .addOrRemoveCart(pack.id!)
                                              .then((status) {
                                                if (status == "added") {
                                                  successToast(
                                                    "Pack Added To Cart".tr,
                                                  );
                                                } else if (status ==
                                                    "removed") {
                                                  successToast(
                                                    "Pack Removed From Cart".tr,
                                                  );
                                                }
                                              });
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              }),
                              SizedBox(height: Platform.isAndroid ? 30 : 60),
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
