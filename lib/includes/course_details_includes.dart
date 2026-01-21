import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:share_plus/share_plus.dart';
import '../enums/enums.dart';
import '/includes/ratings.dart';
import '../controllers/section_controller.dart';
import '/components/custom_loader.dart';
import '/components/slide_animations.dart';
import '../controllers/course_controller.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';
import 'faq_widget.dart';
import 'outcomes_widget.dart';
import 'requirements_widget.dart';

Widget buildLessonItem({
  required BuildContext context,
  required int lessonId,
  required String lessonTitle,
  required String sectionName,
  required String courseTitle,
  required String duration,
  required bool hasAccess,
  required Gradient gradient,
  required double screenWidth,
  required void Function() onPlayPressed,
  required void Function() unlockPressed,
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
            onTap: onPlayPressed,
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
                  color: hasAccess ? Colors.white : Colors.grey,
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
                  if (hasAccess && downloadUrl != null)
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
                  if (!hasAccess)
                    IconButton(
                      style: IconButton.styleFrom(padding: EdgeInsets.zero),
                      icon: Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.tertiaryColor,
                        size: 24,
                      ),
                      onPressed: () => unlockPressed(),
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
    colors: [HexColor('#22695B'), HexColor('#094A4F')],
    stops: const [0.0, 1.0],
  );
}

Widget buildBuyButton(
  Course thisCourse,
  void Function()? onBuyPressed,
  void Function()? onAddToCartPressed,
  void Function()? onViewCartPressed,
) {
  return BottomTopSlide(
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

          return LayoutBuilder(
            builder: (context, constraints) {
              // choose breakpoint
              final bool isNarrow = constraints.maxWidth < 350;

              final buttons = <Widget>[
                // BUY BUTTON
                Expanded(
                  child: ElevatedButton(
                    onPressed: onBuyPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tertiaryColor,
                      surfaceTintColor: AppColors.tertiaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 4,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Buy '.tr,
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
                              : "Free".tr,
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
                              decoration: TextDecoration.lineThrough,
                              decorationColor: Colors.grey.withOpacity(0.9),
                              decorationThickness: 2,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 10, height: 10),

                // CART BUTTON
                courseController.cartList.any(
                      (item) => item.id == thisCourse.id,
                    )
                    ? ElevatedButton(
                      onPressed: onViewCartPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 4,
                        ),
                      ),
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
                    )
                    : ElevatedButton.icon(
                      onPressed: onAddToCartPressed,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: AppColors.tertiaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon:
                          isLoading
                              ? null
                              : const Icon(Icons.add_shopping_cart),
                      label:
                          isLoading
                              ? customLoader(color: AppColors.secondaryColor)
                              : Text(
                                'Add To Cart'.tr,
                                style: const TextStyle(
                                  color: Color(0xFF071B1A),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                    ),
              ];

              // 🔁 SWITCH LAYOUT
              return isNarrow
                  ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:
                          buttons.map((w) {
                            if (w is Expanded) return w.child;
                            return w;
                          }).toList(),
                    ),
                  )
                  : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: buttons,
                  );
            },
          );
        },
      ),
    ),
  );
}

List<Widget> buildCourseSection(
  BuildContext context,
  Course thisCourse,
  void Function() onSavedPressed,
  Color color,
  IconData iconData,
) {
  final GlobalKey shareWidgetKey = GlobalKey();
  final courseController = Get.put(CourseController());
  bool hasAccess = courseController.myCourses.any(
    (course) => course.id == thisCourse.id,
  );
  return [
    Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              thisCourse.title ?? 'Unknown'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20),
            child: InkWell(
              onTap: onSavedPressed,

              child: Icon(iconData, size: 25, color: color),
            ),
          ),
        ],
      ),
    ),

    Text(
      thisCourse.totalEnrollment != null
          ? '${thisCourse.totalEnrollment} ${thisCourse.totalEnrollment == 1 ? "Student".tr : "Students".tr}'
          : 'N/A',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.grey,
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildRatingStars(
          context,
          thisCourse.id!,
          hasAccess,
          thisCourse.averageRating ?? 0.0,
          fontSize: 14,
        ),

        TextButton.icon(
          key: shareWidgetKey,
          onPressed: () {
            final RenderBox? box =
                shareWidgetKey.currentContext?.findRenderObject() as RenderBox?;

            Share.share(
              "${'Check Out This Course From Xkills:'.tr} ${thisCourse.title}\n\n${thisCourse.shortDescription}\n\n${'Link:'.tr} ${thisCourse.shareableLink}",
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
            'Share'.tr,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    ),
    Divider(color: HexColor('#094B50'), height: 0, thickness: 0),
    const SizedBox(height: 10),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Level: '.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            Text(
              " ${GetUtils.capitalize(thisCourse.level!)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Language: '.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            Text(
              " ${GetUtils.capitalize(thisCourse.language!)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
    Divider(color: HexColor('#094B50'), height: 20, thickness: 0),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'Expiry: '.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            Text(
              " ${GetUtils.capitalize(thisCourse.expiryPeriod ?? "Lifetime".tr)}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              'Certificate: '.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            Text(
              " Yes".tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    ),
    const SizedBox(height: 10),

    Divider(color: HexColor('#094B50'), height: 0, thickness: 0),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (thisCourse.requirements != null &&
            thisCourse.requirements!.isNotEmpty)
          TextButton(
            child: Text(
              'Requirements'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.tertiaryColor,
              ),
            ),
            onPressed: () {
              openDefaultDialog(context, DialogType.REQUIREMENTS, thisCourse);
            },
          ),
        if (thisCourse.outcomes != null && thisCourse.outcomes!.isNotEmpty)
          TextButton(
            child: Text(
              'Outcomes'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.tertiaryColor,
              ),
            ),
            onPressed: () {
              openDefaultDialog(context, DialogType.OUTCOMES, thisCourse);
            },
          ),
        if (thisCourse.faqs != null && thisCourse.faqs!.isNotEmpty)
          TextButton(
            child: Text(
              'FAQ'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: AppColors.tertiaryColor,
              ),
            ),
            onPressed: () {
              openDefaultDialog(context, DialogType.FAQ, thisCourse);
            },
          ),
      ],
    ),
    Divider(color: HexColor('#094B50'), height: 0, thickness: 0),

    const SizedBox(height: 20),
  ];
}

void openDefaultDialog(
  BuildContext context,
  DialogType dialogType,
  Course thisCourse,
) async {
  Get.bottomSheet(
    backgroundColor: Colors.grey[300],
    isScrollControlled: true,
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: SingleChildScrollView(
        child: Center(
          child:
              dialogType == DialogType.FAQ
                  ? FaqWidget(faqs: thisCourse.faqs!)
                  : dialogType == DialogType.OUTCOMES
                  ? OutcomesWidget(outcomes: thisCourse.outcomes!)
                  : RequirementsWidget(requirements: thisCourse.requirements!),
        ),
      ),
    ),
  );
}
