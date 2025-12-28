// import 'dart:convert';
// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../includes/instructor_details.dart';
// import '../../includes/social_links_row.dart';
// import '/constants/endpoints.dart';
// import '/models/instructor.dart';
// import '/components/custom_loader.dart';
// import '/components/grid_course_card.dart';
// import '/components/shimmer_widgets/course_grid_shimmer.dart';
// import '/constants/app_brand.dart';
// import '/controllers/course_controller.dart';
// import '/models/course.dart';
// import '/theme/app_colors.dart';

// class InstructorDetailsScreen extends StatefulWidget {
//   final Instructor thisInstructor;
//   final bool fromInstructorsScreen;
//   const InstructorDetailsScreen({
//     super.key,
//     required this.thisInstructor,
//     required this.fromInstructorsScreen,
//   });

//   @override
//   State<InstructorDetailsScreen> createState() =>
//       InstructorDetailsScreenState();
// }

// class InstructorDetailsScreenState extends State<InstructorDetailsScreen> {
//   final courseController = Get.put(CourseController());

//   @override
//   void initState() {
//     super.initState();
//     _loadInitialData();
//   }

//   void _loadInitialData() {
//     courseController.instructorCoursesFuture = courseController
//         .getCoursesByInstructor(widget.thisInstructor.id!);
//   }

//   Future<void> _refreshData() async {
//     _loadInitialData();
//     await Future.wait([courseController.instructorCoursesFuture!]);
//     setState(() {});
//   }

//   List<String> _parseSkills(String skillsJson) {
//     if (skillsJson.isEmpty) return [];

//     try {
//       final List<dynamic> decodedList = json.decode(skillsJson);
//       return decodedList
//           .map(
//             (item) =>
//                 item is Map<String, dynamic> && item.containsKey('value')
//                     ? item['value'] as String
//                     : '',
//           )
//           .where((skill) => skill.isNotEmpty)
//           .toList();
//     } catch (e) {
//       print('Error decoding skills JSON: $e');
//       return [];
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final parsedSkills = _parseSkills(widget.thisInstructor.skills ?? '[]');
//     final double statusBarHeight = MediaQuery.of(context).padding.top;

//     final double topPadding =
//         Platform.isAndroid ? statusBarHeight + 15 : statusBarHeight;
//     return RefreshIndicator(
//       onRefresh: _refreshData,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         extendBodyBehindAppBar: true,

//         body: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [AppColors.secondaryColor, AppColors.primaryColor],
//               begin: Alignment.centerLeft,
//               end: Alignment.centerRight,
//             ),
//           ),
//           child: Stack(
//             children: [
//               CustomScrollView(
//                 slivers: [
//                   SliverAppBar(
//                     expandedHeight: 70.0,
//                     collapsedHeight: 0.0,
//                     toolbarHeight: 0.0,
//                     floating: true,
//                     pinned: false,
//                     backgroundColor: Colors.transparent,
//                     automaticallyImplyLeading: false,
//                     flexibleSpace:
//                         Container(), // Empty container to satisfy the requirement
//                   ),
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: Column(
//                         children: [
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               "Instructor Details",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                               ),
//                             ),
//                           ),
//                           SizedBox(height: 10),
//                           Stack(
//                             children: [
//                               Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   color: Colors.white.withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                           width: 100,
//                                           height: 100,
//                                           decoration: BoxDecoration(
//                                             color: AppColors.primaryColor,
//                                             borderRadius: BorderRadius.circular(
//                                               10,
//                                             ),
//                                           ),
//                                           child:
//                                               widget.thisInstructor.photo !=
//                                                           null &&
//                                                       widget
//                                                           .thisInstructor
//                                                           .photo!
//                                                           .isNotEmpty
//                                                   ? ClipRRect(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                           10,
//                                                         ),
//                                                     child: CachedNetworkImage(
//                                                       imageUrl:
//                                                           "${Endpoints.baseUrl}/public/${widget.thisInstructor.photo}",
//                                                       fit: BoxFit.cover,
//                                                       placeholder:
//                                                           (context, url) =>
//                                                               customLoader(),
//                                                       errorWidget:
//                                                           (
//                                                             context,
//                                                             url,
//                                                             error,
//                                                           ) => const Icon(
//                                                             Icons.error,
//                                                           ),
//                                                     ),
//                                                   )
//                                                   : Icon(
//                                                     Icons.person,
//                                                     size: 70,
//                                                     color: Colors.grey,
//                                                   ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         InstructorDetailsContent(
//                                           thisInstructor: widget.thisInstructor,
//                                         ),
//                                       ],
//                                     ),
//                                     Divider(
//                                       color: Colors.white.withOpacity(0.2),
//                                       height: 20,
//                                       thickness: .5,
//                                     ),
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text.rich(
//                                               TextSpan(
//                                                 children: [
//                                                   TextSpan(
//                                                     text: "Total Courses: ",
//                                                     style: TextStyle(
//                                                       color: Colors.white
//                                                           .withOpacity(
//                                                             .7,
//                                                           ), // Label color is Gray
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 11,
//                                                     ),
//                                                   ),
//                                                   TextSpan(
//                                                     text:
//                                                         " ${widget.thisInstructor.totalCourses.toString()} ",
//                                                     style: const TextStyle(
//                                                       color:
//                                                           Colors
//                                                               .white, // Value color is White
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                       fontSize: 12,
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                     Text.rich(
//                                       TextSpan(
//                                         children: [
//                                           TextSpan(
//                                             text: "Skills: ",
//                                             style: TextStyle(
//                                               color: Colors.white.withOpacity(
//                                                 .7,
//                                               ),
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 11,
//                                             ),
//                                           ),
//                                           TextSpan(
//                                             text:
//                                                 " ${parsedSkills.join(', ')} ",
//                                             style: const TextStyle(
//                                               color:
//                                                   Colors
//                                                       .white, // Value color is White
//                                               fontWeight: FontWeight.bold,
//                                               fontSize: 11,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     SizedBox(height: 10),
//                                     SocialLinksRow(
//                                       facebookUrl:
//                                           widget.thisInstructor.facebook ?? '',
//                                       xUrl:
//                                           widget.thisInstructor.linkedin ?? '',
//                                       instagramUrl:
//                                           widget.thisInstructor.linkedin ?? '',
//                                       youtubeUrl:
//                                           widget.thisInstructor.linkedin ?? '',
//                                       whatsappNumber:
//                                           widget.thisInstructor.phone ?? '',
//                                       linkedinUrl:
//                                           widget.thisInstructor.linkedin ?? '',
//                                       telegramUrl:
//                                           widget.thisInstructor.linkedin ?? '',
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),

//                           const SizedBox(height: 20),
//                           Align(
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               "${widget.thisInstructor.name}'s Courses",
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       child: FutureBuilder(
//                         future: courseController.instructorCoursesFuture,
//                         builder: (context, asyncSnapshot) {
//                           if (asyncSnapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return const CourseShimmerGrid();
//                           } else if (asyncSnapshot.hasError) {
//                             return Center(
//                               child: Text('Error: ${asyncSnapshot.error}'),
//                             );
//                           } else if (asyncSnapshot.data == null ||
//                               asyncSnapshot.data!.isEmpty) {
//                             return Center(
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text(
//                                     'No course'.tr,
//                                     style: TextStyle(color: Colors.white),
//                                   ),
//                                   SizedBox(height: Get.height / 10),

//                                   SizedBox(height: 20),
//                                 ],
//                               ),
//                             );
//                           } else {
//                             final List<Course> courses = asyncSnapshot.data!;

//                             return GridView.builder(
//                               shrinkWrap: true,
//                               primary: false,
//                               physics: const NeverScrollableScrollPhysics(),
//                               padding: const EdgeInsets.only(
//                                 top: 10,
//                                 bottom: 20,
//                               ),
//                               itemCount: courses.length,
//                               gridDelegate:
//                                   SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 2,
//                                     crossAxisSpacing: 10,
//                                     mainAxisSpacing: 10,
//                                     childAspectRatio:
//                                         widget.fromInstructorsScreen
//                                             ? 0.75
//                                             : .66,
//                                   ),
//                               itemBuilder: (context, index) {
//                                 final course = courses[index];
//                                 return GridCourseCard(
//                                   thisCourse: course,
//                                   fromInstructorsScreen:
//                                       widget.fromInstructorsScreen,
//                                 );
//                               },
//                             );
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               Positioned(
//                 top: topPadding,
//                 left: 10,
//                 child: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: IconButton(
//                     padding: EdgeInsets.zero,
//                     icon: const Icon(
//                       Icons.arrow_back,
//                       size: 28,
//                       color: Colors.white,
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                   ),
//                 ),
//               ),

//               // App Brand
//               Positioned(top: topPadding, left: 0, right: 0, child: appBrand()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
