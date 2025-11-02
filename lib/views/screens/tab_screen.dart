// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, use_super_parameters, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:skillsbank/components/custom_loader.dart';
import 'package:skillsbank/theme/app_colors.dart';
import 'account_screen.dart';
import 'home_screen.dart';
import 'instructors_screen.dart';
import 'my_courses_screen.dart';

class TabsScreen extends StatefulWidget {
  final int pageIndex;

  const TabsScreen({Key? key, this.pageIndex = 0}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  bool isLoggedIn = false;
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.pageIndex;
  }

  List<Widget> _pages() {
    return [
      HomeScreen(),
      MyCoursesScreen(),
      InstructorsScreen(),
      AccountScreen(),
    ];
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
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
        backgroundColor: AppColors.primaryColor,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[700],
        selectedFontSize: 13,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Home",
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            label: "My Courses",
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outlined),
            label: "Instructors",
            backgroundColor: AppColors.primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Account",
            backgroundColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
