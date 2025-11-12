import 'package:flutter/material.dart';
import '../includes/ratings.dart';
import '../models/course.dart';
import '/theme/app_colors.dart'; // Ensure this path is correct

class CourseInfoFooter extends StatelessWidget {
  final Course thisCourse;
  final VoidCallback onBookmarkPressed;

  const CourseInfoFooter({
    super.key,
    required this.thisCourse,
    required this.onBookmarkPressed,
  });

 
  @override
  Widget build(BuildContext context) {
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
                        text: '${thisCourse.title}: ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      // Course Description (Gray, Not Bolded, Truncated)
                      TextSpan(
                        text: thisCourse.shortDescription,
                        style: TextStyle(
                          color: Colors.grey[300], // Gray color
                          fontWeight: FontWeight.normal,
                          fontSize: 12,
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
                    buildRatingStars(thisCourse.averageRating ?? 0.0),
                    Text(
                      thisCourse.isPaid!
                          ? thisCourse.discountFlag!&&thisCourse.discountedPrice != null
                              ? '\$${thisCourse.discountedPrice}'
                              : '${thisCourse.price}'
                          : "Free",
                      style: const TextStyle(
                        color: Color(0xFFE6C068),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
