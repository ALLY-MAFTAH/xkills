import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillsbank/components/slide_animations.dart';
import 'package:skillsbank/models/category.dart';
import '../../components/custom_search.dart';
import '../../controllers/category_controller.dart';
import '../../theme/app_metrices.dart';
import '/components/grid_course_card.dart';
import '/components/shimmer_widgets/course_grid_shimmer.dart';
import '/constants/app_brand.dart';
import '/controllers/course_controller.dart';
import '/models/course.dart';
import '/theme/app_colors.dart';

class CoursesScreen extends StatefulWidget {
  final Category? selectedCategory;
  const CoursesScreen({super.key,  this.selectedCategory});

  @override
  State<CoursesScreen> createState() => CoursesScreenState();
}

class CoursesScreenState extends State<CoursesScreen> {
  final TextEditingController searchController = TextEditingController();

  final courseController = Get.find<CourseController>();
  final categoryController = Get.find<CategoryController>();

  String categoryTitle = 'All ';
  String selectedCourseLevel = 'All'.tr;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    if (widget.selectedCategory != null) {
      categoryTitle = "${widget.selectedCategory!.title!} ";
      courseController.allCoursesFuture = courseController.getCoursesByCategory(
        widget.selectedCategory!.id!,
      );
    } else {
      courseController.allCoursesFuture = courseController.getAllCourses();
    }
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    await Future.wait([courseController.allCoursesFuture!]);
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
            widget.selectedCategory!=null&&widget.selectedCategory!.isGolden!
                ? Transform.rotate(
                  angle: pi, // 90 degrees in radians
                  child: Image.asset(
                    'assets/images/golden_background.jpg',
                    fit: BoxFit.fill,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                )
                :
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
                      "$categoryTitle Courses".tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    CustomSearch(
                      searchController: searchController,
                      onSearch: () {},
                    ),

                    const SizedBox(height: 20),

                    /// 🔽 COURSES + LEVEL FILTER
                    FutureBuilder<List<Course>>(
                      future: courseController.allCoursesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CourseShimmerGrid();
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: Get.height / 4),
                            child: const Center(
                              child: Text(
                                "No Course",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }

                        final allCourses = snapshot.data!;

                        /// 🔹 Extract unique levels
                        final List<String> orderedLevels = [
                          "beginner",
                          "intermediate",
                          "advanced",
                        ];

                        final Set<String> availableLevels =
                            allCourses
                                .map((c) => c.level)
                                .whereType<String>()
                                .toSet();

                        final List<String> levels =
                            orderedLevels
                                .where(
                                  (level) =>
                                      level == "All".tr ||
                                      availableLevels.contains(level),
                                )
                                .toList();

                        /// 🔹 Filter courses by selected level
                        final List<Course> filteredCourses =
                            selectedCourseLevel == 'All'.tr
                                ? allCourses
                                : allCourses
                                    .where(
                                      (course) =>
                                          course.level == selectedCourseLevel,
                                    )
                                    .toList();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Wrap(
                              runSpacing: 10,
                              spacing: 10,
                              children: [
                                _levelChip(
                                  label: 'All'.tr,
                                  selected: selectedCourseLevel == 'All'.tr,
                                  onTap: () {
                                    setState(() {
                                      selectedCourseLevel = 'All'.tr;
                                    });
                                  },
                                ),

                                ...levels.map(
                                  (level) => _levelChip(
                                    label: level.tr,
                                    selected: selectedCourseLevel == level,
                                    onTap: () {
                                      setState(() {
                                        selectedCourseLevel = level;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredCourses.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: .85,
                                  ),
                              itemBuilder: (context, index) {
                                return GridCourseCard(
                                  thisCourse: filteredCourses[index],
                                  isGolden:
                                      widget.selectedCategory !=
                                              null
                                          ? widget
                                              .selectedCategory!
                                              .isGolden!
                                          : false,
                                );
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

  /// 🟡 Reusable level chip
  Widget _levelChip({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return LeftRightSlide(
      child: Container(
        height: 30,
        // width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient:
              selected
                  ? LinearGradient(
                    colors:
                       widget.selectedCategory!=null&& widget.selectedCategory!.isGolden!
                            ? [
                              AppColors.goldenColor,
                              AppColors.goldenColor.withOpacity(.2),
                            ]
                            : [AppColors.brainColor, AppColors.primaryColor],
                  )
                  : null,
        ),
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            side: BorderSide(
              color:
                 widget.selectedCategory!=null&& widget.selectedCategory!.isGolden!
                      ? AppColors.goldenColor
                      : Colors.grey,
              width: 0.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            GetUtils.capitalize(label)!,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ),
    );
  }
}
