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
  // final VoidCallback onSavePressed;

  const GridCourseCard({
    super.key,
    required this.thisCourse,
    required this.isGolden,
    // required this.onSavePressed,
    required this.courseController,
  });

  @override
  State<GridCourseCard> createState() => _GridCourseCardState();
}

class _GridCourseCardState extends State<GridCourseCard> {

  @override
  Widget build(BuildContext context) {
    const double footerHeight = 85.0;

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
        decoration:
            widget.isGolden
                ? BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: BoxBorder.all(
                    color: AppColors.tertiaryColor,
                    width: 1,
                  ),
                )
                : null,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),

          child: Stack(
            children: [
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryColor,
                        const Color.fromARGB(255, 8, 65, 66),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
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
                 
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
