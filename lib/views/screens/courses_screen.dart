import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/category_controller.dart';
import '/components/grid_course_card.dart';
import '/components/shimmer_widgets/course_grid_shimmer.dart';
import '/constants/app_brand.dart';
import '/controllers/course_controller.dart';
import '/models/course.dart';
import '/theme/app_colors.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => CoursesScreenState();
}

class CoursesScreenState extends State<CoursesScreen> {
  final courseController = Get.find<CourseController>();
  final categoryController = Get.find<CategoryController>();
  String categoryTitle = 'All ';

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    if (categoryController.selectedCategory != null) {
      categoryTitle = "${categoryController.selectedCategory!.title!} ";
      courseController.coursesFuture = courseController.getCoursesByCategory(
        categoryController.selectedCategory!.id!,
      );
    } else {
      courseController.coursesFuture = courseController.getCourses();
    }
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    await Future.wait([courseController.coursesFuture!]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isGolden =
        categoryController.selectedCategory?.isGolden ?? false;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // 🌟 THE INSTANT BACKGROUND
          Positioned.fill(
            child:
                isGolden
                    ? Image.asset(
                      "assets/images/golden_background.jpg",
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.low,

                      gaplessPlayback: true,
                    )
                    : Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondaryColor,
                            AppColors.primaryColor,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
          ),

          // 🌟 CONTENT
          RefreshIndicator(
            onRefresh: _refreshData,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                const SliverAppBar(
                  expandedHeight: 70,
                  collapsedHeight: 0,
                  toolbarHeight: 0,
                  floating: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$categoryTitle Courses",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: FutureBuilder<List<Course>>(
                      future: courseController.coursesFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CourseShimmerGrid();
                        }
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: Get.height / 4),
                            child: Center(
                              child: Text(
                                "No Course".tr,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        }
                        final courses = snapshot.data!;
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: courses.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: .66,
                              ),
                          itemBuilder:
                              (context, index) => GridCourseCard(
                                thisCourse: courses[index],
                                fromInstructorsScreen: true,
                              ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          appBrand(context: context, hasBackButton: true),
        ],
      ),
    );
  }
}
