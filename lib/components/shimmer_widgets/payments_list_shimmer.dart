
// Placeholder for the Courses Grid (2x2 grid, aspect ratio .66)
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/app_colors.dart';

class PaymentsListShimmer extends StatelessWidget {
  const PaymentsListShimmer({super.key});

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
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        itemCount: 4, // Show a fixed number of placeholders
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: .66,
        ),
        itemBuilder: (context, index) {
          // Placeholder card structure
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image/Cover Placeholder
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Title Placeholder
              Container(height: 12, width: 100, color: Colors.white),
              const SizedBox(height: 4),
              // Description Placeholder
              Container(height: 10, width: 150, color: Colors.white),
            ],
          );
        },
      ),
    );
  }
}
