import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import '/components/slide_animations.dart';
import 'package:vibration/vibration.dart';
import '../../components/players/network_player_dialog.dart';
import '../../components/players/youtube_player_dialog.dart';
import '../../components/shake_widget.dart';
import '/constants/app_brand.dart';
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
  final Course thisCourse;
  const CourseDetailsScreen({super.key, required this.thisCourse});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final courseController = Get.put(CourseController());
  final sectionController = Get.put(SectionController());
  bool _shakePayment = false;

  final bool _isNavigatingPreview = false;
  AsyncSnapshot<List<Section>> snapshot = AsyncSnapshot.withData(
    ConnectionState.none,
    [],
  );
  bool hasEnrolled = false;
  bool hasAccess = false;
  bool isSaved = false;
  bool showVideoPlayer = false;
  Widget? nextPage;
  @override
  void initState() {
    // thisCourse = courseController.selectedCourse;
    sectionController.sectionsFuture = sectionController.getSections(
      widget.thisCourse.id!,
    );
    courseController.cartListFuture = courseController.getCartList();
    courseController.savedCoursesFuture = courseController.getSavedCourses();
    isSaved = courseController.savedCourses.any(
      (course) => course.id == widget.thisCourse.id,
    );
    hasAccess = courseController.myCourses.any(
      (myCourse) => myCourse.id == widget.thisCourse.id,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
                          ? screenHeight / 2.9
                          : screenHeight / 3.8,
                  stretch: true,
                  pinned: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: const [StretchMode.zoomBackground],
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (!showVideoPlayer)
                          widget.thisCourse.thumbnail!.isNotEmpty
                              ? BottomTopSlide(
                                child: CachedNetworkImage(
                                  imageUrl: widget.thisCourse.thumbnail!,
                                  height: screenHeight / 4.4,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => customLoader(),
                                  errorWidget:
                                      (context, url, error) =>
                                          const Icon(Icons.error),
                                ),
                              )
                              : Icon(
                                Icons.image,
                                size: Get.width,
                                color: Colors.grey,
                              )
                        else
                          Align(
                            alignment: Alignment.topCenter,
                            child: TopBottomSlide(
                              child: ClipRRect(child: nextPage),
                            ),
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
                        if (!showVideoPlayer)
                          appBrand(
                            hasBackButton: true,
                            context: context,
                            showCartButton: false,
                          ),
                        if (!widget.thisCourse.isPaid!)
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
                                "Free".tr,
                                style: TextStyle(
                                  color: AppColors.tertiaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          top:Platform.isAndroid? screenHeight / 3.42:screenHeight / 3.85,
                          left: 10,
                          right: 10,
                          child: SizedBox(
                            height: 45,
                            width: Get.width,
                            child: ElevatedButton(
                              onPressed:
                                  _isNavigatingPreview
                                      ? null
                                      : () async {
                                        if (showVideoPlayer) {
                                          showVideoPlayer = false;
                                          setState(() {});
                                          return;
                                        }
                                        showVideoPlayer = true;
                                        setState(() {});
                                        String videoUrl =
                                            widget.thisCourse.preview ?? "";
                                        final courseId = widget.thisCourse.id!;

                                        // --- URL Type Checks ---
                                        final isYouTube =
                                            videoUrl.contains("youtube.com") ||
                                            videoUrl.contains("youtu.be");
                                        final isMp4 = RegExp(
                                          r"\.mp4(\?|$)",
                                        ).hasMatch(videoUrl);
                                        final isWebm = RegExp(
                                          r"\.webm(\?|$)",
                                        ).hasMatch(videoUrl);
                                        final isOgg = RegExp(
                                          r"\.ogg(\?|$)",
                                        ).hasMatch(videoUrl);
                                        final isMkv = RegExp(
                                          r"\.mkv(\?|$)",
                                        ).hasMatch(videoUrl);
                                        // -----------------------

                                        if (isYouTube) {
                                          nextPage = YoutubeVideoPlayerDialog(
                                            showControls: false,
                                            courseId: courseId,
                                            videoUrl: videoUrl,
                                          );
                                        } else if (isMp4 ||
                                            isOgg ||
                                            isWebm ||
                                            isMkv) {
                                          nextPage = NetworkVideoPlayerDialog(
                                            showControls: false,
                                            courseId: courseId,
                                            videoUrl: videoUrl,
                                          );
                                        } else {
                                          nextPage = Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                            ),
                                            child: SizedBox(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.7,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const Icon(
                                                      Icons
                                                          .videocam_off_rounded,
                                                      size: 80,
                                                      color: Colors.white54,
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Text(
                                                      "Video URL is not available."
                                                          .tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 20),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
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
                                height: 45,
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
                                        child: Icon(
                                          showVideoPlayer
                                              ? Icons.stop_rounded
                                              : Icons.play_arrow_rounded,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    const SizedBox(width: 10),
                                    Text(
                                      showVideoPlayer
                                          ? "Stop".tr
                                          : _isNavigatingPreview
                                          ? 'Loading....'.tr
                                          : 'Watch Course Preview'.tr,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
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
                          ...buildCourseSection(
                            context,
                            widget.thisCourse,
                            () {
                              isSaved = !isSaved;
                              setState(() {});
                              courseController.addOrRemoveSavedCourse(
                                widget.thisCourse.id!,
                              );
                            },
                            isSaved ? AppColors.goldenColor : Colors.white,
                            isSaved
                                ? Icons.bookmark_rounded
                                : Icons.bookmark_outline,
                          ),
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
                                        Text(
                                          'Lessons In This Course'.tr,
                                          style: TextStyle(
                                            fontSize: 12,
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
                                    'No Lessons Yet'.tr,
                                    style: TextStyle(color: Colors.white, fontSize: 12),
                                  ),
                                );
                              } else {
                                List<Section> sections = [];
                                sections = asyncSnapshot.data!;
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
                                        Text(
                                          '${'Lessons In This Course'.tr} ($totalLessons)',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.timer,
                                              size: 16,
                                              color: Colors.grey,
                                            ),
                                            Text(
                                              ' $displayDurationString',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white.withOpacity(
                                                  1,
                                                ),
                                              ),
                                            ),
                                          ],
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
                                                context: context,
                                                lessonId: lesson.id!,
                                                lessonTitle: lesson.title!,
                                                sectionName:
                                                    sections.first.title!,
                                                courseTitle:
                                                    widget.thisCourse.title!,
                                                duration: lesson.duration!,
                                                hasAccess: hasAccess,
                                                gradient: lessonGradient,
                                                screenWidth: screenWidth,
                                                onPlayPressed: () {
                                                  hasEnrolled = courseController
                                                      .myCourses
                                                      .any(
                                                        (myCourse) =>
                                                            myCourse.id ==
                                                            widget
                                                                .thisCourse
                                                                .id,
                                                      );
                                                  if (hasEnrolled) {
                                                    if (lesson.videoUrl !=
                                                            null &&
                                                        lesson.id != null) {
                                                      navigateToVideoPlayer(
                                                        context: context,
                                                        videoUrl:
                                                            lesson.videoUrl!,
                                                        courseId:
                                                            widget
                                                                .thisCourse
                                                                .id!,
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
                                                    }
                                                  } else if (widget
                                                      .thisCourse
                                                      .isPaid!) {
                                                    errorToast(
                                                      "This is a paid course. Please buy to access the lessons."
                                                          .tr,
                                                    );
                                                    Vibration.vibrate(
                                                      duration: 100,
                                                    );

                                                    setState(() {
                                                      _shakePayment = true;
                                                    });
                                                    Future.delayed(
                                                      const Duration(
                                                        milliseconds: 450,
                                                      ),
                                                      () {
                                                        if (mounted) {
                                                          setState(
                                                            () =>
                                                                _shakePayment =
                                                                    false,
                                                          );
                                                        }
                                                      },
                                                    );
                                                  } else {
                                                    openConfirmEnrollDialog(
                                                      "Play",
                                                      lesson,
                                                    );
                                                  }
                                                },
                                                downloadUrl: lesson.videoUrl!,
                                                unlockPressed: () {
                                                  errorToast(
                                                    "This is a paid course. Please buy to access the lessons."
                                                        .tr,
                                                  );
                                                  Vibration.vibrate(
                                                    duration: 100,
                                                  );

                                                  setState(() {
                                                    _shakePayment = true;
                                                  });
                                                  Future.delayed(
                                                    const Duration(
                                                      milliseconds: 450,
                                                    ),
                                                    () {
                                                      if (mounted) {
                                                        setState(
                                                          () =>
                                                              _shakePayment =
                                                                  false,
                                                        );
                                                      }
                                                    },
                                                  );
                                                },
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
                                                            context: context,
                                                            lessonId:
                                                                lesson.id!,
                                                            lessonTitle:
                                                                lesson.title!,
                                                            sectionName:
                                                                section.title!,
                                                            courseTitle:
                                                                widget
                                                                    .thisCourse
                                                                    .title!,
                                                            duration:
                                                                lesson
                                                                    .duration!,
                                                            hasAccess:
                                                                hasAccess,
                                                            gradient:
                                                                lessonGradient,
                                                            screenWidth:
                                                                screenWidth,
                                                            onPlayPressed: () {
                                                              hasEnrolled = courseController
                                                                  .myCourses
                                                                  .any(
                                                                    (
                                                                      myCourse,
                                                                    ) =>
                                                                        myCourse
                                                                            .id ==
                                                                        widget
                                                                            .thisCourse
                                                                            .id,
                                                                  );
                                                              if (hasEnrolled) {
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
                                                                        widget
                                                                            .thisCourse
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
                                                                }
                                                              } else if (widget
                                                                  .thisCourse
                                                                  .isPaid!) {
                                                                errorToast(
                                                                  "This is a paid course. Please buy to access the lessons."
                                                                      .tr,
                                                                );
                                                                Vibration.vibrate(
                                                                  duration: 100,
                                                                );

                                                                setState(() {
                                                                  _shakePayment =
                                                                      true;
                                                                });
                                                                Future.delayed(
                                                                  const Duration(
                                                                    milliseconds:
                                                                        450,
                                                                  ),
                                                                  () {
                                                                    if (mounted) {
                                                                      setState(
                                                                        () =>
                                                                            _shakePayment =
                                                                                false,
                                                                      );
                                                                    }
                                                                  },
                                                                );
                                                              } else {
                                                                openConfirmEnrollDialog(
                                                                  "Play",
                                                                  lesson,
                                                                );
                                                              }
                                                            },
                                                            downloadUrl:
                                                                lesson
                                                                    .videoUrl!,
                                                            unlockPressed: () {
                                                              errorToast(
                                                                "This is a paid course. Please buy to access the lessons."
                                                                    .tr,
                                                              );
                                                              Vibration.vibrate(
                                                                duration: 100,
                                                              );

                                                              setState(() {
                                                                _shakePayment =
                                                                    true;
                                                              });
                                                              Future.delayed(
                                                                const Duration(
                                                                  milliseconds:
                                                                      450,
                                                                ),
                                                                () {
                                                                  if (mounted) {
                                                                    setState(
                                                                      () =>
                                                                          _shakePayment =
                                                                              false,
                                                                    );
                                                                  }
                                                                },
                                                              );
                                                            },
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
                          SizedBox(height: widget.thisCourse.isPaid! ? 85 : 20),
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
                } else if (courseController.myCourses.any(
                  (myCourse) => myCourse.id == widget.thisCourse.id,
                )) {
                  return Container();
                } else if (!widget.thisCourse.isPaid!) {
                  return Container();
                } else {
                  return GetBuilder<CourseController>(
                    builder: (courseController) {
                      return Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: ShakeWidget(
                          shake: _shakePayment,
                          child: buildBuyButton(
                            widget.thisCourse,
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => PaymentOptionsScreen(
                                      courseIds: [widget.thisCourse.id!],
                                      totalAmount:
                                          widget.thisCourse.priceForPayment!,
                                    ),
                              ),
                            ),
                            () {
                              if (!courseController.isLoading) {
                                courseController
                                    .addOrRemoveCart(widget.thisCourse.id!)
                                    .then((status) {
                                      if (status == "added") {
                                        successToast("Course added to cart".tr);
                                      } else if (status == "removed") {
                                        successToast(
                                          "Course removed from cart".tr,
                                        );
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
                          ),
                        ),
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
                  'Confirm Enroll'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.secondaryColor,
                  ),
                ),
                content: Text(
                  playOrDownload == "Play"
                      ? 'By playing this lesson you confirm enrollment to this course'
                          .tr
                      : 'By downloading this lesson you confirm enrollment to this course'
                          .tr,
                  style: TextStyle(
                    color: AppColors.secondaryColor,
                    fontSize: 14,
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
                              if (widget.thisCourse.isPaid!) {
                                // CALL PAID ENROLL
                                hasEnrolled = await courseController
                                    .freeCourseEnroll(widget.thisCourse.id!);
                              } else {
                                hasEnrolled = await courseController
                                    .freeCourseEnroll(widget.thisCourse.id!);
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
          if (lesson.videoUrl != null && lesson.id != null) {
            navigateToVideoPlayer(
              context: context,
              videoUrl: lesson.videoUrl!,
              courseId: widget.thisCourse.id!,
              lessonId: lesson.id!,
            );
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NoVideoUrl()),
            );
          }
        } else {
          print("Download ::::::");
        }
      } else {
        errorToast("Failed to enroll, please try again".tr);
      }
      setState(() {});
    }
  }
}
