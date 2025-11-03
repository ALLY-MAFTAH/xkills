import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/components/shimmer_widgets/cart_items_shimmer.dart';
import '../../components/custom_loader.dart';
import '../../constants/app_brand.dart';
import '../../controllers/course_controller.dart';
import '../../models/course.dart';
import '../../theme/app_colors.dart';
import 'course_details_screen.dart';
import 'payment_options_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final courseController = Get.put(CourseController());
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    courseController.cartListFuture = courseController.getCartList();
  }

  void _calculateTotal(List<Course> cartItems) {
    _totalPrice = cartItems.fold(0.0, (sum, item) {
      final priceString = item.discountedPrice.toString();
      final price =
          double.tryParse(priceString) ??
          double.tryParse(item.price.toString()) ??
          0.0;
      return sum + price;
    });
  }

  Widget _buildCartItem(Course thisCourse) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          courseController.selectedCourse = thisCourse;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CourseDetailsScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    thisCourse.thumbnail!.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: thisCourse.thumbnail!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => customLoader(),
                            errorWidget:
                                (context, url, error) =>
                                    const Icon(Icons.error),
                          ),
                        )
                        : Icon(
                          Icons.movie_filter,
                          size: 70,
                          color: Colors.grey,
                        ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      thisCourse.title!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${thisCourse.shortDescription}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 241, 239, 234),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap:
                        courseController.isLoading
                            ? null
                            : () {
                              courseController
                                  .addOrRemoveCart(thisCourse.id!)
                                  .then((status) {
                                    if (status == "removed") {
                                      setState(() {
                                        courseController.cartListFuture =
                                            courseController.getCartList();
                                      });
                                    }
                                  });
                            },
                    child:
                        courseController.isLoading
                            ? customLoader()
                            : Icon(
                              size: 28,
                              Icons.delete_forever_outlined,
                              color: Colors.redAccent,
                            ),
                  ),
                  SizedBox(height: thisCourse.discountFlag! ? 8 : 25),
                  if (thisCourse.isPaid! && thisCourse.discountFlag!)
                    Text(
                      '${thisCourse.price}', // Assuming originalPrice exists
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        decoration:
                            TextDecoration
                                .lineThrough, // The strikethrough effect
                        decorationColor: Colors.grey.withOpacity(0.9),
                        decorationThickness: 2,
                      ),
                    ),
                  Text(
                    thisCourse.isPaid!
                        ? thisCourse.discountFlag! &&
                                thisCourse.discountedPrice != null
                            ? '\$${thisCourse.discountedPrice}'
                            : '${thisCourse.price}'
                        : "Free",

                    style: const TextStyle(
                      color: Color(0xFFE6C068),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget for displaying the Empty Cart content
  Widget _buildEmptyCartContent(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.shopping_cart_outlined,
              size: 80,
              color: Colors.white54,
            ),
            const SizedBox(height: 15),
            const Text(
              "Your cart is empty.",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                "Browse Courses",
                style: TextStyle(color: const Color(0xFFE6C068), fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine status bar height for correct positioning
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double topPadding =
        Platform.isAndroid ? statusBarHeight + 15 : statusBarHeight;

    return GetBuilder<CourseController>(
      builder: (courseController) {
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

                    // 2. Main Cart Content (FutureBuilder)
                    FutureBuilder<List<Course>>(
                      future: courseController.cartListFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return SliverList(
                            delegate: SliverChildListDelegate([
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0,
                                ),
                                child: Column(
                                  children: [
                                    CartItemShimmer(),
                                    CartItemShimmer(),
                                    CartItemShimmer(),
                                  ],
                                ),
                              ),
                            ]),
                          );
                        }

                        if (snapshot.hasError) {
                          return SliverToBoxAdapter(
                            child: SizedBox(
                              height: 300,
                              child: Center(
                                child: Text(
                                  'Error loading cart: ${snapshot.error}',
                                  style: const TextStyle(
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }

                        final List<Course> cartItems = snapshot.data ?? [];
                        final bool isEmpty = cartItems.isEmpty;
                        _calculateTotal(cartItems);

                        return SliverList(
                          delegate: SliverChildListDelegate([
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child:
                                  isEmpty
                                      ? _buildEmptyCartContent(context)
                                      : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ...cartItems.map(_buildCartItem),
                                          const SizedBox(height: 20),
                                          Divider(
                                            color: Colors.white30,
                                            thickness: 1,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 100,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                const Text(
                                                  'Total:',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  '\$${_totalPrice.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                    color: Color(0xFFE6C068),
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w900,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                            ),
                          ]),
                        );
                      },
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
                Positioned(
                  top: topPadding,
                  left: 0,
                  right: 0,
                  child: appBrand(),
                ),
                Visibility(
                  visible: false,
                  child: Positioned(
                    top: Platform.isAndroid ? topPadding + 45 : topPadding + 30,
                    left: 0,
                    right: 0,
                    child: const Center(
                      child: Text(
                        "My Cart",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                if (courseController.cartList.isNotEmpty)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: Platform.isAndroid ? 85 : 100,

                      padding: EdgeInsets.only(
                        top: 25,
                        left: 12,
                        right: 12,
                        bottom: Platform.isAndroid ? 15 : 25,
                      ),

                      child: GetBuilder<CourseController>(
                        builder: (courseController) {
                          return Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => PaymentOptionsScreen(
                                              totalAmount: _totalPrice,
                                            ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.tertiaryColor,
                                    surfaceTintColor: AppColors.tertiaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          'Proceed to Checkout',
                                          style: const TextStyle(
                                            color: Color(0xFF071B1A),
                                            fontSize: 18,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
