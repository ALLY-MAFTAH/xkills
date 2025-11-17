import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/endpoints.dart';
import '../theme/app_colors.dart';
import 'custom_loader.dart';

class GridInstructorCard extends StatelessWidget {
  final String title;
  final String phone;
  final String biography;
  final String photo;
  final String skills;
  final int totalCourses;

  const GridInstructorCard({
    super.key,
    required this.title,
    required this.phone,
    required this.biography,
    required this.photo,
    required this.skills,
    required this.totalCourses,
  });
  List<String> _parseSkills(String skillsJson) {
    if (skillsJson.isEmpty) return [];

    try {
      final List<dynamic> decodedList = json.decode(skillsJson);
      return decodedList
          .map(
            (item) =>
                item is Map<String, dynamic> && item.containsKey('value')
                    ? item['value'] as String
                    : '',
          )
          .where((skill) => skill.isNotEmpty)
          .toList();
    } catch (e) {
      print('Error decoding skills JSON: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final parsedSkills = _parseSkills(skills);
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              margin: const EdgeInsets.all(0),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondaryColor,
                            AppColors.primaryColor,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0.35),
                            Colors.white.withOpacity(0.10),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.04, 0.08],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withOpacity(0.3),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.3],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 15,
                    left: 5,
                    right: ((Get.width / 2) - (Get.width / 4.6) - 30),
                    child: Text(
                      "$totalCourses ${totalCourses <= 1 ? 'Course' : 'Courses'}",
                      style: const TextStyle(
                        color: AppColors.tertiaryColor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Positioned(
                    bottom: 30,
                    left: 5,
                    right: ((Get.width / 2) - (Get.width / 4.6) - 30),
                    child: Text(
                      parsedSkills.join(', '),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            height: Get.height / 6.0,
            width: Get.width / 4.6,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(color: Colors.transparent),
            child:
                photo.isNotEmpty
                    ? ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: CachedNetworkImage(
                        // imageUrl:  "https://i.ebayimg.com/images/g/xRQAAOSwotJmRTJl/s-l1600.webp",
                        imageUrl: "${Endpoints.baseUrl}/public/$photo",
                        fit: BoxFit.cover,
                        placeholder: (context, url) => customLoader(),
                        errorWidget:
                            (context, url, error) => const Icon(Icons.error),
                      ),
                    )
                    : Icon(Icons.movie_filter, size: 70, color: Colors.grey),
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 7, 87, 89),
                  const Color.fromARGB(255, 4, 22, 22),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
