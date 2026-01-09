import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/course_controller.dart';
import '../includes/ratings.dart';
import '../models/course.dart';
import '/theme/app_colors.dart'; // Ensure this path is correct

class CourseInfoFooter extends StatefulWidget {
  final Course thisCourse;
  // final VoidCallback onSavePressed;
  const CourseInfoFooter({
    super.key,
    required this.thisCourse,
    // required this.onSavePressed,
  });

  @override
  State<CourseInfoFooter> createState() => _CourseInfoFooterState();
}

class _CourseInfoFooterState extends State<CourseInfoFooter> {
  final courseController = Get.put(CourseController());
  bool isSaved = false;

  @override
  void initState() {
    isSaved = courseController.savedCourses.any(
      (course) => course.id == widget.thisCourse.id,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final courseController = Get.put(CourseController());
    bool hasEnrolled = courseController.myCourses.any(
      (course) => course.id == widget.thisCourse.id,
    );
    return Container(
      color: AppColors.secondaryColor,
      child: Stack(
        children: [
          // 1. White Overlay for the "White Overlay" requirement
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color.fromARGB(255, 2, 49, 50),
                    AppColors.secondaryColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // 2. Original content (Padding added for clean spacing)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${widget.thisCourse.title}: ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      // Course Description (Gray, Not Bolded, Truncated)
                      TextSpan(
                        text: widget.thisCourse.shortDescription,
                        style: TextStyle(
                          color: Colors.grey[300], // Gray color
                          fontWeight: FontWeight.normal,
                          fontSize: 10,
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
                    buildRatingStars(
                      context,
                      widget.thisCourse.id!,
                      hasEnrolled,
                      widget.thisCourse.averageRating ?? 0.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: InkWell(
                        onTap: () {
                          print("PREssed SAVE");
                          isSaved = !isSaved;
                          courseController.addOrRemoveSavedCourse(
                            widget.thisCourse.id!,
                          );
                          courseController.update();
                          setState(() {});
                        },

                        child: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_outline,
                          size: 17,
                          color:
                              isSaved ? AppColors.tertiaryColor : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  widget.thisCourse.isPaid!
                      ? widget.thisCourse.discountFlag! &&
                              widget.thisCourse.discountedPrice != null
                          ? '\$${widget.thisCourse.discountedPrice}'
                          : '${widget.thisCourse.price}'
                      : "Free".tr,
                  style: const TextStyle(
                    color: Color(0xFFE6C068),
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
