import 'package:flutter/material.dart';
import 'package:skillsbank/components/course_info_footer.dart';

import '../theme/app_colors.dart';

class GridCourseCard extends StatelessWidget {
  final String coverUrl;
  final String teacherName;
  final String teacherDescription;
  final String teacherImageUrl;
  final String courseTitle;
  final String courseDescription;
  final double rating;
  final bool isBookmarked;
  final bool isPremium;

  const GridCourseCard({
    super.key,
    required this.coverUrl,
    required this.teacherName,
    required this.teacherDescription,
    required this.teacherImageUrl,
    required this.courseTitle,
    required this.courseDescription,
    required this.rating,
    required this.isBookmarked,
    required this.isPremium,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the height of the info footer, estimated at ~80 pixels for calculation
    const double footerHeight = 85.0;

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Stack(
        // This is the main container for the card
        children: [
          // 1. Full Background Gradient (Fills the entire card)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),

          // 2. Course Cover Image (Must be sized to fit above the footer)
          // We use Positioned to explicitly define its area.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            // Height is the card height minus the footer height
            bottom: footerHeight + 45,
            child: Image.asset(coverUrl, fit: BoxFit.cover),
          ),

          // 3. Teacher Info (Placed just below the image, above the footer)
          Positioned(
            left: 5,
            right: 5,
            // Positioned above the footer
            bottom: footerHeight,
            child: Container(
              color: Colors.transparent,
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                minTileHeight: 50,
                leading: CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(teacherImageUrl),
                ),
                horizontalTitleGap: 5,
                title: Text(
                  teacherName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                subtitle: Text(
                  teacherDescription,
                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
            ),
          ),

          // 4. Course Info Footer (Docked correctly at the bottom of the Stack)
          // *** FIX: This Positioned is now a direct child of the Stack ***
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CourseInfoFooter(
              courseTitle: courseTitle,
              courseDescription: courseDescription,
              rating: rating,
              isBookmarked: isBookmarked,
              isPremium: isPremium,
              onBookmarkPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
