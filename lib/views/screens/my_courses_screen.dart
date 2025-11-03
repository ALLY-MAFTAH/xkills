import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillsbank/views/screens/course_details_screen.dart';
import '/views/screens/courses_screen.dart';
import '../../models/my_course.dart';
import '/components/shimmer_widgets/cart_items_shimmer.dart';
import '../../components/custom_loader.dart';
import '../../constants/app_brand.dart';
import '../../controllers/course_controller.dart';
import '../../theme/app_colors.dart';

class MyCoursesScreen extends StatefulWidget {
  const MyCoursesScreen({super.key});

  @override
  State<MyCoursesScreen> createState() => _MyCoursesScreenState();
}

class _MyCoursesScreenState extends State<MyCoursesScreen> {
  final courseController = Get.put(CourseController());

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    courseController.myCoursesFuture = courseController.getMyCourses();
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    await Future.wait([courseController.myCoursesFuture!]);
    setState(() {});
  }

  Widget _buildMyCourseItem(MyCourse myCourse) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          // courseController.selectedCourse = myCourse;
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (_) => CourseDetailsScreen()),
          // );
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
                    myCourse.thumbnail!.isNotEmpty
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl: myCourse.thumbnail!,
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
                      myCourse.title!,
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
                      '${myCourse.shortDescription}',
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
                  SizedBox(height: myCourse.discountFlag! ? 8 : 25),
                  if (myCourse.isPaid! && myCourse.discountFlag!)
                    Text(
                      '${myCourse.price}', // Assuming originalPrice exists
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
                    myCourse.isPaid!
                        ? myCourse.discountFlag! &&
                                myCourse.discountedPrice != null
                            ? '\$${myCourse.discountedPrice}'
                            : '${myCourse.price}'
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

  Widget _buildEmptyMyCoursesContent(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.school_rounded, size: 80, color: Colors.white54),
            const SizedBox(height: 15),
            const Text(
              "You haven't purchased any course yet.",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CoursesScreen()),
                );
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
        return RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.secondaryColor,
          backgroundColor: Colors.white,
          child: Scaffold(
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

                      FutureBuilder<List<MyCourse>>(
                        future: courseController.myCoursesFuture,
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
                                    'Error loading my courses: ${snapshot.error}',
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }

                          final List<MyCourse> myCourses = snapshot.data ?? [];
                          final bool isEmpty = myCourses.isEmpty;

                          return SliverList(
                            delegate: SliverChildListDelegate([
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                child:
                                    isEmpty
                                        ? _buildEmptyMyCoursesContent(context)
                                        : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...myCourses.map(
                                              _buildMyCourseItem,
                                            ),
                                            const SizedBox(height: 20),
                                            Divider(
                                              color: Colors.white30,
                                              thickness: 1,
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
                      top:
                          Platform.isAndroid
                              ? topPadding + 45
                              : topPadding + 30,
                      left: 0,
                      right: 0,
                      child: const Center(
                        child: Text(
                          "My Courses",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
