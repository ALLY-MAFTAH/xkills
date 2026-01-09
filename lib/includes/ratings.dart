import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/custom_loader.dart';
import '../components/toasts.dart';
import '../controllers/course_controller.dart';
import '../theme/app_colors.dart';

Widget buildRatingStars(
  BuildContext context,
  int courseId,
  bool isEnrolled,
  double rating, {
  double fontSize = 12,
}) {
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

    stars.add(Icon(icon, color: color, size: fontSize));
  }
  stars.add(
    Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        rating.toStringAsFixed(1),
        style: TextStyle(
          color: Colors.white,
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  return InkWell(
    onTap: () {
      if (isEnrolled) {
        _openRatingDialog(context, courseId);
      } else {
        errorToast("You can only rate courses you are enrolled in.".tr);
      }
    },
    child: Row(children: stars),
  );
}

void _openRatingDialog(BuildContext context, int courseId) async {
  final courseController = Get.put(CourseController());

  await showDialog<bool>(
    context: context,
    barrierDismissible: !courseController.isLoading,
    builder: (BuildContext dialogContext) {
      double rating = 0.0;
      final TextEditingController reviewController = TextEditingController();

      return GetBuilder<CourseController>(
        builder: (courseController) {
          return AlertDialog(
            titlePadding: EdgeInsets.only(top: 20, left: 12, right: 12),
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            backgroundColor: Colors.grey[300],

            title: Text(
              'Rate This Course'.tr,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: AppColors.secondaryColor,
              ),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Tap the stars to rate this course. Your rating helps others choose better."
                        .tr,
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ⭐ DRAGGABLE STAR RATING
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        children: [
                          GestureDetector(
                            onHorizontalDragUpdate: (details) {
                              final box =
                                  context.findRenderObject() as RenderBox;
                              final localPos = box.globalToLocal(
                                details.globalPosition,
                              );

                              final starWidth = box.size.width / 5;
                              double newRating = (localPos.dx / starWidth);

                              // round to nearest 0.5
                              newRating = (newRating * 2).round() / 2;

                              if (newRating < 0.5) newRating = 0.5;
                              if (newRating > 5) newRating = 5;

                              setState(() {
                                rating = newRating;
                              });
                            },
                            onTapDown: (details) {
                              final box =
                                  context.findRenderObject() as RenderBox;
                              final localPos = box.globalToLocal(
                                details.globalPosition,
                              );

                              final starWidth = box.size.width / 5;
                              double newRating = (localPos.dx / starWidth);

                              newRating = (newRating * 2).round() / 2;

                              if (newRating < 0.5) newRating = 0.5;
                              if (newRating > 5) newRating = 5;

                              setState(() {
                                rating = newRating;
                              });
                            },
                            child: StarDisplay(value: rating, size: 50),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "${rating.toStringAsFixed(1)} / 5",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            rating <= 1
                                ? 'Terrible'.tr
                                : rating <= 2
                                ? 'Not Good'.tr
                                : rating <= 3
                                ? 'Okay'.tr
                                : rating <= 4
                                ? 'Good'.tr
                                : 'Excellent'.tr,
                            style: const TextStyle(
                              color: AppColors.secondaryColor,
                              fontWeight: FontWeight.bold,fontSize: 12
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 4), // x, y
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: reviewController,
                      maxLines: 3,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 14,
                        decoration: TextDecoration.none,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Write A Short Review (Optional)'.tr,
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed:
                          courseController.isLoading
                              ? null
                              : () async {
                                await courseController.storeCourseRate(
                                  courseId,
                                  rating,
                                  reviewController.text,
                                );

                                Navigator.pop(dialogContext, true);
                              },
                      child:
                          courseController.isLoading
                              ? customLoader(color: Colors.white)
                              : Text(
                                'Submit Rating'.tr,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 14
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

class StarDisplay extends StatelessWidget {
  final double value; // e.g. 3.5
  final double size;

  const StarDisplay({super.key, required this.value, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final starValue = index + 1;

        IconData icon;
        if (value >= starValue) {
          icon = Icons.star_rounded;
        } else if (value >= starValue - 0.5) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_border_rounded;
        }

        return Expanded(
          child: Icon(
            icon,
            color: value == 0 ? Colors.white : Colors.amber,
            size: size,
          ),
        );
      }),
    );
  }
}

class GestureStarRating extends StatelessWidget {
  final double rating; // current value
  final double size;
  final ValueChanged<double> onChanged;

  const GestureStarRating({
    super.key,
    required this.rating,
    required this.onChanged,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTapDown: (details) {
            final box = context.findRenderObject() as RenderBox?;
            if (box == null) return;

            final localPos = details.localPosition.dx;
            final isHalf = localPos < size / 2;

            double newRating = isHalf ? index + 0.5 : index + 1.0;

            onChanged(newRating);
          },
          child: _buildStar(index),
        );
      }),
    );
  }

  Widget _buildStar(int index) {
    final starValue = index + 1;

    IconData icon;
    if (rating >= starValue) {
      icon = Icons.star_rounded;
    } else if (rating >= starValue - 0.5) {
      icon = Icons.star_half_rounded;
    } else {
      icon = Icons.star_border_rounded;
    }

    return Icon(icon, color: Colors.amber, size: size);
  }
}
