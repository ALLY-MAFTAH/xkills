import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_metrices.dart';
import '/components/grid_course_card.dart';
import '/components/shimmer_widgets/course_grid_shimmer.dart';
import '/constants/app_brand.dart';
import '/controllers/course_controller.dart';
import '/models/course.dart';
import '/theme/app_colors.dart';

class SavedCoursesScreen extends StatefulWidget {
  const SavedCoursesScreen({super.key});

  @override
  State<SavedCoursesScreen> createState() => SavedCoursesScreenState();
}

class SavedCoursesScreenState extends State<SavedCoursesScreen> {
  final courseController = Get.find<CourseController>();

  @override
  void initState() {
    super.initState();

    _loadInitialData();
  }

  void _loadInitialData() {
    courseController.savedCoursesFuture = courseController.getSavedCourses();
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    await Future.wait([courseController.savedCoursesFuture!]);
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
                      "Saved Courses".tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// 🔽 COURSES + LEVEL FILTER
                    FutureBuilder<List<Course>>(
                      future: courseController.savedCoursesFuture,
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
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }

                        final savedCourses = snapshot.data!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: savedCourses.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: .85,
                                  ),
                              itemBuilder: (context, index) {
                                return GridCourseCard(
                                  courseController: courseController,
                                  thisCourse: savedCourses[index],
                                  isGolden: false,
                                  reloadPage: () {
                                    _loadInitialData();
                                    setState(() {});
                                  },
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
}
