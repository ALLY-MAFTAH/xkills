import 'package:flutter/material.dart';
import '/theme/app_colors.dart'; // Ensure this path is correct

class CourseInfoFooter extends StatelessWidget {
  final String courseTitle;
  final String courseDescription;
  final double rating; // Rating variable (e.g., 4.5)
  final bool isBookmarked;
  final bool isPremium;
  final VoidCallback onBookmarkPressed;

  const CourseInfoFooter({
    super.key,
    required this.courseTitle,
    required this.courseDescription,
    required this.rating,
    required this.isBookmarked,
    required this.isPremium,
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
        color = Colors.white70; // Use a dimmer color for empty stars
      }

      stars.add(Icon(icon, color: color, size: 12));
    }

    // Add the numeric rating next to the stars
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
              color: Colors.white.withOpacity(
                0.12,
              ), // Subtle white overlay effect
            ),
          ),
          if (isPremium)
            Positioned.fill(
              child: CircleAvatar(
                child: Text(
                  '👑',
                  style: TextStyle(
                    fontSize: 18,
                    height: 1,
                    color: Colors.amber[700],
                  ),
                ), // Subtle white overlay effect
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
                        text: '$courseTitle: ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      // Course Description (Gray, Not Bolded, Truncated)
                      TextSpan(
                        text: courseDescription,
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
                    _buildRatingStars(rating),
                    InkWell(
                      onTap: onBookmarkPressed,
                      child: Icon(
                        isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                        color: Colors.white,
                        size: 20,
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
