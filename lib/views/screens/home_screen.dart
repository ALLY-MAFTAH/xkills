// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillsbank/theme/app_padding.dart';
import '../../components/slide_card.dart';
import '/components/grid_course_card.dart';
import '/theme/app_colors.dart';
import '/views/screens/courses_screen.dart';
import '../../components/custom_search.dart';
import '../../components/grid_category_card.dart';
import '../../components/shimmer_widgets/category_grid_shimmer.dart';
import '../../components/shimmer_widgets/course_grid_shimmer.dart';
import '../../constants/app_brand.dart';
import '../../controllers/category_controller.dart';
import '../../controllers/course_controller.dart';
import '../../models/category.dart';
import '../../models/course.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  final categoryController = Get.put(CategoryController());
  final courseController = Get.put(CourseController());
  int _currentIndex = 0;
  late AnimationController _particlesController;

  @override
  void initState() {
    super.initState();
    _particlesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
    _loadInitialData();
  }

  void _loadInitialData() {
    categoryController.categoriesFuture = categoryController.getCategories();
    courseController.coursesFuture = courseController.getCourses();
    courseController.myCoursesFuture = courseController.getMyCourses();
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    await Future.wait([
      categoryController.categoriesFuture!,
      courseController.coursesFuture!,
      courseController.myCoursesFuture!,
    ]);
    setState(() {});
  }

  final List<SlideData> slides = [
    SlideData(
      title: "Soft Paperless Bank",
      subtitle: "Smart • Modern • Digital Banking",
      asset: 'assets/images/slide_01.jpg',
      bgGradient: [Color(0xFF6DD3FF), AppColors.primaryColor],
    ),
    SlideData(
      title: "Your Security Matters",
      subtitle:
          "Bank-grade encryption protects your identity, documents and transactions.",
      asset: 'assets/images/slide_02.png',
      bgGradient: [Color(0xFFFFB199), AppColors.secondaryColor],
    ),
    SlideData(
      title: "Paperless Onboarding",
      subtitle:
          "Open and verify your account digitally — fast, secure & no paperwork.",
      asset: 'assets/images/slide_03.png',
      bgGradient: [Color(0xFF70E1F5), AppColors.tertiaryColor],
    ),
    SlideData(
      title: "Paperless Onboarding",
      subtitle:
          "Open and verify your account digitally — fast, secure & no paperwork.",
      asset: 'assets/images/slide_04.jpg',
      bgGradient: [Color(0xFF70E1F5), AppColors.primaryColor],
    ),
  ];
  @override
  void dispose() {
    _particlesController.dispose();
    super.dispose();
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
                padding: EdgeInsets.all(0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Platform.isAndroid ? 80 : 100),
                    CarouselSlider.builder(
                          itemCount: slides.length,
                          itemBuilder: (context, index, realIndex) {
                            final s = slides[index];
                        
                            return AnimatedBuilder(
                              animation: _particlesController,
                              builder: (context, child) {
                                final progress =
                                    (_particlesController.value +
                                        index / slides.length) %
                                    1.0;
                                return Transform.translate(
                                  offset: Offset(
                                    sin(progress * 2 * pi) * 6,
                                    0,
                                  ),
                                  child: child,
                                );
                              },
                              // Child must be a simple widget inside Expanded
                              child: SlideCard(slide: s),
                            );
                          },
                          options: CarouselOptions(
                            padEnds: false,
                            viewportFraction: 1,
                            enlargeCenterPage: true,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 8),
                            autoPlayAnimationDuration: Duration(seconds: 2),
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentIndex = index;
                              });
                            },
                          ),
                        ),
                    
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                                slides.asMap().entries.map((entry) {
                                  int idx = entry.key;
                                  bool active = idx == _currentIndex;
                                  return AnimatedContainer(
                                    padding: EdgeInsets.all(0),
                                    duration: const Duration(
                                      milliseconds: 300,
                                    ),
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    width: active ? 20 : 8,
                                    height: 8,
                                    decoration: BoxDecoration(
                                      color:
                                          active
                                              ? const Color.fromARGB(
                                                255,
                                                11,
                                                236,
                                                127,
                                              )
                                              : Colors.white.withOpacity(.3),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  );
                                }).toList(),
                          ),
                        ),
                     
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.horizontal,
                      ),
                      child: CustomSearch(
                        searchController: searchController,
                        onSearch: () {},
                      ),
                    ),

                    // Category Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.horizontal,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 1,
                        ),

                        title: const Text(
                          'Choose Category',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.horizontal,
                      ),
                      child: FutureBuilder(
                        future: categoryController.categoriesFuture,
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CategoryGridShimmer();
                          } else if (asyncSnapshot.hasError) {
                            return Center(
                              child: Text('Error: ${asyncSnapshot.error}'),
                            );
                          } else if (asyncSnapshot.data == null ||
                              asyncSnapshot.data!.isEmpty) {
                            return Center(
                              child: Text(
                                'No category yet',
                                style: TextStyle(color: Colors.white),
                              ),
                            );
                          } else {
                            final List<Category> categories =
                                asyncSnapshot.data!;

                            return GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 20),
                              itemCount: categories.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 7,
                                    mainAxisSpacing: 7,
                                    childAspectRatio: 2,
                                  ),
                              itemBuilder: (context, index) {
                                final item = categories[index];
                                return GridCategoryCard(
                                  subtitle: item.keywords ?? "",
                                  title: item.title ?? "",
                                  thumbnail: item.thumbnail!,
                                  isGolden: item.isGolden!,
                                  onTap:
                                      () => {
                                        categoryController.selectCategory(
                                          item.id!,
                                        ),
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => CoursesScreen(),
                                          ),
                                        ),
                                      },
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),

                    Divider(color: Colors.grey[700], endIndent: 10, indent: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.horizontal,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 1,
                        ),
                        onTap: () {
                          categoryController.selectCategory(0);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CoursesScreen(),
                            ),
                          );
                        },
                        title: const Text(
                          'Top Courses',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                        ),
                        minTileHeight: 30,
                      ),
                    ),

                    // --- COURSES FUTUREBUILDER (UPDATED) ---
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppPadding.horizontal,
                      ),
                      child: FutureBuilder(
                        future: courseController.coursesFuture,
                        builder: (context, asyncSnapshot) {
                          if (asyncSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CourseShimmerGrid();
                          } else if (asyncSnapshot.hasError) {
                            return Center(
                              child: Text('Error: ${asyncSnapshot.error}'),
                            );
                          } else if (asyncSnapshot.data == null ||
                              asyncSnapshot.data!.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'No course yet'.tr,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  SizedBox(height: Get.height / 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 8,
                                      backgroundColor: Colors.white.withOpacity(
                                        .1,
                                      ),
                                    ),
                                    onPressed: () {
                                      _refreshData();
                                    },
                                    child: Text(
                                      "Reload",
                                      style: TextStyle(
                                        color: const Color(0xFFE6C068),
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ],
                              ),
                            );
                          } else {
                            final List<Course> courses = asyncSnapshot.data!;

                            return GridView.builder(
                              shrinkWrap: true,
                              primary: false,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 20,
                              ),
                              itemCount: courses.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: .66,
                                  ),
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                return GridCourseCard(
                                  thisCourse: course,
                                  fromInstructorsScreen: true,
                                );
                              },
                            );
                          }
                        },
                      ),
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
