// Placeholder for the Categories Grid (2x2 grid, aspect ratio 1.8)
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_colors.dart';

class InstructorGridShimmer extends StatelessWidget {
  const InstructorGridShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    // 🎨 Use colors that contrast nicely but remain subtle
    final baseColor = AppColors.secondaryColor.withOpacity(.5);
    final highlightColor = Colors.grey.withOpacity(0.05);

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: GridView.builder(
        shrinkWrap: true,
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(bottom: 20),
        itemCount: 4, // Show a fixed number of placeholders
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.8,
        ),
        itemBuilder: (context, index) {
          // Placeholder card structure
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
            ),
          );
        },
      ),
    );
  }
}
