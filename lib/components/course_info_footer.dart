import 'package:flutter/material.dart';
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

  // Helper method to build the star rating row
  Widget _buildRatingStars(double rating) {
    List<Widget> stars = [];
    int fullStars = rating.floor();
    double fractionalPart = rating - fullStars;

    for (int i = 0; i < 5; i++) {
      IconData icon;
      Color color = Colors.amber;

      if (i < fullStars) {
        icon = Icons.star;
      } else if (i == fullStars && fractionalPart > 0) {
        icon = Icons.star_half;
      } else {
        icon = Icons.star_border;
        color = Colors.white70;
      }

      stars.add(Icon(icon, color: color, size: 12));
    }
    stars.add(
      Padding(
        padding: const EdgeInsets.only(left: 4.0),
        child: Text(
          rating.toStringAsFixed(1),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    return Row(children: stars);
  }

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
                    Colors.white.withOpacity(0.1),
                    AppColors.secondaryColor.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
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
                    _buildRatingStars(thisCourse.averageRating ?? 0.0),
                    Text(
                      thisCourse.isPaid!
                          ? thisCourse.discountedPrice != null
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
