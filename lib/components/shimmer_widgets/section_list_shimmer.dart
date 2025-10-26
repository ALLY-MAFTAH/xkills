import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SectionListShimmer extends StatelessWidget {
  const SectionListShimmer({super.key});

  // A helper method to create a single shimmering lesson item
  Widget _buildShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05), // Placeholder color
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            // Shimmer for Play Icon
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 16),
            // Shimmer for Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: Colors.white,
                    margin: const EdgeInsets.only(right: 50),
                  ),
                  const SizedBox(height: 5),
                  Container(height: 10, width: 100, color: Colors.white),
                ],
              ),
            ),
            // Shimmer for Duration/Lock Icon
            Container(height: 14, width: 50, color: Colors.white),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // You can customize the base and highlight colors to match your theme
    return Shimmer.fromColors(
      baseColor: Colors.white.withOpacity(0.1),
      highlightColor: Colors.white.withOpacity(0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          2,
          (index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Shimmer for Section Header (Title & Duration)
              Container(
                height: 16,
                width: 150,
                color: Colors.white,
                margin: const EdgeInsets.only(top: 15, bottom: 10),
              ),
              // Shimmer for Lesson 1
              _buildShimmerItem(),
              // Shimmer for Lesson 2
              _buildShimmerItem(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
