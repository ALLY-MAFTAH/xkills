import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import '/theme/app_colors.dart';

import 'home_screen.dart';
import 'my_courses_screen.dart';
import 'shop_screen.dart';
import 'account_screen.dart';

class TabsScreen extends StatefulWidget {
  final int pageIndex;
  const TabsScreen({super.key, this.pageIndex = 0});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  late int _index;

  final pages = const [
    HomeScreen(),
    ShopScreen(),
    MyCoursesScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.secondaryColor,

      body: IndexedStack(index: _index, children: pages),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: RepaintBoundary(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque, // 🔥 BLOCKS BACK TAPS
                    onTap: () {}, // empty — just absorbs
                    child: LiquidGlassLayer(
                      settings: const LiquidGlassSettings(
                        blur: 0,
                        thickness: 25,                                lightAngle: 0.8 * 3.14,

                        glassColor: Color.fromARGB(16, 255, 255, 255),
                      ),
                      child: LiquidGlass(
                        shape: LiquidRoundedSuperellipse(borderRadius: 40),
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () => setState(() => _index = 0),
                                child: _NavItem(
                                  icon: Icons.home_rounded,
                                  label: "Home",
                                  selected: _index == 0,
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => _index = 1),
                                child: _NavItem(
                                  icon: Icons.shopify_rounded,
                                  label: "Shop",
                                  selected: _index == 1,
                                ),
                              ),
                              InkWell(
                                onTap: () => setState(() => _index = 2),
                                child: _NavItem(
                                  icon: Icons.school_rounded,
                                  label: "My Courses",
                                  selected: _index == 2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _index = 3),
                child: RepaintBoundary(
                  child: LiquidGlassLayer(
                    settings: const LiquidGlassSettings(
                      blur: 0,
                      thickness: 20,                                lightAngle: 0.8 * 3.14,

                      glassColor: Color.fromARGB(16, 255, 255, 255),
                    ),
                    child: LiquidGlass(
                      shape: LiquidRoundedSuperellipse(borderRadius: 50),
                      child: Container(
                        width: 50,
                        height: 50,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.account_circle_outlined,
                          color:
                              _index == 3
                                  ? const Color.fromARGB(255, 115, 219, 151)
                                  : Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
      padding: EdgeInsets.symmetric(
        horizontal: selected ? 16 : 12,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color:
            selected
                ? const Color.fromARGB(255, 115, 219, 151)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: selected ? 22 : 30,
            color: selected ? Colors.black : Colors.white,
          ),
          if (selected) ...[
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
