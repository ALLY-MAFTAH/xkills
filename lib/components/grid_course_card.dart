import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '/components/course_info_footer.dart';
import '../controllers/course_controller.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';
import '../views/screens/course_details_screen.dart';
import 'custom_loader.dart';

class GridCourseCard extends StatefulWidget {
  final CourseController courseController;
  final Course thisCourse;
  final bool isGolden;
  final VoidCallback reloadPage;

  const GridCourseCard({
    super.key,
    required this.thisCourse,
    required this.isGolden,
    required this.courseController,
    required this.reloadPage,
  });

  @override
  State<GridCourseCard> createState() => _GridCourseCardState();
}

class _GridCourseCardState extends State<GridCourseCard> {
  @override
  Widget build(BuildContext context) {
    const double footerHeight = 100;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CourseDetailsScreen(thisCourse: widget.thisCourse);
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
              widget.isGolden
                  ? BoxBorder.all(color: AppColors.tertiaryColor, width: 1)
                  : null,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withOpacity(0.4),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: footerHeight,
                child:
                    widget.thisCourse.thumbnail!.isNotEmpty
                        ? CachedNetworkImage(
                          imageUrl: widget.thisCourse.thumbnail!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => customLoader(),
                          errorWidget:
                              (context, url, error) => const Icon(Icons.error),
                        )
                        : const Icon(
                          Icons.image,
                          size: 100,
                          color: Colors.grey,
                        ),
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

              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CourseInfoFooter(
                  thisCourse: widget.thisCourse,
                  isGolden: widget.isGolden,
                  reloadPage: widget.reloadPage,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
