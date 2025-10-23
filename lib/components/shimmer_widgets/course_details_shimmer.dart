import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../theme/app_colors.dart';

// --- NEW SHIMMER WIDGET ---
class CourseDetailsShimmer extends StatelessWidget {
  const CourseDetailsShimmer({super.key});

  // Helper widget for drawing a simple rectangular placeholder
  Widget _buildPlaceholderBox({
    double? width,
    double? height,
    double radius = 4.0,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  // Helper widget for a single lesson item shimmer
  Widget _buildLessonShimmerItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        height: 54, // Approx height of the lesson item
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white, // Placeholder color
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    // Use the same colors chosen previously for consistency
    final baseColor = AppColors.secondaryColor.withOpacity(.5);
    final highlightColor = Colors.grey.withOpacity(0.05);

    // This Scafffold is wrapped with the shimmer effect
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.95, -0.32),
            end: Alignment(0.95, 0.32),
            colors: [AppColors.secondaryColor, AppColors.primaryColor],
            stops: const [0.1093, 0.6261],
          ),
        ),
        child: Stack(
          children: [
            // Shimmer effect wrapped around the scrollable content
            Shimmer.fromColors(
              baseColor: baseColor,
              highlightColor: highlightColor,
              enabled: true, // Always true for a loading state
              child: CustomScrollView(
                slivers: [
                  // 1. SliverAppBar Shimmer (Cover Image Area)
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    expandedHeight: screenHeight * 0.52,
                    stretch: true,
                    pinned: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [StretchMode.zoomBackground],
                      background: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Large Placeholder for the image
                          Container(
                            color: Colors.white, // The primary shimmer target
                          ),
                          
                          // The rest of the fixed UI elements (Back button, Watch button area) 
                          // will not shimmer but are needed for layout, but for a clean shimmer
                          // we only mock the data that is being loaded (Title, Students)

                          // Shimmer for Course Title
                          Positioned(
                            bottom: 48,
                            left: 10,
                            child: _buildPlaceholderBox(width: 200, height: 18),
                          ),

                          // Shimmer for Students Count
                          Positioned(
                            bottom: 20,
                            left: 10,
                            child: _buildPlaceholderBox(width: 80, height: 12),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 2. Main Content Section Shimmer
                  SliverToBoxAdapter(
                    child: Container(
                      color: AppColors.primaryColor,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom: screenHeight * 0.12,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Description Placeholder
                              _buildPlaceholderBox(width: double.infinity, height: 10),
                              const SizedBox(height: 5),
                              _buildPlaceholderBox(width: double.infinity, height: 10),
                              const SizedBox(height: 5),
                              _buildPlaceholderBox(width: 250, height: 10),
                              
                              const SizedBox(height: 10),
                              
                              // Teacher Row Placeholder
                              Row(
                                children: [
                                  // Avatar Placeholder
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Teacher Name
                                        _buildPlaceholderBox(width: 120, height: 16),
                                        const SizedBox(height: 8),
                                        // Teacher Description
                                        _buildPlaceholderBox(width: 180, height: 11),
                                      ],
                                    ),
                                  ),
                                  // Follow Button Placeholder
                                  _buildPlaceholderBox(width: 75, height: 30, radius: 15),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Lessons Header Placeholder
                              _buildPlaceholderBox(width: 150, height: 16),
                              const SizedBox(height: 10),

                              // Lesson Items Placeholders
                              _buildLessonShimmerItem(),
                              _buildLessonShimmerItem(),
                              _buildLessonShimmerItem(),
                              _buildLessonShimmerItem(),
                              _buildLessonShimmerItem(),

                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Footer with Buy Button (Fixed at bottom) - DOES NOT SHIMMER
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: screenHeight * 0.0998,
                decoration: BoxDecoration(
                  color: HexColor('#08484D').withOpacity(0.91),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x40000000),
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Container(
                  width: double.infinity,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white, // A simple white box placeholder for the button
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
             // Back Button (Fixed at top) - DOES NOT SHIMMER
            Positioned(
              top: MediaQuery.of(context).padding.top + 15,
              left: 10,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Navigator.pop(context); // Note: Shimmer is stateless, so this may not work if used outside a stateful context
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}