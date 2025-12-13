// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import '/theme/app_colors.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'shop_screen.dart';
import 'my_courses_screen.dart';

class TabsScreen extends StatefulWidget {
  final int pageIndex;

  const TabsScreen({Key? key, this.pageIndex = 0}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.pageIndex;
  }

  List<Widget> _pages() {
    return [
      HomeScreen(),
      MyCoursesScreen(),
      ShopScreen(),
      AccountScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedPageIndex, children: _pages()),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          _selectedPageIndex = value;
          setState(() {});
        },
        elevation: 8,
        backgroundColor: AppColors.secondaryColor,
        currentIndex: _selectedPageIndex,
        selectedItemColor: const Color.fromARGB(255, 11, 236, 127),
        unselectedItemColor: Colors.grey[500],
        selectedFontSize: 13,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
            backgroundColor: AppColors.secondaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            label: "My Courses",
            backgroundColor: AppColors.secondaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopify_rounded),
            label: "Shop",
            backgroundColor: AppColors.secondaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
            backgroundColor: AppColors.secondaryColor,
          ),
        ],
      ),
    );
  }
}
