import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/app_brand.dart';
import '../../controllers/course_controller.dart';
import '../../theme/app_colors.dart';

class NoVideoUrl extends StatefulWidget {
  const NoVideoUrl({super.key});

  @override
  State<NoVideoUrl> createState() => _NoVideoUrlState();
}

class _NoVideoUrlState extends State<NoVideoUrl> {
  @override
  Widget build(BuildContext context) {
    // Determine status bar height for correct positioning
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final double topPadding =
        Platform.isAndroid ? statusBarHeight + 15 : statusBarHeight;

    return GetBuilder<CourseController>(
      builder: (courseController) {
        return Scaffold(
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
                      expandedHeight: 80.0,
                      collapsedHeight: 0.0,
                      toolbarHeight: 0.0,
                      floating: true,
                      pinned: false,
                      backgroundColor: Colors.transparent,
                      automaticallyImplyLeading: false,
                      flexibleSpace: Container(),
                    ),

                    SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.videocam_off_rounded,
                                    size: 80,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    "Video URL Is Not Available.".tr,
                                    textAlign: TextAlign.center,
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
                        ),
                      ]),
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
                Positioned(
                  top: topPadding,
                  left: 0,
                  right: 0,
                  child: appBrand(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
