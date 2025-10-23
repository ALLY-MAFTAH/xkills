import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillsbank/components/course_info_footer.dart';

import '../controllers/course_controller.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';
import '../views/screens/course_details_screen.dart';
import 'custom_loader.dart';

class GridCourseCard extends StatefulWidget {
  final Course thisCourse;

  const GridCourseCard({super.key, required this.thisCourse});

  @override
  State<GridCourseCard> createState() => _GridCourseCardState();
}

class _GridCourseCardState extends State<GridCourseCard> {
  final courseController = Get.put(CourseController());

  @override
  Widget build(BuildContext context) {
    // Determine the height of the info footer, estimated at ~80 pixels for calculation
    const double footerHeight = 85.0;

    return InkWell(
      onTap: () {
        courseController.selectedCourse = widget.thisCourse;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CourseDetailsScreen();
            },
          ),
        );
      },
      child: ClipRRect(
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
              child:
                  widget.thisCourse.thumbnail!.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: widget.thisCourse.thumbnail!,
                        // width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => customLoader(),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                      )
                      : const Icon(Icons.image, size: 100, color: Colors.grey),
            ),
            if (widget.thisCourse.isBest!)
              Positioned(
                top: 5,
                right: 5,
                child: CircleAvatar(
                  backgroundColor: AppColors.primaryColor,
                  radius: 12,
                  child: Icon(
                    Icons.star,
                    size: 18,
                    color: AppColors.tertiaryColor,
                  ),
                ),
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
                    backgroundColor: Colors.grey.shade200,
                    child: ClipOval(
                      child:
                          widget.thisCourse.instructorImage!.isNotEmpty
                              ? CachedNetworkImage(
                                imageUrl: widget.thisCourse.instructorImage!,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => customLoader(),
                                errorWidget:
                                    (context, url, error) =>
                                        const Icon(Icons.error),
                              )
                              : const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey,
                              ),
                    ),
                  ),
                  horizontalTitleGap: 5,
                  title: Text(
                    widget.thisCourse.instructorName!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  subtitle: Text(
                    widget.thisCourse.instructorName!,
                    style: const TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CourseInfoFooter(
                courseTitle: widget.thisCourse.title!,
                courseDescription: widget.thisCourse.shortDescription!,
                rating: widget.thisCourse.averageRating!,
                isBookmarked: widget.thisCourse.isBest!,
                onBookmarkPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
