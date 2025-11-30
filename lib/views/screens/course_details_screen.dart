import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '../../models/lesson.dart';
import '/components/toasts.dart';
import '../../components/no_video_url.dart';
import '../../components/shimmer_widgets/section_list_shimmer.dart';
import '../../controllers/course_controller.dart';
import '../../components/custom_loader.dart';
import '../../controllers/section_controller.dart';
import '../../includes/course_details_includes.dart';
import '../../models/course.dart';
import '../../models/section.dart';
import '../../theme/app_colors.dart';
import '../../utils/time_conversion.dart';
import '../../utils/video_player_utils.dart';
import 'cart_screen.dart';
import 'payment_options_screen.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final courseController = Get.put(CourseController());
  final sectionController = Get.put(SectionController());

  Course thisCourse = Course();
  bool _isNavigatingPreview = false;
  AsyncSnapshot<List<Section>> snapshot = AsyncSnapshot.withData(
    ConnectionState.none,
    [],
  );
  bool hasEnrolled = false;

  @override
  void initState() {
    thisCourse = courseController.selectedCourse;
    sectionController.sectionsFuture = sectionController.getSections(
      thisCourse.id!,
    );
    courseController.cartListFuture = courseController.getCartList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Set system UI style to have white status bar icons
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.95, -0.32),
            end: Alignment(0.95, 0.32),
            colors: [AppColors.secondaryColor, AppColors.primaryColor],
            stops: const [0.1093, 0.6261],
          ),
        ),
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight:
                      Platform.isAndroid
                          ? screenHeight / 2.4
                          : screenHeight / 2.8,
                  stretch: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.zoomBackground],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        thisCourse.thumbnail!.isNotEmpty
                            ? CachedNetworkImage(
                              imageUrl: thisCourse.thumbnail!,
                              height: screenHeight / 4,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => customLoader(),
                              errorWidget:
                                  (context, url, error) =>
                                      const Icon(Icons.error),
                            )
                            : Icon(
                              Icons.image,
                              size: Get.width,
                              color: Colors.grey,
                            ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: screenHeight * 0.4,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  AppColors.primaryColor.withOpacity(0.2),
                                  AppColors.primaryColor.withOpacity(0.5),
                                  AppColors.primaryColor.withOpacity(0.8),
                                  AppColors.primaryColor.withOpacity(0.95),
                                  AppColors.primaryColor,
                                ],
                                stops: const [0.0, 0.2, 0.4, 0.65, 0.85, 1.0],
                              ),
                            ),
                          ),
                        ),

                        // Back Button
                        Positioned(
                          top:
                              Platform.isAndroid
                                  ? MediaQuery.of(context).padding.top + 15
                                  : MediaQuery.of(context).padding.top,
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
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        if (!thisCourse.isPaid!)
                          Positioned(
                            top:
                                Platform.isAndroid
                                    ? MediaQuery.of(context).padding.top + 15
                                    : MediaQuery.of(context).padding.top,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: AppColors.primaryColor,
                              ),
                              child: Text(
                                "Free",
                                style: TextStyle(
                                  color: AppColors.tertiaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top: screenHeight / 3,
                          left: 10,
                          right: 10,
                          child: SizedBox(
                            height: 52,
                            width: Get.width,
                            child: ElevatedButton(
                              onPressed:
                                  _isNavigatingPreview
                                      ? null
                                      : () async {
                                        // Set loading state immediately
                                        setState(() {
                                          _isNavigatingPreview = true;
                                        });

                                        try {
                                          if (thisCourse.preview != null &&
                                              thisCourse.id != null) {
                                            // Make the navigation call asynchronous
                                            await navigateToVideoPlayer(
                                              context: context,
                                              videoUrl: thisCourse.preview!,
                                              courseId: thisCourse.id!,
                                              lessonId: null,
                                            );
                                          } else {
                                            await Navigator.push(
                                              // Await all navigation for consistent loading
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => NoVideoUrl(),
                                              ),
                                            );
                                            print("Preview URL is null");
                                          }
                                        } finally {
                                          if (mounted) {
                                            setState(() {
                                              _isNavigatingPreview = false;
                                            });
                                          }
                                        }
                                      },
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Container(
                                width: Get.width,
                                height: 52,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      HexColor("#072424").withOpacity(0.95),
                                      HexColor("#084A4F").withOpacity(0.95),
                                    ],
                                    stops: const [0.1321, 0.9359],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (_isNavigatingPreview) // ⭐️ Show loader if navigating
                                      SizedBox(
                                        width: 26,
                                        height: 26,
                                        child: customLoader(),
                                      )
                                    else // ⭐️ Otherwise, show play icon
                                      SizedBox(
                                        width: 26,
                                        height: 26,
                                        child: const Icon(
                                          Icons.play_arrow_rounded,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      _isNavigatingPreview
                                          ? 'Loading...'
                                          : 'Watch Course Preview', // ⭐️ Update text
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                        letterSpacing: 0.32,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.primaryColor),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...buildCourseSection(context, thisCourse),
                          FutureBuilder(
                            future: sectionController.sectionsFuture,
                            builder: (context, asyncSnapshot) {
                              snapshot = asyncSnapshot;

                              if (asyncSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Lessons in This Course',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        // Dynamic Shimmer Box for count/duration text
                                        Shimmer.fromColors(
                                          baseColor: Colors.white.withOpacity(
                                            0.1,
                                          ),
                                          highlightColor: Colors.white
                                              .withOpacity(0.05),
                                          child: Container(
                                            height: 12,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    // Continue with Shimmer for the list of sections
                                    const SectionListShimmer(),
                                  ],
                                );
                              } else if (asyncSnapshot.hasError) {
                                return Center(
                                  child: Text(
                                    'Error: ${asyncSnapshot.error}',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              } else if (asyncSnapshot.data == null ||
                                  asyncSnapshot.data!.isEmpty) {
                                return Center(
                                  child: Text(
                                    'No section yet',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                );
                              } else {
                                final List<Section> sections =
                                    asyncSnapshot.data!;
                                int totalLessons = sections.fold(
                                  0,
                                  (sum, section) =>
                                      sum + section.lessons!.length,
                                );
                                int totalSeconds = sections.fold(0, (
                                  sum,
                                  section,
                                ) {
                                  String durationString =
                                      section.totalDuration ?? '00:00:00';
                                  return sum +
                                      durationToSeconds(durationString);
                                });
                                String displayDurationString;
                                if (totalSeconds < 3600) {
                                  // Less than an hour: show M minutes and S seconds
                                  int minutes = totalSeconds ~/ 60;
                                  int seconds = totalSeconds % 60;
                                  if (minutes > 0) {
                                    displayDurationString =
                                        '${minutes}m ${seconds}s';
                                  } else {
                                    displayDurationString = '${seconds}s';
                                  }
                                } else {
                                  // More than an hour: show H hours and M minutes
                                  int hours = totalSeconds ~/ 3600;
                                  int remainingMinutes =
                                      (totalSeconds % 3600) ~/ 60;
                                  displayDurationString =
                                      '${hours}h ${remainingMinutes}m';
                                }
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          'Lessons in This Course',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          '$totalLessons Lessons ($displayDurationString)',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white.withOpacity(1),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    if (sections.length == 1)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children:
                                            sections.first.lessons!.map((
                                              lesson,
                                            ) {
                                              final lessonGradient =
                                                  getLessonGradient(lesson);
                                              return buildLessonItem(
                                                context,
                                                lesson.title!,
                                                lesson.duration!,
                                                lesson.userValidity!,
                                                true,
                                                lessonGradient,
                                                screenWidth,
                                                () {
                                                  if (courseController.myCourses
                                                      .any(
                                                        (myCourse) =>
                                                            myCourse.id ==
                                                            thisCourse.id,
                                                      )) {
                                                    if (lesson.videoUrl !=
                                                            null &&
                                                        lesson.id != null) {
                                                      navigateToVideoPlayer(
                                                        context: context,
                                                        videoUrl:
                                                            lesson.videoUrl!,
                                                        courseId:
                                                            thisCourse.id!,
                                                        lessonId: lesson.id!,
                                                      );
                                                    } else {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (context) =>
                                                                  NoVideoUrl(),
                                                        ),
                                                      );
                                                      print(
                                                        "Lesson video URL is null",
                                                      );
                                                    }
                                                  } else {
                                                    openConfirmEnrollDialog(
                                                      "Play",
                                                      lesson,
                                                    );
                                                  }
                                                },
                                                () {
                                                  if (courseController.myCourses
                                                      .any(
                                                        (myCourse) =>
                                                            myCourse.id ==
                                                            thisCourse.id,
                                                      )) {
                                                    print("Download course");
                                                  } else {
                                                    openConfirmEnrollDialog(
                                                      "Download",
                                                      lesson,
                                                    );
                                                  }
                                                },
                                                () => print(
                                                  "Lesson ${lesson.title} unlocked",
                                                ),
                                              );
                                            }).toList(),
                                      )
                                    else
                                      Column(
                                        children:
                                            sections.map((section) {
                                              return Theme(
                                                data: Theme.of(
                                                  context,
                                                ).copyWith(
                                                  dividerColor: AppColors
                                                      .secondaryColor
                                                      .withOpacity(.5),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        bottom: 5,
                                                      ),
                                                  child: ExpansionTile(
                                                    iconColor: Colors.white,
                                                    collapsedIconColor:
                                                        Colors.white,
                                                    tilePadding:
                                                        EdgeInsets.symmetric(
                                                          horizontal: 5,
                                                        ),
                                                    title: buildSectionHeader(
                                                      "${(sections.indexOf(section) + 1).toString()}. ${section.title!}",
                                                    ),
                                                    collapsedBackgroundColor:
                                                        AppColors.secondaryColor
                                                            .withOpacity(.2),
                                                    backgroundColor: AppColors
                                                        .secondaryColor
                                                        .withOpacity(.3),
                                                    collapsedShape:
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                    childrenPadding:
                                                        EdgeInsets.all(5),
                                                    children:
                                                        section.lessons!.map((
                                                          lesson,
                                                        ) {
                                                          final lessonGradient =
                                                              getLessonGradient(
                                                                lesson,
                                                              );

                                                          return buildLessonItem(
                                                            context,
                                                            lesson.title!,
                                                            lesson.duration!,
                                                            lesson
                                                                .userValidity!,
                                                            false,
                                                            lessonGradient,
                                                            screenWidth,
                                                            () {
                                                              if (courseController
                                                                  .myCourses
                                                                  .any(
                                                                    (
                                                                      myCourse,
                                                                    ) =>
                                                                        myCourse
                                                                            .id ==
                                                                        thisCourse
                                                                            .id,
                                                                  )) {
                                                                if (lesson.videoUrl !=
                                                                        null &&
                                                                    lesson.id !=
                                                                        null) {
                                                                  navigateToVideoPlayer(
                                                                    context:
                                                                        context,
                                                                    videoUrl:
                                                                        lesson
                                                                            .videoUrl!,
                                                                    courseId:
                                                                        thisCourse
                                                                            .id!,
                                                                    lessonId:
                                                                        lesson
                                                                            .id!,
                                                                  );
                                                                } else {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder:
                                                                          (
                                                                            context,
                                                                          ) =>
                                                                              NoVideoUrl(),
                                                                    ),
                                                                  );
                                                                  print(
                                                                    "Lesson video URL is null",
                                                                  );
                                                                }
                                                              } else {
                                                                openConfirmEnrollDialog(
                                                                  "Play",
                                                                  lesson,
                                                                );
                                                              }
                                                            },
                                                            () {
                                                              if (courseController
                                                                  .myCourses
                                                                  .any(
                                                                    (
                                                                      myCourse,
                                                                    ) =>
                                                                        myCourse
                                                                            .id ==
                                                                        thisCourse
                                                                            .id,
                                                                  )) {
                                                                print(
                                                                  "Download course",
                                                                );
                                                              } else {
                                                                openConfirmEnrollDialog(
                                                                  "Download",
                                                                  lesson,
                                                                );
                                                              }
                                                            },
                                                            () => print(
                                                              "Lesson ${lesson.title} unlocked",
                                                            ),
                                                          );
                                                        }).toList(),
                                                  ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                  ],
                                );
                              }
                            },
                          ),
                          SizedBox(height: thisCourse.isPaid! ? 85 : 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            FutureBuilder(
              future: courseController.cartListFuture,
              builder: (context, cartSnapshot) {
                if (cartSnapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                } else if (!thisCourse.isPaid!) {
                  return Container();
                } else {
                  return GetBuilder<CourseController>(
                    builder: (courseController) {
                      return buildBuyButton(
                        thisCourse,
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => PaymentOptionsScreen(
                                  courseIds: [thisCourse.id!],
                                  totalAmount: double.parse(
                                    thisCourse.discountedPrice.toString(),
                                  ),
                                ),
                          ),
                        ),
                        () {
                          if (!courseController.isLoading) {
                            courseController
                                .addOrRemoveCart(thisCourse.id!)
                                .then((status) {
                                  if (status == "added") {
                                    successToast("Course added to cart".tr);
                                  } else if (status == "removed") {
                                    successToast("Course removed from cart".tr);
                                  }
                                });
                          }
                        },
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CartScreen()),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  openConfirmEnrollDialog(String playOrDownload, Lesson lesson) async {
    final confirm = await showDialog<bool>(
      context: context,
      barrierDismissible: !courseController.isLoading,
      builder:
          (BuildContext dialogContext) => GetBuilder<CourseController>(
            builder: (courseController) {
              return AlertDialog(
                backgroundColor: Colors.grey,
                title: Text(
                  'Confirm Enroll',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: AppColors.secondaryColor,
                  ),
                ),
                content: Text(
                  playOrDownload == "Play"
                      ? 'By playing this lesson you confirm enrollment to this course'
                      : 'By downloading this lesson you confirm enrollment to this course',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryColor,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: AppColors.tertiaryColor,
                      backgroundColor: AppColors.tertiaryColor,
                    ),
                    onPressed:
                        courseController.isLoading
                            ? null
                            : () => Navigator.pop(dialogContext, false),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: AppColors.secondaryColor,
                      backgroundColor: AppColors.secondaryColor,
                    ),
                    onPressed:
                        courseController.isLoading
                            ? null
                            : () async {
                              if (thisCourse.isPaid!) {
                                // CALL PAID ENROLL
                                hasEnrolled = await courseController
                                    .freeCourseEnroll(thisCourse.id!);
                              } else {
                                hasEnrolled = await courseController
                                    .freeCourseEnroll(thisCourse.id!);
                              }
                              Navigator.pop(dialogContext, true);
                            },
                    child:
                        courseController.isLoading
                            ? customLoader(color: Colors.white)
                            : Text(
                              'Enroll',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ],
              );
            },
          ),
    );
    if (confirm == true) {
      if (hasEnrolled) {
        if (playOrDownload == "Play") {
          print("Playyyyyy ::::::");

          if (lesson.videoUrl != null && lesson.id != null) {
            navigateToVideoPlayer(
              context: context,
              videoUrl: lesson.videoUrl!,
              courseId: thisCourse.id!,
              lessonId: lesson.id!,
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoVideoUrl()),
            );
            print("Lesson video URL is null");
          }
        } else {
          print("Download ::::::");
        }
      } else {
        errorToast("Failed to enroll, please try again");
      }
      setState(() {});
    }
  }
}
