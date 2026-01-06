import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_metrices.dart';
import '/includes/ratings.dart';
import '/models/course.dart';
import '/views/screens/course_details_screen.dart';
import '/views/screens/courses_screen.dart';
import '/models/my_course.dart';
import '/components/shimmer_widgets/cart_items_shimmer.dart';
import '/components/custom_loader.dart';
import '/constants/app_brand.dart';
import '/controllers/course_controller.dart';
import '/theme/app_colors.dart';

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
    Course course = Course(
      id: myCourse.id,
      title: myCourse.title,
      slug: myCourse.slug,
      shortDescription: myCourse.shortDescription,
      userId: myCourse.userId,
      categoryId: myCourse.categoryId,
      courseType: myCourse.courseType,
      status: myCourse.status,
      level: myCourse.level,
      language: myCourse.language,
      isPaid: myCourse.isPaid,
      isBest: myCourse.isBest,
      discountedPrice: myCourse.discountedPrice,
      discountFlag: myCourse.discountFlag,
      enableDripContent: myCourse.enableDripContent,
      dripContentSettings: myCourse.dripContentSettings,
      metaKeywords: myCourse.metaKeywords,
      metaDescription: myCourse.metaDescription,
      thumbnail: myCourse.thumbnail,
      banner: myCourse.banner,
      preview: myCourse.preview,
      description: myCourse.description,
      requirements: myCourse.requirements,
      outcomes: myCourse.outcomes,
      faqs: myCourse.faqs,
      instructorIds: myCourse.instructorIds,
      averageRating: myCourse.averageRating,
      createdAt: myCourse.createdAt,
      updatedAt: myCourse.updatedAt,
      expiryPeriod: myCourse.expiryPeriod,
      instructors: myCourse.instructors,
      priceCart: myCourse.priceCart,
      instructorName: myCourse.instructorName,
      instructorProfile: myCourse.instructorProfile,
      instructorImage: myCourse.instructorImage,
      totalEnrollment: myCourse.totalEnrollment,
      shareableLink: myCourse.shareableLink,
      totalReviews: myCourse.totalReviews,
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CourseDetailsScreen(thisCourse: course,)),
          );
        },
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 90,
                          height: 90,
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
                                      placeholder:
                                          (context, url) => customLoader(),
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
                              SizedBox(height: 20),
                              Text(
                                myCourse.title!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              // Text(
                              //   "By ${myCourse.instructorName!}",
                              //   style: TextStyle(
                              //     color: AppColors.tertiaryColor,
                              //     fontSize: 12,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                              const SizedBox(height: 4),
                              Text(
                                '${myCourse.shortDescription}',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 224, 232, 236),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // 📚 Lessons Count
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                children: [
                                  // Value (White Color)
                                  TextSpan(
                                    text:
                                        "${myCourse.totalNumberOfLessons.toString()} ",
                                    style: const TextStyle(
                                      color:
                                          Colors.white, // Value color is White
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  // Label (Gray Color)
                                  TextSpan(
                                    text: " Total Lessons",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(
                                        .7,
                                      ), // Label color is Gray
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text.rich(
                              TextSpan(
                                children: [
                                  // Value (White Color)
                                  TextSpan(
                                    text:
                                        "${myCourse.totalDuration.toString()} ",
                                    style: const TextStyle(
                                      color:
                                          Colors.white, // Value color is White
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  // Label (Gray Color)
                                  TextSpan(
                                    text: " Total Duration",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(
                                        .7,
                                      ), // Label color is Gray
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        buildRatingStars(
                          myCourse.averageRating ?? 0.0,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              right: 0,
              top: 0,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 4,
                    width: 5,
                    child: CustomPaint(painter: TrianglePainter()),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 120, 105, 76),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            !myCourse.isPaid! ? "Purchased".tr : "Free".tr,
                            style: const TextStyle(
                              color: Color(0xFFE6C068),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
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
            Text(
              "You haven't enrolled to any course yet.".tr,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CoursesScreen(selectedCategory: null,)),
                );
              },
              child: Text(
                "Browse Courses".tr,
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
    return GetBuilder<CourseController>(
      builder: (courseController) {
        return RefreshIndicator(
          onRefresh: _refreshData,
          color: AppColors.secondaryColor,
          backgroundColor: Colors.white,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,

            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.secondaryColor,
                        AppColors.primaryColor,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppMetrices.horizontalPadding,
                      right: AppMetrices.horizontalPadding,
                      bottom: AppMetrices.verticalPadding + 25,
                      top: AppMetrices.verticalPadding,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: Platform.isAndroid ? 90 : 100),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "My Courses".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(height: 15),
                        FutureBuilder<List<MyCourse>>(
                          future: courseController.myCoursesFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
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
                              );
                            }

                            if (snapshot.hasError) {
                              return SizedBox(
                                height: 300,
                                child: Center(
                                  child: Text(
                                    'Error loading your courses: ${snapshot.error}',
                                    style: const TextStyle(
                                      color: Colors.redAccent,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final List<MyCourse> myCourses =
                                snapshot.data ?? [];
                            final bool isEmpty = myCourses.isEmpty;
                            return isEmpty
                                ? _buildEmptyMyCoursesContent(context)
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ...myCourses.map(_buildMyCourseItem),
                                    const SizedBox(height: 20),
                                  ],
                                );
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
      },
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint =
        Paint()
          ..color = Colors.grey
          ..strokeWidth = 2.0;
    Path path = Path();
    path.moveTo(0.0, size.height);
    path.lineTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
