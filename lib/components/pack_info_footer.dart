import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/course_controller.dart';
import '../includes/ratings.dart';
import '../models/course.dart';

class PackInfoFooter extends StatelessWidget {
  final Course thisPack;
  final VoidCallback onBookmarkPressed;

  const PackInfoFooter({
    super.key,
    required this.thisPack,
    required this.onBookmarkPressed,
  });

  @override
  Widget build(BuildContext context) {
    final courseController = Get.put(CourseController());
    bool hasEnrolled = courseController.myPacks.any(
      (course) => course.id == thisPack.id,
    );
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${thisPack.title}: ',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  TextSpan(
                    text: thisPack.shortDescription,
                    style: TextStyle(
                      color: Colors.grey[300], // Gray color
                      fontWeight: FontWeight.normal,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  thisPack.isPaid!
                      ? thisPack.discountFlag! &&
                              thisPack.discountedPrice != null
                          ? '\$${thisPack.discountedPrice}'
                          : '${thisPack.price}'
                      : "Free".tr,
                  style: const TextStyle(
                    color: Color(0xFFE6C068),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                buildRatingStars(
                  context,
                  thisPack.id!,
                  hasEnrolled,
                  thisPack.averageRating ?? 0.0,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
