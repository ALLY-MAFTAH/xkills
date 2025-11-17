import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final courseController = Get.put(CourseController());

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    courseController.coursesFuture = courseController.getCourses();
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    await Future.wait([courseController.coursesFuture!]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double topPadding =
        Platform.isAndroid ? statusBarHeight + 15 : statusBarHeight;

    return RefreshIndicator(
      onRefresh: _refreshData,
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
                    expandedHeight: 70.0,
                    collapsedHeight: 0.0,
                    toolbarHeight: 0.0,
                    floating: true,
                    pinned: false,
                    backgroundColor: Colors.transparent,
                    automaticallyImplyLeading: false,
                    flexibleSpace:
                        Container(), // Empty container to satisfy the requirement
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Courses",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),

                          const SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                  fromInstructorsScreen: false,
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
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
              Positioned(top: topPadding, left: 0, right: 0, child: appBrand()),
            ],
          ),
        ),
      ),
    );
  }
}
