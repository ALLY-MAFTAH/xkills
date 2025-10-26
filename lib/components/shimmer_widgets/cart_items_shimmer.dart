import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CartItemShimmer extends StatelessWidget {
  const CartItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = Colors.white.withOpacity(0.3);
    final highlightColor = Colors.white.withOpacity(0.1);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 15),
              // Text placeholders
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 16, width: double.infinity, color: Colors.grey),
                    const SizedBox(height: 8),
                    Container(height: 16, width: 150, color: Colors.grey),
                    const SizedBox(height: 10),
                    Container(height: 18, width: 70, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
