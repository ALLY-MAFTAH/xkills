import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_page.dart'; // Assuming this is your HomePage widget

class SwipeScreen extends StatefulWidget {
  const SwipeScreen({super.key});

  @override
  State<SwipeScreen> createState() => _SwipeScreenState();
}

class _SwipeScreenState extends State<SwipeScreen>
    with TickerProviderStateMixin {
  // Page View Controller
  PageController? _pageController;
  // int _currentPage = 0; // Tracks the fully visible page index
  double _scrollPosition =
      0.0; // Tracks the scroll position (e.g., 0.5 between page 0 and 1)

  // List of PageView content (moved here for easier use)
  final List<String> corouselTitles = [
    "Learn New Skills",
    "Connect with Experts",
    "Trending Courses",
  ];
  final List<String> corouselSubtitles = [
    "Master new skills with top courses and enhance your career opportunities",
    "Get personalized guidance and insights from industry-leading experts",
    "Stay ahead in your field by exploring the latest and most trending topics",
  ];
  final int pageCount = 3; // Total number of pages

  // Hint Animation (Pulsating "SWIPE UP" text)
  late AnimationController _hintController;
  late Animation<double> _opacityAnimation;

  double _dragOffset = 0.0;
  late AnimationController _snapToZeroController;
  late Animation<double> _snapToZeroAnimation;

  // Constants
  static const double _snapBackMaxPullDown = 50.0;
  static const double _navThreshold = -150.0;
  static const double _navVelocity = -1000.0;

  @override
  void initState() {
    super.initState();

    // Initialize PageController
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
      duration: const Duration(milliseconds: 300),
    )..addListener(() {
      setState(() {
        _dragOffset = _snapToZeroAnimation.value;
      });
    });
  }

  void _pageListener() {
    if (_pageController!.page != null) {
      setState(() {
        // Update both the integer page index and the double scroll position
        _scrollPosition = _pageController!.page!;
        // _currentPage = _pageController!.page!.round();
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

  // --- GESTURE HANDLERS (Unchanged) ---
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
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 0),
        pageBuilder:
            (context, animation, secondaryAnimation) => const HomePage(),
      ),
    );
  }
  // -------------------------------------

  // --- WIDGET BUILDER METHOD ---

  // Helper method to build a single dot with dynamic color
  Widget _buildDot(int index) {
    // Determine the alpha/opacity based on distance from the current scroll position
    double opacity = 1.0 - (_scrollPosition - index).abs();
    opacity = opacity.clamp(0.4, 1.0); // Clamp opacity between 40% and 100%

    // Color interpolation for smooth transition
    Color color =
        Color.lerp(
          Colors.white54, // Inactive color
          Colors.white, // Active color
          opacity * 2 - 1, // Map opacity (0.4-1.0) to lerp factor (0.0-1.0)
        ) ??
        Colors.white54; // Default to inactive color

    // Size interpolation (optional, but enhances visual feedback)
    double size = 10.0 + (opacity - 0.4) * (15.0 / 0.6); // Scale size slightly

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
          // 1. BACKGROUND IMAGE
          Image.asset(
            "assets/images/swipe_back.png",
            width: Get.width,
            fit: BoxFit.fill,
          ),

          // 2. BACKGROUND OVERLAY COLOR
          Container(
            height: screenHeight,
            width: Get.width,
            color: const Color.fromARGB(255, 0, 40, 40).withOpacity(.4),
          ),

          // 3. PAGE VIEW CONTENT

          // 4. BOTTOM GRADIENT (STATIC - not moving with the drag)
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

          // 5. DRAGGABLE UNIT (DOTS + SWIPE HINT)
          GestureDetector(
            onVerticalDragUpdate: _onVerticalDragUpdate,
            onVerticalDragEnd: _onVerticalDragEnd,
            // Use Positioned.fill to allow gestures across the whole screen
            child: Positioned.fill(
              child: Transform.translate(
                offset: Offset(0, _dragOffset),
                child: Stack(
                  children: [
                    PageView.builder(
                      controller: _pageController, // Attach controller
                      itemCount: pageCount,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: screenHeight / 1.8,
                            left: 20,
                            right: 20,
                          ),
                          child: Column(
                            children: [
                              Text(
                                corouselTitles[index],
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 50,
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
                    // DOTS (Dynamically colored)
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
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _opacityAnimation,
                          builder: (context, child) {
                            double dragFade =
                                1.0 -
                                (_dragOffset.abs() / _navThreshold.abs()).clamp(
                                  0.0,
                                  1.0,
                                );
                            return Opacity(
                              opacity: (_opacityAnimation.value * dragFade)
                                  .clamp(0.0, 1.0),
                              child: child,
                            );
                          },
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'SWIPE UP',
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
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
