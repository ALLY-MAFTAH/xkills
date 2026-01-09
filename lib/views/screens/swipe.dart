import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/signin_page.dart';

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with TickerProviderStateMixin {
  // Page View Controller
  PageController? _pageController;
  double _scrollPosition = 0.0;

  // List of PageView content (omitted for brevity)
  final List<String> corouselTitles = [
    "Learn New Skills".tr,
    "Connect with Experts".tr,
    "Trending Courses".tr,
  ];
  final List<String> corouselSubtitles = [
    "Master new skills with top courses and enhance your career opportunities".tr,
    "Get personalized guidance and insights from industry-leading experts".tr,
    "Stay ahead in your field by exploring the latest and most trending topics".tr,
  ];
  final int pageCount = 3;

  // Hint Animation, Drag Offset, and Snap Controllers (omitted for brevity)
  late AnimationController _hintController;
  late Animation<double> _opacityAnimation;
  double _dragOffset = 0.0;
  late AnimationController _snapToZeroController;
  late Animation<double> _snapToZeroAnimation;

  // Constants (omitted for brevity)
  static const double _snapBackMaxPullDown = 50.0;
  static const double _navThreshold = -150.0;
  static const double _navVelocity = -1000.0;
  // ... (rest of initState, dispose, and gesture handlers)

  // Note: Your _snapToZeroController duration is very short (3 milliseconds)
  // which might make the snap back animation barely visible. Consider changing it to
  // const Duration(milliseconds: 300) for a smooth effect.
  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController!.addListener(_pageListener);

    _hintController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _hintController, curve: Curves.easeInOut),
    );
    _hintController.repeat(reverse: true);

    _snapToZeroController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ), // <-- Recommended change for smooth snap
    )..addListener(() {
      setState(() {
        _dragOffset = _snapToZeroAnimation.value;
      });
    });
  }

  void _pageListener() {
    if (_pageController!.page != null) {
      setState(() {
        _scrollPosition = _pageController!.page!;
      });
    }
  }

  @override
  void dispose() {
    _pageController!.removeListener(_pageListener);
    _pageController!.dispose();
    _hintController.dispose();
    _snapToZeroController.dispose();
    super.dispose();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    if (_snapToZeroController.isAnimating) {
      _snapToZeroController.stop();
    }
    setState(() {
      _dragOffset = (_dragOffset + details.delta.dy).clamp(
        double.negativeInfinity,
        _snapBackMaxPullDown,
      );
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    final double velocity = details.primaryVelocity ?? 0.0;

    if (_dragOffset < _navThreshold || velocity < _navVelocity) {
      _navigateToNextPage();
    } else {
      _snapBackToZero();
    }
  }

  void _snapBackToZero() {
    _snapToZeroAnimation = Tween<double>(begin: _dragOffset, end: 0.0).animate(
      CurvedAnimation(parent: _snapToZeroController, curve: Curves.elasticOut),
    );

    _snapToZeroController.reset();
    _snapToZeroController.forward();
  }

  void _navigateToNextPage() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 0),
        pageBuilder:
            (context, animation, secondaryAnimation) => const SigninPage(),
      ),
    );
  }

  // Helper method to build a single dot with dynamic color (omitted for brevity)
  Widget _buildDot(int index) {
    double opacity = 1.0 - (_scrollPosition - index).abs();
    opacity = opacity.clamp(0.4, 1.0);
    Color color =
        Color.lerp(Colors.white54, Colors.white, opacity * 2 - 1) ??
        Colors.white54;
    double size = 10.0 + (opacity - 0.4) * (15.0 / 0.6);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Icon(Icons.circle, size: size.clamp(10.0, 12.0), color: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF071919),
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE & OVERLAY (Unchanged)
          Image.asset(
            "assets/images/swipe_back.png",
            width: Get.width,
            fit: BoxFit.fill,
          ),
          Container(
            height: screenHeight,
            width: Get.width,
            color: const Color.fromARGB(255, 0, 40, 40).withOpacity(.4),
          ),

          // 2. PAGE VIEW (Unchanged)
          PageView.builder(
            controller: _pageController,
            itemCount: pageCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  top: screenHeight / 1.8,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      corouselTitles[index],
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 45,
                        height: 1,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      corouselSubtitles[index],
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // 3. BOTTOM GRADIENT (Unchanged)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight / 3,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    const Color.fromARGB(255, 1, 39, 34).withOpacity(.1),
                    const Color.fromARGB(255, 1, 39, 34).withOpacity(.3),
                    const Color.fromARGB(255, 1, 39, 34).withOpacity(.5),
                    const Color.fromARGB(255, 0, 30, 30),
                    const Color.fromARGB(255, 0, 30, 30),
                  ],
                ),
              ),
            ),
          ),

          // ⭐️ 4. GESTURE DETECTOR and ANIMATED INDICATORS
          // We wrap the entire swipe region in GestureDetector
          GestureDetector(
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragEnd: _onVerticalDragEnd,
            
            // Limit the gesture detection area to the bottom half of the screen
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                // This makes the target hit box span the full width
                width: Get.width, 
                // Adjust height to cover the region where user might swipe
                height: screenHeight / 2.5, 
                color: Colors.transparent, // Important: Use transparent color for hit testing
              ),
            ),
          ),
          
          // ⭐️ 5. ANIMATED INDICATORS (Slightly restructured for cleaner layout)
          AnimatedBuilder(
            animation: _opacityAnimation,
            builder: (context, child) {
              double dragFade =
                  1.0 -
                  (_dragOffset.abs() / _navThreshold.abs()).clamp(0.0, 1.0);
              return Opacity(
                opacity: (_opacityAnimation.value * dragFade).clamp(0.0, 1.0),
                child: child,
              );
            },
            // The indicators and swipe text are now the child of the AnimatedBuilder
            child: Transform.translate(
              offset: Offset(0, _dragOffset),
              child: Stack(
                children: [
                  Positioned(
                    bottom: screenHeight / 7,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(pageCount, (index) {
                        return _buildDot(index);
                      }),
                    ),
                  ),

                  // SWIPE TEXT AND ARROWS
                  Positioned(
                    bottom: screenHeight * 0.02,
                    left: 0,
                    right: 0,
                    child:  Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'SWIPE UP'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.keyboard_double_arrow_up_rounded,
                            color: Colors.white,
                            size: 35,
                          ),
                        ],
                      ),
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
