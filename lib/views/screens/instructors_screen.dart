// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/grid_instructor_card.dart';
import '/theme/app_colors.dart';
import '../../components/custom_search.dart';
import '../../components/shimmer_widgets/instructor_grid_shimmer.dart';
import '../../constants/app_brand.dart';
import '../../controllers/instructor_controller.dart';
import '../../models/instructor.dart';
import 'dart:io';

import 'instructor_details_screen.dart';

class InstructorsScreen extends StatefulWidget {
  const InstructorsScreen({super.key});

  @override
  State<InstructorsScreen> createState() => _InstructorsScreenState();
}

class _InstructorsScreenState extends State<InstructorsScreen> {
  final TextEditingController searchController = TextEditingController();
  final instructorController = Get.put(InstructorController());

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    instructorController.instructorsFuture =
        instructorController.getInstructors();
  }

  Future<void> _refreshData() async {
    _loadInitialData();
    // Wait for the new data fetch to complete
    await Future.wait([instructorController.instructorsFuture!]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final double appBarHeight =
        (Platform.isAndroid ? 60 : 30) + MediaQuery.of(context).padding.top;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double minContentHeight = screenHeight - appBarHeight;

    return RefreshIndicator(
      onRefresh: _refreshData,
      color: AppColors.secondaryColor,
      backgroundColor: Colors.white,
      child: Scaffold(
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
            // 2. Main Content
            SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Platform.isAndroid ? 80 : 100),
                    CustomSearch(
                      searchController: searchController,
                      onSearch: () {},
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 2),
                      child: const Text(
                        'Instructors',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),

                    // --- INSTRUCTOR LIST/EMPTY STATE ---
                    FutureBuilder(
                      future: instructorController.instructorsFuture,
                      builder: (context, asyncSnapshot) {
                        if (asyncSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const InstructorGridShimmer();
                        } else if (asyncSnapshot.hasError) {
                          // *** FIX 2: Ensure error message takes up space ***
                          return SizedBox(
                            height: minContentHeight * 0.5,
                            child: Center(
                              child: Text(
                                'Error loading data: ${asyncSnapshot.error}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else if (asyncSnapshot.data == null ||
                            asyncSnapshot.data!.isEmpty) {
                          // *** FIX 3: Ensure 'No instructor' message takes up space ***
                          // This forces the SingleChildScrollView to become scrollable
                          return SizedBox(
                            height:
                                minContentHeight *
                                0.7, // Take up a large part of the screen
                            child: const Center(
                              child: Text(
                                'No instructors found.',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          );
                        } else {
                          final List<Instructor> instructors =
                              asyncSnapshot.data!;

                          return GridView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: instructors.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 1.4,
                                ),
                            itemBuilder: (context, index) {
                              final instructor = instructors[index];
                              return InkWell(
                                onTap:
                                    () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (_) => InstructorDetailsScreen(
                                              thisInstructor: instructor,
                                              fromInstructorsScreen: true,
                                            ),
                                      ),
                                    ),
                                child: GridInstructorCard(
                                  title: instructor.name!,
                                  phone: instructor.phone ?? "",
                                  biography: instructor.about ?? "",
                                  photo: instructor.photo ?? "",
                                  totalCourses: instructor.totalCourses!,
                                  skills: instructor.skills ?? "",
                                ),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
