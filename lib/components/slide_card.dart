
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hexcolor/hexcolor.dart';

// class SlideData {
//   final String title;
//   final String asset;
//   final List<Color> bgGradient;
//   const SlideData({
//     required this.title,
//     required this.asset,
//     required this.bgGradient,
//   });
// }

// class SlideCard extends StatelessWidget {
//   final SlideData slide;
//   const SlideCard({required this.slide, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//     height: 100,
//       width: Get.width-20,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.08),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.white.withOpacity(0.06)),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.white.withOpacity(0.08),
//             blurRadius: 12,
//             offset: const Offset(0, 8),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(10),
//         child: Image.asset(slide.asset, fit: BoxFit.cover),
//       ),
//     );
//   }
// }
