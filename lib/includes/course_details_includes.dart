import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share_plus/share_plus.dart';
import '/components/toasts.dart';
import '../controllers/section_controller.dart';
import '/components/custom_loader.dart';
import '/components/slide_animations.dart';
import '../controllers/course_controller.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';

Widget buildLessonItem({
  required BuildContext context,
  required int lessonId,
  required String lessonTitle,
  required String sectionName,
  required String courseTitle,
  required String duration,
  required bool userValidity,
  required Gradient gradient,
  required double screenWidth,
  void Function()? onPlayPressed,
  String? downloadUrl,
}) {
  final sectionController = Get.put(SectionController());

  return GetBuilder<CourseController>(
    builder: (_) {
    
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            onTap: userValidity ? onPlayPressed : null,
            minTileHeight: 0,
            contentPadding: EdgeInsets.zero,
            minVerticalPadding: 3,
            leading: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: Padding(
                padding: EdgeInsets.zero,
                child: Icon(
                  Icons.play_arrow_rounded,
                  color: userValidity ? Colors.white : Colors.grey,
                  size: 24,
                ),
              ),
            ),
            horizontalTitleGap: 10,
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                lessonTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
            trailing: IntrinsicWidth(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    duration,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(width: 5),
                  if (userValidity && downloadUrl != null)
                    IconButton(
                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      icon: Icon(
                        Icons.file_download_outlined,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        sectionController.downloadLessonVideo(
                          lessonId: lessonId,
                          courseTitle: courseTitle,
                          sectionName: sectionName,
                          lessonTitle: lessonTitle,
                          url: downloadUrl,
                        );
                      },
                    ),
                  if (!userValidity)
                    IconButton(
                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      icon:  Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.tertiaryColor,
                        size: 24,
                      ),
                      onPressed:
                          () => infoToast("Please purchase to unlock.".tr),
                    ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

Widget buildSectionHeader(String title) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Text(
      title,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
  );
}

LinearGradient getLessonGradient(dynamic lesson) {
  return LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      // Conditional colors based on is_free or user_validity
      lesson.isFree == true || lesson.userValidity == true
          ? HexColor('#22695B')
          : HexColor('#094A4F'),
      lesson.isFree == true || lesson.userValidity == true
          ? HexColor('#00403D')
          : HexColor('#094A4F'),
    ],
    stops: const [0.0, 1.0],
  );
}

Widget buildBuyButton(
  Course thisCourse,
  void Function()? onBuyPressed,
  void Function()? onAddToCartPressed,
  void Function()? onViewCartPressed,
) {
  return Positioned(
    left: 0,
    right: 0,
    bottom: 0,
    child: BottomTopSlide(
      child: Container(
        height: Platform.isAndroid ? 85 : 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              AppColors.secondaryColor.withOpacity(0.2),
              AppColors.secondaryColor.withOpacity(0.5),
              AppColors.secondaryColor.withOpacity(0.8),
              AppColors.secondaryColor,
              AppColors.secondaryColor,
              AppColors.secondaryColor,
              AppColors.secondaryColor,
              AppColors.secondaryColor,
            ],
            stops: const [0, 0.1, 0.2, 0.3, 1, 1, 1, 1, 1],
          ),
        ),
        padding: EdgeInsets.only(
          top: 25,
          left: 12,
          right: 12,
          bottom: Platform.isAndroid ? 15 : 25,
        ),

        child: GetBuilder<CourseController>(
          builder: (courseController) {
            final isLoading = courseController.loadingCartIds.contains(
              thisCourse.id,
            );
            return Row(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onBuyPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiaryColor,
                      surfaceTintColor: AppColors.tertiaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(2),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Buy ',
                            style: const TextStyle(
                              color: Color(0xFF071B1A),
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            thisCourse.isPaid!
                                ? thisCourse.discountFlag! &&
                                        thisCourse.discountedPrice != null
                                    ? '\$${thisCourse.discountedPrice}'
                                    : '${thisCourse.price}'
                                : "Free",
                            style: const TextStyle(
                              color: Color(0xFF071B1A),
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(width: 10),
                          if (thisCourse.discountFlag!)
                            Text(
                              '${thisCourse.price}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black,
                                decoration:
                                    TextDecoration
                                        .lineThrough, // The strikethrough effect
                                decorationColor: Colors.grey.withOpacity(0.9),
                                decorationThickness: 2,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                courseController.cartList.any(
                      (item) => item.id == thisCourse.id,
                    )
                    ? ElevatedButton(
                      onPressed: onViewCartPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        padding: EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Icon(
                              Icons.shopping_cart_rounded,
                              size: 30,
                              color: AppColors.secondaryColor,
                            ),
                            Positioned(
                              top: -2,
                              left: 22,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: AppColors.tertiaryColor,
                                child: Text(
                                  courseController.cartList.length.toString(),
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : ElevatedButton.icon(
                      onPressed: onAddToCartPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tertiaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon:
                          isLoading
                              ? null
                              : Icon(Icons.add_shopping_cart_rounded),
                      label: Center(
                        child:
                            isLoading
                                ? customLoader(color: AppColors.secondaryColor)
                                : Text(
                                  'Add to Cart',
                                  style: const TextStyle(
                                    color: Color(0xFF071B1A),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                      ),
                    ),
              ],
            );
          },
        ),
      ),
    ),
  );
}

List<Widget> buildCourseSection(BuildContext context, Course thisCourse) {
  final GlobalKey shareWidgetKey = GlobalKey();
  return [
    Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
      child: Text(
        thisCourse.title ?? 'Unknown',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    ),

    Text(
      thisCourse.totalEnrollment != null
          ? '${thisCourse.totalEnrollment} Students'
          : 'N/A',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.grey,
        letterSpacing: 0.24,
      ),
    ),
    SizedBox(height: 10),
    Html(
      data: thisCourse.description ?? thisCourse.shortDescription ?? "",
      style: {
        "body": Style(
          color: Colors.white.withOpacity(.7),
          fontSize: FontSize(10),
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
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            label: Text(
              'Save',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            icon: Icon(Icons.bookmark_border, size: 20, color: Colors.white),
          ),
        ),
        Expanded(
          child: TextButton.icon(
            key: shareWidgetKey,
            onPressed: () {
              final RenderBox? box =
                  shareWidgetKey.currentContext?.findRenderObject()
                      as RenderBox?;

              Share.share(
                'Check out this course from Skillsbank: ${thisCourse.title}\nBy: ${thisCourse.instructorName}\n\n${thisCourse.shortDescription}\n\nLink: ${thisCourse.shareableLink}',
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
              );
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            icon: Icon(Icons.share_outlined, size: 20, color: Colors.white),
            label: Text(
              'Share',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    ),
    const SizedBox(height: 5),
    Divider(color: HexColor('#094B50'), height: 0, thickness: 0),
    const SizedBox(height: 10),
  ];
}
