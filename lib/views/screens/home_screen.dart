// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:skillsbank/constants/auth_user.dart';
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
  final ScrollController _categoryScrollController = ScrollController();

  int _currentIndex = 0;
  Timer? _autoPlayTimer;
  bool _isPaused = false;
  final Duration _slideDuration = const Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    // _timer = Timer.periodic(_slideDuration, (timer) {
    //   setState(() {
    //     _currentIndex = (_currentIndex + 1) % slides.length;
    //   });
    // });
    _startAutoPlay();

    _loadInitialData();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();

    _autoPlayTimer = Timer.periodic(_slideDuration, (_) {
      if (_isPaused) return;

      setState(() {
        _currentIndex = (_currentIndex + 1) % slides.length;
      });
    });
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
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
      asset: 'assets/images/banner_01.jpg',
      bgGradient: [Color(0xFF6DD3FF), AppColors.primaryColor],
    ),
    SlideData(
      title: "Your Security Matters",
      asset: 'assets/images/banner_02.jpg',
      bgGradient: [Color(0xFFFFB199), AppColors.secondaryColor],
    ),
    SlideData(
      title: "Paperless Onboarding",
      asset: 'assets/images/banner_03.png',
      bgGradient: [Color(0xFF70E1F5), AppColors.tertiaryColor],
    ),
    // SlideData(
    //   title: "Paperless Onboarding",
    //   asset: 'assets/images/banner_04.png',
    //   bgGradient: [Color(0xFF70E1F5), AppColors.primaryColor],
    // ),
    // SlideData(
    //   title: "Paperless Onboarding",
    //   asset: 'assets/images/banner_05.png',
    //   bgGradient: [Color(0xFF70E1F5), AppColors.primaryColor],
    // ),
  ];
  @override
  void dispose() {
    _stopAutoPlay();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppColors.secondaryColor,
      backgroundColor: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.transparent,

        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryColor,AppColors.primaryColor, AppColors.secondaryColor],
            ),
          ),
          child: Stack(
            children: [
              CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                slivers: [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight:
                        Platform.isAndroid
                            ? screenHeight / 2.1
                            : screenHeight / 2.4,
                    stretch: true,
                    pinned: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.zoomBackground],
                      background: GestureDetector(
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity == null) return;

                          // Swipe right → previous
                          if (details.primaryVelocity! > 0) {
                            setState(() {
                              _currentIndex =
                                  (_currentIndex - 1 + slides.length) %
                                  slides.length;
                            });
                          }
                          // Swipe left → next
                          else {
                            setState(() {
                              _currentIndex =
                                  (_currentIndex + 1) % slides.length;
                            });
                          }
                        },

                        onLongPressStart: (_) {
                          _isPaused = true;
                        },

                        onLongPressEnd: (_) {
                          _isPaused = false;
                        },

                        child: Stack(
                          fit: StackFit.loose,
                          children: [
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 1200),
                              switchInCurve: Curves.easeIn,
                              switchOutCurve: Curves.easeOut,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                              child: SizedBox(
                                height: screenHeight / 2,
                                key: ValueKey(_currentIndex),
                                child: Image.asset(
                                  slides[_currentIndex].asset,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top:
                                  Platform.isAndroid
                                      ? MediaQuery.of(context).padding.top + 15
                                      : MediaQuery.of(context).padding.top,
                              left: 10,
                              right: 10,
                              child: appBrand(),
                            ),
                            Positioned(
                              // bottom: 0,
                              left: 0,
                              right: 0,
                              top: 150,
                              height: screenHeight / 2.8,
                              child: Container(
                                decoration: BoxDecoration(
                                  // color: Colors.red,
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      AppColors.primaryColor.withOpacity(0.1),
                                      AppColors.primaryColor.withOpacity(0.3),
                                      AppColors.primaryColor.withOpacity(0.6),
                                      AppColors.primaryColor.withOpacity(0.8),
                                      AppColors.primaryColor,
                                      AppColors.primaryColor,
                                    ],
                                    // stops: const [0.1, 1,1,1],
                                  ),
                                ),
                              ),
                            ),

                            // Back Button
                            Positioned(
                              top: screenHeight / 3,
                              left: 10,
                              right: 10,
                              child: Text(
                                "Hello, ${Auth().user!.name!.split(' ').first}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                ),
                              ),
                            ),
                            Positioned(
                              top: screenHeight / 2.8,
                              left: 10,
                              right: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Build Your Xkills".tr,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,

                                      children:
                                          slides.asMap().entries.map((entry) {
                                            int idx = entry.key;
                                            bool active = idx == _currentIndex;
                                            return AnimatedContainer(
                                              padding: EdgeInsets.all(0),
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 4,
                                                  ),
                                              width: active ? 20 : 8,
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color:
                                                    active
                                                        ? Colors.white
                                                        : Colors.white
                                                            .withOpacity(.3),
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            );
                                          }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: screenHeight / 2.4,
                              left: 10,
                              right: 10,
                              child: CustomSearch(
                                searchController: searchController,
                                onSearch: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Stack(
                      children: [
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            // color: Colors.red
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primaryColor,
                                AppColors.primaryColor.withOpacity(0.95),
                                AppColors.primaryColor.withOpacity(0.8),
                                AppColors.primaryColor.withOpacity(0.5),
                                AppColors.primaryColor.withOpacity(0.2),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.horizontal,
                                vertical: 5,
                              ),
                              child: Text(
                                'Browse Categories',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppPadding.horizontal,
                                vertical: 10,
                              ),
                              child: FutureBuilder(
                                future: categoryController.categoriesFuture,
                                builder: (context, asyncSnapshot) {
                                  if (asyncSnapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CategoryGridShimmer();
                                  } else if (asyncSnapshot.hasError) {
                                    return Center(
                                      child: Text(
                                        'Error: ${asyncSnapshot.error}',
                                      ),
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
                                        asyncSnapshot.data!.reversed.toList();

                                    return SizedBox(
                                      height: 200,
                                      child: LayoutBuilder(
                                        builder: (context, constraints) {
                                          final double gridHeight =
                                              constraints.maxHeight;
                                          final double gridWidth =
                                              MediaQuery.of(context).size.width;

                                          // spacing values (must match GridDelegate)
                                          const double mainSpacing = 10;
                                          const double crossSpacing = 10;

                                          // height of one card (2 rows)
                                          final double itemHeight =
                                              (gridHeight - mainSpacing) / 2;

                                          // width of one card (2 columns)
                                          final double itemWidth =
                                              (gridWidth - crossSpacing) / 7.2;

                                          final double childAspectRatio =
                                              itemWidth / itemHeight;

                                          return Stack(
                                            children: [
                                              GridView.builder(
                                                controller:
                                                    _categoryScrollController,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                padding:
                                                    const EdgeInsets.only(
                                                      right: 10,
                                                    ),
                                                itemCount: categories.length,
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                      crossAxisCount: 2,
                                                      mainAxisSpacing:
                                                          mainSpacing,
                                                      crossAxisSpacing:
                                                          crossSpacing,
                                                      childAspectRatio:
                                                          childAspectRatio,
                                                    ),
                                                itemBuilder: (
                                                  context,
                                                  index,
                                                ) {
                                                  final item =
                                                      categories[index];
                                                  return GridCategoryCard(
                                                    subtitle:
                                                        item.keywords ?? "",
                                                    title: item.title ?? "",
                                                    thumbnail:
                                                        item.thumbnail!,
                                                    isGolden: item.isGolden!,
                                                    onTap: () {
                                                      categoryController
                                                          .selectCategory(
                                                            item.id!,
                                                          );
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (_) =>
                                                                  CoursesScreen(),
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),

                                              // 👉 Animated scroll hint
                                              _ScrollHintArrow(
                                                controller:
                                                    _categoryScrollController,
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),

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
                                      builder:
                                          (context) => const CoursesScreen(),
                                    ),
                                  );
                                },
                                title: const Text(
                                  'Top Courses',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                                      child: Text(
                                        'Error: ${asyncSnapshot.error}',
                                      ),
                                    );
                                  } else if (asyncSnapshot.data == null ||
                                      asyncSnapshot.data!.isEmpty) {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'No course yet'.tr,
                                            style: TextStyle(
                                              color: Colors.white,
                                            ),
                                          ),
                                          SizedBox(height: Get.height / 10),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 8,
                                              backgroundColor: Colors.white
                                                  .withOpacity(.1),
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
                                    final List<Course> courses =
                                        asyncSnapshot.data!;

                                    return GridView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                      ],
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
}

class _ScrollHintArrow extends StatefulWidget {
  final ScrollController controller;
  const _ScrollHintArrow({required this.controller});

  @override
  State<_ScrollHintArrow> createState() => _ScrollHintArrowState();
}

class _ScrollHintArrowState extends State<_ScrollHintArrow>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _slideAnimation = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _scrollRight() {
    widget.controller.animateTo(
      widget.controller.offset + 250,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 8,
      top: 0,
      bottom: 0,
      child: Center(
        child: GestureDetector(
          onTap: _scrollRight,
          child: AnimatedBuilder(
            animation: _slideAnimation,
            builder: (_, __) {
              return Transform.translate(
                offset: Offset(_slideAnimation.value, 0),
                child: LiquidGlassLayer(
                  settings: LiquidGlassSettings(
                    thickness: 10,
                    blur: 1,
                    glassColor: const Color.fromARGB(99, 9, 72, 73),
                  ),
                  child: LiquidGlass(
                    shape: LiquidRoundedSuperellipse(borderRadius: 50),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Row(
                        children: const [
                          Text(
                            "Scroll",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 12,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class SlideData {
  final String title;
  final String asset;
  final List<Color> bgGradient;
  const SlideData({
    required this.title,
    required this.asset,
    required this.bgGradient,
  });
}
