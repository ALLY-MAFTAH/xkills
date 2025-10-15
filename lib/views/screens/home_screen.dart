// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:skillsbank/components/grid_course_card.dart';
import 'package:skillsbank/theme/app_colors.dart';
import 'package:skillsbank/views/screens/courses_screen.dart';
import '../../components/custom_search.dart';
import '../../components/grid_category_card.dart';
import '../../constants/app_brand.dart';
import 'categories_screen.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();

  // Mock data (omitted for brevity)
  final List<Map<String, String>> categories = const [
    {'title': 'Film & Video', 'subtitle': 'Editing', 'isPremium': "0"},
    {'title': 'Color', 'subtitle': 'Grading', 'isPremium': "0"},
    {'title': 'Graphics', 'subtitle': 'Design', 'isPremium': "0"},
    {'title': 'Visual', 'subtitle': 'Effects/VFX', 'isPremium': "0"},
    {'title': 'Golden', 'subtitle': 'Tips & Tricks', 'isPremium': "1"},
    {'title': 'Photo', 'subtitle': 'Photography', 'isPremium': "0"},
  ];
  final List<Map<String, String>> courses = const [
    {
      'coverUrl': "assets/images/workshop.png",
      'teacherName': "Ally Maftah",
      'teacherDescription': "Professional Photographer",
      'teacherImageUrl': "assets/images/teacher01.png",
      'courseTitle': "Mastering Photography",
      'courseDescription':
          "Learn the art of photography from basics to advanced techniques.",
      'rating': "5.0",
      'isBookmarked': "1",
      'isPremium': "1",
    },
    // ... (rest of course data)
    {
      'coverUrl': "assets/images/workshop.png",
      'teacherName': "David White",
      'teacherDescription': "Video Editor",
      'teacherImageUrl': "assets/images/teacher02.png",
      'courseTitle': "Video Editing Essentials",
      'courseDescription':
          "Learn essential video editing skills using popular software.",
      'rating': "3.4",
      'isBookmarked': "0",
      'isPremium': "0",
    },
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: null,
        title: appBrand(),
        backgroundColor: Colors.transparent,
        toolbarHeight: Platform.isAndroid ? 60 : 30,
      ),
      body: Stack(
        children: [
          // 1. Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.secondaryColor, AppColors.primaryColor],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
          // 2. Main Content - NOW SCROLLABLE
          SingleChildScrollView(
            // <-- WRAP ENTIRE CONTENT IN SCROLL VIEW
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                // Column is now correctly scrollable as children are sized
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Platform.isAndroid ? 80 : 100),
                  CustomSearch(
                    searchController: searchController,
                    onSearch: () {},
                  ),

                  // Category Section Header
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CategoriesScreen(),
                        ),
                      );
                    },
                    title: const Text(
                      'Choose Category',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 20),
                    itemCount: categories.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 1.8,
                        ),
                    itemBuilder: (context, index) {
                      final item = categories[index];
                      return GridCategoryCard(
                        title: item['title']!,
                        subtitle: item['subtitle']!,
                        isPremium:
                            int.parse(item['isPremium']!) == 1 ? true : false,
                      );
                    },
                  ),

                  // Top Courses Section Header
                  Divider(color: Colors.grey[700]),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 1),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoursesScreen(),
                        ),
                      );
                    },
                    title: const Text(
                      'Top Courses',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_rounded,
                      color: Colors.white,
                    ),
                  ),

                  // Top Courses Grid (FIXED: Flexible removed, shrinkWrap/physics added)
                  GridView.builder(
                    shrinkWrap: true, // <-- CRUCIAL
                    primary: false, // <-- CRUCIAL
                    physics:
                        const NeverScrollableScrollPhysics(), // <-- CRUCIAL
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    itemCount: courses.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: .66,
                        ),
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return GridCourseCard(
                        coverUrl: course['coverUrl']!,
                        teacherName: course['teacherName']!,
                        teacherDescription: course['teacherDescription']!,
                        teacherImageUrl: course['teacherImageUrl']!,
                        courseTitle: course['courseTitle']!,
                        courseDescription: course['courseDescription']!,
                        rating: double.parse(course['rating']!),
                        isBookmarked:
                            int.parse(course['isBookmarked']!) == 1
                                ? true
                                : false,
                        isPremium:
                            int.parse(course['isPremium']!) == 1 ? true : false,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
