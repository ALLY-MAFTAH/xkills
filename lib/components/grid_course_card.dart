import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skillsbank/models/instructor.dart';
import 'package:skillsbank/views/screens/instructor_details_screen.dart';
import '../controllers/instructor_controller.dart';
import '/components/course_info_footer.dart';
import '../controllers/course_controller.dart';
import '../models/course.dart';
import '../theme/app_colors.dart';
import '../views/screens/course_details_screen.dart';
import 'custom_loader.dart';
import 'toasts.dart';

class GridCourseCard extends StatefulWidget {
  final Course thisCourse;
  final bool fromInstructorsScreen;

  const GridCourseCard({
    super.key,
    required this.thisCourse,
    required this.fromInstructorsScreen,
  });

  @override
  State<GridCourseCard> createState() => _GridCourseCardState();
}

class _GridCourseCardState extends State<GridCourseCard> {
  final courseController = Get.put(CourseController());
  final instructorController = Get.put(InstructorController());

  @override
  Widget build(BuildContext context) {
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
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom:
                  widget.fromInstructorsScreen
                      ? footerHeight
                      : footerHeight + 45,
              child:
                  widget.thisCourse.thumbnail!.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: widget.thisCourse.thumbnail!,
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

            Visibility(
              visible: !widget.fromInstructorsScreen,
              child: Positioned(
                left: 5,
                right: 5,
                bottom: footerHeight,
                child: InkWell(
                  onTap: () async {
                    try {
                      final String instructorIdsJson =
                          widget.thisCourse.instructorIds!;
                      final List<dynamic> idList = json.decode(
                        instructorIdsJson,
                      );
                      print(idList);
                      if (idList != []) {
                        final int instructorId = int.parse(
                          idList.first.toString(),
                        );

                        Instructor? thisInstructor = await instructorController
                            .getInstructorById(instructorId);
                        print(thisInstructor.name);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => InstructorDetailsScreen(
                                  thisInstructor: thisInstructor,
                                  fromInstructorsScreen: true,
                                ),
                          ),
                        );
                                            } else {
                        errorToast("Instructor not found.");
                      }
                    } catch (e) {
                      print(e.toString());
                      errorToast("Instructor not found.");
                    }
                  },
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
                                    imageUrl:
                                        widget.thisCourse.instructorImage!,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder:
                                        (context, url) => customLoader(),
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
                        widget.thisCourse.instructorProfile??'',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CourseInfoFooter(
                thisCourse: widget.thisCourse,
                onBookmarkPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
