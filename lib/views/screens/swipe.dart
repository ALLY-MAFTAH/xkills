import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../theme/app_colors.dart';
import '../auth/signin_page.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<String> corouselTitles = [
    "Learn New Skills".tr,
    "Connect with Experts".tr,
    "Trending Courses".tr,
    "Achieve Your Goals".tr, // Added 4th for 04.png
  ];

  final List<String> corouselSubtitles = [
    "Master new skills with top courses and enhance your career opportunities"
        .tr,
    "Get personalized guidance and insights from industry-leading experts".tr,
    "Stay ahead in your field by exploring the latest and most trending topics"
        .tr,
    "Join thousands of students and start your journey today".tr,
  ];

  final List<String> images = [
    "assets/images/welcome/01.jpg",
    "assets/images/welcome/02.jpg",
    "assets/images/welcome/03.jpg",
    "assets/images/welcome/04.jpg",
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (_currentPage < images.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToSignIn();
    }
  }

  void _navigateToSignIn() {
    Get.offAll(() => const SigninPage());
  }

  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF071919),
      body: Stack(
        children: [
          // 1. DYNAMIC BACKGROUND IMAGE
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: Image.asset(
              images[_currentPage],
              key: ValueKey<int>(_currentPage),
              width: Get.width,
              height: Get.height,
              fit: BoxFit.cover,
            ),
          ),

          // 2. DARK OVERLAY
          Positioned(
            top: screenHeight/2,
            child: Container(
              height: screenHeight/2,
              width: Get.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color(0xFF001E1E).withOpacity(0.8),
                    const Color(0xFF001E1E),
                  ],
                ),
              ),
            ),
          ),

          // 3. PAGE VIEW (TEXT CONTENT)
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.fromLTRB(25, screenHeight/1.4, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      corouselTitles[index],
                      style: const TextStyle(
                        fontSize: 28,
                        height: 1.1,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      corouselSubtitles[index],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 4. BOTTOM CONTROLS (Dots + Button)
          Positioned(
            bottom: Get.height / 4+50,
            left: 25,
            right: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                images.length,
                (index) => _buildDot(index),
              ),
            ),
          ),
          Positioned(
            bottom: Get.height / 20,
            left: 25,
            right: 25,
            child: Center(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient:  LinearGradient(
                          colors: [
                            AppColors.primaryColor,
                            AppColors.secondaryColor,
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: _handleNext,

                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusDirectional.circular(30),
                      side: BorderSide(color: Colors.grey),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == images.length - 1
                              ? "Get Started".tr
                              : "Next".tr,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
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
