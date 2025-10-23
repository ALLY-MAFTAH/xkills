import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skillsbank/models/course.dart';
import '../../components/from_network.dart';
import '../../components/from_vimeo_player.dart';
import '../../components/new_youtube_player.dart';
import '../../components/no_preview_video.dart';
import '../../controllers/course_controller.dart';

import '../../components/custom_loader.dart';
import '../../theme/app_colors.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen> {
  final courseController = Get.put(CourseController());
  Course thisCourse = Course();
  final GlobalKey _shareWidgetKey = GlobalKey();
  @override
  void initState() {
    thisCourse = courseController.selectedCourse;
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
                          top: MediaQuery.of(context).padding.top + 15,
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
                        Positioned(
                          top: screenHeight / 3,
                          left: 10,
                          right: 10,
                          child: SizedBox(
                            height: 52,
                            width: Get.width,
                            child: ElevatedButton(
                              onPressed: () {
                                if (thisCourse.preview != null) {
                                  final previewUrl = thisCourse.preview!;
                                  print(previewUrl);

                                  final isYouTube =
                                      previewUrl.contains("youtube.com") ||
                                      previewUrl.contains("youtu.be");
                                  final isVimeo = previewUrl.contains(
                                    "vimeo.com",
                                  );
                                  final isDrive = previewUrl.contains(
                                    "drive.google.com",
                                  );
                                  final isMp4 = RegExp(
                                    r"\.mp4(\?|$)",
                                  ).hasMatch(previewUrl);
                                  final isWebm = RegExp(
                                    r"\.webm(\?|$)",
                                  ).hasMatch(previewUrl);
                                  final isOgg = RegExp(
                                    r"\.ogg(\?|$)",
                                  ).hasMatch(previewUrl);

                                  if (isYouTube) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                YoutubeVideoPlayerFlutter(
                                                  courseId:
                                                      thisCourse.id!,
                                                  videoUrl: previewUrl,
                                                ),
                                      ),
                                    );
                                  } else if (isDrive) {
                                    final RegExp regExp = RegExp(r'[-\w]{25,}');
                                    final Match? match = regExp.firstMatch(
                                      thisCourse.preview.toString(),
                                    );
                                    // print(match);
                                    String url =
                                        'https://drive.google.com/uc?export=download&id=${match!.group(0)}';
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => PlayVideoFromNetwork(
                                              courseId: thisCourse.id!,
                                              videoUrl: url,
                                            ),
                                      ),
                                    );
                                  } else if (isVimeo) {
                                    String vimeoVideoId =
                                        thisCourse.preview!.split('/').last;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => FromVimeoPlayer(
                                              courseId: thisCourse.id!,
                                              vimeoVideoId: vimeoVideoId,
                                            ),
                                      ),
                                    );
                                  } else if (isMp4 || isOgg || isWebm) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => PlayVideoFromNetwork(
                                              courseId: thisCourse.id!,
                                              videoUrl: previewUrl,
                                            ),
                                      ),
                                    );
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => NoPreviewVideo(),
                                      ),
                                    );
                                  }
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NoPreviewVideo(),
                                    ),
                                  );
                                  print("Preview URL is null");
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
                                    Container(
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
                                      'Watch',
                                      style: TextStyle(
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
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(vertical: 10),
                            child: Text(
                              thisCourse.title ?? 'Unknown',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // Students Count
                          Text(
                            thisCourse.totalEnrollment != null
                                ? '${thisCourse.totalEnrollment} Students'
                                : 'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              color: Colors.white,
                              letterSpacing: 0.24,
                            ),
                          ),
                          SizedBox(height: 10),
                          Html(
                            data:
                                thisCourse.description ??
                                thisCourse.shortDescription ??
                                "",
                            style: {
                              "body": Style(
                                color: Colors.white.withOpacity(.7),
                                fontSize: FontSize(11),
                                fontWeight: FontWeight.bold,
                                margin: Margins.all(0),
                              ),
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () {
                                    print("Save button pressed");
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  label: Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.bookmark_border,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  key: _shareWidgetKey,
                                  onPressed: () {
                                    final RenderBox? box =
                                        _shareWidgetKey.currentContext
                                                ?.findRenderObject()
                                            as RenderBox?;

                                    Share.share(
                                      'Check out this course from Skillsbank: ${thisCourse.title}\nBy: ${thisCourse.instructorName}\n\n${thisCourse.shortDescription}\n\nLink: ${thisCourse.shareableLink}',
                                      sharePositionOrigin:
                                          box!.localToGlobal(Offset.zero) &
                                          box.size,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0),
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.share_outlined,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                  label: Text(
                                    'Share',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Divider(
                            color: HexColor('#094B50'),
                            height: 0,
                            thickness: 0,
                          ),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.grey.shade200,
                                child: ClipOval(
                                  child:
                                      thisCourse.instructorImage!.isNotEmpty
                                          ? CachedNetworkImage(
                                            imageUrl:
                                                thisCourse.instructorImage!,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder:
                                                (context, url) =>
                                                    customLoader(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          )
                                          : const Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      thisCourse.instructorName ?? 'Unknown',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      thisCourse.instructorProfile ?? "",
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Follow Button
                              ElevatedButton(
                                onPressed: () {
                                  print("Follow button pressed");
                                },
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(75, 30),
                                  backgroundColor: HexColor('#094B50'),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Follow',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 5),
                          Divider(
                            color: HexColor('#094B50'),
                            height: 0,
                            thickness: 0,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Lessons in This Class',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '9 Lessons (9h 28m)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(1),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          _buildLessonItem(
                            'Introduction',
                            '01:06',
                            true,
                            LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                HexColor('#22695B'),
                                HexColor('#00403D'),
                              ],
                              stops: const [0.0, 1.0],
                            ),
                            screenWidth,
                            () {
                              print("Introduction lesson pressed");
                            },
                          ),
                          _buildLessonItem(
                            'Startup',
                            '04:11',
                            false,
                            LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                HexColor('#094A4F'),
                                HexColor('#094A4F'),
                              ],
                              stops: const [0.0, 1.0],
                            ),
                            screenWidth,
                            () {
                              print("Startup lesson pressed");
                            },
                          ),
                          _buildLessonItem(
                            'Startup',
                            '04:11',
                            false,
                            LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                HexColor('#094A4F'),
                                HexColor('#094A4F'),
                              ],
                              stops: const [0.0, 1.0],
                            ),
                            screenWidth,
                            () {
                              print("Startup lesson pressed");
                            },
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Footer with Buy Button (Fixed at bottom)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.0998,
                decoration: BoxDecoration(
                  color: HexColor('#08484D').withOpacity(0.91),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: TextButton(
                  onPressed: () {
                    print("Buy button pressed");
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6C068),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: const Center(
                      child: Text(
                        'Buy Tsh 20,000 / \$8.08',
                        style: TextStyle(
                          color: Color(0xFF071B1A),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLessonItem(
    String title,
    String duration,
    bool hasDownloadIcon,
    Gradient gradient,
    double screenWidth,
    void Function()? onPressed,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(Get.width, 40),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Container(
          width: double.infinity,
          // height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.32,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  duration,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
              if (hasDownloadIcon)
                const Icon(
                  Icons.file_download_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              if (!hasDownloadIcon)
                const Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.tertiaryColor,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
